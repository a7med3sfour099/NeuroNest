class UserModel {
  final String name;
  final String email;
  final String? image;
  final String? token;
  final String? address;

  UserModel({
    required this.name,
    required this.email,
    this.image,
    this.token,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      token: json['token'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'token': token,
      'address': address,
    };
  }

  /// Create a copy with modifications
  UserModel copyWith({
    String? name,
    String? email,
    String? image,
    String? token,
    String? address,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      token: token ?? this.token,
      address: address ?? this.address,
    );
  }
}
