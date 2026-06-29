import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/assessmentResult/widgets/custom_card_widg.dart';
import 'package:neuronest/features/assessmentResult/widgets/riskgauge_widg.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResultView extends StatefulWidget {
  const ResultView({
    super.key,
    this.onBackPressed,
    this.selectedAnswers,
    this.totalQuestions = 0,
    this.apiResult,
  });

  final VoidCallback? onBackPressed;
  final List<String?>? selectedAnswers;
  final int totalQuestions;
  final Map<String, dynamic>? apiResult;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late List<dynamic> _selectedAnswers;
  Map<String, dynamic>? _apiResult;
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = widget.selectedAnswers ?? [];
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

    if (args is Map<String, dynamic>) {
      _apiResult = args['apiResult'];

      if (args['selectedAnswers'] != null) {
        _selectedAnswers = List<dynamic>.from(args['selectedAnswers']);
      }
    } else if (args is List) {
      _selectedAnswers = args;
      _calculateRiskScore();
    }

    _isDataInitialized = true;
  }

  double? _parseAnswerValue(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value);
  }

  void _calculateRiskScore() {
    int count = 0;

    for (var answer in _selectedAnswers) {
      final value = _parseAnswerValue(answer);
      if (value != null) {
        count++;
      }
    }

    if (count > 0) {
    } else {}
  }

  int _getAnsweredCountByQuestions(List<int> questionIndices) {
    int count = 0;

    for (final question in questionIndices) {
      final index = question - 1;

      if (index < _selectedAnswers.length && _selectedAnswers[index] != null) {
        count++;
      }
    }

    return count;
  }

  bool _hasAnyAnswerByQuestions(List<int> questionIndices) {
    return _getAnsweredCountByQuestions(questionIndices) > 0;
  }

  double _getCategoryAverageByQuestions(List<int> questionIndices) {
    double sum = 0;
    int count = 0;

    for (final question in questionIndices) {
      final index = question - 1;

      if (index < _selectedAnswers.length) {
        final value = _parseAnswerValue(_selectedAnswers[index]?.toString());

        if (value != null) {
          sum += value;
          count++;
        }
      }
    }

    return count == 0 ? 0.0 : sum / count;
  }

  String _getCategoryRatingByQuestions(List<int> questionIndices) {
    final average = _getCategoryAverageByQuestions(questionIndices);
    final answeredCount = _getAnsweredCountByQuestions(questionIndices);

    if (answeredCount == 0) return 'No Data';

    if (average <= 0.33) {
      return 'Low';
    } else if (average <= 0.66) {
      return 'Moderate';
    } else {
      return 'High';
    }
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

  String getRiskMessage(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return 'Strong indicators were detected. Professional evaluation is recommended.';
      case 'moderate':
        return 'Some indicators were detected. Further assessment is recommended.';
      case 'low':
        return 'Few indicators were detected. Continue monitoring development.';
      default:
        return 'Assessment completed.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _apiResult ?? widget.apiResult;

    if (result == null) return const Center(child: CircularProgressIndicator());

    final riskLevel = result['riskLevel'] ?? 'Unknown';
    final score = result['totalScore'] ?? 0;
    // final message = result['message'] ?? '';

    final riskMessage = getRiskMessage(riskLevel);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Assessment Result',
          size: 21,
          color: const Color(0xff000000),
          weight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _buildRiskGaugeCard(riskLevel, score, riskMessage),
              const Gap(13),
              _buildCategoriesCards(),
              const Gap(13),
              CustomElevatedbutton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/root',
                    (route) => false,
                  );
                },
                text: 'Go to Home',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskGaugeCard(
    String riskLevel,
    dynamic score,
    String riskMessage,
  ) {
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
            RiskGauge(value: score.toDouble()),
            const Gap(17),
            Column(
              children: [
                CustomText(
                  text: 'Risk Level: $riskLevel',
                  size: 20,
                  color: Colors.black,
                  weight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const Gap(10),
                CustomText(
                  text: 'Score: $score',
                  size: 18,
                  color: Colors.black,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const Gap(10),
                CustomText(
                  text: riskMessage,
                  size: 16,
                  color: const Color(0xff6C6969),
                  weight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesCards() {
    print('RESULT ANSWERS => $_selectedAnswers');
    print('RESULT LENGTH => ${_selectedAnswers.length}');
    final categories = [
      {
        'title': 'Social Interaction',
        // 'start': 0,
        // 'end': 4,
        'questions': [3, 8, 10, 11, 14, 15, 18],
        'image': 'assets/ques/ques_image.png',
      },
      {
        'title': 'Communication',
        // 'start': 5,
        // 'end': 9,
        'questions': [1, 6, 7, 9, 16, 17, 19],
        'image': 'assets/ques/ques_image_2.png',
      },
      {
        'title': 'Repetitive Behaviors',
        // 'start': 10,
        // 'end': 14,
        'questions': [2, 4, 5, 12, 13, 20],
        'image': 'assets/ques/ques_image_3.png',
      },
    ];

    List<Widget> visibleCards = [];

    for (var category in categories) {
      // final start = category['start'] as int;
      // final end = category['end'] as int;
      final questions = category['questions'] as List<int>;

      if (_hasAnyAnswerByQuestions(questions)) {
        final rating = _getCategoryRatingByQuestions(questions);
        // final average = _getCategoryAverageByQuestions(questions);

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
