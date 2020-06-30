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
      'addPage': 'Add a new page',
      'library': 'Library',
      'noQuote': 'No available quotes. Please check the settings.',
      'pages': 'Pages',
      'quote': 'Quote',
      'settings': 'Settings',
      'update': 'Update',
      'updated': 'Updated',
      'updating': 'Updating',
    },
    'fr': {
      'about': 'A propos',
      'addPage': 'Ajouter une nouvelle page',
      'library': 'Bibliothèque',
      'noQuote':
          'Pas de citations disponible. Veuillez vérifier les paramètres.',
      'pages': 'Pages',
      'quote': 'Citation',
      'settings': 'Paramètres',
      'update': 'Mettre à jour',
      'updated': 'Mise à jour terminée',
      'updating': 'Mise à jour en cours',
    },
  };

  String get about => _localizedValues[locale.languageCode]['about'];

  String get addPage => _localizedValues[locale.languageCode]['addPage'];

  String get library => _localizedValues[locale.languageCode]['library'];

  String get noQuote => _localizedValues[locale.languageCode]['noQuote'];

  String get pages => _localizedValues[locale.languageCode]['pages'];

  String get quote => _localizedValues[locale.languageCode]['quote'];

  String get settings => _localizedValues[locale.languageCode]['settings'];

  String get update => _localizedValues[locale.languageCode]['update'];

  String get updated => _localizedValues[locale.languageCode]['updated'];

  String get updating => _localizedValues[locale.languageCode]['updating'];
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
