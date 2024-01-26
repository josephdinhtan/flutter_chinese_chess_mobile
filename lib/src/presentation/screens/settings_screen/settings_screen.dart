import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';

import '../../router/router.dart';
import 'local_db/user_settings_db.dart';
import 'sub_settings_screen/language_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/main_menu_background.jpg"),
              fit: BoxFit.cover)),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Settings'),
          ),
          body: SettingsList(
            platform: DevicePlatform.jdt,
            brightness: Brightness.dark,
            sections: [
              SettingsSection(
                textTitle: 'Language',
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: const Text('UI Language'),
                    value: const Text('English'),
                    onPressed: (context) {
                      showLanguageSelectBottomSheet(context);
                    },
                  ),
                ],
              ),
              SettingsSection(
                textTitle: 'Engine',
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: const Text('Parameter'),
                    value: const Text('Configuration'),
                    onPressed: (context) {
                      JdtRouter.navigateTo(
                          context: context,
                          scene: GameScene.settingsEngineParameter);
                    },
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      UserSettingsDb().thinkingArrowEnabled = value;
                      setState(() {});
                    },
                    title: const Text('Engine thinking arrow'),
                    initialValue: UserSettingsDb().thinkingArrowEnabled,
                  ),
                ],
              ),
              SettingsSection(
                textTitle: 'Sound',
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    title: Text('Background music'),
                    initialValue: null,
                    onToggle: (bool value) {},
                  ),
                  SettingsTile.switchTile(
                    title: Text('Sound effect'),
                    initialValue: true,
                    onToggle: (bool value) {},
                  ),
                ],
              ),
              SettingsSection(
                textTitle: 'Chess board',
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: const Text('Board material'),
                    value: const Text("Wooden"),
                    onPressed: (context) {},
                  ),
                  SettingsTile.navigation(
                    title: const Text('Chess piece material'),
                    value: const Text("Wooden"),
                    onPressed: (context) {},
                  ),
                ],
              ),
              SettingsSection(
                textTitle: 'About',
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: const Text('More game'),
                    onPressed: (context) {},
                  ),
                  SettingsTile.navigation(
                    title: const Text('Privacy Policy'),
                    onPressed: (context) {},
                  ),
                  SettingsTile.navigation(
                    title: const Text('Contact to us'),
                    onPressed: (context) {},
                  ),
                  SettingsTile(
                    title: const Text("Version"),
                    value: const Text("1.0.1"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
