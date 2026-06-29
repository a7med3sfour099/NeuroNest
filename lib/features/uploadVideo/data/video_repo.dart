import 'dart:io';

import 'package:dio/dio.dart';
import 'package:neuronest/core/network/dio_client.dart';
import 'package:neuronest/features/uploadVideo/data/video_model.dart';

class VideoRepository {
  final Dio dio = DioClient().dio;

  Future<VideoResultModel?> uploadVideo(int childId, File video) async {
    final formData = FormData.fromMap({
      "ChildID": childId,
      "Video": await MultipartFile.fromFile(
        video.path,
        filename: video.path.split('/').last,
      ),
    });

    final response = await dio.post("/Video/upload", data: formData);

    if (response.statusCode == 200) {
      return VideoResultModel.fromJson(response.data);
    }
    return null;
  }
}
