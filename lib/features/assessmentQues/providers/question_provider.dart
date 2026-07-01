import 'package:flutter/material.dart';
import 'package:neuronest/features/assessmentQues/data/question_model.dart';
import 'package:neuronest/features/assessmentQues/data/question_repo.dart';

class QuestionProvider extends ChangeNotifier {
  final QuestionRepository _repo = QuestionRepository();

  bool isLoading = false;

  List<QuestionModel> questions = [];

  String currentLanguage = 'en';

  Future<void> loadQuestions() async {
    isLoading = true;
    notifyListeners();

    try {
      questions = await _repo.getQuestions();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void setLanguage(String langCode) {
    if (currentLanguage != langCode) {
      currentLanguage = langCode;
      notifyListeners();
    }
  }
}