import 'package:flutter/material.dart';

const _levelColor = [
  Color(0xFFCDAE4D),
  Color(0xFF859750),
  Color(0xFF6C9177),
  Color(0xFF71818B),
  Color(0xFF6C6D67),
  Color(0xFF9C6385),
  Color(0xFFC58251),
  Color(0xFF8C6E51),
  Color(0xFFAF6251),
];

class ChineseBookWidget extends StatelessWidget {
  const ChineseBookWidget(
      {super.key,
      this.bookTitle = "Bí Kíp Tàn Cuộc",
      this.footer = "0 / 300",
      this.iconData});

  final IconData? iconData;
  final String bookTitle;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bookWidth = constraints.maxWidth;
      final bookHeight = constraints.maxHeight;
      //final bookHeight = bookWidth * 8 / 6;
      return Container(
        width: bookWidth,
        height: bookHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: const Color(0xFF1E2D36),
        ),
        child: Stack(children: [
          ...buildBookSpine(
            bookHeight: bookHeight,
            bookWidth: bookWidth,
            spineTitle: '',
            color: Color.fromARGB(255, 26, 39, 47),
          ),
          Positioned(
              right: bookWidth / 20,
              child: SizedBox(
                  height: bookHeight,
                  child: buildBookTitle(
                      bookWidth: bookWidth,
                      bookHeight: bookHeight,
                      bookTitle: bookTitle,
                      footer: footer,
                      iconData: iconData))),
        ]),
      );
    });
  }

  Widget buildBookTitle({
    required double bookWidth,
    required double bookHeight,
    required String bookTitle,
    required String footer,
    IconData? iconData,
  }) {
    double titleBookHeight = bookHeight / 1.3;
    double titleBookWidth = bookWidth / 2.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: bookHeight / 20),
        Container(
          width: titleBookWidth,
          height: titleBookHeight,
          color: const Color(0xFFFEFBFF).withOpacity(0.7),
          child: Container(
            margin: const EdgeInsets.all(3),
            color: const Color(0xFFEADFD3),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (iconData != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Icon(iconData),
                ),
              ...bookTitle
                  .split(' ')
                  .map<Widget>(
                    (String chr) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        chr.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            letterSpacing:
                                2.0 // the white space between letter, default is 0.0
                            ),
                      ),
                    ),
                  )
                  .toList(),
            ]),
          ),
        ),
        Expanded(
            child: Center(
                child: Text(
          footer,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ))),
      ],
    );
  }

  List<Positioned> buildBookSpine({
    required double bookWidth,
    required double bookHeight,
    required String spineTitle,
    required Color color,
  }) {
    double spineWidth = bookWidth / 11;
    double thickness = 2;
    Color lineColor = Colors.white.withOpacity(0.7);
    return [
      Positioned(
        left: 0,
        child: Container(
            width: bookWidth / 3,
            height: bookHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: color.withOpacity(0.8),
            )),
      ),
      Positioned(
          left: spineWidth,
          child: Container(
            width: thickness,
            height: bookHeight,
            color: lineColor,
          )),
      Positioned(
          left: 0,
          top: bookHeight / 8,
          child: Container(
            width: spineWidth,
            height: thickness,
            color: lineColor,
          )),
      Positioned(
          left: 0,
          top: bookHeight / 8 * 3,
          child: Container(
            width: spineWidth,
            height: thickness,
            color: lineColor,
          )),
      Positioned(
          left: 0,
          top: bookHeight / 8 * 5,
          child: Container(
            width: spineWidth,
            height: thickness,
            color: lineColor,
          )),
      Positioned(
          left: 0,
          top: bookHeight / 8 * 7,
          child: Container(
            width: spineWidth,
            height: thickness,
            color: lineColor,
          )),
      Positioned(
          left: bookWidth / 8 + bookWidth / 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                spineTitle.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 8.0),
              ),
            ),
          )),
    ];
  }
}
