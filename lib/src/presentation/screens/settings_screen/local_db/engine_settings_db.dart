import 'package:local_db/local_db.dart';

class EngineConfigDb {
  EngineConfigDb._();
  static final EngineConfigDb _instance = EngineConfigDb._();
  factory EngineConfigDb() => _instance;

  late final LocalDbItem _engineConfigTimeLimit;
  late final LocalDbItem _engineConfigIsPonderSupported;
  late final LocalDbItem _engineConfigThreads;
  late final LocalDbItem _engineConfigLevel;
  late final LocalDbItem _engineConfigHashSize;

  int get engineConfigTimeLimit => _engineConfigTimeLimit.value;
  bool get engineConfigIsPonderSupported =>
      _engineConfigIsPonderSupported.value;
  int get engineConfigThreads => _engineConfigThreads.value;
  int get engineConfigLevel => _engineConfigLevel.value;
  int get engineConfigHashSize => _engineConfigHashSize.value;

  set engineConfigTimeLimit(int value) => _engineConfigTimeLimit.value = value;
  set engineConfigIsPonderSupported(bool value) =>
      _engineConfigIsPonderSupported.value = value;
  set engineConfigThreads(int value) => _engineConfigThreads.value = value;
  set engineConfigLevel(int value) => _engineConfigLevel.value = value;
  set engineConfigHashSize(int value) => _engineConfigHashSize.value = value;

  Future<void> load() async {
    _engineConfigTimeLimit = LocalDbItem('pikafish_time_limit', 3);
    _engineConfigIsPonderSupported = LocalDbItem('pikafish_ponder', false);
    _engineConfigThreads = LocalDbItem('pikafish_threads', 1);
    _engineConfigLevel = LocalDbItem('pikafish_level', 20);
    _engineConfigHashSize = LocalDbItem('pikafish_hashSize', 16);
  }

  timeLimitPlus() {
    if (_engineConfigTimeLimit.value < 90) _engineConfigTimeLimit.value++;
  }

  timeLimitReduce() {
    if (_engineConfigTimeLimit.value > 1) _engineConfigTimeLimit.value--;
  }

  levelPlus() {
    if (_engineConfigLevel.value < 20) _engineConfigLevel.value++;
  }

  levelReduce() {
    if (_engineConfigLevel.value > 1) _engineConfigLevel.value--;
  }

  threadsPlus() {
    if (_engineConfigThreads.value < 16) _engineConfigThreads.value++;
  }

  threadsReduce() {
    if (_engineConfigThreads.value > 1) _engineConfigThreads.value--;
  }

  hashSizePlus() {
    var hs = _engineConfigHashSize.value;

    if (hs < 16) {
      hs++;
    } else if (hs < 256) {
      hs += 16;
      hs = hs ~/ 16 * 16;
    } else {
      hs += 256;
      hs = hs ~/ 256 * 256;
    }
    if (hs >= 4 * 1024) hs = 4 * 1024;
    _engineConfigHashSize.value = hs;
  }

  hashSizeReduce() {
    var hs = _engineConfigHashSize.value;
    if (hs <= 16) {
      hs--;
    } else if (hs <= 256) {
      hs -= 16;
      hs = hs ~/ 16 * 16;
    } else {
      hs -= 256;
      hs = hs ~/ 256 * 256;
    }
    if (hs < 1) hs = 1;
    _engineConfigHashSize.value = hs;
  }

  Future<bool> save() => _engineConfigTimeLimit.save();
}
