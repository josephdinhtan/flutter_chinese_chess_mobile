import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'operation_button_sheet.dart';

class ActionItem {
  final String name;
  final VoidCallback? callback;
  ActionItem({required this.name, this.callback});
}

class OperationBar extends StatefulWidget {
  const OperationBar(
      {super.key, required this.barBackgroundColor, required this.iconColor});

  final Color barBackgroundColor;
  final Color iconColor;

  @override
  State<OperationBar> createState() => _OperationBarState();
}

class _OperationBarState extends State<OperationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.barBackgroundColor,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: "Lùi",
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            tooltip: "Tiến",
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_2_circlepath),
            tooltip: "Đổi chiều bàn cờ",
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Sửa bàn cờ",
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            tooltip: "Open draw",
            onPressed: () {
              //Scaffold.of(context).openDrawer();
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return OperationButtonSheet(
                      backgroundColor: widget.barBackgroundColor,
                      iconColor: widget.iconColor);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
