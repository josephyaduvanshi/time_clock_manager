import 'enployee_model.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? dateOfBirth;
  final String? mobileNumber;
  final Store? store;
  final String avatar;
  final Role role;
  final Status status;
  final String username;
  final Availability? availability;
  final double baseRate;
  final EmploymentType employmentType;

  final String pin;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.dateOfBirth,
    this.mobileNumber,
    this.store,
    required this.avatar,
    required this.role,
    required this.status,
    required this.username,
    this.availability,
    required this.baseRate,
    required this.employmentType,
    required this.pin,
  });

  factory UserModel.fromMap(Map<String, dynamic> json, String id) => UserModel(
        id: id,
        email: json["email"] ?? '',
        name: json["name"] ?? '',
        dateOfBirth: json["dateOfBirth"],
        mobileNumber: json["mobileNumber"],
        store: json["store"] != null ? storeValues.map[json["store"]] : null,
        avatar: json["avatar"] ?? '',
        role: roleValues.map[json["role"]] ?? Role.STAFF,
        status: statusValues.map[json["status"]] ?? Status.ACTIVE,
        username: json["username"] ?? '',
        availability: json["availability"] != null
            ? Availability.fromMap(json["availability"])
            : null,
        baseRate: json["base_rate"] != null
            ? (json["base_rate"] as num).toDouble()
            : 0.0,
        employmentType: employmentTypeValues.map[json["employmentType"]] ??
            EmploymentType.BY_PART_TIME,
        pin: json["pin"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "dateOfBirth": dateOfBirth,
        "mobileNumber": mobileNumber,
        "store": storeValues.reverse[store],
        "avatar": avatar,
        "role": roleValues.reverse[role],
        "status": statusValues.reverse[status],
        "username": username,
        "availability": availability?.toMap(),
        "base_rate": baseRate,
        "employmentType": employmentTypeValues.reverse[employmentType],
        "pin": pin,
      };
}
