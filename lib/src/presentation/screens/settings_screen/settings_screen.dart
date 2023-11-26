import 'package:flutter/material.dart';
import 'package:flutter_chinese_chess_ai_mobile/src/presentation/router/router.dart';
import 'package:jdt_ui/jdt_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Stack(
        children: [
          SettingsList(
            platform: DevicePlatform.jdt,
            sections: [
              SettingsSection(
                textTitle: 'Engine',
                tiles: <SettingsTile>[
                  SettingsTile(
                    title: const Text("Current device time zone"),
                    value: const Text("GMT+7"),
                    trailing: const Text("trailing"),
                  ),
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
                    onToggle: (value) {},
                    title: const Text('Engine thinking arrow'),
                    initialValue: null,
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
