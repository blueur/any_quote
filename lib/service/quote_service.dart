import 'dart:convert';

import 'package:any_quote/model/quote.dart';
import 'package:any_quote/model/wikiquote.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<List<Quote>> updateQuotes(SharedPreferences prefs) async {
  final List<Quote> quotes = await _getQuotes('Kaamelott').toList();
  return prefs
      .setStringList(PreferenceKey.QUOTES,
          quotes.map((quote) => quote.toString()).toList(growable: false))
      .then((success) => quotes);
}

Stream<Quote> parseQuotes(Section section, Parse parse) {
  final Document document = parser.parse(parse.text.all);
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
  final Stream<Quote> externalQuotes =
      Stream.fromIterable(document.querySelectorAll('dl>dd>a'))
          .map((element) => element.attributes['title'])
          .asyncExpand((e) => _getQuotes(e));
  return StreamGroup.merge([internalQuotes, externalQuotes]);
}

Stream<Quote> _getQuotes(String page) {
  return _getSections(page)
      .toList()
      .then((sections) => sections.where((section) => sections
          .where((s) => s.number != section.number)
          .every((s) => !s.number.startsWith('${section.number}.'))))
      .asStream()
      .expand((sections) => sections)
      .asyncExpand((section) => _getQuotesBySection(page, section));
}

Stream<Section> _getSections(String page) {
  return Stream.fromFuture(_getResponse({
    'prop': 'sections',
    'page': page,
  })).expand((response) => response.parse.sections);
}

Stream<Quote> _getQuotesBySection(String page, Section section) {
  return Stream.fromFuture(_getResponse({
    'prop': 'text',
    'page': page,
    'section': section.index,
  }))
      .map((response) => response.parse)
      .asyncExpand((parse) => parseQuotes(section, parse));
}

Future<WikiquoteResponse> _getResponse(Map<String, String> parameters) async {
  final Map<String, String> queryParameters = {
    'action': 'parse',
    'format': 'json',
    'noimages': ''
  };
  queryParameters.addAll(parameters);
  final Uri uri = Uri.https('fr.wikiquote.org', '/w/api.php', queryParameters);
  debugPrint(uri.toString());
  final http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    return WikiquoteResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to call $uri: ${response.statusCode}');
  }
}
