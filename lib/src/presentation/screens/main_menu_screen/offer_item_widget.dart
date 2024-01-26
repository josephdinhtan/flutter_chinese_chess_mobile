import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/extensions/string_extensions.dart';

class OfferItemWidget extends StatelessWidget {
  const OfferItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
          color: const Color(0xFF4193C3),
          borderRadius: BorderRadius.circular(8.0)),
      child: Row(children: [
        const SizedBox(width: 16.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(height: 40.0, "assets/images/diamond.svg"),
        ),
        const SizedBox(width: 16.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Try premium".hardCode,
              style: const TextStyle(
                color: Color(0xFFFFFBF4),
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Không giới hạn nước đi, quảng cáo".hardCode,
              style: const TextStyle(
                color: Color(0xFFFFFBF4),
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        )
      ]),
    );
  }
}
