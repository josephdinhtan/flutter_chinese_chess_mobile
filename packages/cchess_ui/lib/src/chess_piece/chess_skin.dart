import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

const _tag = "ChessSkin";

/// Quân cờ và skin bàn cờ
class ChessSkin {
  String folder = "";

  double width = 521;
  double height = 577;
  double size = 57;
  Offset offset = const Offset(4, 3);

  String board = "board.jpg";
  String blank = "blank.png";

  final _assetRootPath = "assets/skins";

  Map<String, String> redMap = {
    "K": "rk.gif",
    "A": "ra.png",
    "B": "rb.png",
    "C": "rc.png",
    "N": "rn.png",
    "R": "rr.png",
    "P": "rp.png",
    "I": "ri.png"
  };
  Map<String, String> blackMap = {
    "k": "bk.png",
    "a": "ba.png",
    "b": "bb.png",
    "c": "bc.png",
    "n": "bn.png",
    "r": "br.png",
    "p": "bp.png",
    "i": "bi.png"
  };

  late ValueNotifier<bool> readyNotifier;

  ChessSkin(this.folder) {
    readyNotifier = ValueNotifier(false);
    String jsonfile = "$_assetRootPath/$folder/config.json";
    rootBundle.loadString(jsonfile).then((String fileContents) {
      loadJson(fileContents);
    }).catchError((error) {
      log('Skin file $jsonfile error', name: _tag);
      readyNotifier.value = true;
    });
  }

  void loadJson(String content) {
    Map<String, dynamic> json = jsonDecode(content);
    json.forEach((key, value) {
      switch (key) {
        case 'width':
          width = value.toDouble();
          break;
        case 'height':
          height = value.toDouble();
          break;
        case 'size':
          size = value.toDouble();
          break;
        case 'board':
          board = value.toString();
          break;
        case 'blank':
          blank = value.toString();
          break;
        case 'offset':
          offset = Offset(value['dx'].toDouble(), value['dy'].toDouble());
          break;
        case 'red':
          redMap = value.cast<String, String>();
          break;
        case 'black':
          blackMap = value.cast<String, String>();
          break;
      }
    });
    readyNotifier.value = true;
  }

  String get boardImage => "$_assetRootPath/$folder/$board";

  String getRedChessAssetPath(String code) {
    if (!redMap.containsKey(code.toUpperCase())) {
      log('Code error: $code', name: _tag);
      return "$_assetRootPath/$folder/$blank";
    }
    return "$_assetRootPath/$folder/${redMap[code.toUpperCase()]}";
  }

  String getBlackChessAssetPath(String code) {
    if (!blackMap.containsKey(code.toLowerCase())) {
      log('Code error: $code');
      return "assets/skins/$folder/$blank";
    }
    return "assets/skins/$folder/${blackMap[code.toLowerCase()]}";
  }

  Offset getOffset(int chessPieceX, int chessPieceY, double _scale) {
    final align = getAlignFromPos(chessPieceX, chessPieceY);
    final scale = 0.893 * _scale;
    final x = align.x * (width * scale) / 2 +
        (width / 2 * scale) +
        (size / 2 * scale) +
        5.0 * scale;

    final y = align.y * (height * scale) / 2 +
        (height / 2 * scale) +
        size * scale / 2 +
        10.0 * scale;
    return Offset(x, y);
  }

  Alignment getAlignFromPos(int chessPieceX, int chessPieceY) {
    final x = ((chessPieceX * size + offset.dx) * 2) / (width - size) - 1;
    final y =
        (((9 - chessPieceY) * size + offset.dy) * 2) / (height - size) - 1;
    return Alignment(x, y);
  }

  Alignment getAlignFromOffset(double x, double y, double scale,
      [bool isUp = false]) {
    double gapX = isUp ? -0.05 : 0.04;
    double gapY = isUp ? -0.07 : 0.00;
    final xAlign = (x / scale) * 2 / (width - offset.dx) - 1 + gapX;
    final yAlign = (y / scale) * 2 / (height - offset.dy) - 1 + gapY;
    return Alignment(xAlign, yAlign);
  }
}
