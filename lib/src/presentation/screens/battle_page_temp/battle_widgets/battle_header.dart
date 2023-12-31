import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../settings_screen/settings_screen.dart';
import '../state_controllers/game.dart';

class BattleHeader extends StatelessWidget {
  const BattleHeader(
      {super.key, required this.title, this.showSettingsIcon = true});
  final String title;
  final bool showSettingsIcon;

  final itemsColor = GameColors.primary;

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: itemsColor,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );

    final settingButton = IconButton(
      icon: Icon(
        Icons.settings,
        color: itemsColor,
      ),
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      ),
    );

    return Row(
      children: <Widget>[
        backButton,
        const Expanded(child: SizedBox()),
        Text(
          title.toUpperCase(),
          style: GameFonts.art(
            fontSize: 28,
            color: itemsColor,
          ),
        ),
        const Expanded(child: SizedBox()),
        showSettingsIcon ? settingButton : const SizedBox(),
      ],
    );
  }
}
