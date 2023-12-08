import 'package:cchess_ui/src/chess_piece/chess_utils.dart';
import 'package:cchess_ui/src/chess_piece/chess_skin.dart';
import 'package:flutter/material.dart';
import 'chess_item.dart';

/// quân cờ
class Piece extends StatelessWidget {
  final String code;
  final bool isActive;
  final bool isLastActive;
  final bool isHover;
  final double size;
  final ChessSkin chessSkin;

  const Piece({
    Key? key,
    required this.code,
    this.isActive = false,
    this.isLastActive = false,
    this.isHover = false,
    required this.size,
    required this.chessSkin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const angle = 1.9;
    return (code == ' ' || code == '')
        ? Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(color: Colors.transparent),
          )
        : Stack(
            fit: StackFit.expand,
            //alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(size * 100),
                  ),
                  border: (isActive || isLastActive) && !isHover
                      ? Border.all(
                          width: size / 35,
                          color: Colors.white.withOpacity(0.9),
                        )
                      : null,
                  // boxShadow: isActive && !isHover
                  //     ? [
                  //         BoxShadow(
                  //           color: Colors.white.withOpacity(0.7),
                  //           //offset: Offset(size / 5, size / 5),
                  //           blurRadius: 0,
                  //           spreadRadius: 2.0,
                  //         ),
                  //       ]
                  //     : isLastActive && !isHover
                  //         ? [
                  //             BoxShadow(
                  //               color: Colors.white.withOpacity(0.7),
                  //               blurRadius: 0,
                  //               spreadRadius: 2.0,
                  //             ),
                  //           ]
                  //         : null,
                ),
              ),
              Center(
                child: AnimatedContainer(
                  width: size * 0.95,
                  height: size * 0.95,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOutQuint,
                  transform: isHover
                      ? (Matrix4.identity()
                        ..translate(0.0, 0)
                        ..scale(1.15, 1.15, 15))
                      : Matrix4.identity(),
                  transformAlignment: Alignment.center,
                  decoration: (isHover)
                      ? BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.4),
                              offset: Offset(size / 6, size / 6 * angle),
                              blurRadius: 7,
                              spreadRadius: -6,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              offset: Offset(size / 4, size / 4 * angle),
                              blurRadius: 10,
                              spreadRadius: -3,
                            )
                          ],
                          border: Border.all(
                              color: Colors.white.withOpacity(0.9),
                              width: size / 50),
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
                    ChessUtils.isRedTeam(code)
                        ? chessSkin.getRedChessAssetPath(code)
                        : chessSkin.getBlackChessAssetPath(code),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          );
  }
}
