import 'package:any_quote/model/language.dart';
import 'package:any_quote/model/page.dart';
import 'package:any_quote/service/page_service.dart';
import 'package:any_quote/service/wikiquote_service.dart' as wikiquoteService;
import 'package:any_quote/utils/enum_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PagesState();
}

class _PagesState extends State<PagesWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Page>> _pages;

  void _onAdd(Page newPage) {
    setState(() {
      _pages = _prefs.then((prefs) {
        final List<Page> pages = readPages(prefs);
        if (!pages.any((page) => page.toString() == newPage.toString())) {
          pages.add(newPage);
          pages.sort();
        }
        savePages(prefs, pages);
        return pages;
      });
    });
  }

  void _onEnable(List<Page> pages, int index, bool enabled) {
    setState(() {
      _pages = _prefs.then((prefs) {
        pages[index].enabled = enabled;
        savePages(prefs, pages);
        return pages;
      });
    });
  }

  void _onDelete(List<Page> pages, int index) {
    setState(() {
      _pages = _prefs.then((prefs) {
        pages.removeAt(index);
        savePages(prefs, pages);
        return pages;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = _prefs.then(readPages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PageSearchWidget(
          onSearch: _onAdd,
        ),
        FutureBuilder<List<Page>>(
          future: _pages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data.asMap().entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value.title),
                    subtitle: Text(enumToString(entry.value.language)),
                    dense: true,
                    leading: Checkbox(
                      value: entry.value.enabled,
                      onChanged: (value) =>
                          _onEnable(snapshot.data, entry.key, value),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _onDelete(snapshot.data, entry.key),
                    ),
                  );
                }).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ],
    );
  }
}

class PageSearchWidget extends StatefulWidget {
  final Function(Page) onSearch;

  const PageSearchWidget({Key key, @required this.onSearch}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WikiSearchState(onSearch: onSearch);
}

class _WikiSearchState extends State<PageSearchWidget> {
  final TextEditingController _text_controller = TextEditingController();
  final Function(Page) onSearch;

  Language _language;
  String _text;
  Future<List<Page>> _pages;

  _WikiSearchState({@required this.onSearch});

  _onSearch(Language language, String text) {
    setState(() {
      _language = language;
      _text = text;
      if (text.isEmpty) {
        _pages = Future.value([]);
      } else {
        _pages = wikiquoteService
            .queryPrefixSearch(language, text)
            .map((search) => Page(
                  title: search.title,
                  language: language,
                  enabled: true,
                ))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _language = Language.fr;
    _text = '';
    _pages = Future.value([]);
    _text_controller
        .addListener(() => _onSearch(_language, _text_controller.text));
  }

  @override
  void dispose() {
    _text_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _text_controller,
          decoration: InputDecoration(
            hintText: MaterialLocalizations.of(context).searchFieldLabel,
            contentPadding: const EdgeInsets.all(0.0),
            prefix: DropdownButtonHideUnderline(
              child: DropdownButton<Language>(
                value: _language,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (value) => _onSearch(value, _text),
                items: Language.values.map((language) {
                  return DropdownMenuItem(
                    value: language,
                    child: Text(enumToString(language)),
                  );
                }).toList(),
              ),
            ),
            icon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                FocusScope.of(context).unfocus();
                _text_controller.clear();
              },
            ),
          ),
        ),
        FutureBuilder<List<Page>>(
          future: _pages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data
                    .map((page) => ListTile(
                          title: Text(page.title),
                          onTap: () {
                            onSearch(page);
                            _text_controller.clear();
                          },
                        ))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ],
    );
  }
}
