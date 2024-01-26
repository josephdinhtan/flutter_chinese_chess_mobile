import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';
import 'package:provider/provider.dart';

import '../../../../utils/extensions/string_extensions.dart';
import '../../../../utils/logging/prt.dart';
import '../../../router/router.dart';
import '../ad/trigger.dart';
import '../analysis_page_widgets/page_header.dart';
import '../analysis_page_widgets/engine_status_bar.dart';
import '../analysis_page_widgets/history_panel.dart';
import '../analysis_page_widgets/operation_bar.dart';
import '../analysis_page_widgets/review_panel.dart';
import '../analysis_page_widgets/snack_bar.dart';
import '../cchess/cchess_base.dart';
import '../cchess/cchess_fen.dart';
import '../cchess/move_name.dart';
import '../engine/analysis.dart';
import '../engine/cloud_engine.dart';
import '../engine/engine.dart';
import '../engine/hybrid_engine.dart';
import '../engine/pikafish_engine.dart';
import '../state_controllers/battle_state.dart';
import '../state_controllers/board_state.dart';
import '../state_controllers/game.dart';
import 'battle_db.dart';
import 'thinking_board.dart';

class AnalysisPage extends StatefulWidget {
  static const yourTurn = 'Please move';
  const AnalysisPage({Key? key}) : super(key: key);
  @override
  AnalysisPageState createState() => AnalysisPageState();
}

class AnalysisPageState extends State<AnalysisPage> {
  //
  bool _opponentIsHuman = false;

  late BoardState _boardState;
  late BattleState _pageState;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() async {
    prt("Jdt initGame");
    _boardState = Provider.of<BoardState>(context, listen: false);
    _pageState = Provider.of<BattleState>(context, listen: false);

    //createPieceAnimation(const Duration(milliseconds: 200), this);

    await loadBattle();

    engineGoHint();
    // if (_boardState.isOpponentTurn && !_opponentIsHuman) {
    //   prt("Jdt initGame opponent Is Machine, trying move");
    //   engineGo();
    // } else {
    //   _pageState.changeStatus(BattlePage.yourTurn);
    // }
  }

  // 打开上一次退出时的棋谱 Open the chess record from the last time you exited
  Future<void> loadBattle() async {
    await BattleDb().load();
    final position = Fen.toPosition(BattleDb().initBoard)!;

    for (var i = 0; i < BattleDb().moveList.length; i += 4) {
      final move = Move.fromCoordinate(
        int.parse(BattleDb().moveList.substring(i + 0, i + 1)),
        int.parse(BattleDb().moveList.substring(i + 1, i + 2)),
        int.parse(BattleDb().moveList.substring(i + 2, i + 3)),
        int.parse(BattleDb().moveList.substring(i + 3, i + 4)),
      );

      position.move(move);
    }

    _boardState.flipBoard(BattleDb().boardFlipped, notify: false);
    _boardState.setPosition(position);
  }

  Future<bool> saveBattle() async {
    //
    final moveList = _boardState.buildMoveListForManual();

    BattleDb().initBoard = Fen.defaultInitFen;
    BattleDb().moveList = moveList;
    BattleDb().boardFlipped = _boardState.isBoardFlipped;

    return await BattleDb().save();
  }

  confirmNewGame() {
    //
    bool opponentFirst = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start a new game?', style: GameFonts.uicp()),
        content: SingleChildScrollView(
          child: Text("Bạn có muốn tạo một mới?".hardCode),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'.hardCode),
            onPressed: () {
              Navigator.of(context).pop();
              newGame(opponentFirst);
            },
          ),
          TextButton(
            child: Text('Cancel'.hardCode),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  newGame(bool opponentFirst) async {
    prt("Jdt newGame opponentFirst: $opponentFirst opponentIsHuman: $_opponentIsHuman");
    if (AdTrigger.battle.checkAdChance(AdAction.start, context)) return;

    _boardState.flipBoard(opponentFirst);

    _boardState.load(Fen.defaultInitFen, notify: true);

    HybridEngine().newGame();

    setState(() {
      _boardState.engineInfo = null;
      _boardState.bestMove = null;
    });

    // if (opponentFirst && !_opponentIsHuman) {
    //   engineGo();
    // } else {
    //   _pageState.changeStatus(BattlePage.yourTurn);
    // }
    engineGoHint();

    ReviewPanel.popRequest();
  }

  regret() async {
    prt("Jdt regret() undo 1 move", tag: runtimeType);
    if (AdTrigger.battle.checkAdChance(AdAction.regret, context)) return;

    await _stopPonder();

    _boardState.regret(moves: 1);
  }

  goToEditBoard(String editFen) {
    prt("Jdt goToEditBoard", tag: runtimeType);
    String currentFen = "";
    //final boardState = Provider.of<BoardState>(context);
    prt("Jdt goToEditBoard 2", tag: runtimeType);
    prt("Jdt goToEditBoard ${Fen.fromPosition(_boardState.positionMap)}",
        tag: runtimeType);
    JdtRouter.navigateTo(
      context: context,
      scene: GameScene.editBoard,
      parameter: editFen,
    ).then((fenStr) {
      prt("Jdt goToEditBoard result: $fenStr", tag: runtimeType);
      _boardState.setPosition(Fen.toPosition(fenStr!)!);
    });
  }

  cloudAnalysisPosition() async {
    //
    if (AdTrigger.battle.checkAdChance(AdAction.requestAnalysis, context)) {
      return;
    }

    showSnackBar('Analyzing the situation...', shortDuration: true);

    try {
      final result = await CloudEngine().analysis(_boardState.positionMap);

      if (result.response is Analysis) {
        //
        List<AnalysisItem> items = (result.response as Analysis).items;

        for (var item in items) {
          item.name = MoveName.translate(
            _boardState.positionMap,
            Move.fromEngineMove(item.move),
          );
        }
        if (mounted) {
          _showAnalysisItems(
            context,
            items: items,
            callback: (index) => Navigator.of(context).pop(),
          );
        }
      } else if (result.response is Error) {
        if (mounted) {
          showSnackBar(
              'Server calculation has been requested, please check later!');
        }
      } else {
        if (mounted) {
          showSnackBar('mistak: ${result.type}');
        }
      }
    } catch (e) {
      showSnackBar('mistake: $e');
    }
  }

  _showAnalysisItems(
    BuildContext context, {
    required List<AnalysisItem> items,
    required Function(AnalysisItem item) callback,
  }) {
    //
    final List<Widget> children = [];

    for (var item in items) {
      children.add(
        ListTile(
          title: Text(item.name!,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          //subtitle: Text('Probability of winning: ${item.winrate}%'),
          subtitle: Text('Tỉ lệ chiến thắng: ${item.winrate}%',
              style: TextStyle(fontSize: 14, color: Colors.white70)),
          trailing: Text('Điểm: ${item.score}',
              style: TextStyle(fontSize: 18, color: Colors.amber)),
          onTap: () => callback(item),
        ),
      );
      children.add(Divider(
        color: Colors.grey.withOpacity(0.5),
      ));
    }

    children.insert(0, const SizedBox(height: 4.0));
    children.add(const SizedBox(height: 56));

    showGlassModalBottomSheet(
      context: context,
      backgroundOpacity: 0.2,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(top: 24.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }

  flipBoard() async {
    //
    await HybridEngine().newGame();
    await Future.delayed(const Duration(seconds: 1));

    _boardState.engineInfo = null;
    _boardState.bestMove = null;

    _boardState.flipBoard(!_boardState.isBoardFlipped, swapSite: true);
  }

  saveManual() async {
    //
    final success = await _boardState.saveManual();

    if (!mounted) return;
    showSnackBar(success ? 'Saved successfully！' : 'Save failed！');
  }

  onBoardTap(BuildContext context, int index) async {
    prt("Jdt onBoardTap index: $index");

    if (_boardState.isBoardFlipped) index = 89 - index;

    if (_boardState.liftUpIndex == index) {
      _boardState.select(Move.invalidIndex);
      return;
    }

    final position = _boardState.positionMap;

    // 仅 Position 中的 sideToMove 指示一方能动棋
    // Only sideToMove in Position indicates that one side can move
    if (_boardState.isOpponentTurn && !_opponentIsHuman) {
      // chặn người dùng move để cho board mode, nhưng vì mình đã chặn mode từ bestmove nên là nó ko move được và đứng luôn
      prt("Jdt Return because of PieceColor.sameColor 1");
      //return;
    }

    final tapedPiece = position.pieceAt(index);

    // 之前已经有棋子被选中了
    // Một quân cờ đã được chọn trước đó
    if (_boardState.liftUpIndex != Move.invalidIndex &&
        PieceColor.of(position.pieceAt(_boardState.liftUpIndex)) ==
            position.sideToMove) {
      //
      // 当前点击的棋子和之前已经选择的是同一个位置
      // Quân cờ đang bấm sẽ ở cùng vị trí với quân cờ đã chọn trước đó.
      if (_boardState.liftUpIndex == index) {
        prt("Jdt Return because of index == focusIndex");
        return;
      }

      // 之前已经选择的棋子和现在点击的棋子是同一边的，说明是选择另外一个棋子
      // Quân cờ được chọn trước đó nằm cùng phía với quân cờ hiện đang được bấm, biểu thị rằng một quân cờ khác đã được chọn.
      final focusPiece = position.pieceAt(_boardState.liftUpIndex);

      if (PieceColor.sameColor(focusPiece, tapedPiece)) {
        _boardState.select(index);
        prt("Jdt Return because of PieceColor.sameColor 2");
        return;
      }

      // The chess piece clicked now is on a different side
      // than the last chess piece selected. Either the piece is captured
      // or the piece is moved to a blank space.
      if (_boardState.move(Move(_boardState.liftUpIndex, index))) {
        //
        //startPieceAnimation();

        final result = HybridEngine().scanGameResult(
          _boardState.positionMap,
          _boardState.playerSide,
        );

        await _stopPonder();
        engineGoHint();
        switch (result) {
          //
          case GameResult.pending:
            //
            // final move = _boardState.position.lastMove!.asEngineMove();

            // if (_boardState.bestMove?.opponentPonder != null &&
            //     EngineConfigDb().engineConfigIsPonderSupported &&
            //     move == _boardState.bestMove?.opponentPonder) {
            //   //
            //   await HybridEngine().ponderhit();
            //   //
            // } else {
            //   //
            //   await _stopPonder();

            //   if (!_opponentIsHuman) {
            //     prt("Jdt onBoardTap trying moving because opponent is machine");
            //     await Future.delayed(const Duration(seconds: 1));
            //     await engineGo();
            //   }
            // }
            break;
          case GameResult.win:
            gotWin();
            break;
          case GameResult.lose:
            gotLose();
            break;
          case GameResult.draw:
            gotDraw();
            break;
        }
      }
    } else if (tapedPiece != Piece.noPiece &&
        PieceColor.of(tapedPiece) == position.sideToMove) {
      // The chess piece was not selected before, now click to select the chess piece
      _boardState.select(index);
    }
  }

  engineCallback(EngineResponse er) async {
    //
    final resp = er.response;
    prt("Jdt engineCallback resp: $resp");
    if (resp is EngineInfo) {
      // Show board thinking...
      _boardState.engineInfo = resp;

      // scoreType 0 - cp, 1 - mate
      final scoreType = _boardState.engineInfo!.tokens['cp_or_mate'];
      final depth = _boardState.engineInfo!.tokens['depth'];

      if (scoreType != null && scoreType == 1 && depth != null && depth >= 60) {
        PikafishEngine().stop(removeCallback: false);
      }

      if (PikafishEngine().state != EngineState.pondering) {
        final score = _boardState.engineInfo!.score(_boardState, false);
        if (score != null) {
          _pageState.changeStatus(isMate: score.$1, newScore: score.$2);
        }
      }
    } else if (resp is BestMove) {
      //
      final move = Move.fromEngineMove(resp.bestMove);

      // nếu set best move ở đây thì nó sẽ reload state và mũi tên thinking sẽ bị update thêm 1 lần nữa và bị đánh dấu như là đã đi, mặc dù người chơi thật chưa đi
      _boardState.bestMove = (er.response as BestMove);

      // Khong cho May tu Move
      //_boardState.move(move); // JDT broadcast to modules to move Chess Pieces
      //startPieceAnimation();
    } else if (resp is NoBestmove) {
      if (PikafishEngine().state == EngineState.searching) {
        gotWin();
      } else {
        gotLose();
      }
    } else if (resp is Error) {
      showSnackBar(resp.message);
      //_pageState.changeStatus(resp.message);
    }
  }

  Future<void> engineGo() async {
    final state = PikafishEngine().state;
    prt("Jdt engineGo state: $state");

    // comment here mean force re-thinking anytime
    //if (state == EngineState.searching || state == EngineState.hinting) return;

    //_pageState.changeStatus('The other party is thinking...');

    await HybridEngine().go(_boardState.positionMap, engineCallback);
  }

  engineGoPonder() async {
    await HybridEngine().goPonder(
      _boardState.positionMap,
      engineCallback,
      _boardState.bestMove!.opponentPonder!,
    );
  }

  engineGoHint() async {
    //
    if (AdTrigger.battle.checkAdChance(AdAction.requestHint, context)) {
      prt("Jdt Return because of AdTrigger.battle.checkAdChance");
      return;
    }

    final state = PikafishEngine().state;
    prt("Jdt state: $state");
    if (state == EngineState.searching || state == EngineState.hinting) {
      prt("Jdt Return because of EngineState.searching or EngineState.hinting");
      return;
    }

    prt("Jdt engineGoHint if old is pondering, stop ponder first");
    await _stopPonder();
    await Future.delayed(const Duration(seconds: 1));

    prt("Jdt engineGoHint Engine thinking...");
    //_pageState.changeStatus('Engine thinking...');
    await HybridEngine().goHint(_boardState.positionMap, engineCallback);
  }

  gotWin() async {
    //
    await Future.delayed(const Duration(seconds: 1));

    // Audios.playTone('win.mp3');
    _boardState.positionMap.result = GameResult.win;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Won', style: GameFonts.uicp()),
        content: const Text('Congratulations on your victory！'),
        actions: <Widget>[
          TextButton(
            child: const Text('One more round'),
            onPressed: () {
              Navigator.of(context).pop();
              confirmNewGame();
            },
          ),
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  gotLose() async {
    //
    await Future.delayed(const Duration(seconds: 1));

    // Audios.playTone('lose.mp3');
    _boardState.positionMap.result = GameResult.lose;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('lost', style: GameFonts.uicp()),
        content: const Text('Even defeat is gratifying！'),
        actions: <Widget>[
          TextButton(
            child: const Text('One more round'),
            onPressed: () {
              Navigator.of(context).pop();
              confirmNewGame();
            },
          ),
          TextButton(
            child: const Text('closure'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  gotDraw() async {
    //
    await Future.delayed(const Duration(seconds: 1));

    // Audios.playTone('draw.mp3');
    _boardState.positionMap.result = GameResult.draw;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('draw', style: GameFonts.uicp()),
        content: const Text('Harmony is precious!'),
        actions: <Widget>[
          TextButton(
            child: const Text('One more round'),
            onPressed: () {
              Navigator.of(context).pop();
              confirmNewGame();
            },
          ),
          TextButton(
            child: const Text('close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final operatorBar =
        OperationBar(backgroundColor: Colors.white.withOpacity(0.1), items: [
      OperatorItem(
          name: 'Lùi'.hardCode,
          iconData: Icons.arrow_back_ios_rounded,
          onPressed: regret),
      // OperatorItem(
      //     name: 'Go',
      //     iconData: Icons.arrow_forward_ios_rounded,
      //     onPressed: regret),
      OperatorItem(
          name: 'Gợi ý'.hardCode,
          iconData: Icons.saved_search_rounded,
          onPressed: engineGoHint),
      OperatorItem(
          name: 'Lật'.hardCode,
          iconData: Icons.flip_camera_android_rounded,
          onPressed: flipBoard),
      OperatorItem(
          name: 'Tạo mới'.hardCode,
          iconData: Icons.crop_square_outlined,
          onPressed: confirmNewGame),
      OperatorItem(
          name: 'Cloud',
          iconData: CupertinoIcons.cloud_upload,
          onPressed: cloudAnalysisPosition),
      OperatorItem(
        name: 'Sửa hình cờ',
        iconData: Icons.edit_note_rounded,
        onPressed: () {
          goToEditBoard(Fen.fromPosition(_boardState.positionMap));
        },
      ),
      OperatorItem(
          name: 'Lưu hình cờ',
          //iconData: Icons.shape_line_outlined,
          iconData: Icons.stars,
          onPressed: saveManual),
      OperatorItem(
          name: 'Lưu toàn bộ ván cờ',
          iconData: Icons.star_outline_rounded,
          onPressed: saveManual),
    ]);

    return Scaffold(
      body: Container(
        // constraints: const BoxConstraints.expand(),
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/battle_background.jpg"),
        //         fit: BoxFit.cover)),
        // color: GameColors.darkBackground,
        //color: Color.fromRGBO(242, 242, 247, 1),
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/main_menu_background.jpg"),
                fit: BoxFit.cover)),
        //color: const Color(0xFFEDE8E0),
        child: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PageHeader(
                  title: "Phân Tích".capitalize.hardCode,
                  titleColor: Colors.white,
                  // iconData: Icons.saved_search,
                  svgIconPath: "assets/images/searching_robo.svg",
                ),
                const EngineStatusBar(),
                ThinkingBoard(
                  onBoardTap: onBoardTap,
                  boardBackgroundColor: const Color(0xFFdfb87e),
                ),
                const Expanded(child: HistoryPanel()),
                operatorBar
              ]),
        ),
      ),
    );
  }

  Future<void> _stopPonder() async {
    prt("Jdt _stopPonder");
    await HybridEngine().stopPonder();
    _boardState.engineInfo = null;
    _boardState.bestMove = null;
  }

  @override
  void dispose() {
    saveBattle().then((_) => _boardState.reset());
    HybridEngine().stop();
    super.dispose();
  }
}
