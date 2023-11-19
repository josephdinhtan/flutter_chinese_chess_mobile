import 'package:flutter/material.dart';

import '../config/colors/game_colors.dart';
import '../config/styles/game_fonts.dart';
import '../router/router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.menuBackground,
      body: Center(
        child: buildActionControls(context),
      ),
    );
  }

  Widget buildActionControls(BuildContext context) {
    //
    final menuItemStyle = GameFonts.art(
      fontSize: 28,
      color: GameColors.primary,
    );

    return Expanded(
      flex: 4,
      child: Column(
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          TextButton(
            child: Text(
              'Man-machine exercise',
              style: menuItemStyle,
            ),
            onPressed: () =>
                JdtRouter.navigateTo(context: context, scene: GameScene.battle),
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
          const Expanded(child: SizedBox()),
          TextButton(
            //onPressed: () => showReadme(context),
            onPressed: () {},
            child: Text('Release Notes', style: menuItemStyle),
          ),
          const Expanded(flex: 4, child: SizedBox()),
        ],
      ),
    );
  }
}
