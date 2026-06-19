import 'package:neuronest/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback? onBackPressed;

  const QuesAppBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentQuestion / totalQuestions;

    return AppBar(
      leading: IconButton(
        iconSize: 33,
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Question $currentQuestion of $totalQuestions',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
            ),
            Gap(12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65); // Adjust the height as needed for the appbar
}
