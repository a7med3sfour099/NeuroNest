import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.size,
    required this.color,
    required this.weight,
    this.textAlign, this.height,
  });

  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign? textAlign;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight, height: height),
      textAlign: textAlign,
    );
  }
}
