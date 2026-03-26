import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomElevatedbutton extends StatelessWidget {
  const CustomElevatedbutton({super.key, required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color(0xff5DB7DE),
        minimumSize: Size(double.infinity, 50),
        // padding: EdgeInsets.symmetric(horizontal: 100, vertical: 6),
      ),
      onPressed: onPressed,
      child: CustomText(
        text: text,
        size: 23,
        color: Colors.white,
        weight: FontWeight.w500,
        textAlign: TextAlign.center,
      ),
    );
  }
}
