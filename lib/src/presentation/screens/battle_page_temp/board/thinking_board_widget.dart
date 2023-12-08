import 'package:flutter/material.dart';

import '../state_controllers/board_state.dart';
import 'board_widget.dart';
import 'pieces_layout.dart';
import 'thinking_board_layout.dart';

// mặt bàn cờ có thinking
class ThinkingBoardWidget extends BoardWidget {
  //
  const ThinkingBoardWidget(
      double width, Function(BuildContext, int)? onBoardTap,
      {Key? key, required bool opponentHuman})
      : super(width, onBoardTap, opponentHuman: opponentHuman, key: key);

  @override
  Widget buildPiecesLayer(BoardState board, {bool opponentHuman = false}) {
    //
    return ThinkingBoardLayout(
      board,
      PiecesLayout(
        width,
        board.position,
        hoverIndex: board.liftUpIndex,
        footprintIndex: board.footprintIndex,
        activeIndex: board.activeIndex,
        //pieceAnimationValue: board.pieceAnimationValue,
        isBoardFlipped: board.isBoardFlipped,
      ),
    );
  }
}
