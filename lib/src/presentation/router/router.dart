import 'package:flutter/cupertino.dart';
import 'package:flutter_chinese_chess_ai_mobile/src/presentation/screens/battle_screens/battle_screen.dart';
import 'package:provider/provider.dart';
import '../screens/settings_screen/settings_screen.dart';
import '../screens/settings_screen/sub_settings_screen/engine_params_page.dart';
import '../widgets/game/board_state.dart';

enum GameScene {
  unknown,
  battle,
  settings,
  settingsEngineParameter;
}

const _settingsScreen = SettingsScreen();

class JdtRouter {
  static void navigateTo(
      {required BuildContext context, required GameScene scene}) async {
    Widget page;
    switch (scene) {
      case GameScene.battle:
        page = MultiProvider(providers: [
          ChangeNotifierProvider<BoardState>(create: (_) => BoardState()),
        ], child: const BattleScreen());
        break;

      case GameScene.settings:
        page = _settingsScreen;
        break;

      case GameScene.settingsEngineParameter:
        page = EngineParamsPage();
        break;

      case GameScene.unknown:
        throw 'Scene is not define.';
    }

    await Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
