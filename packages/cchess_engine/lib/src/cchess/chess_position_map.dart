import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/prt.dart';
import 'cchess_rules.dart';
import 'cchess_base.dart';
import 'move_name.dart';
import 'cchess_fen.dart';
import 'move_recorder.dart';

class ChessPositionMap {
  //
  GameResult result = GameResult.pending; // ket qua game, thang, thua hoa

  late String _sideToMove;
  late List<String> _pieces; // 10 行，9 列 // 10 hang 9 cot
  late MoveRecorder _recorder;

  String _initBoard = '';
  String? _lastCapturedPosition;

  static ChessPositionMap get startpos {
    return Fen.positionFromFen(Fen.defaultPosition)!;
  }

  ChessPositionMap(
      List<String> pieces, String sideToMove, MoveRecorder recorder) {
    //
    _pieces = pieces;
    _sideToMove = sideToMove;
    _recorder = recorder;

    updateInitPosition();
  }

  ChessPositionMap.clone(ChessPositionMap other) {
    deepCopy(other);
  }

  String get initBoard => _initBoard;

  void updateInitPosition() {
    _lastCapturedPosition = Fen.positionToFen(this);
    _initBoard = Fen.positionToCrManualBoard(this);
  }

  void deepCopy(ChessPositionMap other) {
    //
    _pieces = [];
    for (var piece in other._pieces) {
      _pieces.add(piece);
    }

    _sideToMove = other._sideToMove;

    _recorder = MoveRecorder(
      halfMove: other._recorder.halfMove,
      fullMove: other._recorder.fullMove,
    );

    _initBoard = other._initBoard;
  }

  bool move(Move move, {validate = true}) {
    //
    // 移动是否符合象棋规则 - Nước đi có tuân theo luật cờ không?
    if (validate && !validateMove(move.from, move.to)) {
      return false;
    }

    // 生成棋步，记录步数
    final captured = _pieces[move.to];

    move.captured = captured;
    move.counterMarks = _recorder.toString();

    MoveName.translate(this, move);
    _recorder.moveIn(move, _sideToMove);

    // Sửa đổi bàn cờ
    _pieces[move.to] = _pieces[move.from];
    _pieces[move.from] = Piece.noPiece;

    // Exchange moves
    _sideToMove = PieceColor.opponent(_sideToMove);

    // FEN ghi lại vị trí chiến thắng mới nhất, được yêu cầu bởi công cụ UCCI
    if (captured != Piece.noPiece) {
      _lastCapturedPosition = Fen.positionToFen(this);
    }

    return true;
  }

  // Trong quá trình đánh giá tính hợp pháp của nước đi, cần đưa ra giả định về nước đi trên bàn cờ nhân bản, sau đó kiểm tra hiệu quả.
  // Trong trường hợp này, không có xác minh, không ghi âm và không có bản dịch.
  void moveTest(Move move, {turnSide = false}) {
    //
    // Sửa đổi bàn cờ
    _pieces[move.to] = _pieces[move.from];
    _pieces[move.from] = Piece.noPiece;

    // Trao đổi di chuyển
    if (turnSide) _sideToMove = PieceColor.opponent(_sideToMove);
  }

  // lùi lại nước trước
  bool regret() {
    final lastMove = _recorder.removeLast();
    if (lastMove == null) return false;

    _pieces[lastMove.from] = _pieces[lastMove.to];
    _pieces[lastMove.to] = lastMove.captured;

    _sideToMove = PieceColor.opponent(_sideToMove);

    final counterMarks = MoveRecorder.fromCounterMarks(lastMove.counterMarks);
    _recorder.halfMove = counterMarks.halfMove;
    _recorder.fullMove = counterMarks.fullMove;

    if (lastMove.captured != Piece.noPiece) {
      //
      // 查找上一个吃子局面（或开局），NativeEngine 需要
      final tempPosition = ChessPositionMap.clone(this);

      final moves = _recorder.reverseMovesToPrevCapture();
      for (var move in moves) {
        //
        tempPosition._pieces[move.from] = tempPosition._pieces[move.to];
        tempPosition._pieces[move.to] = move.captured;

        tempPosition._sideToMove =
            PieceColor.opponent(tempPosition._sideToMove);
      }

      _lastCapturedPosition = Fen.positionToFen(tempPosition);
    }

    result = GameResult.pending;

    return true;
  }

  bool validateMove(int from, int to) {
    //
    // 移动的棋子的选手，应该是当前方
    if (PieceColor.of(_pieces[from]) != _sideToMove) return false;

    return (ChessRules.validate(this, Move(from, to)));
  }

  Move last9Moves(int index) =>
      _recorder.moveAt((_recorder.historyLength - 9) + index);

  bool isLongCheck() {
    //
    if (!appearRepeatPosition()) return false;

    final tempPosition = ChessPositionMap.clone(this);
    for (var i = 0; i < 9; i++) {
      tempPosition.regret();
    }

    tempPosition.move(last9Moves(0));
    if (!ChessRules.beChecked(tempPosition)) return false;

    tempPosition.move(last9Moves(1));
    tempPosition.move(last9Moves(2));
    if (!ChessRules.beChecked(tempPosition)) return false;

    tempPosition.move(last9Moves(3));
    tempPosition.move(last9Moves(4));
    if (!ChessRules.beChecked(tempPosition)) return false;

    tempPosition.move(last9Moves(5));
    tempPosition.move(last9Moves(6));
    if (!ChessRules.beChecked(tempPosition)) return false;

    tempPosition.move(last9Moves(7));
    tempPosition.move(last9Moves(8));
    if (!ChessRules.beChecked(tempPosition)) return false;

    return true;
  }

  bool appearRepeatPosition() {
    //
    if (_recorder.historyLength < 9) return false;

    bool same(Move m1, Move m2, [Move? m3]) {
      if (m3 == null) return m1.from == m2.from && m1.to == m2.to;
      return m1.from == m2.from &&
          m1.to == m2.to &&
          m1.from == m3.from &&
          m1.to == m3.to;
    }

    return same(last9Moves(0), last9Moves(4), last9Moves(8)) &&
        same(last9Moves(1), last9Moves(5)) &&
        same(last9Moves(2), last9Moves(6)) &&
        same(last9Moves(3), last9Moves(7));
  }

  Future<bool> saveManual() async {
    //
    final title = formatDate(
      DateTime.now(),
      [yyyy, '-', mm, '-', d, '_', HH, ':', nn, ':', ss],
    );

    const black = 'Chess Path-Chess Classroom';
    const clazz = 'Man-machine exercise';

    final moveList = _recorder.buildMoveListForManual();
    String gameResult;

    switch (result) {
      case GameResult.pending:
        gameResult = 'unknown';
        break;
      case GameResult.win:
        gameResult = 'Red Win';
        break;
      case GameResult.lose:
        gameResult = 'Block Win';
        break;
      case GameResult.draw:
        gameResult = 'Draw';
        break;
    }

    final map = {
      'id': '0',
      'title': title,
      'event': '',
      'clazz': clazz,
      'red': '',
      'black': black,
      'result': gameResult,
      'init_board': _initBoard,
      'move_list': '[DhtmlXQ_movelist]$moveList[/DhtmlXQ_movelist]',
      'comment_list': '',
    };

    final appDocDir = await getApplicationDocumentsDirectory();

    try {
      final contents = jsonEncode(map);

      final file = File('${appDocDir.path}/saved/$title.crm');
      await file.create(recursive: true);

      await file.writeAsString(contents);
      //
    } catch (e) {
      prt('saveManual: $e');
      return false;
    }

    return true;
  }

  String buildPositionCommand({forEleeye = false}) {
    //
    final String? position, moves;

    position = lastCapturedPosition;
    moves = movesAfterLastCaptured;

    if (moves == '') return 'position fen $position';
    return 'position fen $position moves $moves';
  }

  String get moveList => _recorder.buildMoveList();

  String buildMoveListForManual() => _recorder.buildMoveListForManual();

  // broken setting operation

  String pieceAt(int index) => _pieces[index];

  void setPiece(int index, String piece) => _pieces[index] = piece;

  String get sideToMove => _sideToMove;
  void turnSide() => _sideToMove = PieceColor.opponent(_sideToMove);

  // broken access to recorder outside

  MoveRecorder get recorder => _recorder;

  Move? get lastMove => _recorder.last;
  int get halfMove => _recorder.halfMove; // 无吃子步数
  int get fullMove => _recorder.fullMove; // 总回合步数
  String get moveCount => _recorder.toString();

  String? get lastCapturedPosition => _lastCapturedPosition;
  String get allMoves => _recorder.allMoves();
  String get movesAfterLastCaptured => _recorder.movesAfterLastCaptured();
}

String get today => formatDate(DateTime.now(), [yyyy, mm, dd]);
