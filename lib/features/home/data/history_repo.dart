import 'package:dio/dio.dart';
import 'package:neuronest/core/network/dio_client.dart';
import 'history_model.dart';

class HistoryRepository {
  final Dio dio = DioClient().dio;

  Future<HistoryModel?> getHistory(int childId) async {
    try {
         print("========= HISTORY =========");
    print("CHILD ID => $childId");
      final response = await dio.get(
        "/Screening/child/$childId/history",
      );
        print("STATUS => ${response.statusCode}");
    print("DATA => ${response.data}");

      return HistoryModel.fromJson(response.data);
    } catch (e) {
      print("History Error: $e");
      return null;
    }
  }
}