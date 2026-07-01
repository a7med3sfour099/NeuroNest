import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/core/constants/question_categories.dart';
import 'package:neuronest/features/assessmentQues/providers/question_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/screening_provider.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_radiolist.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:neuronest/features/assessmentQues/widgets/ques_appbar_widg.dart';
import 'package:neuronest/shared/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class QuesboardView extends StatefulWidget {
  const QuesboardView({super.key});

  @override
  State<QuesboardView> createState() => _QuesboardViewState();
}

class _QuesboardViewState extends State<QuesboardView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Separate English and Arabic options
  final List<Map<String, String>> optionsEn = [
    {'title': 'Definitely', 'value': '1.0'},
    {'title': 'Never', 'value': '0.0'},
    {'title': 'Often', 'value': '0.66'},
    {'title': 'Rarely', 'value': '0.33'},
  ];

  final List<Map<String, String>> optionsAr = [
    {'title': 'بالتأكيد', 'value': '1.0'},
    {'title': 'أبداً', 'value': '0.0'},
    {'title': 'غالباً', 'value': '0.66'},
    {'title': 'نادراً', 'value': '0.33'},
  ];

  List<String?> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<QuestionProvider>();
      await provider.loadQuestions();
      setState(() {
        _selectedAnswers = List<String?>.filled(
          provider.questions.length,
          null,
          growable: true,
        );
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuestionProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('No Questions Found')));
    }

    return Scaffold(
      appBar: QuesAppBar(
        currentQuestion: _currentPage + 1,
        totalQuestions: provider.questions.length,
        onBackPressed: () {
          if (_currentPage > 0) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
      backgroundColor: AppColors.background,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: List.generate(
          provider.questions.length,
          (index) => _buildQuestionPage(context, index, provider),
        ),
      ),
    );
  }

  Widget _buildQuestionPage(
    BuildContext context,
    int index,
    QuestionProvider provider,
  ) {
    final bool isAr = provider.currentLanguage == 'ar';
    final currentOptions = isAr ? optionsAr : optionsEn;
    
    final question = provider.questions[index];
    final questionNumber = question.questionNumber;
    
    // Use QuestionCategories instead of hardcoded arrays
    final category = QuestionCategories.getCategory(questionNumber);
    final categoryTitle = QuestionCategories.getTitle(category, isAr);
    final categoryImage = QuestionCategories.getImage(category);

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 27.0,
                horizontal: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff5DB7DE).withOpacity(0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 27.0, horizontal: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 191,
                      height: 49,
                      decoration: BoxDecoration(
                        color: const Color(0xff5DB7DE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: CustomText(
                        // Use categoryTitle from QuestionCategories
                        text: categoryTitle,
                        size: 21,
                        color: Colors.white,
                        weight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(23),
                    Image.asset(
                      // Use categoryImage from QuestionCategories
                      categoryImage,
                      width: 115,
                      height: 115,
                    ),
                    const Gap(23),
                    CustomText(
                      text: isAr 
                          ? question.questionAr 
                          : question.questionEn,
                      size: 23,
                      color: const Color(0xff000000),
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(38),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentOptions.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.8,
                          ),
                      itemBuilder: (context, i) {
                        return Center(
                          child: CustomRadioList(
                            fontSize: 19,
                            text: currentOptions[i]['title']!,
                            val: currentOptions[i]['value']!,
                            groupValue: _selectedAnswers.length > index
                                ? _selectedAnswers[index]
                                : null,
                            onChanged: (value) {
                              if (_selectedAnswers.length > index) {
                                setState(() {
                                  _selectedAnswers[index] = value;
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                    CustomElevatedbutton(
                      onPressed: () async {
                        if (_selectedAnswers[_currentPage] == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isAr ? 'يرجى تحديد إجابة قبل المتابعة' : 'Please select an answer before continuing',
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(milliseconds: 1500),
                            ),
                          );
                          return;
                        }
                        if (_currentPage < provider.questions.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _submitAnswers(context);
                        }
                      },
                      text: _currentPage < provider.questions.length - 1
                          ? (isAr ? 'التالي' : 'Next')
                          : (isAr ? 'عرض النتائج' : 'See Results'),
                    ),
                    const Gap(10),
                    CustomTextButton(
                      onPressed: () async {
                        setState(() {
                          _selectedAnswers[_currentPage] = null;
                        });
                        if (_currentPage < provider.questions.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _submitAnswers(context);
                        }
                      },
                      text: isAr ? 'لا أعرف' : 'I don\'t Know',
                      color: const Color(0xff6C6969),
                      size: 23,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAnswers(BuildContext context) async {
    final bool isAr = context.read<QuestionProvider>().currentLanguage == 'ar';
    
    final answers = _selectedAnswers.map((e) {
      return e == '1.0' ? 1 : 0;
    }).toList();

    final result = await context.read<ScreeningProvider>().submitAnswers(answers);

    if (result != null) {
      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: {
          'apiResult': result,
          'selectedAnswers': _selectedAnswers,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAr ? 'فشل إرسال الإجابات' : 'Failed to submit answers'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }
}