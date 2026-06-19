import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/assessmentResult/widgets/custom_card_widg.dart';
import 'package:neuronest/features/assessmentResult/widgets/riskgauge_widg.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NewResultView extends StatefulWidget {
  const NewResultView({
    super.key,
    this.onBackPressed,
    this.selectedAnswers,
    this.totalQuestions = 0,
  });

  final VoidCallback? onBackPressed;
  final List<String?>? selectedAnswers;
  final int totalQuestions;

  @override
  State<NewResultView> createState() => _NewResultViewState();
}

class _NewResultViewState extends State<NewResultView> {
  late int _totalQuestions;
  // Use dynamic type to handle different answers
  late List<dynamic> _selectedAnswers;
  double _riskScore = 0.0;
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = widget.selectedAnswers ?? [];
    _totalQuestions = widget.totalQuestions;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataInitialized) {
      _initializeDataFromNavigation();
    }
  }

  void _initializeDataFromNavigation() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List) {
      _selectedAnswers = args;
      _totalQuestions = args.length;
    }

    _isDataInitialized = true;
    _calculateRiskScore();

    if (mounted) {
      setState(() {});
    }
  }

  // Count the number of answers with a value of 1 (YES)
  void _calculateRiskScore() {
    int yesCount = _getTotalYesCount();
    if (_totalQuestions > 0) {
      _riskScore = (yesCount / _totalQuestions) * 100;
    } else {
      _riskScore = 0.0;
    }
  }

  // Calculate the total number of YES responses for all questions
  int _getTotalYesCount() {
    int count = 0;
    for (var answer in _selectedAnswers) {
      if (_isYesAnswer(answer)) {
        count++;
      }
    }
    return count;
  }

  // Function to check if the answer is YES
  bool _isYesAnswer(dynamic answer) {
    if (answer == null) return false;
    if (answer is int) return answer == 1;
    if (answer is String) {
      return answer.toLowerCase() == 'yes' || answer == '1';
    }
    if (answer is bool) return answer == true;
    return false;
  }

  // Function to check if the answer is NO
  bool _isNoAnswer(dynamic answer) {
    if (answer == null) return false;
    if (answer is int) return answer == 0;
    if (answer is String) {
      return answer.toLowerCase() == 'no' || answer == '0';
    }
    if (answer is bool) return answer == false;
    return false;
  }

  // Count the number of YES answers in a specific range (number adjusted)
  int _getYesCount(int startIndex, int endIndex) {
    int yesCount = 0;
    for (
      int i = startIndex;
      i <= endIndex && i < _selectedAnswers.length;
      i++
    ) {
      if (_isYesAnswer(_selectedAnswers[i])) {
        yesCount++;
      }
    }
    return yesCount;
  }

  // Calculate the number of non-NULL answers (the ones that have been answered, either YES or NO)
  int _getAnsweredCount(int startIndex, int endIndex) {
    int count = 0;
    for (
      int i = startIndex;
      i <= endIndex && i < _selectedAnswers.length;
      i++
    ) {
      if (_selectedAnswers[i] != null) {
        count++;
      }
    }
    return count;
  }

  // Evaluate the category (Low / Moderate / High)
  String _getCategoryRating(int startIndex, int endIndex) {
    int yesCount = _getYesCount(startIndex, endIndex);
    int total = (endIndex - startIndex + 1);

    if (startIndex + total > _selectedAnswers.length) {
      total = _selectedAnswers.length - startIndex;
    }
    if (total < 0) total = 0;

    if (total == 0) return 'No Data';

    double percentage = (yesCount / total) * 100;

    if (percentage <= 33) {
      return 'Low';
    } else if (percentage <= 66) {
      return 'Moderate';
    } else {
      return 'High';
    }
  }

  // Check if there are any answers in the category
  bool _hasAnyAnswer(int startIndex, int endIndex) {
    for (
      int i = startIndex;
      i <= endIndex && i < _selectedAnswers.length;
      i++
    ) {
      if (_selectedAnswers[i] != null) {
        return true;
      }
    }
    return false;
  }

  Color _getRatingColor(String rating) {
    switch (rating) {
      case 'Low':
        return Colors.green.shade700;
      case 'Moderate':
        return Colors.orange.shade700;
      case 'High':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getRatingBackgroundColor(String rating) {
    switch (rating) {
      case 'Low':
        return Colors.green.withOpacity(0.2);
      case 'Moderate':
        return Colors.orange.withOpacity(0.2);
      case 'High':
        return Colors.red.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          iconSize: 33,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
        ),
        title: CustomText(
          text: 'Assessment Result',
          size: 21,
          color: const Color(0xff000000),
          weight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _buildRiskGaugeCard(),
              const Gap(13),
              _buildCategoriesCards(),
              const Gap(13),
              CustomElevatedbutton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/startques',
                    (route) => false,
                  );
                },
                text: 'Retake Assessment',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskGaugeCard() {
    // Calculating the actual percentage for the Overall Assessment
    int yesCount = _getTotalYesCount();
    int totalCount = _selectedAnswers.where((a) => a != null).length;
    String riskText = _getRiskDescription();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 27.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffDBEFF8),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20, left: 10, right: 10),
              child: CustomText(
                text: 'Overall Assessment',
                size: 21,
                color: Color(0xff6C6969),
                weight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(5),
            RiskGauge(value: _riskScore),
            const Gap(17),
            CustomText(
              text: riskText,
              size: 16,
              color: const Color(0xff6C6969),
              weight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getRiskDescription() {
    if (_riskScore >= 70) {
      return 'High likelihood: Behaviors strongly associated with autism spectrum traits.';
    } else if (_riskScore >= 40) {
      return 'Moderate likelihood: Some behaviors may be associated with autism spectrum traits.';
    } else {
      return 'Low likelihood: Few behaviors associated with autism spectrum traits.';
    }
  }

  Widget _buildCategoriesCards() {
    final categories = [
      {
        'title': 'Social Interaction',
        'start': 0,
        'end': 4,
        'image': 'assets/ques/ques_image.png',
      },
      {
        'title': 'Communication',
        'start': 5,
        'end': 9,
        'image': 'assets/ques/ques_image_2.png',
      },
      {
        'title': 'Repetitive Behaviors',
        'start': 10,
        'end': 14,
        'image': 'assets/ques/ques_image_3.png',
      },
    ];

    List<Widget> visibleCards = [];

    for (var category in categories) {
      final start = category['start'] as int;
      final end = category['end'] as int;

      if (_hasAnyAnswer(start, end)) {
        final rating = _getCategoryRating(start, end);
        final yesCount = _getYesCount(start, end);
        final answeredCount = _getAnsweredCount(start, end);

        visibleCards.add(
          Column(
            children: [
              CustomCard(
                backgroundImage: category['image'] as String,
                text: category['title'] as String,
                textCont: rating,
                color: _getRatingBackgroundColor(rating),
                colorTextCont: _getRatingColor(rating),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: CustomText(
                  text: '$yesCount Yes answers out of $answeredCount Questions',
                  size: 12,
                  color: Colors.grey.shade600,
                  weight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(13),
            ],
          ),
        );
      }
    }

    if (visibleCards.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: CustomText(
          text: 'No completed categories to display',
          size: 16,
          color: Colors.grey,
          weight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(children: visibleCards);
  }
}
