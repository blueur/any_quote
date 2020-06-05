import 'package:any_quote/model/quote.dart';
import 'package:any_quote/model/wikiquote.dart';
import 'package:any_quote/service/wikiquote_service.dart' as wikiquoteService;
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<List<Quote>> updateQuotes(SharedPreferences prefs) async {
  final List<Quote> quotes =
      await _getQuotes(Locale.fromSubtags(languageCode: 'fr'), 'Kaamelott')
          .handleError((error) => print(error))
          .toList();
  return prefs
      .setStringList(PreferenceKey.QUOTES,
          quotes.map((quote) => quote.toString()).toList())
      .then((success) => quotes);
}

Stream<Quote> parseQuotes(Locale locale, Section section, Parse parse) {
  final Document document = parser.parse(parse.text);
  document.getElementsByClassName('mw-editsection').forEach((element) {
    element.remove();
  });
  final Stream<Quote> internalQuotes =
      Stream.fromIterable(document.getElementsByClassName('citation'))
          .map((element) {
    final headers = element.parent.getElementsByTagName('h${section.level}');
    final String location = '${parse.title}/${headers.first.text}';
    final String text = element.text.trim();
    final String source = element.nextElementSibling.text.trim();
    final Quote quote = new Quote(location, text, source);
    debugPrint(quote.toString());
    return quote;
  });
  final Stream<Quote> externalQuotes = Stream.fromIterable(parse.links)
      .where((link) => link.exists)
      .where((link) => link.ns == 0)
      .map((link) => link.title)
      .asyncExpand((page) => _getQuotes(locale, page));
  return StreamGroup.merge([internalQuotes, externalQuotes]);
}

Stream<Quote> _getQuotes(Locale locale, String page) {
  return _getSections(locale, page)
      .toList()
      .then((sections) => sections.where((section) => sections
          .where((s) => s.number != section.number)
          .every((s) => !s.number.startsWith('${section.number}.'))))
      .asStream()
      .expand((sections) => sections)
      .asyncExpand((section) => _getQuotesBySection(locale, page, section));
}

Stream<Section> _getSections(Locale locale, String page) {
  return Stream.fromFuture(wikiquoteService.parse(locale, {
    'prop': 'sections',
    'page': page,
  })).expand((response) => response.parse.sections);
}

Stream<Quote> _getQuotesBySection(Locale locale, String page, Section section) {
  return Stream.fromFuture(wikiquoteService.parse(locale, {
    'prop': 'text|links',
    'page': page,
    'section': section.index,
  }))
      .map((response) => response.parse)
      .asyncExpand((parse) => parseQuotes(locale, section, parse));
}
