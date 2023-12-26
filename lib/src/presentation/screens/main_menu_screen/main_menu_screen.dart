import 'package:flutter/material.dart';

import '../../config/colors/game_colors.dart';
import '../../config/styles/game_fonts.dart';
import '../../router/router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.menuBackground,
      body: buildActionControls(context),
    );
  }

  Widget buildActionControls(BuildContext context) {
    //
    final menuItemStyle = GameFonts.art(
      fontSize: 28,
      color: GameColors.primary,
    );

    return Center(
      child: Column(
        children: [
          const Expanded(flex: 40, child: SizedBox()),
          TextButton(
            child: Text(
              'Thẩm cờ',
              style: menuItemStyle,
            ),
            onPressed: () =>
                JdtRouter.navigateTo(context: context, scene: GameScene.battle),
          ),
          const Expanded(child: SizedBox()),
          TextButton(
            child: Text(
              'Kỳ phổ (trung cục, tàn cục, ván đã lưu)',
              style: menuItemStyle,
            ),
            onPressed: () =>
                JdtRouter.navigateTo(context: context, scene: GameScene.battle),
          ),
          const Expanded(child: SizedBox()),
          TextButton(
            //onPressed: () => showReadme(context),
            onPressed: () => JdtRouter.navigateTo(
                context: context, scene: GameScene.editBoard),
            child: Text('Xếp cờ', style: menuItemStyle),
          ),
          const Expanded(child: SizedBox()),
          TextButton(
            child: Text(
              'Settings',
              style: menuItemStyle,
            ),
            onPressed: () => JdtRouter.navigateTo(
                context: context, scene: GameScene.settings),
          ),
          const Expanded(flex: 40, child: SizedBox()),
        ],
      ),
    );
  }
}
