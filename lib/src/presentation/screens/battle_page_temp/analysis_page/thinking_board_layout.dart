import 'package:flutter/material.dart';
import '../../../../utils/logging/prt.dart';
import '../../settings_screen/local_db/user_settings_db.dart';
import '../cchess/cchess_base.dart';
import '../engine/pikafish_engine.dart';
import '../state_controllers/board_state.dart';
import '../board/pieces_layout.dart';
import 'arrow_board_painter.dart';

class ThinkingBoardLayout extends StatefulWidget {
  //
  final BoardState boardState;

  final PiecesLayout piecesLayout;

  const ThinkingBoardLayout(this.boardState, this.piecesLayout, {Key? key})
      : super(key: key);

  @override
  State createState() => _PiecesLayoutState();
}

class _PiecesLayoutState extends State<ThinkingBoardLayout> {
  //
  @override
  Widget build(BuildContext context) {
    //
    final moves = <Move>[];

    if (PikafishEngine().state != EngineState.searching &&
        widget.boardState.bestMove?.opponentPonder != null) {
      //
      prt("Jdt bestMove.opponentPonder != null add move");
      moves.add(Move.fromEngineMove(widget.boardState.bestMove!.bestMove));
      moves.add(
          Move.fromEngineMove(widget.boardState.bestMove!.opponentPonder!));
      //
    } else if (widget.boardState.engineInfo != null) {
      //
      var pvs = widget.boardState.engineInfo!.pvs;
      prt("Jdt bestMove.ponder != null add move pvs: $pvs");

      // limited arrow to 2 only
      if (pvs.length > 2) {
        pvs = pvs.sublist(0, 2);
      }

      moves.addAll(pvs.map((move) => Move.fromEngineMove(move)));
      prt("Jdt bestMove.ponder != null add move moves: $moves");
    }

    final chessPieces = widget.piecesLayout.buildPiecesLayout(context);

    return Stack(children: [
      chessPieces,
      if (UserSettingsDb().thinkingArrowEnabled)
        CustomPaint(
          painter: ArrowBoardPainter(moves, widget.piecesLayout),
        )
    ]);
  }
}
