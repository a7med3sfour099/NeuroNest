import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.backgroundImage, required this.text, required this.textCont, required this.color, required this.colorTextCont});

  final String backgroundImage;
  final String text;
  final String textCont;
  final Color color;
  final Color colorTextCont;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
        leading: Image.asset(
          backgroundImage,
          width: 46,
          height: 46,
        ),
        title: CustomText(
          text: text,
          size: 21,
          color: const Color(0xff000000),
          weight: FontWeight.w600,
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: CustomText(
            text: textCont,
            size: 16,
            color: colorTextCont,
            weight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
