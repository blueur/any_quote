import 'package:any_quote/model/language.dart';
import 'package:any_quote/model/quote.dart';
import 'package:any_quote/model/wikiquote.dart';
import 'package:any_quote/service/page_service.dart';
import 'package:any_quote/service/wikiquote_service.dart' as wikiquoteService;
import 'package:any_quote/utils/dom_utils.dart';
import 'package:any_quote/utils/preferences_utils.dart';
import 'package:async/async.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

List<Quote> readQuotes(SharedPreferences prefs) {
  return readList(
      prefs, PreferenceKey.QUOTES, (string) => Quote.fromString(string));
}

Future<bool> saveQuotes(SharedPreferences prefs, List<Quote> quotes) {
  return saveList(prefs, PreferenceKey.QUOTES, quotes);
}

Future<List<Quote>> updateQuotes(SharedPreferences prefs) async {
  final List<Quote> quotes = await Stream.fromIterable(readPages(prefs))
      .where((page) => page.enabled)
      .asyncExpand((page) => _getQuotes(page.language, page.title))
      .distinct((q1, q2) => q1.toString() == q2.toString())
      .handleError((error) => print(error))
      .toList();
  return saveQuotes(prefs, quotes).then((success) => quotes);
}

Stream<Quote> parseQuotes(Language language, Section section, Parse parse) {
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
    final siblings =
        nextElementSiblingsWhile(element, (e) => e.localName == 'ul');
    final String reference = classNameToString(siblings, 'ref');
    final String original = classNameToString(siblings, 'original');
    final String precision = classNameToString(siblings, 'precisions');
    final Quote quote = new Quote(
      location: location,
      text: text,
      reference: reference,
      original: original,
      precision: precision,
    );
//    debugPrint(quote.toString());
    return quote;
  });
  final Stream<Quote> externalQuotes = Stream.fromIterable(parse.links)
      .where((link) => link.exists)
      .where((link) => link.ns == 0)
      .map((link) => link.title)
      .where((title) => title.startsWith(parse.title))
      .asyncExpand((page) => _getQuotes(language, page));
  return StreamGroup.merge([internalQuotes, externalQuotes]);
}

Stream<Quote> _getQuotes(Language language, String page) {
  return _getSections(language, page)
      .toList()
      .then((sections) => sections.where((section) => sections
          .where((s) => s.number != section.number)
          .every((s) => !s.number.startsWith('${section.number}.'))))
      .asStream()
      .expand((sections) => sections)
      .asyncExpand((section) => _getQuotesBySection(language, page, section));
}

Stream<Section> _getSections(Language language, String page) {
  return Stream.fromFuture(wikiquoteService.parse(language, {
    'prop': 'sections',
    'page': page,
  })).expand((response) => response.parse.sections);
}

Stream<Quote> _getQuotesBySection(
    Language language, String page, Section section) {
  return Stream.fromFuture(wikiquoteService.parse(language, {
    'prop': 'text|links',
    'page': page,
    'section': section.index,
  }))
      .map((response) => response.parse)
      .asyncExpand((parse) => parseQuotes(language, section, parse));
}
