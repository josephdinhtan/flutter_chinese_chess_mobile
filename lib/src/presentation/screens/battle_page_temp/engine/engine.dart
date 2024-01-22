import '../../../../utils/logging/prt.dart';
import '../cchess/cchess_base.dart';
import '../cchess/chess_position_map.dart';
import '../cchess/move_name.dart';
import '../state_controllers/board_state.dart';
import 'analysis.dart';
import 'pikafish_engine.dart';

enum EngineType { cloudLibrary, pikafish }

abstract class Response {
  // empty
}

class NoBestmove extends Response {
  // empty
}

class Error extends Response {
  final String message;
  Error(this.message);
}

class BestMove extends Response {
  //
  late String bestMove;
  String? opponentPonder;

  BestMove(this.bestMove, {this.opponentPonder});

  BestMove.parse(String line) : super() {
    //
    var regx = RegExp(r'bestmove (\w+)');
    var match = regx.firstMatch(line);

    if (match != null) {
      //
      bestMove = match.group(1)!;

      regx = RegExp(r'ponder (\w+)');
      match = regx.firstMatch(line);

      if (match != null) {
        opponentPonder = match.group(1);
      }
    }
  }
}

class EngineInfo extends Response {
  //
  final tokens = <String, int>{};
  final pvs = <String>[];

  EngineInfo.parse(String line) {
    //
    // info depth 10 seldepth 13 multipv 1 score cp -75 nodes 14091
    // nps 6358 hashfull 4 tbhits 0 time 2216 pv h9g7 h0g2 i9h9 i0h0
    // b9c7 h0h4 c9e7 c3c4 h7i7 h4h9 g7h9 g3g4

    // info depth 13 seldepth 16 multipv 1 score cp -30 upperbound
    // nodes 69433 nps 21691 hashfull 31 tbhits 0 time 3201 pv h9g7 h0g2

    // info depth 14 seldepth 19 multipv 1 score cp -18 lowerbound
    // nodes 97595 nps 22915 hashfull 45 tbhits 0 time 4259 pv b9c7

    // info depth 187 seldepth 4 multipv 1 score mate 2 nodes 17818
    // nps 312596 hashfull 0 tbhits 0 time 57 pv b7d7 c0e2 d7d0

    final regx = RegExp(
      r'info depth (\d+) seldepth (\d+) multipv (\d+) score (cp|mate) (-?\d+) (upperbound|lowerbound)?'
      r'nodes (\d+) nps (\d+) hashfull (\d+) tbhits (\d+) time (\d+) pv (.*)',
    );
    final regx2 = RegExp(
      r'info depth (\d+) seldepth (\d+) multipv (\d+) score (cp|mate) (-?\d+) (upperbound|lowerbound)? nodes (\d+) nps (\d+) hashfull (\d+) tbhits (\d+) time (\d+) pv (.*)',
    );
    var match = regx.firstMatch(line);
    match ??= regx2.firstMatch(line);

    if (match != null) {
      //
      tokens['depth'] = int.parse(match.group(1)!);
      tokens['seldepth'] = int.parse(match.group(2)!);
      tokens['multipv'] = int.parse(match.group(3)!);

      tokens['cp_or_mate'] = match.group(4)! == 'cp' ? 0 : 1;
      tokens['score'] = int.parse(match.group(5)!);

      tokens['nodes'] = int.parse(match.group(7)!);
      tokens['nps'] = int.parse(match.group(8)!);
      tokens['hashfull'] = int.parse(match.group(9)!);
      tokens['tbhits'] = int.parse(match.group(10)!);
      tokens['time'] = int.parse(match.group(11)!);

      // prt('Jdt line $line');
      // prt('Jdt match $match');
      final pv = match.group(12)!;
      pvs.addAll(pv.split(' '));
    } else {
      prt('*** Not match: $line');
    }
  }

  String _followingMoves(BoardState boardState) {
    //
    final position = boardState.positionMap;

    final bestmove = boardState.bestMove?.bestMove;

    final tempPosition = ChessPositionMap.clone(position);

    var names = <String>[];

    if (PikafishEngine().state == EngineState.searching) {
      for (var i = 0; i < pvs.length; i++) {
        var move = Move.fromEngineMove(pvs[i]);
        final name = MoveName.translate(tempPosition, move);
        tempPosition.move(move);
        names.add(name);
      }
    } else if (PikafishEngine().state == EngineState.ready) {
      //
      for (var i = 0; i < pvs.length; i++) {
        //
        // if (pvs[i] == bestmove) continue;

        var move = Move.fromEngineMove(pvs[i]);
        final name = MoveName.translate(tempPosition, move);
        tempPosition.move(move);

        names.add(name);
      }
    }

    var result = '';

    if (names.length < 4) {
      result = names.join(' ');
    } else if (names.length < 8) {
      result = '${names.sublist(0, 4).join(' ')}\n';
      result += names.sublist(4).join(' ');
    } else {
      result = '${names.sublist(0, 4).join(' ')}\n';
      result += names.sublist(4, 8).join(' ');
    }

    return result;
  }

  (String, int)? score(BoardState boardState, bool negative) {
    //
    final position = boardState.positionMap;
    final playerSide = boardState.playerSide;

    var score = tokens['score'];
    if (score == null) return null;

    final base = (position.sideToMove == playerSide) ? 1 : -1;
    score = score * base * (negative ? -1 : 1);

    if (tokens['cp_or_mate'] == 0) {
      // cp (centipawns)
      final judge = score == 0
          ? 'cân bằng'
          : score > 0
              ? 'Đỏ ưu'
              : 'Đen ưu';
      if (score < 0) score = score * -1;
      return ('$judge $score điểm', score);
    }

    // mate
    return (
      score > 0 ? '$score nước ĐỎ thắng' : '${-score} nước ĐEN thắng',
      score > 0 ? 10000 : -10000
    );
  }

  String? info(BoardState boardState) {
    //
    var score = tokens['score'];
    if (score == null) return null;

    var result = ''
        'Chiều sâu ${tokens['depth']}, '
        'nút ${tokens['nodes']}, '
        'thời gian ${tokens['time']}\n';

    result += _followingMoves(boardState);

    return result;
  }

  List<String> predictMoves(BoardState boardState) {
    var score = tokens['score'];
    if (score == null) return [""];

    final position = boardState.positionMap;
    final tempPosition = ChessPositionMap.clone(position);

    var moves = <String>[];
    prt("Jdt predictMoves state: ${PikafishEngine().state}");
    // switch (PikafishEngine().state) {
    //   case EngineState.searching:
    //   case EngineState.ready:
    //   case EngineState.pondering:
    //   case EngineState.free:
    //   case EngineState.hinting:
    // }
    for (var i = 0; i < pvs.length; i++) {
      var move = Move.fromEngineMove(pvs[i]);
      final name = MoveName.translate(tempPosition, move);
      tempPosition.move(move);
      moves.add(name);
    }
    return moves;
  }
}

class Analysis extends Response {
  final List<AnalysisItem> items;
  Analysis(this.items);
}

class EngineResponse {
  final EngineType type;
  final Response response;
  EngineResponse(this.type, this.response);
}

typedef EngineCallback = Function(EngineResponse);
