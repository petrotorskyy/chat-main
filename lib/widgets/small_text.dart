import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;
  TextAlign? textAlign;

  SmallText({
    Key? key,
    this.color = const Color.fromARGB(255, 14, 13, 13),
    required this.text,
    this.size = 30,
    this.height = 1.2,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: 'Inter',
        height: height,
      ),
      textAlign: textAlign,
    );
  }
}
