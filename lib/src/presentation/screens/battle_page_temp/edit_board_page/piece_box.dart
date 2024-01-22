import 'package:flutter/material.dart';
import 'package:flutter_chinese_chess_ai_mobile/src/utils/logging/prt.dart';

import '../board/chess_skin.dart';
import '../board/piece_image_widget.dart';

class PieceBox extends StatelessWidget {
  const PieceBox(
      {super.key,
      required this.pieces,
      required this.onAddingPieceSelected,
      required this.activePiece,
      required this.isRed});
  final bool isRed;
  final String pieces;
  final String activePiece;
  final Function(String pieceStr) onAddingPieceSelected;
  static const allItemChrs = 'abncrpw';
  final direction = Axis.horizontal;

  int matchCount(String chr) {
    if (chr.toUpperCase() == 'W') {
      prt('Jdt pieces: $pieces');
      return 30 - pieces.length;
    }
    return RegExp(chr).allMatches(pieces).length;
  }

  bool isPieceHandOn(String chr) {
    if (chr.toUpperCase() == 'W' &&
        activePiece.toUpperCase() == chr.toUpperCase()) {
      return true;
    }
    return activePiece == chr;
  }

  @override
  Widget build(BuildContext context) {
    String _allItemChrs = allItemChrs;
    if (isRed) _allItemChrs = allItemChrs.toUpperCase();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _allItemChrs
          .split('')
          .map<Widget>(
            (String chr) => _ItemWidget(
              chr: chr,
              count: matchCount(chr),
              isActive: isPieceHandOn(chr),
              onSelected: (pieceStr) {
                onAddingPieceSelected(pieceStr);
              },
            ),
          )
          .toList(),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final String chr;
  final int count;
  final bool isActive;
  final pieceSize = 40.0;
  final Function(String pieceStr) onSelected;

  const _ItemWidget({
    Key? key,
    required this.chr,
    required this.count,
    required this.isActive,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //prt("Jdt chr: $chr, isActive: $isActive", tag: runtimeType);
    return GestureDetector(
      onTap: () {
        if (count > 0) {
          onSelected(chr);
        } else {
          onSelected(' ');
        }
      },
      child: SizedBox(
        width: pieceSize,
        height: pieceSize,
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: count > 0
                  ? const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.color,
                    )
                  : ColorFilter.mode(
                      Colors.grey.withOpacity(0.5),
                      BlendMode.dstOut,
                    ),
              child: PieceImageWidget(
                code: chr,
                chessSkin: ChessSkin(),
                isActive: false,
                isHandOn: isActive,
                size: pieceSize,
                handOnColor: Colors.greenAccent,
              ),
            ),
            Align(
              alignment: const Alignment(1.3, -1.8),
              child: Container(
                width: pieceSize / 2,
                height: pieceSize / 2,
                decoration: BoxDecoration(
                  color: count > 0
                      ? Colors.red.withOpacity(0.8)
                      : Colors.grey.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.white, fontSize: pieceSize / 3),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
