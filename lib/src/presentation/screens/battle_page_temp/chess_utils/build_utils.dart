import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../state_controllers/battle_state.dart';
import '../state_controllers/game.dart';
import 'ruler.dart';

const _paddingH = 10.0;

double _additionPaddingH = 0;

Widget createRatingScore(BuildContext context,
    {Function()? leftAction, Function()? rightAction}) {
  double score = 0;
  double percentage = 0.5;

  final subtitle = Consumer<BattleState>(
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
          LinearProgressIndicator(
            color: Colors.red,
            backgroundColor: Colors.black,
            value: percentage,
          ),
        ],
      );
    },
  );

  return subtitle;
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
