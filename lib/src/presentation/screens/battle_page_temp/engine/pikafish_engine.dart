import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pikafish_engine/pikafish_engine.dart';

import '../../../../utils/logging/prt.dart';
import '../cchess/chess_position_map.dart';
import '../data_base/local_data.dart';
import 'engine.dart';
import 'pikafish_config.dart';

enum EngineState {
  free,
  ready,
  searching,
  pondering,
  hinting;

  @override
  String toString() {
    switch (this) {
      case EngineState.free:
        return 'free';
      case EngineState.ready:
        return 'ready';
      case EngineState.searching:
        return 'searching';
      case EngineState.pondering:
        return 'pondering';
      case EngineState.hinting:
        return 'hinting';
    }
  }
}

class PikafishEngine {
  //
  factory PikafishEngine() => _instance;
  static final PikafishEngine _instance = PikafishEngine._();

  PikafishEngine._() {
    _setupEngine();
  }

  late Pikafish _engine;
  late StreamSubscription _subscription;

  EngineCallback? callback;
  EngineState _state = EngineState.free;

  Future<void> startup() async {
    //
    while (_engine.state.value == PikafishState.starting) {
      await Future.delayed(const Duration(seconds: 1));
    }

    _engine.stdin = 'uci';

    await _setupNnue();

    _state = EngineState.ready;
  }

  Future<void> applyConfig() async {
    //
    final config = PikafishConfig(LocalData().profile);

    if (!config.ponder) stopPonder();

    _engine.stdin = 'setoption name Threads value ${config.threads}';
    _engine.stdin = 'setoption name Hash value ${config.hashSize}';
    _engine.stdin = 'setoption name Ponder value ${config.ponder}';
    _engine.stdin = 'setoption name Skill Level value ${config.level}';

    _engine.stdin = 'ucinewgame';
  }

  Future<bool> go(ChessPositionMap position, EngineCallback callback) async {
    //
    this.callback = callback;

    final pos = position.lastCapturedPosition;
    final moves = position.movesAfterLastCaptured;

    var uciPos = 'position fen $pos', uciGo = '';
    if (moves != '') uciPos += ' moves $moves';

    var timeLimit = PikafishConfig(LocalData().profile).timeLimit;
    if (timeLimit <= 90) timeLimit *= 1000;
    uciGo = 'go movetime $timeLimit';

    _state = EngineState.searching;

    prt("Jdt go uciPos: $uciPos");
    prt("Jdt go uciGo: $uciGo");
    _engine.stdin = uciPos;
    _engine.stdin = uciGo;

    return true;
  }

  Future<bool> goPonder(
      ChessPositionMap position, EngineCallback callback, String ponder) async {
    //
    this.callback = callback;

    final pos = position.lastCapturedPosition;
    final moves = position.movesAfterLastCaptured;

    var uciPos = 'position fen $pos', uciGo = '';
    if (moves != '') uciPos += ' moves $moves';

    if (moves == '') uciPos += ' moves ';

    uciPos += ' $ponder';
    uciGo = 'go ponder infinite';

    _state = EngineState.pondering;

    _engine.stdin = uciPos;
    _engine.stdin = uciGo;

    return true;
  }

  Future<bool> goHint(
      ChessPositionMap position, EngineCallback callback) async {
    // actually is go but state is hinting
    final result = go(position, callback);
    _state = EngineState.hinting;

    return result;
  }

  Future<void> ponderhit() async {
    //
    prt("Jdt ponderhit _state = EngineState.searching");
    _engine.stdin = 'ponderhit';
    _state = EngineState.searching;

    final timeLimit = PikafishConfig(LocalData().profile).timeLimit;
    await Future.delayed(
      Duration(seconds: timeLimit),
      () => _engine.stdin = 'stop',
    );
  }

  Future<void> stopPonder() async {
    //
    if (_state == EngineState.pondering) {
      await stop();
    } else {
      prt('##### stopPonder: $_state');
    }
  }

  Future<void> stop({removeCallback = true}) async {
    //
    if (_state != EngineState.free && _state != EngineState.ready) {
      if (removeCallback) callback = null;
      _engine.stdin = 'stop';
      _state = EngineState.ready;
    } else {
      prt('##### stop: $_state');
    }
  }

  Future<void> shutdown() async {
    _engine.dispose();
    _subscription.cancel();
    _state = EngineState.free;
  }

  _setupEngine() {
    _engine = Pikafish();
    _subscriber();
  }

  void _subscriber() {
    //
    _subscription = _engine.stdout.listen((line) {
      // out from engine
      prt('Jdt engine=> $line');
      if (callback == null) return;

      if (line.startsWith('info')) {
        callback!(EngineResponse(EngineType.pikafish, EngineInfo.parse(line)));
      } else if (line.startsWith('bestmove')) {
        callback!(EngineResponse(
            EngineType.pikafish, BestMove.parse(line))); // engineCallback
        _state = EngineState.ready;
      } else if (line.startsWith('nobestmove')) {
        callback!(EngineResponse(EngineType.pikafish, NoBestmove()));
        _state = EngineState.ready;
      }
    });
  }

  _setupNnue() async {
    //
    final appDocDir = await getApplicationDocumentsDirectory();
    final nnueFile = File('${appDocDir.path}/pikafish0305.nnue');

    if (!(await nnueFile.exists())) {
      await nnueFile.create(recursive: true);
      final bytes = await rootBundle.load('assets/engine/pikafish.nnue');
      await nnueFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }

    final length = await nnueFile.length();
    prt('length: $length');

    _engine.stdin = 'setoption name EvalFile value ${nnueFile.path}';
  }

  void newGame() {
    //
    stop();

    _engine.stdin = 'ucinewgame';
    _state = EngineState.ready;
  }

  EngineState get state => _state;
}
