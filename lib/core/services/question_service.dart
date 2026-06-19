import 'package:neuronest/core/network/api_service.dart';

class QuestionService {
  final ApiService _api = ApiService();

  /// Fetch all questions from backend
  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    try {
      final response = await _api.get('/questions');

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('Fetch questions error: $e');
      // Return default questions if API fails (fallback)
      return _getDefaultQuestions();
    }
  }

  /// Fetch questions by category
  Future<List<Map<String, dynamic>>> fetchQuestionsByCategory(String category) async {
    try {
      final response = await _api.get('/questions/category/$category');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('Fetch questions by category error: $e');
      return [];
    }
  }

  /// Submit answers and get result
  Future<Map<String, dynamic>> submitAnswers(List<String?> answers) async {
    try {
      final response = await _api.post('/assessments/submit', {
        'answers': answers.map((a) => a ?? '').toList(),
      });

      if (response is Map<String, dynamic>) {
        return {
          'score': response['score'] ?? 0.0,
          'riskLevel': response['riskLevel'] ?? 'Low',
          'riskDescription': response['riskDescription'] ?? '',
          'categories': response['categories'] ?? [],
          'assessmentId': response['assessmentId'],
        };
      }
      return _calculateLocalResult(answers);
    } catch (e) {
      print('Submit answers error: $e');
      return _calculateLocalResult(answers);
    }
  }

  /// Save assessment result locally
  Future<bool> saveAssessmentResult(Map<String, dynamic> result) async {
    try {
      final response = await _api.post('/assessments/save', result);
      return response is Map && response['success'] == true;
    } catch (e) {
      print('Save assessment result error: $e');
      return false;
    }
  }

  /// Get assessment history
  Future<List<Map<String, dynamic>>> getAssessmentHistory() async {
    try {
      final response = await _api.get('/assessments/history');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('Get assessment history error: $e');
      return [];
    }
  }

  /// Get single assessment by ID
  Future<Map<String, dynamic>?> getAssessmentById(String id) async {
    try {
      final response = await _api.get('/assessments/$id');
      if (response is Map<String, dynamic>) {
        return response;
      }
      return null;
    } catch (e) {
      print('Get assessment by ID error: $e');
      return null;
    }
  }

  // ==================== Local Fallback Methods ====================

  List<Map<String, dynamic>> _getDefaultQuestions() {
    return [
      {'text': 'Does your child look at you when you call his/her name?', 'category': 'Social Interaction'},
      {'text': 'How easy is it for you to get eye contact with your child?', 'category': 'Social Interaction'},
      {'text': 'Does your child point to indicate that he/she wants something?', 'category': 'Communication'},
      {'text': 'Does your child point to share interest with you?', 'category': 'Social Interaction'},
      {'text': 'Does your child pretend? (e.g. care for dolls, talk on a toy phone)', 'category': 'Communication'},
      {'text': 'Does your child follow where you\'re looking?', 'category': 'Social Interaction'},
      {'text': 'If you or someone else is visibly upset, does your child show signs of wanting to comfort them?', 'category': 'Social Interaction'},
      {'text': 'How would you describe your child\'s first words?', 'category': 'Communication'},
      {'text': 'Does your child use simple gestures? (e.g. wave goodbye)', 'category': 'Communication'},
      {'text': 'Does your child stare at nothing with no apparent purpose?', 'category': 'Repetitive Behaviors'},
    ];
  }

  Map<String, dynamic> _calculateLocalResult(List<String?> answers) {
    int yesCount = 0;
    for (var answer in answers) {
      if (answer == '1' || answer?.toLowerCase() == 'yes') {
        yesCount++;
      }
    }
    double score = answers.isEmpty ? 0 : (yesCount / answers.length) * 100;
    String riskLevel = score <= 33 ? 'Low' : (score <= 66 ? 'Moderate' : 'High');

    return {
      'score': score,
      'riskLevel': riskLevel,
      'riskDescription': _getRiskDescription(score),
      'categories': [],
      'assessmentId': null,
    };
  }

  String _getRiskDescription(double score) {
    if (score >= 70) {
      return 'High likelihood: Behaviors strongly associated with autism spectrum traits.';
    } else if (score >= 40) {
      return 'Moderate likelihood: Some behaviors may be associated with autism spectrum traits.';
    } else {
      return 'Low likelihood: Few behaviors associated with autism spectrum traits.';
    }
  }
}