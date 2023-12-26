import 'package:local_db/local_db.dart';

import '../cchess/cchess_fen.dart';

class BattleDb {
  BattleDb._();
  static final BattleDb _instance = BattleDb._();
  factory BattleDb() => _instance;

  late final LocalDbItem _initBoard;
  late final LocalDbItem _moveList;
  late final LocalDbItem _boardFlipped;

  String get initBoard => _initBoard.value;
  String get moveList => _moveList.value;
  bool get boardFlipped => _boardFlipped.value;

  set initBoard(String value) => _initBoard.value = value;
  set moveList(String value) => _moveList.value = value;
  set boardFlipped(bool value) => _boardFlipped.value = value;

  Future<void> load() async {
    _initBoard = LocalDbItem('battlepage_init_board', Fen.defaultPosition);
    _moveList = LocalDbItem('battlepage_move_list', '');
    _boardFlipped = LocalDbItem('battlepage_board_flipped', false);
  }

  save() => _initBoard.save();
}
