import 'package:any_quote/widget/quote_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Any Quote',
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
    ),
    home: QuoteWidget(),
  ));
}
