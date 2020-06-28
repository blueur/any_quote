import 'dart:convert';

import 'package:any_quote/model/language.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable()
class WikiPage implements Comparable {
  final String title;
  final Language language;
  bool enabled;

  WikiPage({this.title, this.language, this.enabled});

  factory WikiPage.fromJson(Map<String, dynamic> json) =>
      _$WikiPageFromJson(json);

  Map<String, dynamic> toJson() => _$WikiPageToJson(this);

  factory WikiPage.fromString(String string) =>
      string != null ? WikiPage.fromJson(json.decode(string)) : null;

  @override
  String toString() {
    return json.encode(toJson());
  }

  @override
  int compareTo(other) {
    return toString().compareTo(other.toString());
  }
}
