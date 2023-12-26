import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pikafish_engine/pikafish_engine.dart';

import '../../../../utils/logging/prt.dart';
import '../../settings_screen/local_db/engine_settings_db.dart';
import '../cchess/chess_position_map.dart';
import 'engine.dart';

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

  /*This for prevent Engine startup again and again Help hot reload, hot restart for developing UI */
  static bool isEnable = true;

  late Pikafish _engine;
  late StreamSubscription _subscription;

  EngineCallback? callback;
  EngineState _state = EngineState.free;

  bool _isStarted = false;

  Future<void> startup() async {
    if (!isEnable) return;
    if (_isStarted) {
      prt("Engine is started, ignore");
      stop();
      return;
    }
    while (_engine.state.value == PikafishState.starting) {
      await Future.delayed(const Duration(seconds: 1));
    }

    _engine.stdin = 'uci';

    await _setupNnue();

    _state = EngineState.ready;
    _isStarted = true;
  }

  Future<void> applyConfig() async {
    prt("Jdt pikafish_engine applyConfig()");
    if (!isEnable) return;
    final config = EngineConfigDb();

    if (!config.engineConfigIsPonderSupported) stopPonder();

    _engine.stdin =
        'setoption name Threads value ${config.engineConfigThreads}';
    _engine.stdin = 'setoption name Hash value ${config.engineConfigHashSize}';
    _engine.stdin =
        'setoption name Ponder value ${config.engineConfigIsPonderSupported}';
    _engine.stdin =
        'setoption name Skill Level value ${config.engineConfigLevel}';

    _engine.stdin = 'ucinewgame';
  }

  Future<bool> go(ChessPositionMap position, EngineCallback callback) async {
    //
    if (!isEnable) return true;
    this.callback = callback;

    final pos = position.lastCapturedPosition;
    final moves = position.movesAfterLastCaptured;

    var uciPos = 'position fen $pos', uciGo = '';
    if (moves != '') uciPos += ' moves $moves';

    var timeLimit = EngineConfigDb().engineConfigTimeLimit;
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
    if (!isEnable) return true;
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
    if (!isEnable) return true;
    // actually is go but state is hinting
    final result = go(position, callback);
    _state = EngineState.hinting;

    return result;
  }

  Future<void> ponderhit() async {
    //
    prt("Jdt ponderhit _state = EngineState.searching");
    if (!isEnable) return;
    _engine.stdin = 'ponderhit';
    _state = EngineState.searching;

    final timeLimit = EngineConfigDb().engineConfigTimeLimit;
    await Future.delayed(
      Duration(seconds: timeLimit),
      () => _engine.stdin = 'stop',
    );
  }

  Future<void> stopPonder() async {
    //
    if (!isEnable) return;
    if (_state == EngineState.pondering) {
      await stop();
    } else {
      prt('##### stopPonder: $_state');
    }
  }

  Future<void> stop({removeCallback = true}) async {
    //
    if (!isEnable) return;
    if (_state != EngineState.free && _state != EngineState.ready) {
      if (removeCallback) callback = null;
      _engine.stdin = 'stop';
      _state = EngineState.ready;
    } else {
      prt('##### stop: $_state');
    }
  }

  Future<void> shutdown() async {
    if (!isEnable) return;
    _engine.dispose();
    _subscription.cancel();
    _state = EngineState.free;
    _isStarted = false;
  }

  _setupEngine() {
    if (!isEnable) return;
    _engine = Pikafish();
    _subscriber();
  }

  void _subscriber() {
    //
    if (!isEnable) return;
    _subscription = _engine.stdout.listen((line) {
      // out from engine
      prt('Jdt engine=> $line');
      if (callback == null) return;

      if (line.startsWith('info')) {
        callback!(EngineResponse(EngineType.pikafish, EngineInfo.parse(line)));
      } else if (line.startsWith('bestmove')) {
        prt('Jdt Skip callback for bestmove because we want to keep last engine Info arrows');
        // Skip bestmove because we want to keep last engine Info arrows
        // callback!(EngineResponse(
        //     EngineType.pikafish, BestMove.parse(line))); // engineCallback
        _state = EngineState.ready;
      } else if (line.startsWith('nobestmove')) {
        callback!(EngineResponse(EngineType.pikafish, NoBestmove()));
        _state = EngineState.ready;
      }
    });
  }

  _setupNnue() async {
    //
    if (!isEnable) return;
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
    if (!isEnable) return;
    stop();

    _engine.stdin = 'ucinewgame';
    _state = EngineState.ready;
  }

  EngineState get state => _state;
  bool get isStarted => _isStarted;
}
