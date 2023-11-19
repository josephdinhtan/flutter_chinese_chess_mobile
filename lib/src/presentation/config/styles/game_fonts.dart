import 'package:flutter/material.dart';

import '../colors/game_colors.dart';

class GameFonts {
  //
  static TextStyle uicp({
    double? fontSize,
    Color color = GameColors.primary,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      //fontFamily: LocalData().uiFont.value,
      height: height,
    );
  }

  static TextStyle ui({
    double? fontSize,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      //fontFamily: LocalData().uiFont.value,
      height: height,
    );
  }

  static TextStyle art({
    double? fontSize,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      //fontFamily: LocalData().artFont.value,
      height: height,
    );
  }

  static TextStyle artForce({
    double? fontSize,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      //fontFamily: LocalData().artFont.value,
      height: height,
    );
  }
}
