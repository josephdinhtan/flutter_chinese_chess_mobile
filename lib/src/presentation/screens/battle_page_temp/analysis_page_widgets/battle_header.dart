import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../settings_screen/settings_screen.dart';
import '../state_controllers/game.dart';

class BattleHeader extends StatelessWidget {
  const BattleHeader({
    super.key,
    required this.title,
    this.iconData,
    this.showSettingsIcon = true,
    this.titleColor = GameColors.primary,
    this.iconColor = const Color(0xFFA82E28),
    this.fontSize = 24.0,
  });
  final String title;
  final IconData? iconData;
  final bool showSettingsIcon;
  final Color titleColor;
  final Color iconColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: titleColor,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );

    final settingButton = IconButton(
      icon: Icon(
        Icons.settings,
        color: titleColor,
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
        getIcon(iconData),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const Expanded(child: SizedBox()),
        showSettingsIcon ? settingButton : const SizedBox(),
      ],
    );
  }

  Widget getIcon(IconData? iconData) {
    if (iconData == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        iconData,
        color: iconColor,
        size: fontSize * 1.5,
      ),
    );
  }
}
