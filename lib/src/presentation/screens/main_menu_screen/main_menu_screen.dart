import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'menu_item.dart';
import 'offer_item_widget.dart';
import '../../../utils/extensions/string_extensions.dart';

import '../../config/styles/game_fonts.dart';
import '../../router/router.dart';
import '../battle_page_temp/analysis_page_widgets/page_header.dart';
import 'book_menu_widget.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/main_menu_background.jpg"),
              fit: BoxFit.cover)),
      // // color: Colors.brown[900],
      child: buildActionControls(context),
    );
  }

  Widget buildActionControls(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(height: 16),
            PageHeader(
              title: "Cờ Thẩm".capitalize.hardCode,
              titleColor: Colors.white,
              svgIconPath: "assets/images/house-search.svg",
              removeBackIcon: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Column(
                  children: [
                    const OfferItemWidget(),
                    MenuItem(
                      title: "Thẩm Cờ",
                      subTitle: "Thẩm ván đấu",
                      leadingImagePath: "assets/images/menu_01.png",
                      onPressed: () => JdtRouter.navigateTo(
                          context: context, scene: GameScene.battle),
                      svgIconPath: "assets/images/searching_robo.svg",
                    ),
                    const SizedBox(height: 8.0),
                    MenuItem(
                      title: "Xếp Quân",
                      subTitle: "Tự tạo thế quân và phân tích",
                      leadingImagePath: "assets/images/menu_03.png",
                      svgIconPath: "assets/images/aim.svg",
                      onPressed: () => JdtRouter.navigateTo(
                          context: context, scene: GameScene.editBoard),
                    ),
                    const SizedBox(height: 8.0),
                    MenuItem(
                      title: "Kỳ Phổ",
                      subTitle: "Trung cục, Tàn cục",
                      leadingImagePath: "assets/images/menu_02.png",
                      svgIconPath: "assets/images/agenda.svg",
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
                    const SizedBox(height: 8.0),
                    MenuItem(
                      title: "Lưu Trữ",
                      subTitle: "Ván cờ, hình cờ đã lưu".capitalize,
                      leadingImagePath: "assets/images/menu_04.png",
                      svgIconPath: "assets/images/like.svg",
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
                  ],
                ),
              ),
            ),
            if (false)
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
        ),
      ),
    );
  }
}
