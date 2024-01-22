import 'package:flutter/material.dart';

import '../board/board_widget.dart';
import '../board/pieces_layout.dart';
import '../cchess/chess_position_map.dart';
import '../chess_utils/ruler.dart';

class EditBoard extends StatelessWidget {
  const EditBoard({
    super.key,
    this.onBoardTap,
    required this.activeIndex,
    required this.isFlipped,
    required this.positionMap,
    required this.onHandIndex,
    this.backgroundImagePath,
    this.boardBackgroundColor,
    this.boardLineColor,
  });

  final ChessPositionMap positionMap;
  final bool isFlipped;
  final int activeIndex;
  final int onHandIndex;
  final String? backgroundImagePath;
  final Color? boardBackgroundColor;
  final Color? boardLineColor;
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
      positionMap: positionMap,
      width: width,
      onBoardTap: onBoardTap,
      footprintIndex: activeIndex,
      isFlipped: isFlipped,
      handOnIndex: onHandIndex,
      backgroundImagePath: backgroundImagePath,
      backgroundColor: boardBackgroundColor,
      boardLineColor: boardLineColor,
    );
  }
}

class _EditBoardWidget extends BoardWidget {
  const _EditBoardWidget({
    required this.positionMap,
    required this.footprintIndex,
    required this.handOnIndex,
    required double width,
    required this.isFlipped,
    this.backgroundImagePath,
    this.backgroundColor,
    this.boardLineColor,
    Function(BuildContext, int)? onBoardTap,
    Key? key,
  }) : super(
          width,
          onBoardTap,
          key: key,
          boardBackgroundImagePath: backgroundImagePath,
          boardBackgroundColor: backgroundColor,
          boardLineColor: boardLineColor,
        );
  final ChessPositionMap positionMap;
  final bool isFlipped;
  final int footprintIndex;
  final int handOnIndex;
  final String? backgroundImagePath;
  final Color? backgroundColor;
  final Color? boardLineColor;

  @override
  Widget buildPiecesLayer(BuildContext context, {bool opponentHuman = false}) {
    final piecesLayout = PiecesLayout(
      width,
      positionMap,
      footprintIndex: footprintIndex,
      handOnIndex: handOnIndex,
      isBoardFlipped: isFlipped,
      handOnColor: Colors.greenAccent,
    );
    return piecesLayout.buildPiecesLayout(context);
  }
}
