import 'package:any_quote/model/quote.dart';
import 'package:any_quote/service/quote_service.dart';
import 'package:any_quote/service/random_service.dart';
import 'package:any_quote/widget/quote_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class RandomQuoteWidget extends StatefulWidget {
  RandomQuoteWidget({Key key}) : super(key: key);

  @override
  _RandomQuoteWidgetState createState() => _RandomQuoteWidgetState();
}

class _RandomQuoteWidgetState extends State<RandomQuoteWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<Quote> _quote;

  Future<Quote> _setQuote(Quote quote) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _quote = prefs
          .setString(PreferenceKey.QUOTE, quote.toString())
          .then((success) => quote);
    });
    return quote;
  }

  Future<Quote> _refreshQuote() async {
    final Quote quote = await _getRandomQuote();
    return _setQuote(quote);
  }

  Future<Quote> _getRandomQuote() async {
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
      final Quote quote =
          Quote.fromString(prefs.getString(PreferenceKey.QUOTE));
      if (quote != null) {
        return quote;
      } else {
        return _refreshQuote();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Center(
              child: RefreshIndicator(
                onRefresh: _refreshQuote,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: FutureBuilder<Quote>(
                      future: _quote,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              if (snapshot.data != null) {
                                return QuoteWidget(snapshot.data);
                              } else {
                                return const NoQuoteWidget();
                              }
                            }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          color: Theme.of(context).primaryColor,
          icon: const Icon(Icons.refresh),
          onPressed: _refreshQuote,
        )
      ],
    );
  }
}
