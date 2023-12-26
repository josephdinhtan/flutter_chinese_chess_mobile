import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';

import '../local_db/engine_settings_db.dart';
import '../widgets/spinner_list_tile.dart';

class EngineParamsPage extends StatefulWidget {
  const EngineParamsPage({super.key});

  @override
  State<EngineParamsPage> createState() => _EngineParamsPageState();
}

class _EngineParamsPageState extends State<EngineParamsPage> {
  void reloadUi() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Engine parameters"),
      ),
      body: SettingsList(platform: DevicePlatform.jdt, sections: [
        SettingsSection(textTitle: 'PikaFish', tiles: <SettingsTile>[
          SettingsTile(
            title: const Text("Thinking time"),
            value: SpinnerListTile(
              unit: "Second",
              initValue: EngineConfigDb().engineConfigTimeLimit,
              reduce: () {
                EngineConfigDb().timeLimitReduce();
                reloadUi();
              },
              plus: () {
                EngineConfigDb().timeLimitPlus();
                reloadUi();
              },
            ),
          ),
          SettingsTile(
            title: const Text("Difficulty level"),
            value: SpinnerListTile(
              unit: "Class",
              initValue: EngineConfigDb().engineConfigLevel,
              reduce: () {
                EngineConfigDb().levelReduce();
                reloadUi();
              },
              plus: () {
                EngineConfigDb().levelPlus();
                reloadUi();
              },
            ),
          ),
          SettingsTile(
            title: const Text("Threads"),
            value: SpinnerListTile(
              unit: "Thread",
              initValue: EngineConfigDb().engineConfigThreads,
              reduce: () {
                EngineConfigDb().threadsReduce();
                reloadUi();
              },
              plus: () {
                EngineConfigDb().threadsPlus();
                reloadUi();
              },
            ),
          ),
          SettingsTile(
            title: const Text("Hash size"),
            value: SpinnerListTile(
              unit: "MB",
              initValue: EngineConfigDb().engineConfigHashSize,
              reduce: () {
                EngineConfigDb().hashSizeReduce();
                reloadUi();
              },
              plus: () {
                EngineConfigDb().hashSizePlus();
                reloadUi();
              },
            ),
          ),
        ])
      ]),
    );
  }
}
