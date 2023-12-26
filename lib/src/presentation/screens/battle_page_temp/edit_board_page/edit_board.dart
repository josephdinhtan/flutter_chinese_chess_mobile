import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../board/board_widget.dart';
import '../board/pieces_layout.dart';
import '../cchess/cchess_fen.dart';
import '../chess_utils/ruler.dart';

class EditBoard extends StatelessWidget {
  const EditBoard(
      {super.key,
      this.onBoardTap,
      required this.editFen,
      required this.isFlipped});

  final String editFen;
  final bool isFlipped;
  final Function(BuildContext, int)? onBoardTap;

  @override
  Widget build(BuildContext context) {
    // Giới hạn độ rộng của bàn cờ khi tỉ lệ màn hình nhỏ hơn 16/9
    final windowSize = MediaQuery.of(context).size;
    double height = windowSize.height, width = windowSize.width;
    if (height / width < Ruler.kProperAspectRatio) {
      width = height / Ruler.kProperAspectRatio;
    }
    return _EditBoardWidget(
        initFen: editFen,
        width: width,
        onBoardTap: onBoardTap,
        isFlipped: isFlipped);
  }
}

// mặt bàn cờ có thinking
class _EditBoardWidget extends BoardWidget {
  const _EditBoardWidget(
      {required this.initFen,
      required double width,
      required this.isFlipped,
      Function(BuildContext, int)? onBoardTap,
      Key? key})
      : super(width, onBoardTap, key: key);
  final String initFen;
  final bool isFlipped;

  @override
  Widget buildPiecesLayer(BuildContext context, {bool opponentHuman = false}) {
    final piecesLayout = PiecesLayout(
      width,
      Fen.toPosition(initFen)!,
      isBoardFlipped: isFlipped,
    );
    return piecesLayout.buildPiecesLayout(context);
  }
}
