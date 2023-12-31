/// Chess coordinate in a game board
class ChessPosition {
  /// Lateral coordinate
  int x;

  /// Longitudinal coordinate
  int y;

  /// constructor pos by x and y
  ChessPosition(this.x, this.y);

  /// constructor pos by x and flipped y
  ChessPosition.tlOrigin(this.x, int y) : y = 9 - y;

  /// constructor from a code position
  ChessPosition.fromCode(String code)
      : x = code.codeUnitAt(0) - 'a'.codeUnitAt(0),
        y = int.tryParse(code[1]) ?? 0;

  @override
  int get hashCode => x * 10 + y;

  /// trans to code position
  String toCode() {
    return String.fromCharCode(x + 'a'.codeUnitAt(0)) + y.toString();
  }

  /// A copy of position
  ChessPosition copy() => ChessPosition(x, y);

  @override
  String toString() => '$x.$y;${toCode()}';

  @override
  bool operator ==(Object other) {
    if (other is ChessPosition) {
      return x == other.x && y == other.y;
    }
    return false;
  }
}
