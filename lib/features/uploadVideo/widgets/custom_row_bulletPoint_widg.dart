import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomRowBulletPoint extends StatelessWidget {
  String text;
  CustomRowBulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 12),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Color(0xff000000),
            shape: BoxShape.circle,
          ),
        ),
        Gap(8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
