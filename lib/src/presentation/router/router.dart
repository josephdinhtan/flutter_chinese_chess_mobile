import 'package:flutter/cupertino.dart';
import '../screens/battle_page_temp/edit_board_page/edit_board_page.dart';
import '../screens/battle_page_temp/analysis_page/analysis_page.dart';
import '../screens/settings_screen/settings_screen.dart';
import '../screens/settings_screen/sub_settings_screen/engine_params_page.dart';

enum GameScene {
  unknown,
  battle,
  editBoard,
  settings,
  settingsEngineParameter;
}

const _settingsScreen = SettingsScreen();

class JdtRouter {
  static Future<String?> navigateTo(
      {required BuildContext context,
      required GameScene scene,
      dynamic parameter}) async {
    Widget page;
    switch (scene) {
      case GameScene.battle:
        page = const AnalysisPage();
        break;

      case GameScene.settings:
        page = _settingsScreen;
        break;

      case GameScene.settingsEngineParameter:
        page = const EngineParamsPage();
        break;

      case GameScene.editBoard:
        page = EditBoardPage(fen: parameter);
        break;

      case GameScene.unknown:
        throw 'Scene is not define.';
    }

    return await Navigator.of(context).push<String>(
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
