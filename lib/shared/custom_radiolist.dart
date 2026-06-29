import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomRadioList extends StatelessWidget {
  const CustomRadioList({
    super.key,
    required this.text,
    required this.val,
    this.groupValue,
    this.onChanged,
    this.fontSize = 23,
  });

  final String text;
  final String val;
  final String? groupValue;
  final ValueChanged<String?>? onChanged;
  final double? fontSize;

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
      // activeColor: Color(0xff5DB7DE).withOpacity(0.6),
      activeColor: Colors.white,
      selectedTileColor: const Color(0xff5DB7DE).withOpacity(0.6),
      selected: isSelected,
      title: CustomText(
        text: text,
        size: fontSize ?? 23,
        color: isSelected ? Colors.white : AppColors.textPrimary,
        weight: FontWeight.w500,
      ),
      value: val,
    );
  }
}
