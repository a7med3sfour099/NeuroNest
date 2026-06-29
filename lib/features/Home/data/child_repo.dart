import 'package:flutter/material.dart';
import 'package:neuronest/core/network/api_service.dart';
import 'package:neuronest/features/Home/data/child_model.dart';

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

Future<ChildModel?> getCurrentChild() async {
  try {
    final response = await _api.get("/child");

    debugPrint(response.toString());

    if (response is List && response.isNotEmpty) {
      final lastChild = response.last;

      return ChildModel.fromJson(lastChild);
    }

    return null;
  } catch (e) {
    debugPrint("Error fetching current child: $e");
    return null;
  }
}
}