import 'dart:math';

import 'package:flutter/material.dart';

import '../../settings_screen/local_db/user_settings_db.dart';
import '../cchess/cchess_base.dart';
import '../state_controllers/game.dart';

class PieceHandWriting extends StatelessWidget {
  final String code;
  final bool selected;
  final double diameter, squareSize;
  final bool rotate;

  const PieceHandWriting(
      {Key? key,
      required this.code,
      required this.selected,
      required this.diameter,
      required this.squareSize,
      this.rotate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final theme = UserSettingsDb().highContrast
        ? BoardTheme.highContrastTheme
        : BoardTheme.defaultTheme;

    final borderColor = Piece.isRed(code)
        ? theme.redPieceBorderColor
        : theme.blackPieceBorderColor;
    final bgColor =
        Piece.isRed(code) ? theme.redPieceColor : theme.blackPieceColor;
    final textColor =
        Piece.isRed(code) ? theme.redPieceTextColor : theme.blackPieceTextColor;

    final textStyle = GameFonts.artForce(
      color: textColor,
      fontSize: diameter * 0.8,
    );

    if (selected) {
      return Transform.rotate(
        angle: rotate ? pi : 0,
        child: Container(
          width: squareSize,
          height: squareSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(squareSize / 2),
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: squareSize - diameter + 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 2,
              )
            ],
          ),
          child: Center(
            child: Text(
              Piece.zhName[code]!,
              style: textStyle,
              textScaleFactor: 1,
            ),
          ),
        ),
      );
    }

    return Transform.rotate(
      angle: rotate ? pi : 0,
      child: Container(
        margin: EdgeInsets.all((squareSize - diameter) / 2),
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(diameter / 2),
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            Piece.zhName[code]!,
            style: textStyle,
            textScaleFactor: 1,
          ),
        ),
      ),
    );
  }
}
