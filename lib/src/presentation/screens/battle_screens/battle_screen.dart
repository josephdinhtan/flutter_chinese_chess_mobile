import 'package:flutter/material.dart';

import '../../config/colors/game_colors.dart';
import 'battle_widgets/operation_bar/operation_bar.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GameColors.battleBackground,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: GameColors.battleBackground,
          body: Column(
            children: [
              Text("Score: 1023 (đỏ ưu)"),
              SizedBox(
                height: 400,
                child: Center(child: Text("Board")),
              ),
              OperationBar(
                  barBackgroundColor: GameColors.operationBarBackground,
                  iconColor: GameColors.iconColor),
              const Expanded(child: Center(child: Text("comment"))),
            ],
          ),
        ),
      ),
    );
  }
}
