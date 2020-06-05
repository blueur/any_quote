import 'dart:convert';
import 'dart:ui';

import 'package:any_quote/model/wikiquote.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<WikiquoteResponse> parse(
    Locale locale, Map<String, String> parameters) async {
  final Map<String, String> parseParameters = {
    'action': 'parse',
    'noimages': '',
  };
  parseParameters.addAll(parameters);
  return _getWikiquoteResponse(locale, parseParameters);
}

Future<WikiquoteResponse> _getWikiquoteResponse(
    Locale locale, Map<String, String> parameters) async {
  final Map<String, String> queryParameters = {
    'format': 'json',
    'formatversion': '2',
    'utf8': '',
  };
  queryParameters.addAll(parameters);
  final Uri uri = Uri.https(
      '${locale.languageCode}.wikiquote.org', '/w/api.php', queryParameters);
  debugPrint('http GET $uri');
  final http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    return WikiquoteResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to call $uri: ${response.statusCode}');
  }
}
