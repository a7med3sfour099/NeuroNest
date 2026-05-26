import 'package:dio/dio.dart';
import 'package:firstversion1/core/network/api_exceptions.dart';
import 'package:firstversion1/core/network/dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  /// CRUD METHODS

  /// get
  Future<dynamic> get(String endPoint) async {
    try {
      final response = await _dioClient.dio.get(endPoint);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleException(e);
    }
  }

  /// post

  Future<dynamic> post(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.post(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleException(e);
    }
  }

  /// put || update

  Future<dynamic> put(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.put(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleException(e);
    }
  }



  /// delete

  Future<dynamic> delete(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.delete(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleException(e);
    }
  }




}
