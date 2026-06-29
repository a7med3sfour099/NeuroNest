class VideoResultModel {
  final int screeningId;
  final int childId;
  final double totalScore;
  final String riskLevel;
  final String message;

  VideoResultModel({
    required this.screeningId,
    required this.childId,
    required this.totalScore,
    required this.riskLevel,
    required this.message,
  });

  factory VideoResultModel.fromJson(Map<String,dynamic> json){
    return VideoResultModel(
      screeningId: json["screeningID"],
      childId: json["childID"],
      totalScore: (json["totalScore"] as num).toDouble(),
      riskLevel: json["riskLevel"],
      message: json["message"] ?? "",
    );
  }
}