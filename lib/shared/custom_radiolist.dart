import 'package:graduationproject/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomRadioList extends StatelessWidget {
  const CustomRadioList({
    super.key,
    required this.text,
    required this.val,
    this.groupValue,
    this.onChanged,
  });

  final String text;
  final String val;
  final String? groupValue;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = val == groupValue;
    return RadioListTile(
      groupValue: groupValue,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xff9D9D9D).withOpacity(0.4), width: 1),
      ),
      activeColor: Color(0xff5DB7DE).withOpacity(0.6),
      selectedTileColor: const Color(0xff5DB7DE).withOpacity(0.6),
      selected: isSelected,
      title: CustomText(
        text: text,
        size: 31,
        color: Color(0xff000000),
        weight: FontWeight.w500,
      ),
      value: val,
    );
  }
}
