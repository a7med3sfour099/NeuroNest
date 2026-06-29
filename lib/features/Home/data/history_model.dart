class HistoryModel {
  final ChildInfo child;
  final HistoryStats stats;
  final List<HistoryItem> history;

  HistoryModel({
    required this.child,
    required this.stats,
    required this.history,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      child: ChildInfo.fromJson(json["child"]),
      stats: HistoryStats.fromJson(json["stats"]),
      history: (json["history"] as List)
          .map((e) => HistoryItem.fromJson(e))
          .toList(),
    );
  }
}

class ChildInfo {
  final int childID;
  final String childName;

  ChildInfo({required this.childID, required this.childName});

  factory ChildInfo.fromJson(Map<String, dynamic> json) {
    return ChildInfo(childID: json["childID"], childName: json["childName"]);
  }
}

class HistoryStats {
  final int total;
  final String? lastAssessmentDate;
  final String currentRiskLevel;

  HistoryStats({
    required this.total,
    this.lastAssessmentDate,
    required this.currentRiskLevel,
  });

  factory HistoryStats.fromJson(Map<String, dynamic> json) {
    return HistoryStats(
      total: json["total"] ?? 0,
      lastAssessmentDate: json["lastAssessmentDate"],
      currentRiskLevel: json["currentRiskLevel"] ?? "N/A",
    );
  }
}

class HistoryItem {
  final int screeningID;
  final String screeningDate;
  final double totalScore;
  final String riskLevel;
  final String status;
  final String screeningType;

  HistoryItem({
    required this.screeningID,
    required this.screeningDate,
    required this.totalScore,
    required this.riskLevel,
    required this.status,
    required this.screeningType,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      screeningID: json["screeningID"],
      screeningDate: json["screeningDate"],
      totalScore: (json["totalScore"] as num).toDouble(),
      riskLevel: json["riskLevel"],
      status: json["status"],
      screeningType: json["screeningType"],
    );
  }
}
