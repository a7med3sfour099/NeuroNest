import 'package:flutter/material.dart';
import 'package:neuronest/core/network/api_service.dart';

class ChildRepository {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>?> addChild(
    Map<String, dynamic> body,
  ) async {
    final response =
        await _api.post('/child', body);

        debugPrint(response.toString());
        

    if (response is Map<String, dynamic>) {
      return response;
    }
    return null;
  }
}