import '../chess_piece/chess_skin.dart';
import 'package:flutter/material.dart';

/// checkerboard
class Board extends StatelessWidget {
  final ChessSkin chessSkin;

  const Board({Key? key, required this.chessSkin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      chessSkin.boardImage,
      fit: BoxFit.contain,
    );
  }
}
