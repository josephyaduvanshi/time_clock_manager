class UserModel {
  final String? userID;
  final String name;
  final String email;
  final String? role;
  final String? photoUrl;
  final String? status;

  UserModel({
    this.userID,
    this.photoUrl,
    required this.name,
    required this.email,
    this.role,
    this.status,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      status: map['status'],
      photoUrl: map['photoUrl'],
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      status: map['status'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'name': name,
        'email': email,
        'role': role,
        'status': status ?? '',
        'photoUrl': photoUrl,
      };
}
