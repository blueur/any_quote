import 'package:any_quote/model/quote.dart';
import 'package:any_quote/service/quote_service.dart';
import 'package:any_quote/widget/quote_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LibraryState();
}

class _LibraryState extends State<LibraryWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _text_controller = TextEditingController();
  Future<List<Quote>> _quotes;
  bool Function(Quote quote) _predicate = (quote) => true;

  void _onSearch(String search) {
    final String searchText = search.toLowerCase();
    setState(() {
      _predicate = (quote) =>
          quote.text.toLowerCase().contains(searchText) ||
          quote.location.toLowerCase().contains(searchText) ||
          quote.reference.toLowerCase().contains(searchText);
    });
  }

  @override
  void initState() {
    super.initState();
    _quotes = _prefs.then(readQuotes);
    _text_controller.addListener(() => _onSearch(_text_controller.text));
  }

  @override
  void dispose() {
    _text_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _text_controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: MaterialLocalizations.of(context).searchFieldLabel,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                FocusScope.of(context).unfocus();
                _text_controller.clear();
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Quote>>(
        future: _quotes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Quote> quotes = snapshot.data.where(_predicate).toList();
            if (quotes.isNotEmpty) {
              return Scrollbar(
                child: ListView(
                  children: quotes
                      .asMap()
                      .entries
                      .map((entry) => Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              QuoteWidget(entry.value),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text('${entry.key + 1}/${quotes.length}'),
                              )
                            ],
                          ))
                      .toList(),
                  physics: const BouncingScrollPhysics(),
                ),
              );
            } else {
              return const NoQuoteWidget();
            }
          } else if (snapshot.hasError) {
            return Text('error: ${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
