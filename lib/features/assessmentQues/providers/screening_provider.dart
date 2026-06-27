import 'package:flutter/material.dart';
import 'package:neuronest/features/assessmentQues/data/screening_repo.dart';

class ScreeningProvider extends ChangeNotifier {
  final ScreeningRepository _repo =
      ScreeningRepository();

  bool isLoading = false;

  int? screeningId;
  int? childId;

  Future<int?> createScreening(
    int childId,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      this.childId = childId;

      final id =
          await _repo.createScreening(childId);

      screeningId = id;

      return id;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<Map<String, dynamic>?> submitAnswers(
  List<int> answers,
) async {
  print('PROVIDER SCREENING ID => $screeningId');
  print('PROVIDER CHILD ID => $childId');

  if (screeningId == null || childId == null) {
    print('SCREENING OR CHILD ID IS NULL');
    return null;
  }

  return await _repo.submitAnswers(
    screeningId: screeningId!,
    childId: childId!,
    answers: answers,
  );
}
}