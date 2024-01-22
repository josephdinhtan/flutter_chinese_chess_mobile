import 'package:flutter/material.dart';
import 'chess_skin.dart';

class PieceImageWidget extends StatelessWidget {
  final String code;
  final double size;
  final bool isActive;
  final bool isHandOn;
  final ChessSkin chessSkin;
  final Color activeColor;
  final Color handOnColor;

  const PieceImageWidget(
      {Key? key,
      required this.code,
      required this.size,
      required this.chessSkin,
      required this.isActive,
      required this.isHandOn,
      this.activeColor = Colors.white,
      this.handOnColor = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const angle = 1.9;

    final pieceImagePath = chessSkin.getChessAssetPath(code);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(size * 100),
              ),
              border: isActive && !isHandOn
                  ? Border.all(
                      width: size / 25,
                      color: activeColor.withOpacity(0.9),
                    )
                  : null,
            ),
          ),
          Center(
            child: AnimatedContainer(
              width: size * 0.95,
              height: size * 0.95,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              transform: isHandOn
                  ? (Matrix4.identity()
                    ..translate(0.0, 0)
                    ..scale(1.15, 1.15, 15))
                  : Matrix4.identity(),
              transformAlignment: Alignment.center,
              decoration: (isHandOn)
                  ? BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.4),
                          offset: Offset(size / 6, size / 6 * angle),
                          blurRadius: 7,
                          spreadRadius: -6,
                        ),
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.2),
                          offset: Offset(size / 4, size / 4 * angle),
                          blurRadius: 10,
                          spreadRadius: -3,
                        )
                      ],
                      border: Border.all(
                          color: handOnColor.withOpacity(0.9),
                          width: size / 25),
                      borderRadius: BorderRadius.all(
                        Radius.circular(size * 100),
                      ),
                    )
                  : BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.4),
                          offset: Offset(size / 20, size / 20 * angle),
                          blurRadius: 2,
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          offset: Offset(size / 10, size / 10 * angle),
                          blurRadius: 6,
                          spreadRadius: -2,
                        ),
                      ],
                      // border: isActive
                      //     ? Border.all(
                      //         color: Colors.white60,
                      //         width: size / 50,
                      //         style: BorderStyle.solid,
                      //       )
                      //     : null,
                      borderRadius: BorderRadius.all(
                        Radius.circular(size),
                      ),
                    ),
              child: Image.asset(
                pieceImagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
