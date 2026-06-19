import 'dart:io';
import 'package:dio/dio.dart';
import 'package:neuronest/core/network/dio_client.dart';
import 'package:http_parser/http_parser.dart';

class VideoService {
  final DioClient _dioClient = DioClient();

  /// Upload video file for analysis
  Future<Map<String, dynamic>> uploadAndAnalyze(File videoFile) async {
    try {
      final formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(
          videoFile.path,
          contentType: MediaType('video', 'mp4'),
        ),
      });

      final response = await _dioClient.dio.post(
        '/video/analyze',
        data: formData,
        onSendProgress: (sent, total) {
          final progress = total > 0
              ? (sent / total * 100).toStringAsFixed(0)
              : '0';
          print('Upload progress: $progress%');
        },
      );

      if (response.data is Map<String, dynamic>) {
        return _parseAnalysisResult(response.data);
      }
      return _getDefaultAnalysisResult();
    } catch (e) {
      print('Video upload error: $e');
      return _getDefaultAnalysisResult();
    }
  }

  /// Upload video with custom options
  Future<Map<String, dynamic>> uploadVideo({
    required File videoFile,
    int? durationSeconds,
    String? childId,
    void Function()? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(videoFile.path),
        if (durationSeconds != null) 'duration': durationSeconds,
        if (childId != null) 'childId': childId,
      });

      final response = await _dioClient.dio.post(
        '/video/upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            onProgress();
          }
        },
      );

      return response.data;
    } catch (e) {
      print('Video upload error: $e');
      rethrow;
    }
  }

  /// Get analysis result by video ID
  Future<Map<String, dynamic>?> getAnalysisResult(String videoId) async {
    try {
      final response = await _dioClient.dio.get('/video/result/$videoId');
      if (response.data is Map<String, dynamic>) {
        return _parseAnalysisResult(response.data);
      }
      return null;
    } catch (e) {
      print('Get analysis result error: $e');
      return null;
    }
  }

  /// Get all video assessments history
  Future<List<Map<String, dynamic>>> getVideoHistory() async {
    try {
      final response = await _dioClient.dio.get('/video/history');
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print('Get video history error: $e');
      return [];
    }
  }

  /// Delete video assessment
  Future<bool> deleteVideoAssessment(String videoId) async {
    try {
      final response = await _dioClient.dio.delete('/video/$videoId');
      return response.statusCode == 200;
    } catch (e) {
      print('Delete video error: $e');
      return false;
    }
  }

  // ==================== Private Helpers ====================

  Map<String, dynamic> _parseAnalysisResult(Map<String, dynamic> data) {
    return {
      'socialInteraction': _toDouble(
        data['social_score'] ?? data['socialInteraction'],
      ),
      'communication': _toDouble(
        data['communication_score'] ?? data['communication'],
      ),
      'repetitiveBehaviors': _toDouble(
        data['behavior_score'] ?? data['repetitiveBehaviors'],
      ),
      'eyeContact': _toDouble(data['eye_contact_score'] ?? data['eyeContact']),
      'facialExpressions': _toDouble(
        data['facial_score'] ?? data['facialExpressions'],
      ),
      'gestures': _toDouble(data['gesture_score'] ?? data['gestures']),
      'vocalizations': _toDouble(data['vocal_score'] ?? data['vocalizations']),
      'overallScore': _toDouble(data['overall_score'] ?? data['overallScore']),
      'analysisStatus': data['status'] ?? data['analysisStatus'] ?? 'completed',
      'recommendations':
          data['recommendations'] ?? _getDefaultRecommendations(),
      'videoId': data['videoId'] ?? data['id'],
      'createdAt': data['createdAt'],
    };
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> _getDefaultAnalysisResult() {
    return {
      'socialInteraction': 45.0,
      'communication': 50.0,
      'repetitiveBehaviors': 30.0,
      'eyeContact': 60.0,
      'facialExpressions': 55.0,
      'gestures': 40.0,
      'vocalizations': 65.0,
      'overallScore': 48.0,
      'analysisStatus': 'completed',
      'recommendations': _getDefaultRecommendations(),
      'videoId': null,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  List<String> _getDefaultRecommendations() {
    return [
      '✓ Continue monitoring developmental milestones',
      '✓ Encourage social interaction and play',
      '✓ Maintain consistent routines',
      '✓ Consult with pediatrician for concerns',
    ];
  }
}
