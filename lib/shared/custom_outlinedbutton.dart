import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    this.backgroundImage,
    required this.text, this.onPressed,
  });

  final String? backgroundImage;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: Color(0xffD9D9D9)),
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (backgroundImage != null) ...[
            Image.asset(
              backgroundImage!,
              width: 31.5,
              height: 32.14,
              fit: BoxFit.cover,
            ),
          ],
          Gap(5),
          CustomText(
            text: text,
            size: 23,
            color: Color(0xff000000),
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
