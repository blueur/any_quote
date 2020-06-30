import 'package:any_quote/localizations.dart';
import 'package:any_quote/model/quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuoteWidget extends StatelessWidget {
  final Quote quote;

  const QuoteWidget(this.quote, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                quote.location,
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
            SelectableText(
              quote.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            quote.original.isNotEmpty
                ? SelectableText(
                    quote.original,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 16,
            ),
            quote.precision.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SelectableText(
                      quote.precision,
                      textAlign: TextAlign.left,
                    ),
                  )
                : const SizedBox.shrink(),
            Align(
              alignment: Alignment.centerRight,
              child: SelectableText(
                quote.reference,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoQuoteWidget extends StatelessWidget {
  const NoQuoteWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context).noQuote),
    );
  }
}
