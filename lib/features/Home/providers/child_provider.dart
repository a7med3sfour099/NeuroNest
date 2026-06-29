import 'package:flutter/material.dart';
import 'package:neuronest/features/Home/data/child_model.dart';
import 'package:neuronest/features/Home/data/child_repo.dart';

class ChildProvider extends ChangeNotifier {
  final ChildRepository _repo = ChildRepository();

  bool isLoading = false;

  Future<int?> addChild({
    required String childName,
    required String dateOfBirth,
    required String gender,
    required bool hasJaundice,
    required bool familyASD,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _repo.addChild({
        "childName": childName,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "hasJaundice": hasJaundice,
        "familyASD": familyASD,
      });

      if (response != null) {
        currentChild = ChildModel.fromJson(response);

        notifyListeners();
        return response['childID'];
      }

      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ChildModel? currentChild;

Future<void> loadChild() async {
  currentChild = await _repo.getCurrentChild();

  debugPrint(
    "Current Child => ${currentChild?.childName} (${currentChild?.childID})",
  );

  notifyListeners();
}
}
