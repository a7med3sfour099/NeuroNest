import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/home/providers/child_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/screening_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/question_provider.dart'; // NEW IMPORT
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
    // Listen to the QuestionProvider for language state
    final provider = context.watch<QuestionProvider>();
    final bool isAr = provider.currentLanguage == 'ar';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,

        // Add the transparent AppBar with the Hamburger Menu
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.black, size: 30),
              onSelected: (String lang) {
                // Update language globally when selected
                context.read<QuestionProvider>().setLanguage(lang);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'en',
                  child: Row(
                    children: [
                      const Text('🇺🇸', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text(
                        'EN',
                        style: TextStyle(
                          fontWeight: provider.currentLanguage == 'en'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'ar',
                  child: Row(
                    children: [
                      const Text('🇸🇦', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text(
                        'AR',
                        style: TextStyle(
                          fontWeight: provider.currentLanguage == 'ar'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(10),
          ],
        ),

        // 3. Wrap in SafeArea since we now have an AppBar
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              // Reduced top padding from 198 to 80 because the AppBar takes up space now
              padding: const EdgeInsets.symmetric(
                vertical: 80.0,
                horizontal: 15.0,
              ),
              // 4. Directionality ensures RTL rendering for Arabic
              child: Directionality(
                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/ques/ques_view.png',
                        width: 216,
                        height: 216,
                      ),
                    ),
                    const Gap(32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          CustomText(
                            // 5. Dynamic text rendering based on selected language
                            text: isAr ? 'هيا بنا نبدأ' : 'Let\'s get started',
                            size: 23,
                            color: AppColors.textPrimary,
                            weight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(3),
                          CustomText(
                            text: isAr
                                ? 'أجب عن بعض الأسئلة لمساعدتنا في فهم طفلك بشكل أفضل'
                                : 'Answer a few questions to help us understand your child better',
                            size: 20,
                            color: AppColors.textTertiary,
                            weight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(32),
                          CustomElevatedbutton(
                            onPressed: () async {
                              final child = context
                                  .read<ChildProvider>()
                                  .currentChild;

                              print("CURRENT CHILD => ${child?.childID}");

                              if (child == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isAr
                                          ? 'لم يتم تحديد طفل'
                                          : "No child selected",
                                    ),
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

                            text: isAr ? 'ابدأ التقييم' : 'Start Assessment',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
