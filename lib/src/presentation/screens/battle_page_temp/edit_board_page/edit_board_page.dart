import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chinese_chess_ai_mobile/src/presentation/screens/battle_page_temp/cchess/chess_position_map.dart';

import '../../../../utils/logging/prt.dart';
import '../analysis_page_widgets/battle_header.dart';
import '../analysis_page_widgets/operation_bar.dart';
import '../cchess/cchess_fen.dart';
import 'edit_board.dart';
import 'piece_box.dart';
import 'side_selection_bottom_sheet.dart';

const String _noPiece = ' ';
const String _removePiece = 'W';

class EditBoardPage extends StatefulWidget {
  const EditBoardPage({super.key, this.fen});
  final String? fen;

  @override
  State<EditBoardPage> createState() => _EditBoardPageState();
}

class _EditBoardPageState extends State<EditBoardPage> {
  int onHandIndex = -1;
  String onHandPiece = _noPiece;
  String deadHandOnPiece = _noPiece;
  late ChessPositionMap positionMap;
  @override
  void initState() {
    positionMap = Fen.toPosition(widget.fen ?? Fen.defaultInitFen)!;
    super.initState();
  }

  void resetSelectedPieces() {
    onHandIndex = -1;
    deadHandOnPiece = onHandPiece = _noPiece;
  }

  bool isPiecePositionValid(int index, String pieceStr) {
    if (pieceStr.toUpperCase() == 'K') return false;
    return true;
  }

  onBoardTap(BuildContext context, int index) async {
    prt("Jdt onBoardTap $index", tag: runtimeType);
    String selectedPiece = positionMap.pieceAt(index);
    if (deadHandOnPiece.toUpperCase() == _removePiece) {
      if (selectedPiece.toUpperCase() != 'K') {
        positionMap.setPiece(index, _noPiece);
        deadHandOnPiece = _noPiece;
      }
    } else if (deadHandOnPiece != _noPiece) {
      if (isPiecePositionValid(index, selectedPiece)) {
        positionMap.setPiece(index, deadHandOnPiece);
        deadHandOnPiece = _noPiece;
      }
    } else if (onHandIndex == -1) {
      onHandIndex = index;
      onHandPiece = positionMap.pieceAt(index);
    } else if (onHandIndex == index) {
      onHandIndex = -1;
    } else {
      if (isPiecePositionValid(index, selectedPiece)) {
        prt("Jdt onBoardTap index: $index pieceSelected: $selectedPiece",
            tag: runtimeType);
        positionMap.setPiece(onHandIndex, _noPiece);
        positionMap.setPiece(index, onHandPiece);
        onHandIndex = -1;
      }
    }
    setState(() {});
  }

  void deadPieceSelected(String pieceStr) {
    prt("Jdt deadPieceSelected() deadActivePiece: $deadHandOnPiece pieceStr: $pieceStr",
        tag: runtimeType);
    if (deadHandOnPiece == pieceStr)
      deadHandOnPiece = _noPiece;
    else
      deadHandOnPiece = pieceStr;

    setState(() {});
  }

  void clearAll() {
    setState(() {
      resetSelectedPieces();
      positionMap = Fen.toPosition(Fen.emptyFen)!;
    });
  }

  void fillAllPieces() {
    setState(() {
      resetSelectedPieces();
      positionMap = Fen.toPosition(Fen.defaultInitFen)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deadPieces = positionMap.diePieceStr;
    final operatorBar =
        OperationBar(backgroundColor: Colors.transparent, items: [
      OperatorItem(
        name: 'Xoá bàn',
        iconData: CupertinoIcons.rectangle_expand_vertical,
        onPressed: clearAll,
      ),
      OperatorItem(
        name: 'Đầy bàn',
        // iconData: Icons.grain_rounded,
        iconData: CupertinoIcons.rectangle_grid_1x2,
        onPressed: fillAllPieces,
      ),
      OperatorItem(
        name: 'Thẩm',
        iconData: CupertinoIcons.search,
        onPressed: () {
          showFirstMoveSelectionBottomSheet(
            context,
            (isRed) {
              prt('Jdt isRed: $isRed', tag: runtimeType);
              var sideToMove = isRed ? 'w' : 'b';
              var layout = Fen.layoutOfFen(Fen.fromPosition(positionMap));
              var fen =
                  layout.replaceRange(layout.length - 1, null, sideToMove);
              prt('Jdt sideToMove: $sideToMove layout: $layout',
                  tag: runtimeType);
              prt('Jdt fen: $fen', tag: runtimeType);
              //Navigator.of(context).pop();
              Navigator.of(context).pop<String>('$fen - - 0 1');
            },
          );
        },
      ),
      OperatorItem(
        name: 'Lưu hình cờ',
        iconData: CupertinoIcons.star,
        onPressed: () {},
      ),
      OperatorItem(
        name: 'Dán FEN',
        iconData: Icons.paste,
        onPressed: () {},
      ),
      OperatorItem(
        name: 'Chép FEN',
        iconData: Icons.copy,
        onPressed: () {},
      ),
    ]);
    return Scaffold(
      body: Column(
        children: [
          const BattleHeader(title: "Xếp cờ"),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PieceBox(
                  isRed: false,
                  pieces: deadPieces,
                  activePiece: deadHandOnPiece,
                  onAddingPieceSelected: deadPieceSelected,
                ),
                const SizedBox(height: 8.0),
                EditBoard(
                  onBoardTap: onBoardTap,
                  positionMap: positionMap,
                  isFlipped: false, // TODO: need update later
                  activeIndex: -1,
                  onHandIndex: onHandIndex,
                  boardBackgroundColor: const Color(0xFFdfb87e),
                  // backgroundImagePath:
                  //     "assets/images/board_wood_background.jpg",
                ),
                const SizedBox(height: 12.0),
                PieceBox(
                  isRed: true,
                  pieces: deadPieces,
                  activePiece: deadHandOnPiece,
                  onAddingPieceSelected: deadPieceSelected,
                ),
              ],
            ),
          ),
          operatorBar,
        ],
      ),
    );
  }
}
