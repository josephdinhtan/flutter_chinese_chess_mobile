import 'package:flutter/material.dart';
import 'package:jdt_ui/jdt_ui.dart';

import '../widgets/spinner_list_tile.dart';

class EngineParamsPage extends StatefulWidget {
  const EngineParamsPage({super.key});

  @override
  State<EngineParamsPage> createState() => _EngineParamsPageState();
}

class _EngineParamsPageState extends State<EngineParamsPage> {
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
              initValue: 1,
              reduce: () {},
              plus: () {},
            ),
          ),
          SettingsTile(
            title: const Text("Difficulty level"),
            value: SpinnerListTile(
              unit: "Class",
              initValue: 1,
              reduce: () {},
              plus: () {},
            ),
          ),
          SettingsTile(
            title: const Text("Threads"),
            value: SpinnerListTile(
              unit: "Thread",
              initValue: 1,
              reduce: () {},
              plus: () {},
            ),
          ),
          SettingsTile(
            title: const Text("Hash size"),
            value: SpinnerListTile(
              unit: "MB",
              initValue: 1,
              reduce: () {},
              plus: () {},
            ),
          ),
        ])
      ]),
    );
  }
}
