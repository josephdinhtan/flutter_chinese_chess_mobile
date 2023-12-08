import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chinese_chess_ai_mobile/src/presentation/screens/settings_screen/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../board/thinking_board_widget.dart';
import '../state_controllers/game.dart';
import '../state_controllers/page_state.dart';
import 'ruler.dart';

const _paddingH = 10.0;

double _additionPaddingH = 0;

Widget createRatingScore(BuildContext context, GameScene scene,
    {Function()? leftAction, Function()? rightAction}) {
  double score = 0;
  double percentage = 0.5;

  final subtitle = Consumer<PageState>(
    builder: (context, pageState, child) {
      score = pageState.score.toDouble();
      percentage = 0.5 + score / 5000;
      prt("Jdt score update to: $score, percentage: $percentage");
      if (percentage > 1) percentage = 0.95;
      if (percentage < 0) percentage = 0.05;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              pageState.status, // score, please move
              maxLines: 1,
              style: GameFonts.ui(
                fontSize: 16,
                color: GameColors.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              color: Colors.red,
              backgroundColor: Colors.black,
              value: percentage,
            ),
          )
        ],
      );
    },
  );

  return subtitle;
  // return Container(
  //   margin: safeArea,
  //   child: subtitle,
  // );
}

double boardPaddingH(BuildContext context) {
  //
  // Giới hạn độ rộng của bàn cờ khi tỉ lệ màn hình nhỏ hơn 16/9
  final windowSize = MediaQuery.of(context).size;
  double height = windowSize.height, width = windowSize.width;

  if (height / width < Ruler.kProperAspectRatio) {
    width = height / Ruler.kProperAspectRatio;
  }

  return (windowSize.width - (width - _paddingH * 2)) / 2;
}

String titleFor(BuildContext context, GameScene scene) {
  //
  switch (scene) {
    //
    case GameScene.battle:
      return 'Man-machine exercise';

    case GameScene.gameNotation:
      return 'my game';

    case GameScene.unknown:
      return "unknown";
  }

  throw 'Scene is node define.';
}

drawText(Canvas canvas, String text, TextStyle textStyle,
    {Offset? centerLocation, Offset? startLocation, Offset? endLocation}) {
  //
  final textSpan = TextSpan(text: text, style: textStyle);
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  )..layout();

  if (startLocation != null) {
    textPainter.paint(canvas, startLocation);
    return;
  }

  final textSize = textPainter.size;

  if (endLocation != null) {
    textPainter.paint(canvas, endLocation - Offset(textSize.width, 0));
    return;
  }

  if (centerLocation != null) {
    //
    final metric = textPainter.computeLineMetrics()[0];

    // 从顶上算，文字的 Baseline 在 2/3 高度线上
    final textOffset = centerLocation -
        Offset(
          textSize.width / 2,
          metric.baseline - textSize.height / 3 + 1,
        );

    textPainter.paint(canvas, textOffset);
  }
}
