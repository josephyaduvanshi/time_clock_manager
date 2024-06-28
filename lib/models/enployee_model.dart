import 'dart:convert';

List<EmployeeModel> employeeModelFromMap(String str) =>
    List<EmployeeModel>.from(
        json.decode(str).map((x) => EmployeeModel.fromMap(x, x['userID'])));

String employeeModelToMap(List<EmployeeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class EmployeeModel {
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

  EmployeeModel({
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

  factory EmployeeModel.fromMap(Map<String, dynamic> json, String id) =>
      EmployeeModel(
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

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "dateOfBirth": dateOfBirth,
        "mobileNumber": mobileNumber,
        "store": store != null ? storeValues.reverse[store] : null,
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

class Availability {
  final Fri sun;
  final Fri mon;
  final Fri tue;
  final Fri wed;
  final Fri thu;
  final Fri fri;
  final Fri sat;

  Availability({
    required this.sun,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
  });

  factory Availability.fromMap(Map<String, dynamic> json) => Availability(
        sun: Fri.fromMap(json["SUN"]),
        mon: Fri.fromMap(json["MON"]),
        tue: Fri.fromMap(json["TUE"]),
        wed: Fri.fromMap(json["WED"]),
        thu: Fri.fromMap(json["THU"]),
        fri: Fri.fromMap(json["FRI"]),
        sat: Fri.fromMap(json["SAT"]),
      );

  Map<String, dynamic> toMap() => {
        "SUN": sun.toMap(),
        "MON": mon.toMap(),
        "TUE": tue.toMap(),
        "WED": wed.toMap(),
        "THU": thu.toMap(),
        "FRI": fri.toMap(),
        "SAT": sat.toMap(),
      };
}

class Fri {
  final double start;
  final double finish;

  Fri({
    required this.start,
    required this.finish,
  });

  factory Fri.fromMap(Map<String, dynamic> json) => Fri(
        start: json["start"]?.toDouble() ?? 0.0,
        finish: json["finish"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "start": start,
        "finish": finish,
      };
}

enum EmploymentType { BY_PART_TIME, FULL_TIME }

final employmentTypeValues = EnumValues({
  "BY_PART_TIME": EmploymentType.BY_PART_TIME,
  "FULL_TIME": EmploymentType.FULL_TIME,
});

enum Role { ADMIN, MANAGER, STAFF }

final roleValues = EnumValues({
  "ADMIN": Role.ADMIN,
  "MANAGER": Role.MANAGER,
  "STAFF": Role.STAFF,
});

enum Status { ACTIVE, INACTIVE }

final statusValues = EnumValues({
  "ACTIVE": Status.ACTIVE,
  "INACTIVE": Status.INACTIVE,
});

enum Store { GREENWAY, WESTON }

final storeValues = EnumValues({
  "GREENWAY": Store.GREENWAY,
  "WESTON": Store.WESTON,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
