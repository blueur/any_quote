import 'package:shared_preferences/shared_preferences.dart';

List<T> readList<T>(
    SharedPreferences prefs, String key, T fromString(String string),
    {List<T> defaultValue = const []}) {
  final List<String> stringList = prefs.getStringList(key);
  if (stringList == null) {
    saveList(prefs, key, defaultValue);
    return defaultValue;
  } else {
    return stringList.map(fromString).toList();
  }
}

Future<bool> saveList<T>(SharedPreferences prefs, String key, List<T> ts) {
  return prefs.setStringList(key, ts.map((t) => t.toString()).toList());
}
