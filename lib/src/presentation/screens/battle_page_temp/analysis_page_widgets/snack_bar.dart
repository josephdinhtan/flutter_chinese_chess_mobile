import 'package:flutter/material.dart';

import '../../../../../main_app_debug.dart';
import '../state_controllers/game.dart';

void showSnackBar(
  String text, {
  bool shortDuration = false,
  Color? bgColor,
  SnackBarAction? action,
}) {
  //
  ScaffoldMessenger.of(ChessAppAi.context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor ?? GameColors.primary,
      duration: Duration(milliseconds: shortDuration ? 1000 : 4000),
      content: Text(text),
      action: action,
    ),
  );
}
