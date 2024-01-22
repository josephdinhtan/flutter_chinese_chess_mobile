import 'package:flutter/material.dart';

class PiecePaint {
  final String piece;
  final Offset pos;
  PiecePaint({required this.piece, required this.pos});
}

class PieceLayout {
  //
  final String piece;
  final double diameter;
  final bool selected;
  final bool isActive;
  final double x, y;
  final bool rotate;

  PieceLayout({
    required this.piece,
    required this.diameter,
    required this.selected,
    required this.isActive,
    required this.x,
    required this.y,
    this.rotate = false,
  });
}
