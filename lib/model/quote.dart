import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  final String location;
  final String text;
  final String source;

  Quote(this.location, this.text, this.source);

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);

  factory Quote.fromString(String string) =>
      string != null ? Quote.fromJson(json.decode(string)) : null;

  @override
  String toString() {
    return json.encode(toJson());
  }
}
