import 'package:flutter/material.dart';

class BlurHolder extends StatelessWidget {
  //
  final double diameter, squreSide;

  const BlurHolder({
    Key? key,
    required this.diameter,
    required this.squreSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all((squreSide - diameter) / 2),
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(diameter / 2),
        color: const Color(0xCCFF8B00),
      ),
    );
  }
}
