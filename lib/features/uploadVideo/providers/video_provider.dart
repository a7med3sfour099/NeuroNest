import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neuronest/features/uploadVideo/data/video_model.dart';
import 'package:neuronest/features/uploadVideo/data/video_repo.dart';

class VideoProvider extends ChangeNotifier {

  final VideoRepository _repo = VideoRepository();

  bool isLoading = false;

  VideoResultModel? result;

  Future<bool> uploadVideo(
      int childId,
      File video,
      ) async {

    isLoading = true;
    notifyListeners();

    try {

    result = await _repo.uploadVideo(
      childId,
      video,
    );
    } catch (e) {
      print('Video upload error: $e');
      result = null;
    }

    isLoading = false;
    notifyListeners();

    return result != null;
  }
}
