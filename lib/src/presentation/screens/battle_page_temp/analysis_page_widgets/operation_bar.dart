import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';

class OperatorItem {
  final String name;
  final IconData? iconData;
  final Function()? onPressed;
  OperatorItem({required this.name, this.iconData, this.onPressed});
}

class OperationBar extends StatefulWidget {
  final List<OperatorItem> items;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const OperationBar({
    Key? key,
    required this.items,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.grey,
    this.iconColor = Colors.grey,
  }) : super(key: key);

  @override
  State<OperationBar> createState() => _OperationBarState();
}

class _OperationBarState extends State<OperationBar> {
  final keys = <GlobalKey>[];
  final GlobalKey containerKey = GlobalKey();

  late final TextStyle buttonStyle;
  final finalChildren = <Widget>[];

  bool finalLayout = false;
  @override
  void initState() {
    buttonStyle = TextStyle(fontSize: 16, color: widget.textColor);
    super.initState();
  }

  void showMore() {
    if (finalChildren.length == widget.items.length) return;
    final itemStyle = TextStyle(fontSize: 18, color: widget.textColor);
    final moreItems = widget.items.sublist(finalChildren.length);

    final children = <Widget>[];

    if (moreItems.length < 5) {
      for (final e in moreItems) {
        children.add(ListTile(
          leading: Icon(e.iconData, color: widget.iconColor),
          title: Text(e.name, style: itemStyle),
          onTap: () {
            Navigator.of(context).pop();
            if (e.onPressed != null) e.onPressed!();
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
                  leading: Icon(left.iconData, color: widget.iconColor),
                  title: Text(left.name, style: itemStyle),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (left.onPressed != null) left.onPressed!();
                  },
                ),
              ),
              Container(width: 1, height: 18, color: Colors.black12),
              Expanded(
                flex: 1,
                child: right == null
                    ? const SizedBox()
                    : ListTile(
                        leading: Icon(right.iconData, color: widget.iconColor),
                        title: Text(right.name, style: itemStyle),
                        onTap: () {
                          Navigator.of(context).pop();
                          if (right.onPressed != null) right.onPressed!();
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
        backgroundOpacity: 1.0,
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
        onPressed: e.onPressed,
        child: e.iconData != null
            ? Column(
                children: [
                  Icon(e.iconData, color: widget.iconColor),
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
        color: widget.backgroundColor,
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
            icon: Icon(Icons.menu_rounded, color: widget.iconColor),
            onPressed: showMore,
          ),
        ],
      ),
    );
  }
}
