import 'package:neuronest/core/network/api_service.dart';
import 'question_model.dart';

class QuestionRepository {
  final ApiService _api = ApiService();

  Future<List<QuestionModel>> getQuestions() async {
    try {
      final response = await _api.get('/question');

      if (response is List) {
        return response
            .map(
              (e) => QuestionModel.fromJson(e),
            )
            .toList();
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}