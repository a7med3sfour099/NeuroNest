import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/shared/custom_elevatedbutton.dart';
import 'package:firstversion1/shared/custom_text.dart';
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
        backgroundColor: AppColors.primary,
        body: Padding(
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
                      color: Color(0xff000000),
                      weight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    Gap(3),
                    CustomText(
                      text:
                          'Answer a few questions to help us understand your child better',
                      size: 20,
                      color: Color(0xff6c6969),
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
    );
  }
}
