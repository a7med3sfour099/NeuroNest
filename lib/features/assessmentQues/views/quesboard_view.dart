import 'package:neuronest/core/constants/app_colors.dart';
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

  final List<Map<String, String>> options = [
    {'title': 'Definitely', 'value': '1.0'},
    {'title': 'Never', 'value': '0.0'},
    {'title': 'Often', 'value': '0.66'},
    {'title': 'Rarely', 'value': '0.33'},
  ];

  // organization of Questions

  // social_interaction Questions: 3,8,10,11,14,15,18
  // communication Questions: 1,6,7,9,16,17,
  // repetitive_behaviors Questions: 2,4,5,12,13,20

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
    return SingleChildScrollView(
      child: Column(
        //=======
        children: [
          // Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 27.0,
              horizontal: 10.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff5DB7DE).withOpacity(0.22),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 27.0, horizontal: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 191,
                    height: 49,
                    decoration: BoxDecoration(
                      color: Color(0xff5DB7DE),
                      // color: Color(0xff4a7dcd),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: CustomText(
                      text: 'Social Interaction',
                      size: 21,
                      color: Colors.white,
                      weight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(23),
                  Image.asset(
                    (index < 7)
                        ? 'assets/ques/ques_image.png'
                        : (index < 7)
                        ? 'assets/ques/ques_image_2.png'
                        : 'assets/ques/ques_image_3.png',
                    width: 115,
                    height: 115,
                  ),
                  Gap(23),
                  CustomText(
                    // You can choose to put the question in Arabic or English
                    text: provider.questions[index].questionEn,
                    size: 23,
                    color: Color(0xff000000),
                    weight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  Gap(38),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: options.length,
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
                          text: options[i]['title']!,
                          val: options[i]['value']!,
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
                  Gap(20),
                  CustomElevatedbutton(
                    onPressed: () async {
                      if (_selectedAnswers[_currentPage] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Please select an answer before continuing',
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
                        print("Selected answers: $_selectedAnswers");
                        final answers = _selectedAnswers.map((e) {
                          return e == '1.0' ? 1 : 0;
                        }).toList();

                        print('ANSWERS => $answers');

                        final result = await context
                            .read<ScreeningProvider>()
                            .submitAnswers(answers);

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
                              content: const Text('Failed to submit answers'),
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
                    },
                    text: _currentPage < provider.questions.length - 1
                        ? 'Next'
                        : 'See Results',
                  ),
                  Gap(10),
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
                        print("Selected answers: $_selectedAnswers");
                        final answers = _selectedAnswers.map((e) {
                          return e == '1.0' ? 1 : 0;
                        }).toList();

                        print('ANSWERS => $answers');

                        final result = await context
                            .read<ScreeningProvider>()
                            .submitAnswers(answers);

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
                            const SnackBar(
                              content: Text('Failed to submit answers'),
                            ),
                          );
                        }
                      }
                    },
                    text: 'I don\'t Know',
                    color: Color(0xff6C6969),
                    size: 23,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
