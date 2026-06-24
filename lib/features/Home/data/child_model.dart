class ChildModel {
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
    required this.familyASD,
  });

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