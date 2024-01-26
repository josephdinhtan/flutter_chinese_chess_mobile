import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../settings_screen/settings_screen.dart';
import '../state_controllers/game.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.iconData,
    this.showSettingsIcon = true,
    this.titleColor = GameColors.primary,
    this.iconColor = const Color(0xFFA82E28),
    this.fontSize = 20.0,
    this.svgIconPath,
    this.removeBackIcon = false,
  });
  final String title;
  final IconData? iconData;
  final String? svgIconPath;
  final bool showSettingsIcon;
  final Color titleColor;
  final Color iconColor;
  final double fontSize;
  final bool removeBackIcon;

  @override
  Widget build(BuildContext context) {
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

    return Card(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          getBackIcon(context, removeBackIcon),
          const Expanded(child: SizedBox()),
          getIcon(iconData),
          getSvgIcon(svgIconPath),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          const Expanded(child: SizedBox()),
          showSettingsIcon ? settingButton : const SizedBox(),
        ],
      ),
    );
  }

  Widget getBackIcon(BuildContext context, bool removeBackIcon) {
    final backButton = IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: removeBackIcon ? Colors.transparent : titleColor,
        ),
        onPressed: () {
          if (!removeBackIcon) Navigator.of(context).pop();
        });
    return backButton;
  }

  Widget getSvgIcon(String? svgIconPath) {
    if (svgIconPath == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: SvgPicture.asset(height: 30.0, svgIconPath),
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
