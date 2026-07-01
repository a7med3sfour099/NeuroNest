import 'package:neuronest/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:neuronest/features/assessmentQues/providers/question_provider.dart';

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
    
    // Listen to the provider to keep the title translated, but we removed the switcher menu
    final provider = context.watch<QuestionProvider>();
    final bool isAr = provider.currentLanguage == 'ar';

    return AppBar(
      leading: IconButton(
        iconSize: 33,
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isAr
                  ? 'سؤال $currentQuestion من $totalQuestions'
                  : 'Question $currentQuestion of $totalQuestions',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
            ),
            const Gap(12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
      
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}