class ChildModel {
  final int childID;
  final String childName;
  final String dateOfBirth;
  final String gender;
  final bool hasJaundice;
  final bool familyASD;

  ChildModel({
    required this.childName,
    required this.dateOfBirth,
    required this.gender,
    required this.hasJaundice,
    required this.familyASD, required this.childID,
  });

factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      childID: json['childID'] ?? 0,
      childName: json['childName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      hasJaundice: json['hasJaundice'] ?? false,
      familyASD: json['familyASD'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "childName": childName,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "hasJaundice": hasJaundice,
      "familyASD": familyASD,
    };
  }
}