import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';

import '../chess_utils/build_utils.dart';
import '../chess_utils/ruler.dart';
import '../state_controllers/game.dart';

class OperatorItem {
  final String name;
  final Icon? icon;
  final VoidCallback? callback;
  OperatorItem({required this.name, this.icon, this.callback});
}

class OperationBar extends StatefulWidget {
  //
  final List<OperatorItem> items;

  const OperationBar({Key? key, required this.items}) : super(key: key);

  @override
  State<OperationBar> createState() => _OperationBarState();
}

class _OperationBarState extends State<OperationBar> {
  //
  final keys = <GlobalKey>[];
  final GlobalKey containerKey = GlobalKey();

  final buttonStyle = GameFonts.art(fontSize: 16, color: GameColors.primary);
  final finalChildren = <Widget>[];

  bool finalLayout = false;

  showMore() {
    if (finalChildren.length == widget.items.length) return;
    const itemStyle = TextStyle(fontSize: 18);
    final moreItems = widget.items.sublist(finalChildren.length);

    final children = <Widget>[];

    if (moreItems.length < 5) {
      for (final e in moreItems) {
        children.add(ListTile(
          leading: e.icon,
          title: Text(e.name, style: itemStyle),
          onTap: () {
            Navigator.of(context).pop();
            if (e.callback != null) e.callback!();
          },
        ));
        //children.add(const Divider());
      }
    } else {
      //
      for (var i = 0; i < moreItems.length; i += 2) {
        //
        final left = moreItems[i];
        final right = i + 1 < moreItems.length ? moreItems[i + 1] : null;

        children.add(
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ListTile(
                  leading: left.icon,
                  title: Text(left.name, style: itemStyle),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (left.callback != null) left.callback!();
                  },
                ),
              ),
              Container(width: 1, height: 18, color: Colors.black12),
              Expanded(
                flex: 1,
                child: right == null
                    ? const SizedBox()
                    : ListTile(
                        leading: right.icon,
                        title: Text(right.name, style: itemStyle),
                        onTap: () {
                          Navigator.of(context).pop();
                          if (right.callback != null) right.callback!();
                        },
                      ),
              ),
            ],
          ),
        );
        //children.add(const Divider());
      }
    }

    showGlassModalBottomSheet(
        context: context,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10),
              ...children,
              const SizedBox(height: 56),
            ],
          ),
        ));
  }

  List<Widget> attemptChildren() {
    //
    final buttons = <TextButton>[];

    for (final e in widget.items) {
      //
      final globalKey = GlobalKey();
      keys.add(globalKey);

      buttons.add(
        TextButton(
          key: globalKey,
          onPressed: null,
          child: Text(e.name, style: buttonStyle),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calculateWeightPosition(buttons);
      setState(() => finalLayout = true);
    });

    return buttons;
  }

  calculateWeightPosition(List<TextButton> buttons) {
    var left = 0.0;

    final containerWidth = containerKey.currentContext!.size!.width;

    for (var i = 0; i < buttons.length; i++) {
      if (i > 0) left = left + keys[i - 1].currentContext!.size!.width;
      if (left + keys[i].currentContext!.size!.width >= containerWidth) break;

      final e = widget.items[i];

      // buttons The buttons in will be Rebuild directly here
      finalChildren.add(TextButton(
        onPressed: e.callback,
        child: e.icon != null
            ? Column(
                children: [
                  e.icon!,
                  Text(e.name, style: buttonStyle),
                ],
              )
            : Text(e.name, style: buttonStyle),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: GameColors.boardBackground,
      ),
      //margin: EdgeInsets.symmetric(horizontal: boardPaddingH(context)),
      //padding: const EdgeInsets.symmetric(vertical: 2),
      //height: Ruler.kOperationBarHeight,
      child: Row(
        children: [
          Expanded(
            key: containerKey,
            child: Row(
              children: finalLayout ? finalChildren : attemptChildren(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: GameColors.primary),
            onPressed: showMore,
          ),
        ],
      ),
    );
  }
}
