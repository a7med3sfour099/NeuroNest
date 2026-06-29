import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartQuesView extends StatefulWidget {
  const StartQuesView({super.key});

  @override
  State<StartQuesView> createState() => _StartQuesViewState();
}

class _StartQuesViewState extends State<StartQuesView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 198.0,
              horizontal: 15.0,
            ),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/ques/ques_view.png',
                    width: 216,
                    height: 216,
                  ),
                ),
                Gap(32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      CustomText(
                        text: 'Let\'s get started',
                        size: 23,
                        color: AppColors.textPrimary,
                        weight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                      Gap(3),
                      CustomText(
                        text:
                            'Answer a few questions to help us understand your child better',
                        size: 20,
                        color: AppColors.textTertiary,
                        weight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                      Gap(32),
                      CustomElevatedbutton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/quesboard');
                        },
                        text: 'Start Assessment',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
