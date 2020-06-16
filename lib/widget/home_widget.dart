import 'package:any_quote/localizations.dart';
import 'package:any_quote/widget/library_widget.dart';
import 'package:any_quote/widget/random_quote_widget.dart';
import 'package:any_quote/widget/settings_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeWidget> {
  int _selectedIndex = 0;
  static final List<Widget> _widgets = <Widget>[
    RandomQuoteWidget(),
    LibraryWidget(),
    SettingsWidget(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _widgets.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.format_quote),
            title: Text(AppLocalizations.of(context).quote),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books),
            title: Text(AppLocalizations.of(context).library),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).settings),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onTap,
      ),
    );
  }
}
