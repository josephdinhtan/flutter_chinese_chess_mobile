import 'cchess_rules.dart';
import 'chess_position_map.dart';
import 'cchess_base.dart';

class MoveName {
  //
  static const redColNames = '九八七六五四三二一';
  static const blackColNames = '１２３４５６７８９';

  static const redDigits = '零一二三四五六七八九';
  static const blackDigits = '０１２３４５６７８９';

  static String translate(ChessPositionMap position, Move move) {
    //
    final colNames = [redColNames, blackColNames];
    final digits = [redDigits, blackDigits];

    final pieceColor = PieceColor.of(position.pieceAt(move.from));
    final sideIndex = (pieceColor == PieceColor.red) ? 0 : 1;

    final pieceName = nameOf(position, move);

    var result = pieceName;

    if (move.ty == move.fy) {
      //
      result += '平${colNames[sideIndex][move.tx]}';
      //
    } else {
      //
      final direction = (pieceColor == PieceColor.red) ? -1 : 1;
      final dir = ((move.ty - move.fy) * direction > 0) ? '进' : '退';

      final piece = position.pieceAt(move.from);

      final specialPieces = [
        Piece.redKnight,
        Piece.blackKnight,
        Piece.redBishop,
        Piece.blackBishop,
        Piece.redAdvisor,
        Piece.blackAdvisor,
      ];

      String targetPos;

      if (specialPieces.contains(piece)) {
        targetPos = colNames[sideIndex][move.tx];
      } else {
        targetPos = digits[sideIndex][ChessRules.abs(move.ty - move.fy)];
      }

      result += '$dir$targetPos';
    }

    return move.name = result;
  }

  static String nameOf(ChessPositionMap position, Move move) {
    //
    final colNames = [redColNames, blackColNames];
    final digits = [redDigits, blackDigits];

    final pieceColor = PieceColor.of(position.pieceAt(move.from));
    final sideIndex = (pieceColor == PieceColor.red) ? 0 : 1;

    final piece = position.pieceAt(move.from);
    final pieceName = Piece.zhName[piece];

    // 士相由于行动行动路径有限，不会出现同一列两个士相都可以进或退的情况
    // 所以一般不说「前士、前相」之类的，根据「进、退」动作即可判断是前一个还是后一个
    if (piece == Piece.redAdvisor ||
        piece == Piece.redBishop ||
        piece == Piece.blackAdvisor ||
        piece == Piece.blackBishop) {
      //
      return '$pieceName${colNames[sideIndex][move.fx]}';
    }

    // 此 Map 的 Key 为「列」， Value 为此列上出现所查寻棋子的 y 坐标（row）列表
    // Khóa của Bản đồ này là "cột" và Giá trị là danh sách tọa độ y (hàng) nơi quân cờ đang được tìm kiếm xuất hiện trên cột này.
    // 返回结果中进行了过滤，如果某一列包含所查寻棋子的数量 < 2，此列不包含在返回结果中
    // Kết quả trả về được lọc, nếu cột chứa số quân cờ tìm kiếm < 2 thì cột này sẽ không được đưa vào kết quả trả về.
    final cols = findPieceSameCol(position, piece);
    final fyIndexes = cols[move.fx];

    // 正在动棋的这一列不包含多个同类棋子
    // Cột cờ đang được di chuyển không chứa nhiều quân cờ giống nhau.
    if (fyIndexes == null) {
      return '$pieceName${colNames[sideIndex][move.fx]}';
    }

    // 只有正在动棋的这一列包含多个同类棋子
    // Chỉ cột cờ đang được di chuyển mới chứa nhiều quân cờ cùng loại.
    if (cols.length == 1) {
      //
      var order = fyIndexes.indexOf(move.fy);
      if (pieceColor == PieceColor.black) order = fyIndexes.length - 1 - order;

      if (fyIndexes.length == 2) {
        return '${'前后'[order]}$pieceName';
      }

      if (fyIndexes.length == 3) {
        return '${'前中后'[order]}$pieceName';
      }

      return '${digits[sideIndex][order]}$pieceName';
    }

    // 这种情况表示有两列都有两个或以上正在查寻的棋子
    // Tình huống này có nghĩa là có hai cột có từ hai quân cờ trở lên đang được tìm kiếm.
    // 这种情况下，从右列开始为棋子指定序数（从前到后），然后再左列
    // Trong trường hợp này, gán số thứ tự cho các phần bắt đầu từ cột bên phải (từ trước ra sau), rồi từ cột bên trái
    if (cols.length == 2) {
      //
      final fxIndexes = cols.keys.toList();
      fxIndexes.sort((a, b) => a - b);

      // 已经按列的 x 坐标排序，当前动子列是否是在右边的列
      // Đã sắp xếp theo tọa độ x của cột, cột phụ chuyển động hiện tại có phải là cột bên phải không
      final currentColStart = (move.fx == fxIndexes[1 - sideIndex]);

      if (currentColStart) {
        //
        var order = fyIndexes.indexOf(move.fy);
        if (pieceColor == PieceColor.black) {
          order = fyIndexes.length - 1 - order;
        }

        return '${digits[sideIndex][order]}$pieceName';
        //
      } else {
        // 当前列表在左边，后计序数
        final fxOtherCol = fxIndexes[sideIndex];

        var order = fyIndexes.indexOf(move.fy);
        if (pieceColor == PieceColor.black) {
          order = fyIndexes.length - 1 - order;
        }

        return '${digits[sideIndex][cols[fxOtherCol]!.length + order]}$pieceName';
      }
    }

    return '****';
  }

  static Map<int, List<int>> findPieceSameCol(
      ChessPositionMap position, String piece) {
    //
    final map = <int, List<int>>{};

    for (var rank = 0; rank < 10; rank++) {
      for (var col = 0; col < 9; col++) {
        //
        if (position.pieceAt(rank * 9 + col) == piece) {
          //
          var fyIndexes = map[col] ?? [];
          fyIndexes.add(rank);
          map[col] = fyIndexes;
        }
      }
    }

    final result = <int, List<int>>{};

    map.forEach((k, v) {
      if (v.length > 1) result[k] = v;
    });

    return result;
  }
}
