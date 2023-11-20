import 'package:flutter/material.dart';

import '../../../../router/router.dart';
import 'drop_down_menu.dart';

enum _Team { red, black }

class OperationButtonSheet extends StatefulWidget {
  OperationButtonSheet(
      {super.key, required this.backgroundColor, required this.iconColor});

  final Color backgroundColor;
  final Color iconColor;

  @override
  State<OperationButtonSheet> createState() => _OperationButtonSheetState();
}

class _OperationButtonSheetState extends State<OperationButtonSheet> {
  // final GameManager _gamer = GameManager.instance;
  // GameSetting? _settings;

  @override
  void initState() {
    super.initState();
    // GameSetting.getInstance().then(
    //   (value) => setState(() {
    //     _settings = value;
    //   }),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return gameDrawer(context);
  }

  Widget gameDrawer(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.settings, color: widget.iconColor),
              title: Text("Cài đặt"),
              onTap: () {
                JdtRouter.pop(context);
                JdtRouter.navigateTo(
                    context: context, scene: GameScene.settings);
              },
            ),
            ListTile(
              leading: Icon(Icons.output_outlined, color: widget.iconColor),
              title: const Text("Ra ngoài"),
              onTap: () {
                JdtRouter.pop(context);
                JdtRouter.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add, color: widget.iconColor),
              title: const Text("Trận đấu mới"),
              onTap: () {
                JdtRouter.pop(context);
                // setState(() {
                //   _gamer.newGame();
                //   //mode = null;
                // });
              },
            ),
            Divider(color: Colors.grey.withOpacity(0.5)),
            ListTile(
              leading: Icon(Icons.description, color: widget.iconColor),
              title: Text("Nhập ván đấu"),
              onTap: () {
                loadFile();
              },
            ),
            ListTile(
              leading: Icon(Icons.save, color: widget.iconColor),
              title: Text("Lưu lại ván đấu"),
              onTap: () {
                JdtRouter.pop(context);
                saveManual();
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: widget.iconColor),
              title: Text("Chép FEN"),
              onTap: () {
                JdtRouter.pop(context);
                copyFen();
              },
            ),
            ListTile(
              leading: Icon(Icons.input, color: widget.iconColor),
              title: Text("Dán FEN"),
              onTap: () {
                JdtRouter.pop(context);
                //copyFen();
                // _gamer.newGame(
                //     "2r1kab2/4a1c2/1c2b1n2/p3NR2p/2p1P4/2P6/P5p1P/1CN1C4/7r1/R1BAKAB2 w - - 1 14");
              },
            ),
            Divider(color: Colors.grey.withOpacity(0.5)),
            ListTile(
              leading: Icon(Icons.filter_center_focus_outlined,
                  color: widget.iconColor),
              title: Row(
                children: [
                  const Text('Đi tiên'),
                  const SizedBox(width: 8.0),
                  DropDownMenu(
                    initValue: "Đỏ",
                    listItem: const ["Đỏ", "Đen"],
                    onChange: (value) {
                      //_settings?.numberOfArrow = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.withOpacity(0.5)),
            ListTile(
              leading:
                  Icon(Icons.arrow_right_alt_outlined, color: widget.iconColor),
              title: Row(
                children: [
                  const Text('Hiện mũi tên'),
                  const SizedBox(width: 8.0),
                  DropDownMenu(
                    initValue: "2",
                    listItem: const ["2", "4", "6", "8", "10"],
                    onChange: (value) {
                      //_settings?.numberOfArrow = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.stream_outlined, color: widget.iconColor),
              title: Row(
                children: [
                  const Text('Độ sâu AI'),
                  const SizedBox(width: 8.0),
                  DropDownMenu(
                    initValue: "5",
                    listItem: ["5", "10", "15", "20", "25", "30"],
                    onChange: (value) {
                      //_settings?.robotLevel = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void copyFen() {
    //Clipboard.setData(ClipboardData(text: _gamer.fenStr));
    //MyDialog.of(context).alert("S.of(context).copy_success");
  }

  Future<void> saveManual() async {
    // String content = _gamer.manual.export();
    // String filename = '${DateTime.now().millisecondsSinceEpoch ~/ 1000}.pgn';
    // if (kIsWeb) {
    //   await _saveManualWeb(content, filename);
    // } else if (Platform.isAndroid || Platform.isIOS || Platform.isWindows) {
    //   await _saveManualNative(content, filename);
    // }
  }

  Future<void> _saveManualNative(String content, String filename) async {
    // final result = await FilePicker.platform.saveFile(
    //   dialogTitle: 'Save pgn file',
    //   fileName: filename,
    //   allowedExtensions: ['pgn'],
    // );
    // if (result != null) {
    //   List<int> fData = gbk.encode(content);
    //   if (Platform.isWindows)
    //     await File('$result').writeAsBytes(fData);
    //   else
    //     await File('$result/$filename').writeAsBytes(fData);
    //   MyDialog.of(context).toast("S.of(context).save_success");
    // }
  }

  Future<void> _saveManualWeb(String content, String filename) async {
    // List<int> fData = gbk.encode(content);
    // var link = html.window.document.createElement('a');
    // link.setAttribute('download', filename);
    // link.style.display = 'none';
    // link.setAttribute('href', Uri.dataFromBytes(fData).toString());
    // html.window.document.getElementsByTagName('body')[0].append(link);
    // link.click();
    // await Future<void>.delayed(const Duration(seconds: 10));
    // link.remove();
  }

  Future<void> loadFile() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pgn', 'PGN'],
    //   withData: true,
    // );

    // if (result != null && result.count == 1) {
    //   String content = gbk.decode(result.files.single.bytes!);
    //   if (_gamer.isStop) {
    //     _gamer.newGame();
    //   }
    //   _gamer.loadPGN(content);
    // } else {
    //   // User canceled the picker
    // }
  }
}
