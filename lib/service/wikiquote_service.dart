import 'dart:convert';

import 'package:any_quote/model/language.dart';
import 'package:any_quote/model/wikiquote.dart';
import 'package:any_quote/utils/enum_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<WikiquoteResponse> parse(
    Language language, Map<String, String> parameters) {
  final Map<String, String> parseParameters = {
    'action': 'parse',
    'noimages': '',
  };
  parseParameters.addAll(parameters);
  return _getWikiquoteResponse(language, parseParameters);
}

Stream<SearchResult> querySearch(Language language, String search,
    {int limit = 8}) {
  final Map<String, String> queryParameters = {
    'action': 'query',
    'list': 'search',
    'srsearch': search,
    'srlimit': limit.toString(),
    'srinfo': '',
    'srprop': '',
  };
  return _getWikiquoteResponse(language, queryParameters)
      .then((wikiquoteResponse) => wikiquoteResponse.query)
      .asStream()
      .expand((query) => query.search);
}

Stream<SearchResult> queryPrefixSearch(Language language, String search,
    {int limit = 8}) {
  final Map<String, String> queryParameters = {
    'action': 'query',
    'list': 'prefixsearch',
    'pssearch': search,
    'pslimit': limit.toString(),
  };
  return _getWikiquoteResponse(language, queryParameters)
      .then((wikiquoteResponse) => wikiquoteResponse.query)
      .asStream()
      .expand((query) => query.prefixsearch);
}

Future<WikiquoteResponse> _getWikiquoteResponse(
    Language language, Map<String, String> parameters) async {
  final Map<String, String> queryParameters = {
    'format': 'json',
    'formatversion': '2',
    'utf8': '',
    'origin': '*',
  };
  queryParameters.addAll(parameters);
  final Uri uri = Uri.https(
      '${enumToString(language)}.wikiquote.org', '/w/api.php', queryParameters);
  debugPrint('http GET $uri');
  final http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    return WikiquoteResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to call $uri: ${response.statusCode}');
  }
}
