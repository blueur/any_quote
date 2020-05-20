import 'package:any_quote/model/quote.dart';
import 'package:any_quote/service/quote_service.dart';
import 'package:any_quote/widget/quote_widget.dart';
import 'package:any_quote/widget/random_widget.dart';
import 'package:any_quote/widget/update_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LibraryState();
}

class _LibraryState extends State<LibraryWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<Quote>> _quotes;

  @override
  void initState() {
    super.initState();
    _quotes = _prefs.then((prefs) {
      return prefs
          .getStringList(QUOTES)
          .map((string) => Quote.fromString(string))
          .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
