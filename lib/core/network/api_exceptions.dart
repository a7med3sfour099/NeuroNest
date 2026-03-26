import 'package:dio/dio.dart';
import 'package:firstversion1/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleException(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionTimeout:
        return ApiError(message: 'Bad Connection');
      case DioErrorType.badResponse:
        return ApiError(message: error.toString());
      default:
        return ApiError(message: 'Something went wrong');
    }
  }
}
