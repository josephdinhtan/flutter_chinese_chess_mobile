import 'package:flutter/material.dart';
import '../../../../utils/logging/prt.dart';
import '../cchess/cchess_base.dart';
import '../cchess/cchess_fen.dart';
import '../cchess/cchess_rules.dart';
import '../cchess/chess_position_map.dart';
import '../engine/engine.dart';

class BoardState with ChangeNotifier {
  //
  late ChessPositionMap _position; // save pieces history
  late int _liftUpIndex, _footprintIndex, _activeIndex;
  //late double _pieceAnimationValue;

  EngineInfo? _engineInfo;
  BestMove? bestMove;

  BoardState() {
    _position = ChessPositionMap.startPos;
    _liftUpIndex = _footprintIndex = _activeIndex = Move.invalidIndex;
    //_pieceAnimationValue = 1;
  }

  setPosition(ChessPositionMap position, {notify = true}) {
    _position = position;
    _liftUpIndex = _footprintIndex = _activeIndex = Move.invalidIndex;

    if (notify) notifyListeners();
  }

  bool _boardInverse = false;
  bool get isBoardFlipped => _boardInverse;

  bool _sitUnderside = true;

  flipBoard(bool inverse, {notify = true, swapSite = false}) {
    //
    _boardInverse = inverse;

    if (swapSite) _sitUnderside = !_sitUnderside;

    if (notify) notifyListeners();
  }

  String get playerSide {
    if (_sitUnderside) return _boardInverse ? PieceColor.black : PieceColor.red;
    return _boardInverse ? PieceColor.red : PieceColor.black;
  }

  String get oppositeSide =>
      playerSide == PieceColor.red ? PieceColor.black : PieceColor.red;

  load(String fen, {notify = false}) {
    //
    final position = Fen.toPosition(fen);
    if (position == null) return false;

    _position = position;
    _liftUpIndex = _footprintIndex = Move.invalidIndex;

    if (notify) notifyListeners();

    return true;
  }

  // pieceAnimationUpdate(double pieceAnimationValue) {
  //   _pieceAnimationValue = pieceAnimationValue;
  //   notifyListeners();
  // }

  select(int index) {
    _liftUpIndex = index;
    //_footprintIndex = Move.invalidIndex;
    // Audios.playTone('click.mp3');

    notifyListeners();
  }

  bool move(Move move) {
    //
    if (!_position.move(move)) {
      // Audios.playTone('invalid.mp3');
      return false;
    }

    _liftUpIndex = Move.invalidIndex;
    _activeIndex = move.to;
    _footprintIndex = move.from;

    if (ChessRules.beChecked(_position)) {
      // Audios.playTone('check.mp3');
    } else {
      // Audios.playTone(
      //   lastMoveCaptured != Piece.noPiece ? 'capture.mp3' : 'move.mp3',
      // );
    }

    notifyListeners();

    return true;
  }

  regret({moves = 2}) {
    prt("Jdt regret()", tag: runtimeType);
    //
    // 轮到自己走棋的时候，才能悔棋
    // Only when it's your turn to play chess can you regret it
    if (isOpponentTurn) {
      // Audios.playTone('invalid.mp3');
      prt("Jdt regret() is Opponent turn, but always allow", tag: runtimeType);
      //return;
    }

    var regretted = false;

    /// 悔棋一回合（两步），才能撤回自己上一次的动棋
    /// Only by regretting one turn (two moves) can you withdraw your last move.
    for (var i = 0; i < moves; i++) {
      //
      if (!_position.regret()) {
        prt("Jdt regret() regret fail", tag: runtimeType);
        break;
      }

      final lastMove = _position.lastMove;

      if (lastMove != null) {
        //
        _footprintIndex = lastMove.from;
        _liftUpIndex = Move.invalidIndex;
        _activeIndex = lastMove.to;
        //
      } else {
        //
        _footprintIndex = _liftUpIndex = Move.invalidIndex;
      }

      regretted = true;
    }

    if (regretted) {
      // Audios.playTone('regret.mp3');
      notifyListeners();
    } else {
      // Audios.playTone('invalid.mp3');
    }
  }

  clearFocus({notify = true}) {
    _liftUpIndex = _footprintIndex = Move.invalidIndex;
    if (notify) notifyListeners();
  }

  reset() {
    flipBoard(false, notify: false);
    _engineInfo = null;
    bestMove = null;
  }

  saveManual() async => await _position.saveManual();

  buildMoveListForManual() => _position.buildMoveListForManual();

  String get lastMoveCaptured {
    final lastMove = _position.lastMove;
    final captured = lastMove?.captured;
    return captured ?? Piece.noPiece;
  }

  EngineInfo? get engineInfo => _engineInfo;

  set engineInfo(EngineInfo? engineInfo) {
    _engineInfo = engineInfo;
    notifyListeners();
  }

  ChessPositionMap get position => _position;
  int get liftUpIndex => _liftUpIndex;
  int get activeIndex => _activeIndex;
  int get footprintIndex => _footprintIndex;
  //double get pieceAnimationValue => _pieceAnimationValue;

  bool get isMyTurn => _position.sideToMove == playerSide;
  bool get isOpponentTurn => _position.sideToMove == oppositeSide;

  bool get isRedTurn => _position.sideToMove == PieceColor.red;
  bool get isBlackTurn => _position.sideToMove == PieceColor.black;
}
