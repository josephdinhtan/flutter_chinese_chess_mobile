import 'package:flutter/material.dart';
import 'chess_skin.dart';
import 'chess_item.dart';
import 'chess_position.dart';
import 'piece.dart';

class PiecesLayout extends StatefulWidget {
  final List<ChessItem> items;
  final ChessItem? activeItem;
  final ChessPosition? lastActiveItemPos;
  final double scale;
  final ChessSkin chessSkin;

  const PiecesLayout({
    Key? key,
    required this.items,
    this.activeItem,
    this.lastActiveItemPos,
    required this.scale,
    required this.chessSkin,
  }) : super(key: key);

  @override
  State<PiecesLayout> createState() => _PiecesLayoutState();
}

class _PiecesLayoutState extends State<PiecesLayout> {
  int curTeam = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: widget.items.map<Widget>((ChessItem item) {
        bool isActive = false;
        bool isHover = false;
        bool isLastActive = false;
        if (item.isBlank) {
          //return;
        } else {
          if (widget.lastActiveItemPos != null) {
            if (widget.lastActiveItemPos == item.position) {
              isLastActive = true;
            }
          }

          if (widget.activeItem != null) {
            if (widget.activeItem!.position == item.position) {
              isActive = true;
              if (curTeam == item.team) {
                isHover = true;
              }
            }
          }
        }

        return AnimatedAlign(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuint,
          //curve: Curves.easeInOutSine,
          alignment: widget.chessSkin
              .getAlignFromPos(item.position.x, item.position.y),
          child: SizedBox(
            width: widget.chessSkin.size * widget.scale,
            height: widget.chessSkin.size * widget.scale,
            //transform: isActive && lastPosition.isEmpty ? Matrix4(1, 0, 0, 0.0, -0.105 * skewStepper, 1 - skewStepper*0.1, 0, -0.004 * skewStepper, 0, 0, 1, 0, 0, 0, 0, 1) : Matrix4.identity(),
            child: Piece(
              code: item.code,
              isHover: isHover,
              isActive: isActive,
              isLastActive: isLastActive,
              size: widget.chessSkin.size * widget.scale,
              chessSkin: widget.chessSkin,
            ),
          ),
        );
      }).toList(),
    );
  }
}
