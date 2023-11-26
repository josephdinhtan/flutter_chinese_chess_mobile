import 'package:flutter/material.dart';

class SpinnerListTile extends StatelessWidget {
  SpinnerListTile(
      {super.key,
      required this.initValue,
      this.unit,
      required this.reduce,
      required this.plus});

  final int initValue;
  final String? unit;
  final Function() reduce;
  final Function() plus;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        icon: const Icon(Icons.remove),
        onPressed: reduce,
      ),
      if (unit != null) Text('$initValue $unit') else Text('$initValue'),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: plus,
      ),
    ]);
  }
}
