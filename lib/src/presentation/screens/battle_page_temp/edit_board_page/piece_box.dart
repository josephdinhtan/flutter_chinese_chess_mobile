import 'dart:ffi';

import 'package:flutter/material.dart';

import '../board/chess_skin.dart';
import '../board/piece_image_widget.dart';

class PieceBox extends StatefulWidget {
  const PieceBox(
      {super.key,
      required this.deadPieces,
      required this.onAddingPieceSelected});
  final String deadPieces;
  final Function(String pieceStr) onAddingPieceSelected;

  @override
  State<PieceBox> createState() => _PieceBoxState();
}

class _PieceBoxState extends State<PieceBox> {
  static const allItemChrs = 'abncrp';
  final direction = Axis.horizontal;
  String activePiece = '';

  int matchCount(String chr) {
    return RegExp(chr).allMatches(widget.deadPieces).length;
  }

  void setActive(String chr) {
    setState(() {
      activePiece = chr;
    });
    widget.onAddingPieceSelected(chr);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: allItemChrs
                      .split('')
                      .map<Widget>(
                        (String chr) => _ItemWidget(
                          chr: chr,
                          count: matchCount(chr),
                          isActive: activePiece == chr,
                          onSelected: (pieceStr) {
                            setActive(pieceStr);
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 16.0, height: 16.0),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: allItemChrs
                      .toUpperCase()
                      .split('')
                      .map<Widget>(
                        (String chr) => _ItemWidget(
                          chr: chr,
                          count: matchCount(chr),
                          isActive: activePiece == chr,
                          onSelected: (pieceStr) {
                            setActive(pieceStr);
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          _SideToMove(onSideMoveSelected: (isRedMove) {}, isRedFirstMove: true),
          const SizedBox(width: 8.0),
        ],
      ),
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
    this.isActive = false,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (count > 0) {
          onSelected(chr);
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
                isHover: false,
                size: pieceSize,
              ),
            ),
            Align(
              alignment: Alignment(1.3, -1.8),
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

class _SideToMove extends StatefulWidget {
  const _SideToMove(
      {super.key,
      required this.onSideMoveSelected,
      this.isRedFirstMove = true});
  final bool isRedFirstMove;
  final Function(bool isRedMove) onSideMoveSelected;
  @override
  State<_SideToMove> createState() => _SideToMoveState();
}

class _SideToMoveState extends State<_SideToMove> {
  void setSideToMove(bool isRed) {
    widget.onSideMoveSelected(isRed);
    setState(() {
      isRedMove = isRed;
    });
  }

  bool isRedMove = true;
  @override
  void initState() {
    isRedMove = widget.isRedFirstMove;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                !isRedMove ? Colors.blueGrey[900] : Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          onPressed: () => setSideToMove(false),
          child: const Text("Đen tiên", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isRedMove ? Colors.red : Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          onPressed: () => setSideToMove(true),
          child: const Text("Đỏ tiên", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
