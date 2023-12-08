import 'cchess_base.dart';

class MoveRecorder {
  //
  // 无吃子步数、总回合数
  // Không có số bước để chụp, tổng số vòng
  var halfMove = 0, fullMove = 0;
  final _history = <Move>[];

  MoveRecorder({this.halfMove = 0, this.fullMove = 0});

  MoveRecorder.fromCounterMarks(String marks) {
    //
    var segments = marks.split(' ');
    if (segments.length != 2) {
      throw 'Error: Invalid Counter Marks: $marks';
    }

    halfMove = int.parse(segments[0]);
    fullMove = int.parse(segments[1]);
  }

  MoveRecorder.fromOther(MoveRecorder other) {
    halfMove = other.halfMove;
    fullMove = other.fullMove;
  }

  void moveIn(Move move, String sideToMove) {
    //
    if (move.captured != Piece.noPiece) {
      halfMove = 0;
    } else {
      halfMove++;
    }

    if (fullMove == 0) {
      fullMove++;
    } else if (sideToMove == PieceColor.black) {
      fullMove++;
    }

    _history.add(move);
  }

  Move? removeLast() {
    if (_history.isEmpty) return null;
    return _history.removeLast();
  }

  Move? get last => _history.isEmpty ? null : _history.last;

  List<Move> reverseMovesToPrevCapture() {
    //
    var moves = <Move>[];

    for (var i = _history.length - 1; i >= 0; i--) {
      if (_history[i].captured != Piece.noPiece) break;
      moves.add(_history[i]);
    }

    return moves;
  }

  String movesAfterLastCaptured() {
    //
    var moves = '', posAfterLastCaptured = -1;

    for (var i = _history.length - 1; i >= 0; i--) {
      if (_history[i].captured != Piece.noPiece) {
        posAfterLastCaptured = i;
        break;
      }
    }

    for (var i = posAfterLastCaptured + 1; i < _history.length; i++) {
      moves += ' ${_history[i].move}';
    }

    return moves.isNotEmpty ? moves.substring(1) : '';
  }

  String allMoves() {
    //
    var moves = '';

    for (var i = 0; i < _history.length; i++) {
      moves += ' ${_history[i].move}';
    }

    return moves.isNotEmpty ? moves.substring(1) : '';
  }

  String buildMoveList() {
    //
    final moveList = <String>[];

    for (var i = 0; i < _history.length; i++) {
      moveList.add('${_history[i].name}${(i + 1) % 4 == 0 ? '\n' : ' '}');
    }

    return moveList.join().trim();
  }

  String buildMoveListForManual() {
    //
    var result = '';

    for (var move in _history) {
      result += '${move.fx}${move.fy}${move.tx}${move.ty}';
    }

    return result;
  }

  int get historyLength => _history.length;

  Move moveAt(int index) => _history[index];

  @override
  String toString() {
    return '$halfMove $fullMove';
  }
}
