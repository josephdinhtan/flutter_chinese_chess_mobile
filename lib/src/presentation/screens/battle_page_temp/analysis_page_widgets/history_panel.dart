import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_controllers/board_state.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({
    super.key,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      //color: Color(0xFF654F4D),
      color: Colors.white70,
    ),
  });

  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Consumer<BoardState>(builder: (context, boardState, child) {
        final moves = boardState.positionMap.moveList;
        final moveWidgets = <Widget>[];
        for (int i = 0; i < moves.length; i = i + 2) {
          moveWidgets.add(SizedBox(
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 16.0),
                Text(
                  ((i + 2) / 2).toString().split('.')[0],
                  style: textStyle.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8.0),
                MoveContainer(
                  text: moves[i],
                  isRed: true,
                  textStyle: textStyle,
                ),
                if (i + 1 < moves.length)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: MoveContainer(
                      text: moves[i],
                      isRed: false,
                      textStyle: textStyle,
                    ),
                  ),
                const SizedBox(width: 8.0),
              ],
            ),
          ));
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines);
            alignment: WrapAlignment.start,
            children: moveWidgets,
          ),
        );
      }),
    );
  }
}

class MoveContainer extends StatelessWidget {
  const MoveContainer({
    super.key,
    required this.text,
    required this.isRed,
    this.textStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Color(0xFF654F4D),
    ),
  });

  final bool isRed;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isRed ? Colors.red.withOpacity(0.2) : Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 0.0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle,
      ),
    );
  }
}
