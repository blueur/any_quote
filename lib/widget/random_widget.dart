import 'package:any_quote/model/quote.dart';
import 'package:any_quote/service/quote_service.dart';
import 'package:any_quote/service/random_service.dart';
import 'package:any_quote/widget/quote_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class RandomWidget extends StatefulWidget {
  RandomWidget({Key key}) : super(key: key);

  @override
  _RandomWidgetState createState() => _RandomWidgetState();
}

class _RandomWidgetState extends State<RandomWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<Quote> _quote;

  Future<void> _refreshQuote() async {
    final SharedPreferences prefs = await _prefs;
    final Quote quote = await getQuote();
    setState(() {
      _quote = prefs
          .setString(PreferenceKey.QUOTE, quote.toString())
          .then((success) => quote);
    });
  }

  Future<Quote> getQuote() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> quoteStrings = prefs.getStringList(PreferenceKey.QUOTES);
    if (quoteStrings != null) {
      return Quote.fromString(randomInstance(quoteStrings));
    } else {
      final List<Quote> quotes = await updateQuotes(prefs);
      return randomInstance(quotes);
    }
  }

  @override
  void initState() {
    super.initState();
    _quote = _prefs.then((prefs) {
      return Quote.fromString(prefs.getString(PreferenceKey.QUOTE));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: FutureBuilder<Quote>(
                  future: _quote,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else {
                          return QuoteWidget(snapshot.data);
                        }
                    }
                  },
                ),
              ),
            ),
            onRefresh: _refreshQuote,
          ),
        ),
        IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.refresh),
          onPressed: _refreshQuote,
        )
      ],
    );
  }
}
