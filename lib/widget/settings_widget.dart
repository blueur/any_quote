import 'package:any_quote/localizations.dart';
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
      icon: const Icon(Icons.library_books),
      getTitle: (context) => AppLocalizations.of(context).sources,
      body: PagesWidget(),
      isExpanded: true,
    ),
    _Setting(
      icon: const Icon(Icons.info),
      getTitle: (context) => AppLocalizations.of(context).about,
      body: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/c/cd/Wikidata_stamp.png',
      ),
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
                  title: Text(setting.getTitle(context)),
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
  final String Function(BuildContext context) getTitle;
  final Widget body;
  bool isExpanded;

  _Setting(
      {@required this.icon,
      @required this.getTitle,
      @required this.body,
      this.isExpanded = false});
}
