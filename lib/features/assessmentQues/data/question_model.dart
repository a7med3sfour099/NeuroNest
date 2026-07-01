class QuestionModel {
  final int questionId;
  final int questionNumber;
  final String questionAr;
  final String questionEn;
  final bool riskIfNo;
  final bool isActive;
  final String category;

  QuestionModel({
    required this.questionId,
    required this.questionNumber,
    required this.questionAr,
    required this.questionEn,
    required this.riskIfNo,
    required this.isActive,
    this.category = 'other',
  });

  factory QuestionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return QuestionModel(
      questionId: json['questionID'],
      questionNumber: json['questionNumber'],
      questionAr: json['questionText_AR'] ?? '',
      questionEn: json['questionText_EN'] ?? '',
      riskIfNo: json['riskIfNo'] ?? false,
      isActive: json['isActive'] ?? false,
      category: json['category'] ?? 'other',
    );
  }
}