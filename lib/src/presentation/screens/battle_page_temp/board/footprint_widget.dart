import 'package:flutter/material.dart';

class FootprintWidget extends StatelessWidget {
  //
  final double size;

  const FootprintWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: size / 1.7,
          height: size / 1.7,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              width: size / 30,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          child: Center(
            child: Container(
              width: size / 3.5,
              height: size / 3.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
