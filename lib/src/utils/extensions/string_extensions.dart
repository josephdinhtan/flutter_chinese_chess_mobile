extension HardCode on String {
  String get hardCode => this;
}

extension Capitalize on String {
  String get capitalize =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}
