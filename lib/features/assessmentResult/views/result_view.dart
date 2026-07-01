import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/core/constants/question_categories.dart';
import 'package:neuronest/features/assessmentResult/widgets/custom_card_widg.dart';
import 'package:neuronest/features/assessmentResult/widgets/riskgauge_widg.dart';
import 'package:neuronest/features/assessmentQues/providers/question_provider.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

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

  // Returns internal keys 'Low', 'Moderate', 'High', 'No Data' for color mapping
  String _getCategoryRatingKeyByQuestions(List<int> questionIndices) {
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

  // Helper to translate risk levels for display
  String _translateRiskLevel(String risk, bool isAr) {
    if (!isAr) return risk;
    switch (risk.toLowerCase()) {
      case 'low':
        return 'منخفض';
      case 'moderate':
        return 'متوسط';
      case 'high':
        return 'مرتفع';
      case 'no data':
        return 'لا توجد بيانات';
      default:
        return risk;
    }
  }

  Color _getRatingColor(String ratingKey) {
    switch (ratingKey) {
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

  Color _getRatingBackgroundColor(String ratingKey) {
    switch (ratingKey) {
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

  String getRiskMessage(String riskLevel, bool isAr) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return isAr
            ? 'تم اكتشاف مؤشرات قوية. يوصى بإجراء تقييم مهني.'
            : 'Strong indicators were detected. Professional evaluation is recommended.';
      case 'moderate':
        return isAr
            ? 'تم اكتشاف بعض المؤشرات. يوصى بإجراء مزيد من التقييم.'
            : 'Some indicators were detected. Further assessment is recommended.';
      case 'low':
        return isAr
            ? 'تم اكتشاف مؤشرات قليلة. استمر في مراقبة التطور.'
            : 'Few indicators were detected. Continue monitoring development.';
      default:
        return isAr ? 'اكتمل التقييم.' : 'Assessment completed.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _apiResult ?? widget.apiResult;

    if (result == null) return const Center(child: CircularProgressIndicator());

    // Get current language from QuestionProvider
    final isAr = context.watch<QuestionProvider>().currentLanguage == 'ar';

    final riskLevelKey = result['riskLevel'] ?? 'Unknown';
    final score = result['totalScore'] ?? 0;

    // Translate the final strings for display
    final riskMessage = getRiskMessage(riskLevelKey, isAr);
    final riskLevelDisplay = _translateRiskLevel(riskLevelKey, isAr);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: isAr ? 'نتيجة التقييم' : 'Assessment Result',
          size: 21,
          color: const Color(0xff000000),
          weight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _buildRiskGaugeCard(riskLevelDisplay, score, riskMessage, isAr),
                _buildCategoriesCards(isAr),
                const Gap(13),
                CustomElevatedbutton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/root',
                      (route) => false,
                    );
                  },
                  text: isAr ? 'العودة للصفحة الرئيسية' : 'Go to Home',
                ),
                const Gap(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiskGaugeCard(
    String riskLevelDisplay,
    dynamic score,
    String riskMessage,
    bool isAr,
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
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 20,
                left: 10,
                right: 10,
              ),
              child: CustomText(
                text: isAr ? 'التقييم الشامل' : 'Overall Assessment',
                size: 21,
                color: const Color(0xff6C6969),
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
                  text: isAr
                      ? 'مستوى الخطر: $riskLevelDisplay'
                      : 'Risk Level: $riskLevelDisplay',
                  size: 20,
                  color: Colors.black,
                  weight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const Gap(10),
                CustomText(
                  text: isAr ? 'النتيجة: $score' : 'Score: $score',
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

  // Build categories dynamically from questions
  Widget _buildCategoriesCards(bool isAr) {
    // Get questions from provider
    final questions = context.watch<QuestionProvider>().questions;

    if (questions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomText(
          text: isAr ? 'لا توجد بيانات' : 'No data available',
          size: 16,
          color: Colors.grey,
          weight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Group questions by category
    final Map<String, List<int>> groupedQuestions = {};

    for (var q in questions) {
      final category = QuestionCategories.getCategory(q.questionNumber);
      groupedQuestions.putIfAbsent(category, () => []);
      groupedQuestions[category]!.add(q.questionNumber);
    }

    // Build category list
    final List<Map<String, dynamic>> categories = [];

    // Define order of categories
    final List<String> categoryOrder = [
      'social',
      'communication',
      'repetitive',
    ];

    for (var categoryKey in categoryOrder) {
      if (groupedQuestions.containsKey(categoryKey)) {
        categories.add({
          'title': QuestionCategories.getTitle(categoryKey, isAr),
          'questions': groupedQuestions[categoryKey]!,
          'image': QuestionCategories.getImage(categoryKey),
        });
      }
    }

    // Add any 'other' categories at the end
    if (groupedQuestions.containsKey('other')) {
      categories.add({
        'title': isAr ? 'أخرى' : 'Other',
        'questions': groupedQuestions['other']!,
        'image': 'assets/ques/ques_image.png',
      });
    }

    List<Widget> visibleCards = [];

    for (var category in categories) {
      final questionsList = category['questions'] as List<int>;

      if (_hasAnyAnswerByQuestions(questionsList)) {
        final ratingKey = _getCategoryRatingKeyByQuestions(questionsList);
        final ratingDisplay = _translateRiskLevel(ratingKey, isAr);

        visibleCards.add(
          Column(
            children: [
              CustomCard(
                backgroundImage: category['image'] as String,
                text: category['title'] as String,
                textCont: ratingDisplay,
                color: _getRatingBackgroundColor(ratingKey),
                colorTextCont: _getRatingColor(ratingKey),
              ),
              const Gap(13),
            ],
          ),
        );
      }
    }

    if (visibleCards.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomText(
          text: isAr
              ? 'لا توجد فئات مكتملة لعرضها'
              : 'No completed categories to display',
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
