import 'package:flutter/material.dart';

import '../../../utils/logging/prt.dart';
import '../../config/colors/game_colors.dart';
import '../../router/router.dart';
import '../../widgets/board/thinking_board_widget.dart';
import '../../widgets/ruler.dart';
import 'battle_widgets/operation_bar/operation_bar.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  onBoardTap(BuildContext context, int index) async {
    prt("Jdt onBoardTap index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GameColors.battleBackground,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: GameColors.battleBackground,
          body: Column(
            children: [
              Text("Score: 1023 (đỏ ưu)"),
              createChessBoard(context, GameScene.battle,
                  onBoardTap: onBoardTap),
              OperationBar(
                  barBackgroundColor: GameColors.operationBarBackground,
                  iconColor: GameColors.iconColor),
              const Expanded(child: Center(child: Text("comment"))),
            ],
          ),
        ),
      ),
    );
  }
}

Widget createChessBoard(BuildContext context, GameScene scene,
    {Function(BuildContext, int)? onBoardTap, bool opponentHuman = false}) {
  //
  // Giới hạn độ rộng của bàn cờ khi tỉ lệ màn hình nhỏ hơn 16/9
  final windowSize = MediaQuery.of(context).size;
  double height = windowSize.height, width = windowSize.width;
  double _additionPaddingH = 0;
  if (height / width < Ruler.kProperAspectRatio) {
    width = height / Ruler.kProperAspectRatio;
    _additionPaddingH = (windowSize.width - width) / 2 + Ruler.kBoardMargin;
  }

// build bàn cờ
  final boardWidget = ThinkingBoardWidget(
    width - 10.0 * 2,
    onBoardTap,
    opponentHuman: opponentHuman,
  );

  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: _additionPaddingH,
      vertical: Ruler.kBoardMargin,
    ),
    child: boardWidget,
  );
}
