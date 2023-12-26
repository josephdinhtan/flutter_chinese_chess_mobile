import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/logging/prt.dart';
import '../cchess/cchess_fen.dart';
import '../engine/pikafish_engine.dart';
import '../state_controllers/board_state.dart';

class PlainInfoPanel extends StatefulWidget {
  const PlainInfoPanel({super.key});

  @override
  State<PlainInfoPanel> createState() => _PlainInfoPanelState();
}

class _PlainInfoPanelState extends State<PlainInfoPanel>
    with SingleTickerProviderStateMixin {
  late final TabController controller;
  @override
  void initState() {
    super.initState();
    controller =
        TabController(length: _panels.length, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final List<Widget> _panels = const [
    _EnginePanel(),
    _HistoryPanel(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          bottom: 10,
          child: TabPageSelector(
            color: Colors.grey,
            selectedColor: Colors.amber,
            controller: controller,
          ),
        ),
        TabBarView(controller: controller, children: _panels),
      ],
    );
  }
}

class _EnginePanel extends StatelessWidget {
  const _EnginePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Consumer<BoardState>(
          builder: (context, boardState, child) {
            String? content;

            if (boardState.engineInfo != null) {
              content = boardState.engineInfo!.info(boardState);
              if (PikafishEngine().state == EngineState.pondering) {
                content = '[ background thinking ]\n$content';
              }
              prt("Jdt buildEngineHint: $content");
            }
            return Text(
              content ?? "",
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Consumer<BoardState>(
          builder: (context, boardState, child) {
            final content = boardState.position.moveList;
            prt("Jdt ${Fen.fromPosition(boardState.position)}",
                tag: "plain_info_panel");
            return Text(
              content,
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}
