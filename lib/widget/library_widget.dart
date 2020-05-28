import 'package:any_quote/model/quote.dart';
import 'package:any_quote/service/quote_service.dart';
import 'package:any_quote/widget/quote_widget.dart';
import 'package:any_quote/widget/update_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LibraryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LibraryState();
}

class _LibraryState extends State<LibraryWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Quote>> _quotes;
  bool Function(Quote quote) _predicate = (quote) => true;

  void _onSearch(String search) {
    final String searchText = search.toLowerCase();
    setState(() {
      _predicate = (quote) =>
          quote.text.toLowerCase().contains(searchText) ||
          quote.location.toLowerCase().contains(searchText) ||
          quote.source.toLowerCase().contains(searchText);
    });
  }

  @override
  void initState() {
    super.initState();
    _quotes = _prefs.then((prefs) {
      return prefs
          .getStringList(PreferenceKey.QUOTES)
          .map((string) => Quote.fromString(string))
          .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'search',
          ),
          onChanged: _onSearch,
        ),
        actions: <Widget>[
          UpdateButton<List<Quote>>(
            update: () async => await updateQuotes(await _prefs),
            onFinish: (context, quotes) {
              return Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('updated ${quotes.length} quotes !'),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Quote>>(
        future: _quotes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scrollbar(
              child: ListView(
                children: snapshot.data
                    .where(_predicate)
                    .map((quote) => QuoteWidget(quote))
                    .toList(growable: false),
                physics: const BouncingScrollPhysics(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
