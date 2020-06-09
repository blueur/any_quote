import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  final String location;
  final String text;
  final String reference;
  final String precision;
  final String original;

  Quote({
    @required this.location,
    @required this.text,
    @required this.reference,
    this.precision,
    this.original,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);

  factory Quote.fromString(String string) =>
      string != null ? Quote.fromJson(json.decode(string)) : null;

  @override
  String toString() {
    return json.encode(toJson());
  }
}
