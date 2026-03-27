import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomCard extends StatelessWidget {
  final Color shapeColor;
  final String image;
  final String text;
  final String subText;
  final Color bColor;
  final String bText;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.shapeColor,
    required this.image,
    required this.text,
    required this.subText,
    required this.bColor,
    required this.bText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      width: 319,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xff000000).withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: shapeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 105,
                vertical: 10,
              ),
              child: Image.asset(
                image,
                width: 81,
                height: 81,
                fit: BoxFit.cover,
              ),
            ),
            const Gap(8),
            CustomText(
              text: text,
              size: 22,
              color: const Color(0xff1E1E1E),
              weight: FontWeight.w700,
            ),
            Gap(4),
            CustomText(
              text: subText,
              size: 16,
              color: const Color(0xff6C6969),
              weight: FontWeight.w400,
            ),
            const Gap(5),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 227,
                height: 37,
                decoration: BoxDecoration(
                  color: bColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: CustomText(
                    text: bText,
                    size: 18,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
