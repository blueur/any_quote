import 'package:any_quote/widget/pages_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  final List<_Setting> _settings = [
    _Setting(
      icon: Icon(Icons.library_books),
      title: 'sources',
      body: PagesWidget(),
      isExpanded: true,
    ),
    _Setting(
      icon: Icon(Icons.info),
      title: 'about',
      body: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/c/cd/Wikidata_stamp.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              _settings[index].isExpanded = !isExpanded;
            });
          },
          children: _settings.map<ExpansionPanel>((setting) {
            return ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: setting.isExpanded,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  leading: setting.icon,
                  title: Text(setting.title),
                );
              },
              body: setting.body,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Setting {
  final Icon icon;
  final String title;
  final Widget body;
  bool isExpanded;

  _Setting(
      {@required this.icon,
      @required this.title,
      @required this.body,
      this.isExpanded = false});
}
