import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_radiolist.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:neuronest/features/assessmentQues/widgets/ques_appbar_widg.dart';
import 'package:neuronest/shared/custom_textbutton.dart';
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

  final List<Map<String, String>> options = [
    {'title': 'Always', 'value': '1.0'},
    {'title': 'Never', 'value': '0.0'},
    {'title': 'Often', 'value': '0.66'},
    {'title': 'Rarely', 'value': '0.33'},
  ];

  final List<String> questions = [
    //1
    "If you point at something across the room, does your child look at it?",
    //2
    "Have you ever wondered if your child might be deaf?",
    //3
    "Does your child play pretend or make-believe?",
    //4
    "Does your child like climbing on things?",
    //5
    "Does your child make unusual finger movements near his or her eyes?",
    //6
    "Does your child point with one finger to ask for something or to get help?",
    //7
    "Does your child point with one finger to show you something interesting?",
    //8
    "Is your child interested in other children?",
    //9
    "Does your child show you things by bringing them to you or holding them up for you to see?",
    //10
    "Does your child respond when you call his or her name?",
    //11
    "When you smile at your child, does he or she smile back at you?",
    //12
    "Does your child get upset by everyday noises?",
    //13
    "Does your child walk?",
    //14
    "Does your child look you in the eye when you are talking to him or her, playing with him or her, or dressing him or her?",
    //15
    "Does your child try to copy what you do?",
    //16
    "If you turn your head to look at something, does your child look around to see what you are looking at?",
    //17
    "Does your child try to get you to watch him or her?",
    //18
    "Does your child understand when you tell him or her to do something?",
    //19
    "If something new happens, does your child look at your face to see how you feel about it?",
    //20
    "Does your child like movement activities?",
  ];

  // organization of Questions

  // social_interaction Questions: 3,8,10,11,14,15,18
  // communication Questions: 1,6,7,9,16,17,
  // repetitive_behaviors Questions: 2,4,5,12,13,20

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
                    (index < 5)
                        ? 'assets/ques/ques_image.png'
                        : (index < 10)
                        ? 'assets/ques/ques_image_2.png'
                        : 'assets/ques/ques_image_3.png',
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
                          text: options[i]['title']!,
                          val: options[i]['value']!,
                          groupValue: _selectedAnswers[index],
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswers[index] = value;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  Gap(20),
                  CustomElevatedbutton(
                    onPressed: () {
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
                      setState(() {
                        _selectedAnswers[_currentPage] = null;
                      });
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
                          // '/test',
                          arguments: _selectedAnswers,
                        );
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
