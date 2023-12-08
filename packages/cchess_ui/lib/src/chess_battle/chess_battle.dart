// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import '../chess_board/board.dart';
// import '../chess_piece/chess_item.dart';
// import '../chess_piece/chess_position.dart';

// bool _isDispose = false;

// class ChessBattle extends StatefulWidget {
//   final String skin;

//   const ChessBattle({Key? key, this.skin = 'woods'}) : super(key: key);

//   @override
//   State<ChessBattle> createState() => ChessBattleState();
// }

// List<AiMove> _aiMoves = [];
// int? _currentBestMoveIndex;

// class ChessBattleState extends State<ChessBattle> {
//   late BuildContext mContext;
//   // currently active child
//   ChessItem? _activeItem;
//   double skewStepper = 0;

//   //possition
//   ChessPosition? _fromBestPos;
//   ChessPosition? _toBestPos;
//   ChessPosition? _fromBestScorePos;
//   ChessPosition? _toBestScorePos;
//   ChessPosition? _fromBestPosOpponent;
//   ChessPosition? _toBestPosOpponent;
//   ChessPosition? _fromBestScoreMove2;
//   ChessPosition? _toBestScorePos2;

//   List<ChessPosition> currentBestMove1_1 = []; // nước đi tốt nhất level 1
//   List<ChessPosition> currentBestMove1_2 = []; // nước đi tốt nhất level 2
//   List<ChessPosition> currentBestMove1_3 = []; // nước đi tốt nhất level 3

//   List<ChessPosition> currentBestMove2_1 = [];
//   List<ChessPosition> currentBestMove2_2 = [];

//   List<ChessPosition> opponentBestMove1_1 = [];
//   List<ChessPosition> opponentBestMove1_2 = [];
//   List<ChessPosition> opponentBestMove1_3 = [];

//   List<ChessPosition> opponentBestMove2_1 = [];
//   List<ChessPosition> opponentBestMove2_2 = [];
//   // eaten child
//   ChessItem? dieFlash;

//   // I just walked
//   String _lastPosition = 'a0';
//   String _lastActiveItemPos = 'a0';

//   // Available points, including capture points
//   List<String> movePoints = [];
//   bool isInit = false;
//   bool isLoading = true;

//   // All pieces when the game is initialized
//   List<ChessItem> items = [];

//   bool _needShowStartGamePopup = false;
//   @override
//   void initState() {
//     GameSetting.getInstance().then((value) => _gameSettings = value);
//     super.initState();
//     _isDispose = false;
//     initGamer();
//     mContext = context;
//   }

//   void updateAiMove(GameEvent event) {
//     if (event.data == null) return;
//     if (event.data.message != null && event.data.message == 'clear') {
//       setState(() {
//         currentBestMove1_1.clear();
//         currentBestMove1_2.clear();
//         currentBestMove2_1.clear();
//         currentBestMove2_2.clear();

//         opponentBestMove1_1.clear();
//         opponentBestMove1_2.clear();
//         opponentBestMove2_1.clear();
//         opponentBestMove2_2.clear();
//         _currentBestMoveIndex = null;
//         _aiMoves.clear();
//       });
//     } else {
//       //log('jdt _aiMoves: $_aiMoves');
//       setState(() {
//         _aiMoves.add(event.data);
//         final currentAiMove = event.data as AiMove;
//         if (currentAiMove.originCode != null) {
//           if (currentAiMove.originCode!.isNotEmpty &&
//               _currentBestMoveIndex != null) {
//             if (currentAiMove.originCode![0] !=
//                 _aiMoves[_currentBestMoveIndex!].originCode![0]) {
//               currentBestMove2_1 = List.from(currentBestMove1_1);
//               currentBestMove2_2 = List.from(currentBestMove1_2);

//               opponentBestMove2_1 = List.from(opponentBestMove1_1);
//               opponentBestMove2_2 = List.from(opponentBestMove1_2);
//             }
//           }
//           if (currentAiMove.originCode!.isNotEmpty) {
//             _currentBestMoveIndex = _aiMoves.length - 1;
//             currentBestMove1_1.clear();
//             currentBestMove1_1.add(ChessPos.fromCode(
//                 currentAiMove.originCode![0].substring(0, 2)));
//             currentBestMove1_1.add(ChessPos.fromCode(
//                 currentAiMove.originCode![0].substring(2, 4)));
//           } else {
//             currentBestMove1_1.clear();
//           }
//           if (currentAiMove.originCode!.length > 2) {
//             currentBestMove1_2.clear();
//             currentBestMove1_2.add(ChessPos.fromCode(
//                 currentAiMove.originCode![2].substring(0, 2)));
//             currentBestMove1_2.add(ChessPos.fromCode(
//                 currentAiMove.originCode![2].substring(2, 4)));
//           } else {
//             currentBestMove1_2.clear();
//           }
//           if (currentAiMove.originCode!.length > 4) {
//             currentBestMove1_3.clear();
//             currentBestMove1_3.add(ChessPos.fromCode(
//                 currentAiMove.originCode![4].substring(0, 2)));
//             currentBestMove1_3.add(ChessPos.fromCode(
//                 currentAiMove.originCode![4].substring(2, 4)));
//           } else {
//             currentBestMove1_3.clear();
//           }
//           if (currentAiMove.originCode!.length > 1) {
//             opponentBestMove1_1.clear();
//             opponentBestMove1_1.add(ChessPos.fromCode(
//                 currentAiMove.originCode![1].substring(0, 2)));
//             opponentBestMove1_1.add(ChessPos.fromCode(
//                 currentAiMove.originCode![1].substring(2, 4)));
//           } else {
//             opponentBestMove1_1.clear();
//           }
//           if (currentAiMove.originCode!.length > 3) {
//             opponentBestMove1_2.clear();
//             opponentBestMove1_2.add(ChessPos.fromCode(
//                 currentAiMove.originCode![3].substring(0, 2)));
//             opponentBestMove1_2.add(ChessPos.fromCode(
//                 currentAiMove.originCode![3].substring(2, 4)));
//           } else {
//             opponentBestMove1_2.clear();
//           }
//           if (currentAiMove.originCode!.length > 5) {
//             opponentBestMove1_3.clear();
//             opponentBestMove1_3.add(ChessPos.fromCode(
//                 currentAiMove.originCode![5].substring(0, 2)));
//             opponentBestMove1_3.add(ChessPos.fromCode(
//                 currentAiMove.originCode![5].substring(2, 4)));
//           } else {
//             opponentBestMove1_3.clear();
//           }
//         }
//       });
//     }
//   }

//   onUiRefresh(GameEvent event) {
//     log("chess.dart showAIbestMove() change: [${_gamer.showAIBestMoves[0]}, ${_gamer.showAIBestMoves[1]}]");
//     setState(() {});
//   }

//   void onFlip(GameEvent event) {
//     setState(() {});
//   }

//   void onResult(GameEvent event) {
//     if (event.data == null || event.data!.isEmpty) {
//       return;
//     }
//     List<String> parts = event.data.split(' ');
//     String? resultText =
//         (parts.length > 1 && parts[1].isNotEmpty) ? parts[1] : null;
//     switch (parts[0]) {
//       case 'checkMate':
//         toast("S.of(context).check");
//         showAction(ActionType.checkMate);
//         break;
//       case 'eat':
//         showAction(ActionType.eat);
//         break;
//       case ChessManual.resultFstLoose:
//         alertResult(resultText ?? "S.of(context).red_loose");
//         break;
//       case ChessManual.resultFstWin:
//         alertResult(resultText ?? "S.of(context).red_win");
//         break;
//       case ChessManual.resultFstDraw:
//         alertResult(resultText ?? "S.of(context).red_draw");
//         break;
//       default:
//         break;
//     }
//   }

//   void reloadGame(GameEvent event) {
//     if (event.data < -1) {
//       return;
//     }
//     if (event.data < 0) {
//       if (!isLoading) {
//         setState(() {
//           isLoading = true;
//         });
//       }
//       return;
//     }
//     setState(() {
//       items = _gamer.manual.getChessItems();
//       isLoading = false;
//       _lastPosition = '';
//       _lastActiveItemPos = '';
//       _activeItem = null;
//     });
//     String position = _gamer.lastMove;
//     if (position.isNotEmpty) {
//       logger.info('last move $position');
//       Future.delayed(const Duration(milliseconds: 32)).then((value) {
//         if (!_isDispose) {
//           setState(() {
//             _lastPosition = position.substring(0, 2);
//             ChessPos activePos = ChessPos.fromCode(position.substring(2, 4));
//             _activeItem = items.firstWhere(
//               (item) =>
//                   !item.isBlank &&
//                   item.position == ChessPos.fromCode(_lastPosition),
//               orElse: () => ChessItem('0'),
//             );
//             _activeItem!.position = activePos;
//           });
//         }
//       });
//     }
//   }

//   void addStep(ChessPos chess, ChessPos next) {
//     _gamer.addStep(chess, next);
//   }

//   Future<void> fetchMovePoints() async {
//     setState(() {
//       movePoints = _gamer.rule.movePoints(_activeItem!.position);
//       // print('move points: $movePoints');
//     });
//   }

//   void onShow2ndMove(GameEvent event) {
//     String move = event.data!;
//     logger.info('onShow2ndMove $move');
//     log('jdt chess.dart onShow2ndMove() -> move: $move');
//     if (move.isEmpty) return;
//     if (move.contains(' ')) {
//       final move1 = move.split(' ')[0];
//       _fromBestScorePos = ChessPos.fromCode(move1.substring(0, 2));
//       _toBestScorePos = ChessPos.fromCode(move1.substring(2, 4));
//       final move2 = move.split(' ')[1];
//       _fromBestScoreMove2 = ChessPos.fromCode(move2.substring(0, 2));
//       _toBestScorePos2 = ChessPos.fromCode(move2.substring(2, 4));
//     } else {
//       _fromBestScorePos = ChessPos.fromCode(move.substring(0, 2));
//       _toBestScorePos = ChessPos.fromCode(move.substring(2, 4));
//     }

//     setState(() {});
//   }

//   void onShowMove(GameEvent event) {
//     String move = event.data!;
//     logger.info('onShowMove $move');
//     log('jdt chess.dart onShowMove() -> move: $move');
//     if (move.isEmpty) return;
//     if (move.contains(' ')) {
//       final move1 = move.split(' ')[0];
//       _fromBestPos = ChessPos.fromCode(move1.substring(0, 2));
//       _toBestPos = ChessPos.fromCode(move1.substring(2, 4));
//       final move2 = move.split(' ')[1];
//       _fromBestPosOpponent = ChessPos.fromCode(move2.substring(0, 2));
//       _toBestPosOpponent = ChessPos.fromCode(move2.substring(2, 4));
//     } else {
//       _fromBestPos = ChessPos.fromCode(move.substring(0, 2));
//       _toBestPos = ChessPos.fromCode(move.substring(2, 4));
//     }

//     setState(() {});
//   }

//   /// Instructions from outside
//   void onMove(GameEvent event) {
//     String move = event.data!;
//     logger.info('onmove $move');
//     if (move.isEmpty) return;
//     if (move == PlayerDriver.rstGiveUp) return;
//     if (move.contains(PlayerDriver.rstRqstDraw)) {
//       toast(
//         "S.of(context).request_draw",
//         SnackBarAction(
//           label: "S.of(context).agree_to_draw",
//           onPressed: () {
//             _gamer.player.completeMove(PlayerDriver.rstDraw);
//           },
//         ),
//         5,
//       );
//       move = move.replaceAll(PlayerDriver.rstRqstDraw, '').trim();
//       if (move.isEmpty) {
//         return;
//       }
//     }
//     if (move == PlayerDriver.rstRqstRetract) {
//       confirm(
//         "S.of(context).request_retract",
//         "S.of(context).agree_retract",
//         "S.of(context).disagree_retract",
//       ).then((bool? isAgree) {
//         _gamer.player
//             .completeMove(isAgree == true ? PlayerDriver.rstRetract : '');
//       });
//       return;
//     }

//     ChessPos fromPos = ChessPos.fromCode(move.substring(0, 2));
//     ChessPos toPosition = ChessPos.fromCode(move.substring(2, 4));
//     _activeItem = items.firstWhere(
//       (item) => !item.isBlank && item.position == fromPos,
//       orElse: () => ChessItem('0'),
//     );

//     ChessItem newActive = items.firstWhere(
//       (item) => !item.isBlank && item.position == toPosition,
//       orElse: () => ChessItem('0'),
//     );
//     setState(() {
//       if (_activeItem != null && !_activeItem!.isBlank) {
//         logger.info('$_activeItem => $move');
//         _activeItem!.position = ChessPos.fromCode(move.substring(2, 4));
//         _lastPosition = fromPos.toCode();

//         if (!newActive.isBlank) {
//           logger.info('eat $newActive');

//           //showAction(ActionType.eat);
//           // snapshot of eaten sub
//           dieFlash = ChessItem(newActive.code, position: toPosition);
//           newActive.isDie = true;
//           Future.delayed(const Duration(milliseconds: 250), () {
//             setState(() {
//               dieFlash = null;
//             });
//           });
//         }
//       } else {
//         logger.info('Remote move error $move');
//       }
//     });
//   }

//   void animateMove(ChessPos nextPosition) {
//     logger.info('animateMove() $_activeItem => $nextPosition');
//     setState(() {
//       _activeItem!.position = nextPosition.copy();
//     });
//   }

//   // void clearActive() {
//   //   setState(() {
//   //     _lastActiveItem = _activeItem = null;
//   //     lastPosition = '';
//   //   });
//   // }

//   /// Check if the user's input location is valid
//   Future<bool> checkCanMove(
//     String activePos,
//     ChessPos toPosition, [
//     ChessItem? toItem,
//   ]) async {
//     if (!movePoints.contains(toPosition.toCode())) {
//       if (toItem != null) {
//         //toast('Không thể ăn ${toItem.code} ở $toPosition'); // exception here
//       } else {
//         //toast('Không thể di chuyển tới $toPosition');
//       }
//       return false;
//     }
//     String move = activePos + toPosition.toCode();
//     ChessRule rule = ChessRule(_gamer.fen.copy());
//     rule.fen.move(move);
//     if (rule.isKingMeet(_gamer.curHand)) {
//       toast("Lộ mặt tướng");
//       return false;
//     }

//     // Division should
//     if (rule.isCheck(_gamer.curHand)) {
//       if (_gamer.isCheckMate) {
//         toast("Không thể di chuyển, đỡ đòn chiếu tướng");
//         //toast("S.of(context).pls_parry_check");
//       } else {
//         toast("Không thể di chuyển, sẽ bị mất tướng");
//         //toast("S.of(context).cant_send_check");
//       }
//       log('Jdt chess.dart checkCanMove() -> false');
//       return false;
//     }
//     return true;
//   }

//   /// Feedback when the user clicks on the position of the chessboard, including selecting, moving, capturing, and no feedback
//   // _checkIsDoubleTouch -> prevent user click many time in same action
//   bool _checkIsDoubleTouch = false;
//   Future<bool> onPointer(ChessPosition toPosition) async {
//     if (_gamer.startedGame == false) return false;
//     if (_checkIsDoubleTouch == true) return false;
//     //print("jdt onPointer() toPosition: $toPosition");
//     ChessItem newActive = items.firstWhere(
//       (item) => !item.isBlank && item.position == toPosition,
//       orElse: () => ChessItem('0'),
//     );

//     int ticker = DateTime.now().millisecondsSinceEpoch;
//     if (newActive.isBlank) {
//       if (_activeItem != null && _activeItem!.team == _gamer.curHand) {
//         log('Jdt onPointer() -> curHand: ${_gamer.curHand == 1 ? 'Đen' : 'Đỏ'}');
//         String activePos = _activeItem!.position.toCode();
//         checkCanMove(activePos, toPosition).then((canMove) {
//           //print("jdt onPointer() canMove: $canMove");
//           log('Jdt onPointer() -> canMove: $canMove');
//           int delay = 250 - (DateTime.now().millisecondsSinceEpoch - ticker);
//           if (delay < 0) {
//             delay = 0;
//           }
//           if (canMove) {
//             animateMove(toPosition);
//             // update now section
//             setState(() {
//               // clear drop points
//               movePoints = [];
//               _lastPosition = activePos;

//               _lastActiveItemPos = toPosition.toCode();
//             });
//             // aad move to manager, it help check position and rule
//             addStep(ChessPosition.fromCode(activePos), toPosition);
//           }
//         });

//         return true;
//       }
//       return false;
//     }

//     // Clear the current selected state
//     if (_activeItem?.position == toPosition) {
//       setState(() {
//         //_lastActiveItem = null;
//         _activeItem = null;
//         //lastPosition = '';
//         movePoints = [];
//       });
//     } else if (newActive.team == _gamer.curHand) {
//       // toggle selected sub
//       setState(() {
//         _activeItem = newActive;
//         //_lastActiveItem = newActive;
//         //lastPosition = '';
//         movePoints = [];
//       });
//       fetchMovePoints();
//       return true;
//     } else {
//       // eat each other's piece
//       if (_activeItem != null && _activeItem!.team == _gamer.curHand) {
//         String activePos = _activeItem!.position.toCode();
//         checkCanMove(activePos, toPosition, newActive).then((canMove) {
//           int delay = 250 - (DateTime.now().millisecondsSinceEpoch - ticker);
//           if (delay < 0) {
//             delay = 0;
//           }
//           if (canMove) {
//             addStep(ChessPosition.fromCode(activePos), toPosition);
//             //showAction(ActionType.eat);
//             animateMove(toPosition);
//             setState(() {
//               // clear drop points
//               movePoints = [];
//               _lastPosition = activePos;

//               // snapshot of eaten sub
//               dieFlash = ChessItem(newActive.code, position: toPosition);
//               newActive.isDie = true;
//             });
//             Future.delayed(Duration(milliseconds: delay), () {
//               setState(() {
//                 dieFlash = null;
//               });
//             });
//           }
//         });
//         return true;
//       }
//     }
//     return false;
//   }

//   ChessPosition pointTrans(
//     Offset tapPoint,
//     bool isFlip,
//   ) {
//     int x = (tapPoint.dx -
//             _gamer.offsetScaleLeft -
//             _gamer.skin.offset.dx * _gamer.scale) ~/
//         (_gamer.skin.size * _gamer.scale);
//     int y = 9 -
//         (tapPoint.dy -
//                 _gamer.offsetScaleTop -
//                 _gamer.skin.offset.dy * _gamer.scale) ~/
//             (_gamer.skin.size * _gamer.scale);
//     return ChessPosition(isFlip ? 8 - x : x, isFlip ? 9 - y : y);
//   }

//   @override
//   Widget build(BuildContext context) {
//     initGamer();
//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     List<Widget> widgets = [const Board()];

//     List<Widget> layer0 = [];

//     // quân bị ăn
//     if (dieFlash != null) {
//       layer0.add(
//         Align(
//           alignment: _gamer.skin.getAlignFromPos(dieFlash!.position),
//           child: Piece(item: dieFlash!, isActive: false),
//         ),
//       );
//     }

//     // đánh dấu vị trí xuất phát quân vừa đi
//     if (_lastPosition.isNotEmpty) {
//       ChessItem emptyItem =
//           ChessItem('0', position: ChessPos.fromCode(_lastPosition));
//       layer0.add(
//         Align(
//           alignment: _gamer.skin.getAlignFromPos(emptyItem.position),
//           child: MarkComponent(
//             size: _gamer.skin.size * _gamer.scale,
//           ),
//         ),
//       );
//     }
//     widgets.add(
//       Center(
//         child: SizedBox(
//           width: _gamer.realBoardWidth,
//           height: _gamer.realBoardHeight,
//           child: Stack(
//             alignment: Alignment.center,
//             fit: StackFit.expand,
//             children: layer0,
//           ),
//         ),
//       ),
//     );

//     // add cac quan co làm nổi ô được chọn với active option
//     widgets.add(
//       Center(
//         child: SizedBox(
//           width: _gamer.realBoardWidth,
//           height: _gamer.realBoardHeight,
//           child: PiecesLayout(
//             items: items,
//             activeItem: _activeItem, // nổi quân cờ và vòng quanh trắng
//             lastActiveItemPos: _lastActiveItemPos.isNotEmpty
//                 ? ChessPos.fromCode(_lastActiveItemPos)
//                 : null,
//           ),
//         ),
//       ),
//     );

//     // đánh dấu những ô có thể đi được
//     List<Widget> layer2 = [];
//     for (var element in movePoints) {
//       ChessItem emptyItem =
//           ChessItem('0', position: ChessPos.fromCode(element));
//       layer2.add(
//         Align(
//           alignment: _gamer.skin.getAlignFromPos(emptyItem.position),
//           child: PointComponent(size: _gamer.skin.size * _gamer.scale),
//         ),
//       );
//     }

//     widgets.add(
//       Center(
//         child: SizedBox(
//           width: _gamer.realBoardWidth,
//           height: _gamer.realBoardHeight,
//           child: Stack(
//             alignment: Alignment.center,
//             fit: StackFit.expand,
//             children: layer2,
//           ),
//         ),
//       ),
//     );

//     return LayoutBuilder(builder: (context, constraints) {
//       double originRatio = _gamer.skin.height / _gamer.skin.width;
//       double currentRatio = constraints.maxHeight / constraints.maxWidth;
//       if (currentRatio > originRatio) {
//         _gamer.scale = constraints.maxWidth / _gamer.skin.width;
//         _gamer.offsetScaleLeft = 0.0;
//         _gamer.offsetScaleTop =
//             (constraints.maxHeight - _gamer.skin.height * _gamer.scale) / 2;
//         _gamer.realBoardWidth = constraints.maxWidth;
//         _gamer.realBoardHeight = constraints.maxWidth * originRatio;
//       } else {
//         _gamer.scale = constraints.maxHeight / _gamer.skin.height;
//         _gamer.offsetScaleTop = 0.0;
//         _gamer.offsetScaleLeft =
//             (constraints.maxWidth - _gamer.skin.width * _gamer.scale) / 2;
//         _gamer.realBoardHeight = constraints.maxHeight;
//         _gamer.realBoardWidth = constraints.maxHeight / originRatio;
//       }

//       return GestureDetector(
//         onTapUp: (detail) {
//           if (_gamer.isLock) return;
//           setState(() {
//             onPointer(pointTrans(detail.localPosition));
//           });
//         },
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//               maxHeight: _gamer.realBoardHeight,
//               minHeight: _gamer.realBoardHeight),
//           child: Stack(
//             alignment: Alignment.center,
//             //fit: StackFit.expand,
//             // children: [
//             //   Image.asset(
//             //     gamer.skin.boardImage,
//             //     fit: BoxFit.contain,
//             //   )
//             // ],
//             children: widgets,
//           ),
//         ),
//         // child: Column(
//         //   children: [
//         //     Flexible(
//         //       child: Stack(
//         //         alignment: Alignment.center,
//         //         fit: StackFit.expand,
//         //         children: widgets,
//         //       ),
//         //     ),
//         //   ],
//         // ),
//       );
//     });
//   }
// }
