import 'package:flutter/material.dart';
import 'package:flutter_chinese_chess_ai_mobile/src/utils/extensions/string_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../state_controllers/battle_state.dart';
import '../state_controllers/board_state.dart';

class EngineStatusBar extends StatelessWidget {
  const EngineStatusBar({
    super.key,
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      //color: Color(0xFF654F4D),
      color: Colors.white70,
    ),
  });

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer<BattleState>(builder: (context, pageState, child) {
          var score = 0;
          var status = "";
          if (pageState.isMate) {
            status = pageState.score > 0
                ? '${pageState.score} nước ĐỎ thắng'.hardCode
                : '${-pageState.score} nước ĐEN thắng'.hardCode;
            score = score > 0 ? 10000 : -10000;
          } else {
            score = pageState.score;
            final judge = score == 0
                ? 'Cân bằng'.hardCode
                : score > 0
                    ? 'Đỏ ưu'.hardCode
                    : 'Đen ưu'.hardCode;
            status = '$judge ${score > 0 ? score : score * -1} điểm'.hardCode;
          }
          return _EnginePercentage(
            score: score,
            status: status,
          );
        }),
        Container(
          height: 40.0,
          child: Consumer<BoardState>(builder: (context, boardState, child) {
            List<String> moves = [];
            prt("Jdt boardState state change: ${boardState.bestMove}");
            prt("Jdt boardState state change: ${boardState.engineInfo}");
            if (boardState.engineInfo != null) {
              moves = boardState.engineInfo!.predictMoves(boardState);
              var pvs = boardState.engineInfo!.pvs;
              prt("Jdt buildEngineHint pvs: $pvs");
              prt("Jdt buildEngineHint: $moves");
            }
            bool isRedMove = boardState.isRedTurn;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: moves.map((item) {
                      var text = Container(
                        decoration: BoxDecoration(
                          color: isRedMove
                              ? Colors.red.withOpacity(0.2)
                              : Colors.black.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: Text(
                          item,
                          style: textStyle,
                        ),
                      );
                      isRedMove = !isRedMove;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: text,
                      );
                    }).toList()),
              ),
            );
          }),
        )
      ],
    );
  }
}

class _EnginePercentage extends StatelessWidget {
  const _EnginePercentage({
    required this.score,
    required this.status,
  });

  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    var percentage = 0.5 - score.toDouble() / 5000;
    prt("Jdt score update to: $score, percentage: $percentage");
    if (score == 10000) {
      percentage = 1;
    } else if (score == -10000) {
      percentage = 0;
    } else if (percentage > 1) {
      percentage = 0.98;
    } else if (percentage < 0) {
      percentage = 0.02;
    }

    return Stack(
      children: [
        SizedBox(
          height: 30.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(
              color: Colors.black,
              backgroundColor: const Color(0xFFCC423C),
              value: percentage,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Text(
                status, // score, please move
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              )),
        ),
      ],
    );
  }
}
