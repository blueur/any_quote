import 'package:any_quote/widget/home_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Any Quote',
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),
    ),
    home: HomeWidget(),
  ));
}

class PreferenceKey {
  static const String QUOTES = 'quotes';
  static const String QUOTE = 'quote';
  static const String PAGES = 'pages';
}
