import 'package:flutter/material.dart';

class TextOutlined extends StatelessWidget {
  final String primary;
  final String secondary;
  final double sizeFont;
  final Color textColor;
  const TextOutlined(
      {super.key,
      required this.primary,
      required this.secondary,
      required this.sizeFont,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          primary,
          style: TextStyle(
            fontFamily: 'Super Boys',
            fontSize: sizeFont,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Colors.black,
          ),
        ),
        Text(
          secondary,
          style: TextStyle(
            fontFamily: 'Super Boys',
            letterSpacing: 4.0,
            fontSize: sizeFont,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
