import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../board/thinking_board_widget.dart';
import 'ruler.dart';
import '../state_controllers/game.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key, required this.scene, this.onBoardTap});

  final GameScene scene;
  final Function(BuildContext, int)? onBoardTap;

  @override
  Widget build(BuildContext context) {
    //
    // Giới hạn độ rộng của bàn cờ khi tỉ lệ màn hình nhỏ hơn 16/9
    final windowSize = MediaQuery.of(context).size;
    double height = windowSize.height, width = windowSize.width;

    if (height / width < Ruler.kProperAspectRatio) {
      width = height / Ruler.kProperAspectRatio;
      //_additionPaddingH = (windowSize.width - width) / 2 + Ruler.kBoardMargin;
    }

// build bàn cờ
    final boardWidget = ThinkingBoardWidget(
      width, // - _paddingH * 2,
      onBoardTap,
      opponentHuman: false,
    );

    return Container(
      margin: EdgeInsets.symmetric(
        //horizontal: _additionPaddingH,
        vertical: Ruler.kBoardMargin,
      ),
      child: Column(
        children: [
          LinearProgressIndicator(),
          boardWidget,
          LinearProgressIndicator(),
        ],
      ),
    );
  }
}
