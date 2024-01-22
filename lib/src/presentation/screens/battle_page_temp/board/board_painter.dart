import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../chess_utils/ruler.dart';

const _kBoardPadding = 5.0;
const _kBoardDigitsTextFontSize = 18.0;
const _defaultBoardLineColor = Color(0x996D000D);

class BoardPainter extends StatelessWidget {
  const BoardPainter({
    super.key,
    required this.width,
    required this.isBoardFlipped,
    this.boardBackgroundColor,
    this.boardLineColor,
    this.backgroundImagePath,
  });
  final Color? boardBackgroundColor;
  final Color? boardLineColor;
  final String? backgroundImagePath;
  final double width;
  final bool isBoardFlipped;

  Widget buildBoardBackground({required Widget child}) {
    if (backgroundImagePath != null) {
      return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImagePath!), fit: BoxFit.cover)),
        child: child,
      );
    } else {
      return Container(
        color: boardBackgroundColor ?? Colors.white,
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBoardBackground(
      child: RepaintBoundary(
        child: CustomPaint(
          painter:
              _LinesOnBoard(width, boardLineColor ?? _defaultBoardLineColor),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: _kBoardPadding,
              horizontal: (width - _kBoardPadding * 2) / 9 / 2 +
                  _kBoardPadding -
                  _kBoardDigitsTextFontSize / 2,
            ),
            child: _WordsOnBoard(
                boardFlipped: isBoardFlipped,
                textColor: boardLineColor ?? _defaultBoardLineColor),
          ),
        ),
      ),
    );
  }
}

class _LinesOnBoard extends CustomPainter {
  _LinesOnBoard(this.width, this.boardLineColor);

  final double width;
  final Color boardLineColor;
  final thePaint = Paint();

  double get gridWidth => (width - Ruler.kBoardPadding * 2) / 9 * 8;
  double get squareWidth => (width - Ruler.kBoardPadding * 2) / 9;

  @override
  void paint(Canvas canvas, Size size) {
    doPaint(
      canvas,
      thePaint,
      gridWidth,
      squareWidth,
      offsetX: Ruler.kBoardPadding + squareWidth / 2,
      offsetY: Ruler.kBoardPadding + Ruler.kBoardDigitsHeight + squareWidth / 2,
      boardLineColor: boardLineColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static doPaint(
    Canvas canvas,
    Paint paint,
    double gridWidth,
    double squareWidth, {
    required double offsetX,
    required double offsetY,
    required Color boardLineColor,
  }) {
    const borderOffset = 4;
    const borderStrokeWidth = 3.0;
    const lineStrokeWidth = 1.5;
    //
    paint.color = boardLineColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineStrokeWidth;

    final left = offsetX, top = offsetY;

    // outer frame
    canvas.drawRect(
      Rect.fromLTWH(left, top, gridWidth, squareWidth * 9),
      paint,
    );

    // board boarder
    paint.strokeWidth = borderStrokeWidth;
    canvas.drawRect(
      Rect.fromLTWH(left - borderOffset, top - borderOffset,
          gridWidth + borderOffset * 2, squareWidth * 9 + borderOffset * 2),
      paint,
    );

    paint.strokeWidth = lineStrokeWidth;

    // 8 horizontal line
    for (var i = 1; i < 9; i++) {
      canvas.drawLine(
        Offset(left, top + squareWidth * i),
        Offset(left + gridWidth, top + squareWidth * i),
        paint,
      );
    }

    // 8 short vertical line
    for (var i = 0; i < 8; i++) {
      //
      canvas.drawLine(
        Offset(left + squareWidth * i, top),
        Offset(left + squareWidth * i, top + squareWidth * 4),
        paint,
      );
      canvas.drawLine(
        Offset(left + squareWidth * i, top + squareWidth * 5),
        Offset(left + squareWidth * i, top + squareWidth * 9),
        paint,
      );
    }

    // King area
    canvas.drawLine(
      Offset(left + squareWidth * 3, top),
      Offset(left + squareWidth * 5, top + squareWidth * 2),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareWidth * 5, top),
      Offset(left + squareWidth * 3, top + squareWidth * 2),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareWidth * 3, top + squareWidth * 7),
      Offset(left + squareWidth * 5, top + squareWidth * 9),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareWidth * 5, top + squareWidth * 7),
      Offset(left + squareWidth * 3, top + squareWidth * 9),
      paint,
    );

    // 炮/兵架位置指示
    // Chỉ báo vị trí súng/quân đội
    final points = [
      // 炮架位置指示
      // Chỉ báo vị trí của pháo

      Offset(left + squareWidth, top + squareWidth * 2),
      Offset(left + squareWidth * 7, top + squareWidth * 2),
      Offset(left + squareWidth, top + squareWidth * 7),
      Offset(left + squareWidth * 7, top + squareWidth * 7),

      // 部分兵架位置指示
      // Chỉ báo vị trí của tốt
      Offset(left + squareWidth * 2, top + squareWidth * 3),
      Offset(left + squareWidth * 4, top + squareWidth * 3),
      Offset(left + squareWidth * 6, top + squareWidth * 3),
      Offset(left + squareWidth * 2, top + squareWidth * 6),
      Offset(left + squareWidth * 4, top + squareWidth * 6),
      Offset(left + squareWidth * 6, top + squareWidth * 6),
    ];

    for (var p in getSoldiersCannonsPoints(
        left + squareWidth, top + squareWidth * 2)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 7, top + squareWidth * 2)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth, top + squareWidth * 7)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 7, top + squareWidth * 7)) {
      canvas.drawLine(p[0], p[1], paint);
    }

    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 2, top + squareWidth * 3)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 4, top + squareWidth * 3)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 6, top + squareWidth * 3)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 2, top + squareWidth * 6)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 4, top + squareWidth * 6)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsPoints(
        left + squareWidth * 6, top + squareWidth * 6)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    // for (var p in points) {
    //   canvas.drawCircle(p, 5, paint);
    // }

    // 兵架靠边位置指示
    // Hướng dẫn vị trí phụ của quân đồn trú
    for (var p
        in getSoldiersCannonsEdgePoints(left, top + squareWidth * 3, true)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p
        in getSoldiersCannonsEdgePoints(left, top + squareWidth * 6, true)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsEdgePoints(
        left + squareWidth * 8, top + squareWidth * 3, false)) {
      canvas.drawLine(p[0], p[1], paint);
    }
    for (var p in getSoldiersCannonsEdgePoints(
        left + squareWidth * 8, top + squareWidth * 6, false)) {
      canvas.drawLine(p[0], p[1], paint);
    }
  }

  static List<List<Offset>> getSoldiersCannonsPoints(
      double left, double right) {
    const accentline = 7;
    const accentGap = 3;
    return [
      // const accentline = 10; // khu chỉ định cho pháo trái trên
      [
        Offset(left + accentGap, right + accentGap),
        Offset(left + accentline, right + accentGap)
      ],
      [
        Offset(left + accentGap, right + accentGap),
        Offset(left + accentGap, right + accentline)
      ],
      [
        Offset(left - accentGap, right - accentGap),
        Offset(left - accentline, right - accentGap)
      ],
      [
        Offset(left - accentGap, right - accentGap),
        Offset(left - accentGap, right - accentline)
      ],
      [
        Offset(left - accentGap, right + accentGap),
        Offset(left - accentline, right + accentGap)
      ],
      [
        Offset(left - accentGap, right + accentGap),
        Offset(left - accentGap, right + accentline)
      ],
      [
        Offset(left + accentGap, right - accentGap),
        Offset(left + accentline, right - accentGap)
      ],
      [
        Offset(left + accentGap, right - accentGap),
        Offset(left + accentGap, right - accentline)
      ],
    ];
  }

  static List<List<Offset>> getSoldiersCannonsEdgePoints(
      double left, double right, bool isLeft) {
    const accentline = 7;
    const accentGap = 3;
    return isLeft
        ? [
            // const accentline = 10; // khu chỉ định cho pháo trái trên
            [
              Offset(left + accentGap, right + accentGap),
              Offset(left + accentline, right + accentGap)
            ],
            [
              Offset(left + accentGap, right + accentGap),
              Offset(left + accentGap, right + accentline)
            ],
            [
              Offset(left + accentGap, right - accentGap),
              Offset(left + accentline, right - accentGap)
            ],
            [
              Offset(left + accentGap, right - accentGap),
              Offset(left + accentGap, right - accentline)
            ],
          ]
        : [
            [
              Offset(left - accentGap, right - accentGap),
              Offset(left - accentline, right - accentGap)
            ],
            [
              Offset(left - accentGap, right - accentGap),
              Offset(left - accentGap, right - accentline)
            ],
            [
              Offset(left - accentGap, right + accentGap),
              Offset(left - accentline, right + accentGap)
            ],
            [
              Offset(left - accentGap, right + accentGap),
              Offset(left - accentGap, right + accentline)
            ],
          ];
  }
}

class _WordsOnBoard extends StatelessWidget {
  //
  final bool boardFlipped;
  final Color textColor;
  const _WordsOnBoard(
      {Key? key, required this.boardFlipped, required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final topSideColumns = boardFlipped ? '一二三四五六七八九' : '１２３４５６７８９';
    final bottomSideColumns = boardFlipped ? '９８７６５４３２１' : '九八七六五四三二一';

    final topSideChildren = <Widget>[], bottomSideChildren = <Widget>[];

    const digitsStyle = TextStyle(fontSize: Ruler.kBoardDigitsTextFontSize);
    const riverTipsStyle = TextStyle(fontSize: 28);

    for (var i = 0; i < 9; i++) {
      //
      topSideChildren.add(Text(topSideColumns[i], style: digitsStyle));
      bottomSideChildren.add(Text(bottomSideColumns[i], style: digitsStyle));

      if (i < 8) {
        topSideChildren.add(const Expanded(child: SizedBox()));
        bottomSideChildren.add(const Expanded(child: SizedBox()));
      }
    }

    // const riverTips = Row(
    //   children: <Widget>[
    //     Expanded(child: SizedBox()),
    //     Text('楚河', style: riverTipsStyle),
    //     Expanded(flex: 2, child: SizedBox()),
    //     Text('汉界', style: riverTipsStyle),
    //     Expanded(child: SizedBox()),
    //   ],
    // );

    return DefaultTextStyle(
      // style: GameFonts.art(color: GameColors.boardTips),
      style: TextStyle(color: textColor),
      child: Column(
        children: <Widget>[
          Row(children: topSideChildren),
          const Expanded(child: SizedBox()),
          //riverTips,
          //const Expanded(child: SizedBox()),
          Row(children: bottomSideChildren),
        ],
      ),
    );
  }
}
