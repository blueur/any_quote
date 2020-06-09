import 'dart:convert';

import 'package:any_quote/model/language.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable()
class Page implements Comparable {
  final String title;
  final Language language;
  bool enabled;

  Page({this.title, this.language, this.enabled});

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);

  factory Page.fromString(String string) =>
      string != null ? Page.fromJson(json.decode(string)) : null;

  @override
  String toString() {
    return json.encode(toJson());
  }

  @override
  int compareTo(other) {
    return toString().compareTo(other.toString());
  }
}
