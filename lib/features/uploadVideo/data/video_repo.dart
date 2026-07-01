import 'dart:io';

import 'package:dio/dio.dart';
import 'package:neuronest/core/network/dio_client.dart';
import 'package:neuronest/features/uploadVideo/data/video_model.dart';

class VideoRepository {
  final Dio dio = DioClient().dio;

  Future<VideoResultModel?> uploadVideo(int childId, File video) async {
    try {
      final formData = FormData.fromMap({
        "ChildID": childId,
        "Video": await MultipartFile.fromFile(
          video.path,
          filename: video.path.split('/').last,
        ),
      });

      print(dio.options.baseUrl);
      print(dio.options.connectTimeout);
      print(dio.options.receiveTimeout);
      print(dio.options.sendTimeout);

      final response = await dio.post("/Video/upload", data: formData);

      print("STATUS => ${response.statusCode}");
      print("DATA => ${response.data}");

      if (response.statusCode == 200) {
        return VideoResultModel.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      print("TYPE => ${e.type}");
      print("MESSAGE => ${e.message}");
      print("STATUS => ${e.response?.statusCode}");
      print("DATA => ${e.response?.data}");
      return null;
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }
}
