import 'package:neuronest/shared/custom_text.dart';
import 'package:neuronest/shared/custom_textbutton.dart';
import 'package:flutter/material.dart';

class CustomRowButton extends StatelessWidget {
  const CustomRowButton({
    super.key,
    required this.text,
    required this.sizedText,
    required this.textButton,
    this.onPressed,
  });

  final String text;
  final double sizedText;
  final String textButton;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: text,
          size: sizedText,
          color: Color(0xff000000),
          weight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
        CustomTextButton(
          onPressed: onPressed,
          text: textButton,
          color: Color(0xff5DB7DE),
          size: sizedText,
          weight: FontWeight.w600,
        ),
      ],
    );
  }
}
