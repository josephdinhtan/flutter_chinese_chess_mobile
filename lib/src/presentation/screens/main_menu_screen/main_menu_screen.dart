import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/colors/game_colors.dart';
import '../../config/styles/game_fonts.dart';
import '../../router/router.dart';
import 'book_menu_widget.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.menuBackground,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/main_menu_background.jpg"),
                fit: BoxFit.cover)),
        // // color: Colors.brown[900],
        child: buildActionControls(context),
      ),
    );
  }

  Widget buildActionControls(BuildContext context) {
    //
    final menuItemStyle = GameFonts.art(
      fontSize: 28,
      color: GameColors.primary,
    );

    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Cờ Thẩm',
          style: menuItemStyle,
        ),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 6 / 8,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            children: [
              BookMenWidget(
                bookTitle: "Phân tích",
                onPressed: () => JdtRouter.navigateTo(
                    context: context, scene: GameScene.battle),
              ),
              BookMenWidget(
                bookTitle: "Xếp cờ",
                onPressed: () => JdtRouter.navigateTo(
                    context: context, scene: GameScene.editBoard),
              ),
              BookMenWidget(
                bookTitle: "Trung cuộc",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Tính năng sẽ được thêm sớm',
                          style: GameFonts.uicp()),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              BookMenWidget(
                bookTitle: "Tàn Cuộc",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Tính năng sẽ được thêm sớm',
                          style: GameFonts.uicp()),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              BookMenWidget(
                bookTitle: "Hình Đã lưu",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Tính năng sẽ được thêm sớm',
                          style: GameFonts.uicp()),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              BookMenWidget(
                bookTitle: "Cài đặt",
                onPressed: () => JdtRouter.navigateTo(
                    context: context, scene: GameScene.settings),
                iconData: CupertinoIcons.settings,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
