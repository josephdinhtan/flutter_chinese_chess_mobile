import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../board/board_widget.dart';
import '../board/pieces_layout.dart';
import '../cchess/cchess_fen.dart';
import '../chess_utils/ruler.dart';
import '../state_controllers/board_state.dart';
import 'thinking_board_layout.dart';

class ThinkingBoard extends StatelessWidget {
  const ThinkingBoard({super.key, this.onBoardTap});
  final Function(BuildContext, int)? onBoardTap;

  @override
  Widget build(BuildContext context) {
    final boardState = Provider.of<BoardState>(context);
    prt("Jdt ${Fen.fromPosition(boardState.position)}",
        tag: "thinking_board_page");
    // Giới hạn độ rộng của bàn cờ khi tỉ lệ màn hình nhỏ hơn 16/9
    final windowSize = MediaQuery.of(context).size;
    double height = windowSize.height, width = windowSize.width;

    if (height / width < Ruler.kProperAspectRatio) {
      width = height / Ruler.kProperAspectRatio;
      //_additionPaddingH = (windowSize.width - width) / 2 + Ruler.kBoardMargin;
    }

// build bàn cờ
    final boardWidget = _ThinkingBoardWidget(
      width, // - _paddingH * 2,
      onBoardTap,
      opponentHuman: false,
    );

    return boardWidget;
  }
}

// mặt bàn cờ có thinking
class _ThinkingBoardWidget extends BoardWidget {
  //
  const _ThinkingBoardWidget(
      double width, Function(BuildContext, int)? onBoardTap,
      {Key? key, required bool opponentHuman})
      : super(width, onBoardTap, opponentHuman: opponentHuman, key: key);

  @override
  Widget buildPiecesLayer(BuildContext context, {bool opponentHuman = false}) {
    return Consumer<BoardState>(builder: (context, boardState, child) {
      return ThinkingBoardLayout(
        boardState,
        PiecesLayout(
          width,
          boardState.position,
          hoverIndex: boardState.liftUpIndex,
          footprintIndex: boardState.footprintIndex,
          activeIndex: boardState.activeIndex,
          //pieceAnimationValue: board.pieceAnimationValue,
          isBoardFlipped: boardState.isBoardFlipped,
        ),
      );
    });
  }
}
