import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neuronest/features/uploadVideo/data/video_model.dart';
import 'package:neuronest/features/uploadVideo/data/video_repo.dart';
import 'package:video_compress/video_compress.dart';

class VideoProvider extends ChangeNotifier {
  final VideoRepository _repo = VideoRepository();

  bool isLoading = false;
  String loadingMessage = '';

  VideoResultModel? result;

  Future<bool> uploadVideo(int childId, File video) async {
    print("========== UPLOAD PIPELINE START ==========");

    isLoading = true;
    loadingMessage = 'Analyzing video...';
    notifyListeners();

    File fileToUpload = video;

    try {
      // 1. Compress the Video (Reduces 200MB to ~15MB without losing AI tracking details)
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );

      if (mediaInfo != null && mediaInfo.file != null) {
        fileToUpload = mediaInfo.file!;
        print("Original size: ${video.lengthSync()} bytes");
        print("Compressed size: ${mediaInfo.filesize} bytes");
      }
    } catch (e) {
      print("Compression failed, falling back to original file: $e");
    }

    loadingMessage = 'Uploading to AI server...';
    notifyListeners();

    try {
      // Upload the compressed video
      result = await _repo.uploadVideo(childId, fileToUpload);
      print("UPLOAD RESULT => $result");
    } catch (e) {
      print("VIDEO ERROR => $e");
      result = null;
      rethrow;
    } finally {
      // 3. Cleanup
      isLoading = false;
      loadingMessage = '';
      notifyListeners();

      // Clear temporary compression cache to prevent memory leaks
      await VideoCompress.deleteAllCache();
    }

    return result != null;
  }
}
