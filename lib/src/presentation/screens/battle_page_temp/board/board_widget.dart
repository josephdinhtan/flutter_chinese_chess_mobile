import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/logging/prt.dart';
import '../chess_utils/ruler.dart';
import '../state_controllers/board_state.dart';
import '../state_controllers/game.dart';
import 'pieces_layout.dart';
import 'pieces_layer.dart';
import 'board_painter.dart';
import 'words_on_board.dart';

// mặt bàn cờ
class BoardWidget extends StatelessWidget {
  //
  final double width;
  final Function(BuildContext, int)? onBoardTap;
  final bool opponentHuman;

  const BoardWidget(this.width, this.onBoardTap,
      {Key? key, this.opponentHuman = false})
      : super(key: key);

  double get height =>
      (width - Ruler.kBoardPadding * 2) / 9 * 10 +
      (Ruler.kBoardPadding + Ruler.kBoardDigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    //
    prt('BoardWidget build...');

    final boardContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: GameColors.boardBackground,
      ),
      child: Consumer<BoardState>(
        builder: (context, board, child) {
          return Stack(
            children: <Widget>[
              RepaintBoundary(
                child: CustomPaint(
                  painter: BoardPainter(width),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: Ruler.kBoardPadding,
                      horizontal: (width - Ruler.kBoardPadding * 2) / 9 / 2 +
                          Ruler.kBoardPadding -
                          Ruler.kBoardDigitsTextFontSize / 2,
                    ),
                    child: WordsOnBoard(board.isBoardFlipped),
                  ),
                ),
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
          board.position,
          hoverIndex: board.liftUpIndex,
          footprintIndex: board.footprintIndex,
          isBoardFlipped: board.isBoardFlipped,
          //pieceAnimationValue: board.pieceAnimationValue,
          opponentIsHuman: opponentHuman,
        ),
      );
    });
  }
}
