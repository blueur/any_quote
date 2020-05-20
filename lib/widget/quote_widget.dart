import 'package:any_quote/model/quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuoteWidget extends StatelessWidget {
  final Quote quote;

  const QuoteWidget(this.quote, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quote == null) {
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('no quote'),
          ),
        ),
      );
    }
    return Card(
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
    );
  }
}
