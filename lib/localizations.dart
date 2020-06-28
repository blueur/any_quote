import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'about': 'About',
      'library': 'Library',
      'noQuote': 'No available quotes. Please check the settings.',
      'quote': 'Quote',
      'settings': 'Settings',
      'sources': 'Sources',
      'updated': 'Update finished',
    },
    'fr': {
      'about': 'A propos',
      'library': 'Bibliothèque',
      'noQuote':
          'Pas de citations disponible. Veuillez vérifier les paramètres.',
      'quote': 'Citation',
      'settings': 'Paramètres',
      'sources': 'Sources',
      'updated': 'Mise à jour terminée',
    },
  };

  String get about => _localizedValues[locale.languageCode]['about'];

  String get library => _localizedValues[locale.languageCode]['library'];

  String get noQuote => _localizedValues[locale.languageCode]['noQuote'];

  String get quote => _localizedValues[locale.languageCode]['quote'];

  String get settings => _localizedValues[locale.languageCode]['settings'];

  String get sources => _localizedValues[locale.languageCode]['sources'];

  String get updated => _localizedValues[locale.languageCode]['updated'];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
