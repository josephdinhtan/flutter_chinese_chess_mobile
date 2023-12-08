import 'chess_position.dart';

import '../utils/jlog.dart';
import 'chess_item.dart';

const _tag = "ChessFen";

/// A snapshot of game
class ChessFen {
  /// Initialize chess layout
  static const initFen =
      'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR';

  /// Initialize chess layout
  static const emptyFen = '4k4/9/9/9/9/9/9/9/9/4K4';

  /// for col index
  static const colIndexBase = 97; // 'a'

  /// map chinese chess to code
  static const nameMap = {
    '将': 'k',
    '帅': 'K',
    '士': 'a',
    '仕': 'A',
    '象': 'b',
    '相': 'B',
    '马': 'n',
    '车': 'r',
    '炮': 'c',
    '砲': 'C',
    '卒': 'p',
    '兵': 'P'
  };

  /// map red code to chinese
  static const nameRedMap = {
    'k': '帅',
    'a': '仕',
    'b': '相',
    'n': '马',
    'r': '车',
    'c': '砲',
    'p': '兵',
  };

  static const nameRedBlackMapVN = {
    'k': 'Tướng',
    'a': 'Sỹ',
    'b': 'Tượng',
    'n': 'Mã',
    'r': 'Xe',
    'c': 'Pháo',
    'p': 'Tốt',
  };

  static const nameRedBlackMapVNCode = {
    'k': 'Tg',
    'a': 'S',
    'b': 'T',
    'n': 'M',
    'r': 'X',
    'c': 'P',
    'p': 'B',
  };

  /// map black code to chinese
  static const nameBlackMap = {
    'k': '将',
    'a': '士',
    'b': '象',
    'n': '马',
    'r': '车',
    'c': '炮',
    'p': '卒',
  };

  /// col name of red team
  static const colRedChinese = ['九', '八', '七', '六', '五', '四', '三', '二', '一'];
  static const colRedVN = ['9', '8', '7', '6', '5', '4', '3', '2', '1'];

  /// chinese numbers
  static const replaceNumber = [
    '０',
    '１',
    '２',
    '３',
    '４',
    '５',
    '６',
    '７',
    '８',
    '９'
  ];

  /// black codes
  static const colBlack = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  /// for chinese move
  static const _nameIndexVN = ['1', '2', '3', '4', '5'];
  static const _stepIndexVN = ['', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static const _nameIndexChinese = ['一', '二', '三', '四', '五'];
  static const _stepIndexChinese = [
    '',
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
    '七',
    '八',
    '九'
  ];
  static const _posIndexChinese = ['前', '中', '后'];

  String _fen = '';
  late List<ChessFenRow> _rows;

  /// 推演变化
  final deductions = <ChessFen>[];

  /// Constructor by a fenstr
  ChessFen([String fenStr = initFen]) {
    if (fenStr.isEmpty) {
      fenStr = initFen;
    }
    fen = fenStr;
  }

  /// Get row
  ChessFenRow operator [](int key) {
    return _rows[key];
  }

  /// force refresh fenstr(usually after batch of moves)
  void clearFen() {
    _fen = '';
  }

  /// Set row
  operator []=(int key, ChessFenRow value) {
    _rows[key] = value;
    _fen = '';
  }

  /// get current fenstr
  String get fen {
    if (_fen.isEmpty) {
      _fen = _rows.reversed.join('/').replaceAllMapped(
            RegExp(r'0+'),
            (match) => match[0]!.length.toString(),
          );
    }
    return _fen;
  }

  /// Set a fen str TODO:Improve
  set fen(String fenStr) {
    if (fenStr.contains(' ')) {
      fenStr = fenStr.split(' ')[0];
    }
    _rows = fenStr
        .replaceAllMapped(
          RegExp(r'\d'),
          (match) => List<String>.filled(int.parse(match[0]!), '0').join(''),
        )
        .split('/')
        .reversed
        .map<ChessFenRow>((row) => ChessFenRow(row))
        .toList();
    _fen = fenStr;
  }

  /// A copy of current situation
  ChessFen copy() => ChessFen(fen);

  /// 创建当前局面下的子力位置
  ChessFen position() {
    int chr = 65;
    String fenStr = fen;
    String positionStr = fenStr.replaceAllMapped(
      RegExp(r'[^0-9\\/]'),
      (match) => String.fromCharCode(chr++),
    );
    // print(positionStr);
    return ChessFen(positionStr);
  }

  /// Move then change the game situation
  bool move(String move) {
    int fromX = move.codeUnitAt(0) - colIndexBase;
    int fromY = int.parse(move[1]);
    int toX = move.codeUnitAt(2) - colIndexBase;
    int toY = int.parse(move[3]);
    if (fromY > 9 || fromX > 8) {
      Jlog.i(_tag, 'From pos error:$move');
      return false;
    }
    if (toY > 9 || toX > 8) {
      Jlog.i(_tag, 'To pos error:$move');
      return false;
    }
    if (fromY == toY && fromX == toX) {
      Jlog.i(_tag, 'No movement:$move');
      return false;
    }
    if (_rows[fromY][fromX] == '0') {
      Jlog.i(_tag, 'From pos is empty:$move');
      return false;
    }
    _rows[toY][toX] = _rows[fromY][fromX];
    _rows[fromY][fromX] = '0';
    _fen = '';

    return true;
  }

  /// Get item from a [ChessPoint]
  String itemAtPos(ChessPosition pos) => _rows[pos.y][pos.x];

  /// Get piece at the string position code
  String itemAt(String pos) => itemAtPos(ChessPosition.fromCode(pos));

  /// Whether there is a valid item at pos
  bool hasItemAt(ChessPosition pos, {int team = -1}) {
    String item = _rows[pos.y][pos.x];
    if (item == '0') {
      return false;
    }
    if (team < 0) {
      return true;
    }
    if ((team == 0 && item.codeUnitAt(0) < ChessFen.colIndexBase) ||
        (team == 1 && item.codeUnitAt(0) >= ChessFen.colIndexBase)) {
      return true;
    }
    return false;
  }

  /// Find a chess by a type code
  ChessPosition? find(String matchCode) {
    ChessPosition? pos;
    int rowNumber = 0;
    _rows.any((row) {
      int start = row.indexOf(matchCode);
      if (start > -1) {
        pos = ChessPosition(start, rowNumber);
        return true;
      }
      rowNumber++;
      return false;
    });
    return pos;
  }

  /// Find all chess of a type code
  List<ChessPosition> findAll(String matchCode) {
    List<ChessPosition> items = [];
    int rowNumber = 0;
    for (var row in _rows) {
      int start = row.indexOf(matchCode);
      while (start > -1) {
        items.add(ChessPosition(start, rowNumber));
        start = row.indexOf(matchCode, start + 1);
      }
      rowNumber++;
    }
    return items;
  }

  /// Find item in a col
  List<ChessItem> findByCol(int col, [int? min, int? max]) {
    List<ChessItem> items = [];
    for (int i = min ?? 0; i <= (max ?? _rows.length - 1); i++) {
      if (_rows[i][col] != '0') {
        items.add(ChessItem(_rows[i][col], position: ChessPosition(col, i)));
      }
    }
    return items;
  }

  /// Get all valid items of this situation
  List<ChessItem> getAll() {
    List<ChessItem> items = [];
    int rowNumber = 0;
    for (var row in _rows) {
      int start = 0;
      while (start < row._fenRow.length) {
        if (row[start] != '0') {
          items.add(
              ChessItem(row[start], position: ChessPosition(start, rowNumber)));
        }
        start++;
      }

      rowNumber++;
    }
    return items;
  }

  /// Get item is dead
  String getDieChr() {
    String fullChrs = initFen.replaceAll(RegExp(r'[1-9/]'), '');
    String currentChrs = getAllChr();
    if (fullChrs.length > currentChrs.length) {
      currentChrs.split('').forEach((chr) {
        fullChrs = fullChrs.replaceFirst(chr, '');
      });
      return fullChrs;
    }

    return '';
  }

  /// Get all valid item code
  String getAllChr() {
    return fen.split('/').reversed.join('/').replaceAll(RegExp(r'[1-9/]'), '');
  }

  @override
  String toString() => fen;

  /// Sort pos
  int posSort(ChessPosition key1, ChessPosition key2) {
    if (key1.x > key2.x) {
      return -1;
    } else if (key1.x < key2.x) {
      return 1;
    }
    if (key1.y > key2.y) {
      return -1;
    } else if (key1.y < key2.y) {
      return 1;
    }
    return 0;
  }

  /// Translate a move to positional representation
  String toPositionString(int team, String move) {
    late String code;
    late String matchCode;
    int colIndex = -1;

    if (_nameIndexChinese.contains(move[0]) ||
        _posIndexChinese.contains(move[0])) {
      code = nameMap[move[1]]!;
    } else {
      code = nameMap[move[0]]!;
      colIndex = team == 0
          ? colRedChinese.indexOf(move[1])
          : colBlack.indexOf(move[1]);
    }
    code = code.toLowerCase();
    matchCode = team == 0 ? code.toUpperCase() : code;

    List<ChessPosition> items = findAll(matchCode);

    ChessPosition curItem;
    // 这种情况只能是小兵
    if (_nameIndexChinese.contains(move[0])) {
      // 筛选出有同列的兵
      List<ChessPosition> nItems = items
          .where(
            (item) => items.any((pawn) => pawn != item && pawn.x == item.x),
          )
          .toList();
      nItems.sort(posSort);
      colIndex = _nameIndexChinese.indexOf(move[0]);
      curItem =
          team == 0 ? nItems[nItems.length - colIndex - 1] : nItems[colIndex];
      // 前中后
    } else if (_posIndexChinese.contains(move[0])) {
      // 筛选出有同列的兵
      List<ChessPosition> nItems = items
          .where(
            (item) => items.any((pawn) => pawn != item && pawn.x == item.x),
          )
          .toList();
      nItems.sort(posSort);
      if (nItems.length > 2) {
        colIndex = _posIndexChinese.indexOf(move[0]);
        curItem =
            team == 0 ? nItems[nItems.length - colIndex - 1] : nItems[colIndex];
      } else {
        if ((team == 0 && move[0] == '前') || (team == 1 && move[0] == '后')) {
          curItem = nItems[0];
        } else {
          curItem = nItems[1];
        }
      }
    } else {
      colIndex = team == 0
          ? colRedChinese.indexOf(move[1])
          : colBlack.indexOf(move[1]);

      List<ChessPosition> nItems =
          items.where((item) => item.x == colIndex).toList();
      nItems.sort(posSort);

      if (nItems.length > 1) {
        if ((team == 0 && move[2] == '进') || (team == 1 && move[2] == '退')) {
          curItem = nItems[1];
        } else {
          curItem = nItems[0];
        }
      } else if (nItems.isNotEmpty) {
        curItem = nItems[0];
      } else {
        Jlog.i(_tag, '招法加载错误 $team $move');
        return '';
      }
    }

    ChessPosition nextItem = ChessPosition(0, 0);
    if (['p', 'k', 'c', 'r'].contains(code)) {
      if (move[2] == '平') {
        nextItem.y = curItem.y;
        nextItem.x = team == 0
            ? colRedChinese.indexOf(move[3])
            : colBlack.indexOf(move[3]);
      } else if ((team == 0 && move[2] == '进') ||
          (team == 1 && move[2] == '退')) {
        nextItem.x = curItem.x;
        nextItem.y = curItem.y +
            (team == 0
                ? _stepIndexChinese.indexOf(move[3])
                : int.parse(move[3]));
      } else {
        nextItem.x = curItem.x;
        nextItem.y = curItem.y -
            (team == 0
                ? _stepIndexChinese.indexOf(move[3])
                : int.parse(move[3]));
      }
    } else {
      nextItem.x = team == 0
          ? colRedChinese.indexOf(move[3])
          : colBlack.indexOf(move[3]);
      if ((team == 0 && move[2] == '进') || (team == 1 && move[2] == '退')) {
        if (code == 'n') {
          if ((nextItem.x - curItem.x).abs() == 2) {
            nextItem.y = curItem.y + 1;
          } else {
            nextItem.y = curItem.y + 2;
          }
        } else {
          nextItem.y = curItem.y + (nextItem.x - curItem.x).abs();
        }
      } else {
        if (code == 'n') {
          if ((nextItem.x - curItem.x).abs() == 2) {
            nextItem.y = curItem.y - 1;
          } else {
            nextItem.y = curItem.y - 2;
          }
        } else {
          nextItem.y = curItem.y - (nextItem.x - curItem.x).abs();
        }
      }
    }

    return '${curItem.toCode()}${nextItem.toCode()}';
  }
}

/// A row of game board
class ChessFenRow {
  String _fenRow;

  /// constructor by a row string
  ChessFenRow(this._fenRow);

  /// get code at key position
  String operator [](int key) {
    return _fenRow[key];
  }

  /// set code at key position
  operator []=(int key, String value) {
    _fenRow = _fenRow.replaceRange(key, key + 1, value);
  }

  /// find code index of this row
  int indexOf(String matchCode, [int start = 0]) {
    return _fenRow.indexOf(matchCode, start);
  }

  @override
  String toString() => _fenRow;
}
