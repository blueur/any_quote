import 'package:any_quote/localizations.dart';
import 'package:any_quote/widget/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    localizationsDelegates: [
      const AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en'),
      const Locale('fr'),
    ],
    home: HomeWidget(),
  ));
}

class PreferenceKey {
  static const String QUOTES = 'quotes';
  static const String QUOTE = 'quote';
  static const String PAGES = 'pages';
}
