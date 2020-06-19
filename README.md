# any_quote

A Flutter application for getting quotes from [Wikiquote](https://www.wikiquote.org/). 

[Powered by Wikidata](https://www.wikidata.org/wiki/Wikidata:Data_access#Best_practices_to_follow)

## Build

### build_runner

[build_runner](https://pub.dev/packages/build_runner)

```shell
# one time
pub run build_runner build
# or continuously
pub run build_runner watch
```

### Flutter

```shell
flutter run --release
# Android
flutter build appbundle
# Web
flutter build web
```

### Miscellaneous

```shell
# generate icons
flutter pub run flutter_launcher_icons:main
```

## Deploy

```shell
# Firebase
firebase deploy
```
