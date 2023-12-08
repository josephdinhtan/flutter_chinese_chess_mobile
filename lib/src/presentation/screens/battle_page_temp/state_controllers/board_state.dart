import 'package:flutter/material.dart';
import '../cchess/cchess_base.dart';
import '../cchess/cchess_fen.dart';
import '../cchess/cchess_rules.dart';
import '../cchess/chess_position_map.dart';
import '../engine/engine.dart';
import 'game.dart';

class BoardState with ChangeNotifier {
  //
  late ChessPositionMap _position;
  late int _liftUpIndex, _footprintIndex, _activeIndex;
  //late double _pieceAnimationValue;

  EngineInfo? _engineInfo;
  BestMove? bestMove;

  BoardState() {
    _position = ChessPositionMap.startpos;
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
    final position = Fen.positionFromFen(fen);
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

  regret(GameScene scene, {moves = 2}) {
    //
    // 轮到自己走棋的时候，才能悔棋
    if (isVs(scene) && isOpponentTurn) {
      // Audios.playTone('invalid.mp3');
      return;
    }

    var regretted = false;

    /// 悔棋一回合（两步），才能撤回自己上一次的动棋

    for (var i = 0; i < moves; i++) {
      //
      if (!_position.regret()) break;

      final lastMove = _position.lastMove;

      if (lastMove != null) {
        //
        _footprintIndex = lastMove.from;
        _liftUpIndex = lastMove.to;
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

  saveManual(GameScene scene) async => await _position.saveManual(scene);

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
}
