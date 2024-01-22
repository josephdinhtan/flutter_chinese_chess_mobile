import 'package:flutter/material.dart';

import '../../widgets/chinese_book_widget.dart';

class BookMenWidget extends StatelessWidget {
  const BookMenWidget(
      {super.key,
      this.bookTitle = "Bí Kíp Tàn Cuộc",
      this.footer = "0 / 300",
      this.iconData,
      required this.onPressed});

  final String bookTitle;
  final String footer;
  final IconData? iconData;

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 6,
        child: ChineseBookWidget(
          bookTitle: bookTitle,
          footer: footer,
          iconData: iconData,
        ),
      ),
    );
  }
}
