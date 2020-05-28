import 'package:any_quote/widget/library_widget.dart';
import 'package:any_quote/widget/random_widget.dart';
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
    RandomWidget(),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            title: Text('quote'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('library'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onTap,
      ),
    );
  }
}
