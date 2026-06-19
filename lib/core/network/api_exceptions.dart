import 'package:dio/dio.dart';
import 'package:neuronest/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: 'Connection timeout');

      case DioExceptionType.badResponse:
        print('=======================');
        print('STATUS CODE => ${error.response?.statusCode}');
        print('ERROR DATA => ${error.response?.data}');
        print('=======================');
        final data = error.response?.data;

        String message = 'Server Error';

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? 'Server Error';
        } else if (data is String) {
          message = data;
        }

        return ApiError(
          statusCode: error.response?.statusCode,
          message: message,
        );

      default:
        return ApiError(message: 'Something went wrong');
    }
  }
}
