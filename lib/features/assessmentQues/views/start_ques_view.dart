import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/Home/providers/child_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/screening_provider.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

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
                        onPressed: () async {
                          final child = context
                              .read<ChildProvider>()
                              .currentChild;

                          print("CURRENT CHILD => ${child?.childID}");

                          if (child == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("No child selected"),
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            return;
                          }

                          final screeningProvider = context
                              .read<ScreeningProvider>();

                          final screeningId = await screeningProvider
                              .createScreening(child.childID);

                          if (screeningId != null && context.mounted) {
                            Navigator.pushNamed(context, '/quesboard');
                          }
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
