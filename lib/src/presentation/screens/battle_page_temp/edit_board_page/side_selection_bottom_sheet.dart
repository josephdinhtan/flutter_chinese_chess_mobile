import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';

enum _sideFirstMove { red, black }

extension _LanguagesExtension on _sideFirstMove {
  String get name {
    switch (this) {
      case _sideFirstMove.red:
        return 'Đỏ tiên';
      case _sideFirstMove.black:
        return 'Đen tiên';
      default:
        return "Unknown";
    }
  }
}

Future<void> _popAfter(
  BuildContext context,
  int miniSecond,
  Function(bool isRed) selected,
  bool isRed,
) async {
  await Future.delayed(Duration(milliseconds: miniSecond));
  Navigator.of(context).pop();
  await Future.delayed(const Duration(milliseconds: 10));
  selected(isRed);
}

void showFirstMoveSelectionBottomSheet(
    BuildContext context, Function(bool isRed) onSelected) {
  _sideFirstMove? _selected = _sideFirstMove.red;
  showGlassModalBottomSheet<void>(
      context: context,
      backgroundOpacity: 1.0,
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
                title: Text(_sideFirstMove.red.name),
                leading: Radio<_sideFirstMove>(
                  value: _sideFirstMove.red,
                  groupValue: _selected,
                  onChanged: (_sideFirstMove? value) {},
                ),
                onTap: () {
                  setState(() {
                    _selected = _sideFirstMove.red;
                    _popAfter(context, 300, onSelected, true);
                  });
                },
              ),
              ListTile(
                title: Text(_sideFirstMove.black.name),
                leading: Radio<_sideFirstMove>(
                  value: _sideFirstMove.black,
                  groupValue: _selected,
                  onChanged: (_sideFirstMove? value) {},
                ),
                onTap: () {
                  setState(() {
                    _selected = _sideFirstMove.black;
                    _popAfter(context, 300, onSelected, false);
                  });
                },
              )
            ],
          ),
        );
      }));
}
