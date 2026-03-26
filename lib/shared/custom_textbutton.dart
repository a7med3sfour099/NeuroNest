import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.color,
    required this.size,
    required this.weight,
    this.onPressed,
  });

  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: CustomText(text: text, size: size, color: color, weight: weight),
    );
  }
}
