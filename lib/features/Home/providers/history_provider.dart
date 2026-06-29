import 'package:flutter/material.dart';
import '../data/history_model.dart';
import '../data/history_repo.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repo = HistoryRepository();

  bool isLoading = false;

  HistoryModel? history;

Future<void> loadHistory(int childId) async {
  print("Provider childId => $childId");

  isLoading = true;
  notifyListeners();

  history = await _repo.getHistory(childId);

    print("==================================");
  print(history);
  print(history?.stats.total);
  print(history?.stats.currentRiskLevel);
  print(history?.history.length);
  print("==================================");


  isLoading = false;
  notifyListeners();
}
}