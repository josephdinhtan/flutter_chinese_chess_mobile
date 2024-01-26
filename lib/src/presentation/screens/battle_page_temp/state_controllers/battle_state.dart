import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BattleState with ChangeNotifier {
  //
  String _status = '...';
  bool _isMate = false;
  bool get isMate => _isMate;
  String get status => _status;

  int _score = 0;
  int get score => _score;

  double _moveTimeOpponent = 0;
  double get moveTimeOpponent => _moveTimeOpponent;

  double _moveTimeSelf = 0;
  double get moveTimeSelf => _moveTimeSelf;

  double _gameTimeOpponent = 0;
  double get gameTimeOpponent => _gameTimeOpponent;

  double _gameTimeSelf = 0;
  double get gameTimeSelf => _gameTimeSelf;

  changeStatus({required bool isMate, int? newScore, notify = true}) {
    _isMate = isMate;
    _score = newScore ?? _score;
    if (notify) notifyListeners();
  }

  updateClock(
    Map<String, dynamic> selfTimer,
    Map<String, dynamic> opponentTimer, {
    notify = true,
  }) {
    //
    try {
      _moveTimeSelf = selfTimer['move_time'];
      _gameTimeSelf = selfTimer['game_time'];

      _moveTimeOpponent = opponentTimer['move_time'];
      _gameTimeOpponent = opponentTimer['game_time'];
    } catch (_) {}

    if (notify) notifyListeners();
  }
}
