import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuronest/shared/custom_text.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? width;

  const CustomContainer({super.key, required this.title, required this.subtitle, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 123,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: title,
            size: 23,
            color: const Color(0xff1E1E1E),
            weight: FontWeight.w700,
          ),
          const Gap(6),
          CustomText(
            textAlign: TextAlign.center,
            text: subtitle,
            size: 18,
            color: const Color(0xff6C6969),
            weight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
