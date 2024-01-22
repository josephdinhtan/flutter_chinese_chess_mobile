import 'package:flutter/material.dart';

import '../../settings_screen/local_db/user_settings_db.dart';

// Channels
const kChannelCommon = 'Common';
const kChannelMainland = 'Mainland';
const kChannelCurrent = kChannelMainland;

class GameColors {
  //
  static const logoColor = Color(0xFF6D000D);
  static const activeColor = Color(0xFF4DA736);

  static const primary = Color(0xFF461220);
  static const secondary = Color(0x99461220);

  static const darkBackground = Colors.brown;
  static const lightBackground = Color(0xFFEEE0CB);
  static const specialBackground = Color(0xFF555555);
  static const menuBackground = Color(0xFFEFDECF);

  static const boardBackground = Color(0xFFEBC38D);

  static const darkTextPrimary = Color(0xFF461220);
  static const darkTextSecondary = Color(0x99FFFFFF);
  static const darkIcon = Colors.greenAccent;

  static const boardLine = Color(0x996D000D);
  static const boardTips = Color(0x666D000D);

  static const lightLine = Color(0x336D000D);
}

class BoardTheme {
  //
  static const defaultTheme = BoardTheme();
  static const highContrastTheme = BoardTheme(
    blackPieceColor: Colors.black,
    blackPieceTextColor: Colors.white,
    redPieceColor: Colors.white,
    redPieceTextColor: Colors.black,
  );

  final Color focusPoint, blurPoint;
  final Color blackPieceColor, blackPieceBorderColor;
  final Color redPieceColor, redPieceBorderColor;
  final Color blackPieceTextColor, redPieceTextColor;

  const BoardTheme({
    this.focusPoint = const Color(0xCCFF8B00),
    this.blurPoint = const Color(0xCCFF8B00),
    this.blackPieceColor = const Color(0xFF222222),
    this.blackPieceBorderColor = const Color(0xFFFF8B00),
    this.redPieceColor = const Color(0xFF7B0000),
    this.redPieceBorderColor = const Color(0xFFFF8B00),
    this.blackPieceTextColor = const Color(0xCCFFFFFF),
    this.redPieceTextColor = const Color(0xCCFFFFFF),
  });
}

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
      fontFamily: UserSettingsDb().uiFont,
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
      fontFamily: UserSettingsDb().uiFont,
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
