import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../battle_widgets/operation_bar.dart';
import '../cchess/cchess_fen.dart';
import '../state_controllers/board_state.dart';
import 'edit_board.dart';
import 'piece_box.dart';

class EditBoardPage extends StatelessWidget {
  EditBoardPage({super.key});

  onBoardTap(BuildContext context, int index) async {
    prt("Jdt onBoardTap $index", tag: runtimeType);
  }

  final _operatorBar = OperationBar(items: [
    OperatorItem(
      name: 'Xoá bàn',
      icon: const Icon(Icons.settings_overscan),
      callback: () {},
    ),
    OperatorItem(
      name: 'Đầy bàn',
      icon: const Icon(Icons.grain_rounded),
      callback: () {},
    ),
    OperatorItem(
      name: 'Lưu hình cờ',
      icon: const Icon(Icons.save_as_outlined),
      callback: () {},
    ),
    OperatorItem(
      name: 'Dán FEN',
      icon: const Icon(Icons.paste),
      callback: () {},
    ),
    OperatorItem(
      name: 'Chép FEN',
      icon: const Icon(Icons.copy),
      callback: () {},
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    final boardState = Provider.of<BoardState>(context);
    final editFen = Fen.fromPosition(boardState.position);
    final deadPieces = Fen.getDiePieces(editFen);
    prt("Jdt boardState.position ${Fen.fromPosition(boardState.position)}",
        tag: runtimeType);
    prt("Jdt deadPieces $deadPieces", tag: runtimeType);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Xếp cờ'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.done_outline_rounded,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Column(
        children: [
          EditBoard(
            onBoardTap: onBoardTap,
            editFen: editFen,
            isFlipped: boardState.isBoardFlipped,
          ),
          const SizedBox(height: 12.0),
          PieceBox(
            deadPieces: deadPieces,
            onAddingPieceSelected: (pieceStr) {},
          ),
          const Expanded(child: SizedBox()),
          _operatorBar,
        ],
      ),
    );
  }
}
