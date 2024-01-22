import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../chess_utils/ruler.dart';
import '../state_controllers/board_state.dart';
import 'board_painter.dart';
import 'pieces_layer.dart';
import 'pieces_layout.dart';

// mặt bàn cờ
class BoardWidget extends StatelessWidget {
  //
  final double width;
  final Function(BuildContext, int)? onBoardTap;
  final bool opponentHuman;
  final String? boardBackgroundImagePath;
  final Color? boardBackgroundColor;
  final Color? boardLineColor;

  const BoardWidget(
    this.width,
    this.onBoardTap, {
    Key? key,
    this.opponentHuman = false,
    this.boardBackgroundImagePath,
    this.boardBackgroundColor,
    this.boardLineColor,
  }) : super(key: key);

  double get height =>
      (width - Ruler.kBoardPadding * 2) / 9 * 10 +
      (Ruler.kBoardPadding + Ruler.kBoardDigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    prt('BoardWidget build...');

    final boardContainer = Container(
      width: width,
      height: height,
      child: Consumer<BoardState>(
        builder: (context, board, child) {
          return Stack(
            children: <Widget>[
              BoardPainter(
                width: width,
                isBoardFlipped: board.isBoardFlipped,
                boardBackgroundColor: boardBackgroundColor,
                backgroundImagePath: boardBackgroundImagePath,
                boardLineColor: boardLineColor,
              ),
              buildPiecesLayer(context, opponentHuman: opponentHuman),
            ],
          );
        },
      ),
    );

    if (onBoardTap == null) {
      return boardContainer;
    }

    return GestureDetector(
      child: boardContainer,
      onTapUp: (d) {
        //
        final gridWidth = (width - Ruler.kBoardPadding * 2) * 8 / 9;
        final squareWidth = gridWidth / 8;

        final dx = d.localPosition.dx, dy = d.localPosition.dy;
        final rank = (dy - Ruler.kBoardPadding - Ruler.kBoardDigitsHeight) ~/
            squareWidth;
        final file = (dx - Ruler.kBoardPadding) ~/ squareWidth;

        if (rank < 0 || rank > 9) return;
        if (file < 0 || file > 8) return;

        if (onBoardTap != null) {
          onBoardTap!(context, rank * 9 + file);
        }
      },
    );
  }

  Widget buildPiecesLayer(BuildContext context, {bool opponentHuman = false}) {
    return Consumer<BoardState>(builder: (context, board, child) {
      return PiecesLayer(
        PiecesLayout(
          width,
          board.positionMap,
          handOnIndex: board.liftUpIndex,
          footprint2ndIndex: board.footprintIndex,
          isBoardFlipped: board.isBoardFlipped,
          //pieceAnimationValue: board.pieceAnimationValue,
          opponentIsHuman: opponentHuman,
        ),
      );
    });
  }
}
