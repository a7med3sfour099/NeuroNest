import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/shared/custom_elevatedbutton.dart';
import 'package:firstversion1/shared/custom_radiolist.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:firstversion1/features/assessmentQues/widgets/ques_appbar_widg.dart';
import 'package:firstversion1/shared/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuesboardView extends StatefulWidget {
  const QuesboardView({super.key});

  @override
  State<QuesboardView> createState() => _QuesboardViewState();
}

class _QuesboardViewState extends State<QuesboardView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> questions = [
    "Does your child look at you when you call his/her name?",
    "How easy is it for you to get eye contact with your child?",
    "Does your child point to indicate that his/her wants something?",
    "Does your child point to share interest with you?",
    "Does your child pretend? (e.g. care for dolls, talk on a toy phone)",
    "Does your child follow where you're looking?",
    "If you or someone else in the family is visibly upset, does your child show signs of wanting to comfort them?",
    "How would you describe your child's first words?",
    "Does your child use simple gestures? (e.g. wave goodbye)",
    "Does your child stare at nothing with no apparent purpose?",
  ];

  List<String?> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<String?>.filled(questions.length, null);
  }

  int get total => questions.length;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuesAppBar(
        currentQuestion: _currentPage + 1,
        totalQuestions: total,
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
      backgroundColor: AppColors.primary,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: List.generate(
          questions.length,
          (index) => _buildQuestionPage(context, index),
        ),
      ),
    );
  }

  Widget _buildQuestionPage(BuildContext context, int index) {
    return SingleChildScrollView(
      child: Column(
        //=======
        children: [
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
                    'assets/ques/ques_image.png',
                    width: 115,
                    height: 115,
                  ),
                  Gap(23),
                  CustomText(
                    text: questions[_currentPage],
                    size: 23,
                    color: Color(0xff000000),
                    weight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  Gap(23),
                  RadioGroup<String>(
                    groupValue: _selectedAnswers[index],
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswers[index] = value!;
                      });
                    },
                    child: Column(
                      children: [
                        CustomRadioList(
                          text: 'Yes',
                          val: '1',
                          groupValue: _selectedAnswers[index],
                          onChanged: (value) =>
                              setState(() => _selectedAnswers[index] = value),
                        ),
                        Gap(17),
                        CustomRadioList(
                          text: 'No',
                          val: '0',
                          groupValue: _selectedAnswers[index],
                          onChanged: (value) =>
                              setState(() => _selectedAnswers[index] = value),
                        ),
                      ],
                    ),
                  ),
                  Gap(26),
                  CustomElevatedbutton(
                    onPressed: () {
                      if (_selectedAnswers[_currentPage] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select Yes or No before continuing',
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      if (_currentPage < questions.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        print("Selected answers: $_selectedAnswers");
                        Navigator.pushNamed(
                          context,
                          '/result',
                          arguments: _selectedAnswers,
                        );
                      }
                    },
                    text: _currentPage < questions.length - 1
                        ? 'Next'
                        : 'See Results',
                  ),
                  Gap(10),
                  CustomTextButton(
                    onPressed: () {
                      if (_currentPage < questions.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/result',
                          // '/test',
                          arguments: _selectedAnswers,
                        );
                      }
                    },
                    text: 'Skip',
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
