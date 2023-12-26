import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';

enum _Languages { english, vietnamese }

extension _LanguagesExtension on _Languages {
  String get name {
    switch (this) {
      case _Languages.english:
        return 'English';
      case _Languages.vietnamese:
        return 'Tiếng Việt';
      default:
        return "Unknown";
    }
  }
}

_Languages? _selected = _Languages.english;

void showLanguageSelectBottomSheet(BuildContext context) {
  showGlassModalBottomSheet<void>(
      context: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(_Languages.vietnamese.name),
                leading: Radio<_Languages>(
                  value: _Languages.vietnamese,
                  groupValue: _selected,
                  onChanged: (_Languages? value) {},
                ),
                onTap: () {
                  setState(() {
                    _selected = _Languages.vietnamese;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(_Languages.english.name),
                leading: Radio<_Languages>(
                  value: _Languages.english,
                  groupValue: _selected,
                  onChanged: (_Languages? value) {},
                ),
                onTap: () {
                  setState(() {
                    _selected = _Languages.english;
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          ),
        );
      }));
}
