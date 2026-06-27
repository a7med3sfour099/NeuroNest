import 'package:neuronest/core/network/api_service.dart';

class ScreeningRepository {
  final ApiService _api = ApiService();

  Future<int?> createScreening(int childId) async {
    try {
      final response = await _api.post('/Screening', {
        "childID": childId,
        "screeningType": "Questionnaire",
      });

      if (response is Map<String, dynamic>) {
        return response['screeningID'];
      }

      return null;
    } catch (e) {
      print('CREATE SCREENING ERROR => $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitAnswers({
    required int screeningId,
    required int childId,
    required List<int> answers,
  }) async {
    try {
      // print(
      //   'SUBMIT BODY => ${{"screeningId": screeningId, "childId": childId, "answers": answers}}',
      // );

      final response = await _api.post('/Screening/submit-answers', {
        "screeningId": screeningId,
        "childId": childId,
        "answers": answers,
      });

      // print('SUBMIT ANSWERS RESPONSE => $response');

      return response;
    } catch (e) {
      print('SUBMIT ANSWERS ERROR => $e');
      return null;
    }
  }
}
