import 'package:any_quote/model/quote.dart';
import 'package:any_quote/service/quote_service.dart' as quoteService;
import 'package:any_quote/service/random_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String QUOTES = 'quotes';
const String QUOTE = 'quote';

class QuoteWidget extends StatefulWidget {
  QuoteWidget({Key key}) : super(key: key);

  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<Quote> _quote;

  Future<List<Quote>> _updateQuotes() async {
    final SharedPreferences prefs = await _prefs;
    final List<Quote> quotes =
        await quoteService.getQuotes('Kaamelott').toList();
    return prefs
        .setStringList(QUOTES, quotes.map((quote) => quote.toString()).toList())
        .then((success) => quotes);
  }

  Future<void> _refreshQuote() async {
    final SharedPreferences prefs = await _prefs;
    final String quoteString = randomInstance(prefs.getStringList(QUOTES));
    final Quote quote = Quote.fromString(quoteString);
    setState(() {
      _quote =
          prefs.setString(QUOTE, quote.toString()).then((success) => quote);
    });
  }

  _quoteWidget(Quote quote) {
    if (quote == null) {
      return Center(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('no quote'),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${quote.location}:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                quote.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  quote.source,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _quote = _prefs.then((prefs) {
      String quoteString = prefs.getString(QUOTE);
      if (quoteString == null) {
        _updateQuotes();
        quoteString = prefs.getString(QUOTE);
      }
      return Quote.fromString(quoteString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote'),
        actions: <Widget>[UpdateButtonWidget(_updateQuotes)],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
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
                  return _quoteWidget(snapshot.data);
                }
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton(
        onPressed: _refreshQuote,
        child: new Icon(Icons.refresh),
      ),
    );
  }
}

class UpdateButtonWidget extends StatefulWidget {
  final Future<List<Quote>> Function() update;

  UpdateButtonWidget(this.update);

  @override
  State<StatefulWidget> createState() => _UpdateButtonState(update);
}

class _UpdateButtonState extends State<UpdateButtonWidget> {
  final Future<List<Quote>> Function() update;
  bool _isUpdating = false;

  _UpdateButtonState(this.update);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_isUpdating) {
          return const AspectRatio(
            aspectRatio: 1.0,
            child: RefreshProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.blue,
            ),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              setState(() {
                _isUpdating = true;
              });
              update().then((quotes) {
                setState(() {
                  _isUpdating = false;
                });
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('updated ${quotes.length} quotes !'),
                  ),
                );
              });
            },
          );
        }
      },
    );
  }
}
