import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/extensions/string_extensions.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.onPressed,
    this.leadingImagePath,
    this.title = "Title",
    this.subTitle = "Subtitle",
    this.svgIconPath,
  });
  final Function() onPressed;
  final String title;
  final String subTitle;
  final String? leadingImagePath;
  final String? svgIconPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 18.0),
            if (leadingImagePath != null)
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(50), // Image radius
                    child: Image.asset(
                      leadingImagePath!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 18.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFFBF4),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subTitle.capitalize,
                  style: const TextStyle(
                    color: Color(0xFFC5B8B2),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4.0),
                if (svgIconPath != null)
                  SvgPicture.asset(height: 30.0, svgIconPath!),
              ],
            )
          ],
        ),
      ),
    );
  }
}
