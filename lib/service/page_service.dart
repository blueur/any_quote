import 'package:any_quote/model/language.dart';
import 'package:any_quote/model/page.dart';
import 'package:any_quote/utils/preferences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

List<Page> _defaultPages = [
  Page(
    title: 'Kaamelott',
    language: Language.fr,
    enabled: true,
  )
];

List<Page> readPages(SharedPreferences prefs) {
  return readList(
      prefs, PreferenceKey.PAGES, (string) => Page.fromString(string),
      defaultValue: _defaultPages);
}

Future<bool> savePages(SharedPreferences prefs, List<Page> pages) {
  return saveList(prefs, PreferenceKey.PAGES, pages);
}
