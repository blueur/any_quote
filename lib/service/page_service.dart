import 'package:any_quote/model/language.dart';
import 'package:any_quote/model/page.dart';
import 'package:any_quote/utils/preferences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

List<WikiPage> _defaultPages = [
  WikiPage(
    title: 'Kaamelott',
    language: Language.fr,
    enabled: true,
  )
];

List<WikiPage> readPages(SharedPreferences prefs) {
  return readList(
      prefs, PreferenceKey.PAGES, (string) => WikiPage.fromString(string),
      defaultValue: _defaultPages);
}

Future<bool> savePages(SharedPreferences prefs, List<WikiPage> pages) {
  return saveList(prefs, PreferenceKey.PAGES, pages);
}
