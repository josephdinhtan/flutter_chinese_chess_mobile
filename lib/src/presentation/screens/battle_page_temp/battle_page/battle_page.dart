import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../ad/trigger.dart';
import '../cchess/cchess_base.dart';
import '../cchess/cchess_fen.dart';
import '../cchess/move_name.dart';
import '../chess_utils/build_utils.dart';
import '../chess_utils/chess_board.dart';
import '../data_base/local_data.dart';
import '../data_base/profile.dart';
import '../engine/analysis.dart';
import '../engine/cloud_engine.dart';
import '../engine/engine.dart';
import '../engine/hybrid_engine.dart';
import '../engine/pikafish_config.dart';
import '../engine/pikafish_engine.dart';
import '../state_controllers/board_state.dart';
import '../state_controllers/game.dart';
import '../state_controllers/page_state.dart';
import '../battle_widgets/checkbox_list_tile_ex.dart';
import '../battle_widgets/operation_bar.dart';
import '../battle_widgets/review_panel.dart';
import '../battle_widgets/snack_bar.dart';
import '../battle_widgets/battle_header.dart';

class BattlePage extends StatefulWidget {
  //
  static const yourTurn = 'Please move';

  const BattlePage({Key? key}) : super(key: key);

  @override
  BattlePageState createState() => BattlePageState();
}

class BattlePageState extends State<BattlePage> {
  //
  bool _opponentIsHuman = false;

  late BoardState _boardState;
  late PageState _pageState;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() async {
    prt("Jdt initGame");
    _boardState = Provider.of<BoardState>(context, listen: false);
    _pageState = Provider.of<PageState>(context, listen: false);

    //createPieceAnimation(const Duration(milliseconds: 200), this);

    await loadBattle();

    if (_boardState.isOpponentTurn && !_opponentIsHuman) {
      prt("Jdt initGame opponent Is Machine, trying move");
      engineGo();
    } else {
      _pageState.changeStatus(BattlePage.yourTurn);
    }
  }

  // 打开上一次退出时的棋谱 Open the chess record from the last time you exited
  Future<void> loadBattle() async {
    //
    final profile = await Profile.local().load();

    final initBoard = profile['battlepage-init-board'] ?? Fen.defaultPosition;
    final moveList = profile['battlepage-move-list'] ?? '';
    final boardInversed = profile['battlepage-board-inversed'] ?? false;
    _opponentIsHuman = profile['battlepage-oppo-human'] ?? false;

    final position = Fen.positionFromFen(initBoard)!;

    for (var i = 0; i < moveList.length; i += 4) {
      final move = Move.fromCoordinate(
        int.parse(moveList.substring(i + 0, i + 1)),
        int.parse(moveList.substring(i + 1, i + 2)),
        int.parse(moveList.substring(i + 2, i + 3)),
        int.parse(moveList.substring(i + 3, i + 4)),
      );

      position.move(move);
    }

    _boardState.flipBoard(boardInversed, notify: false);
    _boardState.setPosition(position);
  }

  Future<bool> saveBattle() async {
    //
    final moveList = _boardState.buildMoveListForManual();

    final profile = await Profile.local().load();

    profile['battlepage-init-board'] = Fen.defaultPosition;
    profile['battlepage-move-list'] = moveList;
    profile['battlepage-board-inversed'] = _boardState.isBoardFlipped;
    profile['battlepage-oppo-human'] = _opponentIsHuman;

    return await profile.save();
  }

  confirmNewGame() {
    //
    bool opponentFirst = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start a new game？', style: GameFonts.uicp()),
        content: SingleChildScrollView(
          child: Column(
            children: [
              CheckboxListTileEx(
                title: const Text('The other party goes first'),
                onChanged: (value) => opponentFirst = value,
                value: opponentFirst,
              ),
              CheckboxListTileEx(
                title: const Text('Players control chess pieces on both sides'),
                onChanged: (value) => _opponentIsHuman = value,
                value: _opponentIsHuman,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Sure'),
            onPressed: () {
              Navigator.of(context).pop();
              newGame(opponentFirst);
            },
          ),
          TextButton(
            child: const Text('Cancel'),
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

    _boardState.load(Fen.defaultPosition, notify: true);

    HybridEngine().newGame();

    setState(() {
      _boardState.engineInfo = null;
      _boardState.bestMove = null;
    });

    if (opponentFirst && !_opponentIsHuman) {
      engineGo();
    } else {
      _pageState.changeStatus(BattlePage.yourTurn);
    }

    ReviewPanel.popRequest();
  }

  regret() async {
    //
    if (AdTrigger.battle.checkAdChance(AdAction.regret, context)) return;

    await _stopPonder();

    _boardState.regret(GameScene.battle, moves: 2);
  }

  analysisPosition() async {
    //
    if (AdTrigger.battle.checkAdChance(AdAction.requestAnalysis, context)) {
      return;
    }

    showSnackBar('Analyzing the situation...', shortDuration: true);

    try {
      final result = await CloudEngine().analysis(_boardState.position);

      if (result.response is Analysis) {
        //
        List<AnalysisItem> items = (result.response as Analysis).items;

        for (var item in items) {
          item.name = MoveName.translate(
            _boardState.position,
            Move.fromEngineMove(item.move),
          );
        }
        if (mounted) {
          showAnalysisItems(
            context,
            items: items,
            callback: (index) => Navigator.of(context).pop(),
          );
        }
      } else if (result.response is Error) {
        if (mounted)
          showSnackBar(
              'Server calculation has been requested, please check later!');
      } else {
        if (mounted) {
          showSnackBar('mistak: ${result.type}');
        }
      }
    } catch (e) {
      showSnackBar('mistake: $e');
    }
  }

  showAnalysisItems(
    BuildContext context, {
    required List<AnalysisItem> items,
    required Function(AnalysisItem item) callback,
  }) {
    //
    final List<Widget> children = [];

    for (var item in items) {
      children.add(
        ListTile(
          title: Text(item.name!, style: GameFonts.ui(fontSize: 18)),
          subtitle: Text('Probability of winning: ${item.winrate}%'),
          trailing: Text('position score: ${item.score}'),
          onTap: () => callback(item),
        ),
      );
      children.add(const Divider());
    }

    children.insert(0, const SizedBox(height: 10));
    children.add(const SizedBox(height: 56));

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }

  swapPosition() async {
    prt("Jdt swapPosition");
    if (PikafishEngine().state == EngineState.pondering) {
      await _stopPonder();
      await Future.delayed(const Duration(seconds: 1));
    }

    _boardState.flipBoard(!_boardState.isBoardFlipped);

    if (_boardState.isOpponentTurn && !_opponentIsHuman) {
      prt("Jdt opponent is Machine trying auto move");
      engineGo();
    } else {
      prt("Jdt swapPosition _opponent is Human");
      _pageState.changeStatus(BattlePage.yourTurn);
    }
  }

  inverseBoard() async {
    //
    await HybridEngine().newGame();
    await Future.delayed(const Duration(seconds: 1));

    _boardState.engineInfo = null;
    _boardState.bestMove = null;

    _boardState.flipBoard(!_boardState.isBoardFlipped, swapSite: true);
  }

  saveManual() async {
    //
    final success = await _boardState.saveManual(GameScene.battle);

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

    final position = _boardState.position;

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
          _boardState.position,
          _boardState.playerSide,
        );

        switch (result) {
          //
          case GameResult.pending:
            //
            final move = _boardState.position.lastMove!.asEngineMove();

            if (_boardState.bestMove?.opponentPonder != null &&
                PikafishConfig(LocalData().profile).ponder &&
                move == _boardState.bestMove?.opponentPonder) {
              //
              await HybridEngine().ponderhit();
              //
            } else {
              //
              await _stopPonder();

              if (!_opponentIsHuman) {
                prt("Jdt onBoardTap trying moving because opponent is machine");
                await Future.delayed(const Duration(seconds: 1));
                await engineGo();
              }
            }
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
          _pageState.changeStatus(score.$1, newScore: score.$2);
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

      final result = HybridEngine().scanGameResult(
        _boardState.position,
        _boardState.playerSide,
      );

      // after move
      switch (result) {
        //
        case GameResult.pending:
          if (er.type == EngineType.cloudLibrary) {
            // nếu cập nhật status ở đây nó sẽ hiện đè lên score
            //_pageState.changeStatus(BattlePage.yourTurn);
            prt("Jdt engineCallback type is EngineType.cloudLibrary");
          } else {
            //afterEngineMove();
          }
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
    } else if (resp is NoBestmove) {
      if (PikafishEngine().state == EngineState.searching) {
        gotWin();
      } else {
        gotLose();
      }
    } else if (resp is Error) {
      showSnackBar(resp.message);
      _pageState.changeStatus(resp.message);
    }
  }

  afterEngineMove() async {
    prt("Jdt afterEngineMove: ${PikafishEngine().state}");
    //
    if (PikafishEngine().state == EngineState.searching) {
      //
      if (_boardState.bestMove?.opponentPonder != null &&
          PikafishConfig(LocalData().profile).ponder) {
        //
        await Future.delayed(
          const Duration(seconds: 1),
          () => engineGoPonder(),
        );
      }

      if (_boardState.engineInfo != null) {
        //
        final score = _boardState.engineInfo?.score(
          _boardState,
          true,
        );
        if (score != null) {
          _pageState.changeStatus('${score.$1}, ${BattlePage.yourTurn}');
          prt("Jdt core != null");
        } else {
          _pageState.changeStatus(BattlePage.yourTurn);
          prt("Jdt core == null");
        }
      } else {
        _pageState.changeStatus(BattlePage.yourTurn);
        prt("Jdt _boardState.engineInfo == null");
      }

      // debug
      if (LocalData().debugMode.value &&
          !PikafishConfig(LocalData().profile).ponder &&
          mounted) {
        //
        Future.delayed(const Duration(seconds: 1), () => engineGoHint());
      }
    } else {
      if (_boardState.isOpponentTurn && !_opponentIsHuman) {
        prt("Jdt _opponentHuman false engineGo after 1 seconds");
        //Future.delayed(const Duration(seconds: 1), () => engineGo());
      }
    }
  }

  Future<void> engineGo() async {
    final state = PikafishEngine().state;
    prt("Jdt engineGo state: $state");
    if (state == EngineState.searching || state == EngineState.hinting) return;

    _pageState.changeStatus('The other party is thinking...');

    await HybridEngine().go(_boardState.position, engineCallback);
  }

  engineGoPonder() async {
    await HybridEngine().goPonder(
      _boardState.position,
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
    _pageState.changeStatus('Engine thinking...');
    await HybridEngine().goHint(_boardState.position, engineCallback);
  }

  gotWin() async {
    //
    await Future.delayed(const Duration(seconds: 1));

    // Audios.playTone('win.mp3');
    _boardState.position.result = GameResult.win;

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
    _boardState.position.result = GameResult.lose;

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
    _boardState.position.result = GameResult.draw;

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
    //
    final ratingScore = createRatingScore(
      context,
      GameScene.battle,
      rightAction: () async {
        //
        await HybridEngine().stop();

        _boardState.engineInfo = null;
        _boardState.bestMove = null;

        if (!mounted) return;

        // Settings button
        // await Navigator.of(context).push(
        //   CupertinoPageRoute(
        //     builder: (context) => const SettingsPage(),
        //   ),
        // );

        if (_boardState.isOpponentTurn && !_opponentIsHuman) {
          prt("Jdt _opponent is Machine, trying move");
          engineGo();
        } else {
          prt("Jdt _opponent is Human");
          _pageState.changeStatus(BattlePage.yourTurn);
        }
      },
    );
    final operatorBar = OperationBar(items: [
      ActionItem(
          name: 'New', icon: const Icon(Icons.add), callback: confirmNewGame),
      ActionItem(
          name: 'Back',
          icon: const Icon(Icons.arrow_back_ios),
          callback: regret),
      ActionItem(name: 'hint', callback: engineGoHint),
      ActionItem(name: 'Cloud library', callback: analysisPosition),
      ActionItem(name: 'exchange situations', callback: swapPosition),
      ActionItem(name: 'flip the board', callback: inverseBoard),
      ActionItem(name: 'Save game record', callback: saveManual),
    ]);

    final engineHint = Consumer<BoardState>(
      builder: (context, __, child) => buildEngineHint(),
    );

    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('images/bg.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        color: GameColors.darkBackground,
        child: Column(children: <Widget>[
          const BattleHeader(),
          ChessBoard(scene: GameScene.battle, onBoardTap: onBoardTap),
          ratingScore,
          engineHint,
          operatorBar
        ]),
      ),
    );
  }

  Widget buildEngineHint() {
    //
    String? content;

    if (_boardState.engineInfo != null) {
      //
      content = _boardState.engineInfo!.info(_boardState);

      if (PikafishEngine().state == EngineState.pondering) {
        content = '[ background thinking ]\n$content';
      }
    }

    content ??= _boardState.position.moveList;

    return buildInfoPanel(content);
  }

  Widget buildInfoPanel(String text) {
    //
    final manualStyle = GameFonts.ui(
      fontSize: 15,
      color: GameColors.primary,
      height: 1.5,
    );

    return Expanded(
      child: Container(
        // width: double.infinity,
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: Text(
            text,
            style: manualStyle,
            textAlign: TextAlign.center,
          ),
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
