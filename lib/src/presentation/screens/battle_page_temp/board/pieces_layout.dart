import 'package:flutter/material.dart';
import '../cchess/cchess_base.dart';
import '../cchess/chess_position_map.dart';
import '../chess_utils/ruler.dart';
import 'footprint_widget.dart';
import 'chess_skin.dart';
import 'piece_image_widget.dart';
import 'piece_stubs.dart';
import 'piece_hand_writing_widget.dart';

class PiecesLayout {
  //
  final double width;
  final ChessPositionMap position;
  final int hoverIndex, footprintIndex, activeIndex;
  final bool isBoardFlipped;

  //final double pieceAnimationValue;
  final bool opponentIsHuman;

  PiecesLayout(
    this.width,
    this.position, {
    //required this.pieceAnimationValue,
    required this.isBoardFlipped,
    this.hoverIndex = Move.invalidIndex,
    this.footprintIndex = Move.invalidIndex,
    this.activeIndex = Move.invalidIndex,
    this.opponentIsHuman = false,
  });

  double get gridWidth => (width - Ruler.kBoardPadding * 2) / 9 * 8;
  double get squareWidth => (width - Ruler.kBoardPadding * 2) / 9;
  double get pieceWidth => squareWidth * 0.96;

  Widget buildPiecesLayout(BuildContext context) {
    //
    const offsetX = Ruler.kBoardPadding;
    const offsetY = Ruler.kBoardPadding + Ruler.kBoardDigitsHeight;

    final pieces = <PieceLayoutStub>[];

    for (var rank = 0; rank < 10; rank++) {
      for (var file = 0; file < 9; file++) {
        //
        final index = rank * 9 + file;
        final piece = position.pieceAt(index);
        // Không add no piece
        if (piece == Piece.noPiece) continue;

        final x = isBoardFlipped ? 8 - file : file;
        final y = isBoardFlipped ? 9 - rank : rank;

        var posX = offsetX + squareWidth * x;
        var posY = offsetY + squareWidth * y;

        // update the piece's location with last moved animation

        // if (pieceAnimationValue < 1 &&
        //     index == hoverIndex &&
        //     activeIndex != Move.invalidIndex) {
        //   //
        //   final fx = activeIndex % 9, fy = activeIndex ~/ 9;
        //   final tx = file, ty = rank;
        //   final ax = fx + (tx - fx) * pieceAnimationValue,
        //       ay = fy + (ty - fy) * pieceAnimationValue;

        //   final x = isBoardFlipped ? 8 - ax : ax;
        //   final y = isBoardFlipped ? 9 - ay : ay;

        //   posX = offsetX + squareWidth * x;
        //   posY = offsetY + squareWidth * y;
        // }

        pieces.add(
          PieceLayoutStub(
            piece: piece,
            diameter: pieceWidth,
            selected: index == hoverIndex,
            isActive: index == activeIndex,
            x: posX,
            y: posY,
            rotate: opponentIsHuman &&
                PieceColor.of(piece) ==
                    (isBoardFlipped ? PieceColor.red : PieceColor.black),
          ),
        );
      }
    }

    final footprintRow = footprintIndex ~/ 9, blurCol = footprintIndex % 9;
    final blurX = isBoardFlipped ? 8 - blurCol : blurCol;
    final blurY = isBoardFlipped ? 9 - footprintRow : footprintRow;

    return Stack(
      children: <Widget>[
        if (footprintIndex != Move.invalidIndex)
          Positioned(
            left: offsetX + blurX * squareWidth,
            top: offsetY + blurY * squareWidth,
            child: FootprintWidget(
              size: squareWidth,
            ),
          ),
        for (var piece in pieces)
          (piece.isActive || piece.selected) && false
              ? AnimatedPositioned(
                  left: piece.x,
                  top: piece.y,
                  duration: const Duration(milliseconds: 2000),
                  onEnd: () {},
                  curve: Curves.easeOutQuint,
                  // child: PieceHandWriting(
                  //   code: piece.piece,
                  //   diameter: piece.diameter,
                  //   squareSize: squareWidth,
                  //   selected: piece.selected,
                  //   rotate: piece.rotate,
                  // ),

                  child: PieceImageWidget(
                    code: piece.piece,
                    chessSkin: ChessSkin(),
                    isActive: piece.isActive,
                    isHover: piece.selected,
                    size: squareWidth,
                  ),
                )
              : Positioned(
                  left: piece.x,
                  top: piece.y,
                  // child: PieceHandWriting(
                  //   code: piece.piece,
                  //   diameter: piece.diameter,
                  //   squareSize: squareWidth,
                  //   selected: piece.selected,
                  //   rotate: piece.rotate,
                  // ),

                  child: PieceImageWidget(
                    code: piece.piece,
                    chessSkin: ChessSkin(),
                    isActive: piece.isActive,
                    isHover: piece.selected,
                    size: squareWidth,
                  ),
                ),
      ],
    );
  }
}
