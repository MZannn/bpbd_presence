class UserModel {
  int? code;
  String? status;
  String? message;
  Data? data;

  UserModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  User user;
  List<Presence> presences;
  List<dynamic> leaveRules;

  Data({
    required this.user,
    required this.presences,
    required this.leaveRules,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        presences: List<Presence>.from(
            json["presences"].map((x) => Presence.fromJson(x))),
        leaveRules: List<dynamic>.from(json["leaveRules"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "presences": List<dynamic>.from(presences.map((x) => x.toJson())),
        "leaveRules": List<dynamic>.from(leaveRules.map((x) => x)),
      };
}

class Presence {
  int id;
  String nip;
  int officeId;
  String? attendanceClock;
  dynamic attendanceClockOut;
  DateTime presenceDate;
  String? attendanceEntryStatus;
  dynamic attendanceExitStatus;
  String? entryPosition;
  double? entryDistance;
  dynamic exitPosition;
  dynamic exitDistance;

  Presence({
    required this.id,
    required this.nip,
    required this.officeId,
    required this.attendanceClock,
    required this.attendanceClockOut,
    required this.presenceDate,
    required this.attendanceEntryStatus,
    required this.attendanceExitStatus,
    required this.entryPosition,
    required this.entryDistance,
    required this.exitPosition,
    required this.exitDistance,
  });

  factory Presence.fromJson(Map<String, dynamic> json) => Presence(
        id: json["id"],
        nip: json["nip"],
        officeId: json["office_id"],
        attendanceClock: json["attendance_clock"],
        attendanceClockOut: json["attendance_clock_out"],
        presenceDate: DateTime.parse(json["presence_date"]),
        attendanceEntryStatus: json["attendance_entry_status"],
        attendanceExitStatus: json["attendance_exit_status"],
        entryPosition: json["entry_position"],
        entryDistance: json["entry_distance"]?.toDouble(),
        exitPosition: json["exit_position"],
        exitDistance: json["exit_distance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nip": nip,
        "office_id": officeId,
        "attendance_clock": attendanceClock,
        "attendance_clock_out": attendanceClockOut,
        "presence_date":
            "${presenceDate.year.toString().padLeft(4, '0')}-${presenceDate.month.toString().padLeft(2, '0')}-${presenceDate.day.toString().padLeft(2, '0')}",
        "attendance_entry_status": attendanceEntryStatus,
        "attendance_exit_status": attendanceExitStatus,
        "entry_position": entryPosition,
        "entry_distance": entryDistance,
        "exit_position": exitPosition,
        "exit_distance": exitDistance,
      };
}

class User {
  String nip;
  String name;
  String position;
  String phoneNumber;
  dynamic profilePhotoPath;
  String deviceId;
  int officeId;
  Office office;

  User({
    required this.nip,
    required this.name,
    required this.position,
    required this.phoneNumber,
    required this.profilePhotoPath,
    required this.deviceId,
    required this.officeId,
    required this.office,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        nip: json["nip"],
        name: json["name"],
        position: json["position"],
        phoneNumber: json["phone_number"],
        profilePhotoPath: json["profile_photo_path"],
        deviceId: json["device_id"],
        officeId: int.parse(json["office_id"]),
        office: Office.fromJson(json["office"]),
      );

  Map<String, dynamic> toJson() => {
        "nip": nip,
        "name": name,
        "position": position,
        "phone_number": phoneNumber,
        "profile_photo_path": profilePhotoPath,
        "device_id": deviceId,
        "office_id": officeId,
        "office": office.toJson(),
      };
}

class Office {
  int id;
  String name;
  String address;
  double latitude;
  double longitude;
  double radius;
  String startWork;
  String startBreak;
  String lateTolerance;
  String endWork;

  Office({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.startWork,
    required this.startBreak,
    required this.lateTolerance,
    required this.endWork,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        radius: double.parse(json["radius"]),
        startWork: json["start_work"],
        startBreak: json["start_break"],
        lateTolerance: json["late_tolerance"],
        endWork: json["end_work"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
        "start_work": startWork,
        "start_break": startBreak,
        "late_tolerance": lateTolerance,
        "end_work": endWork,
      };
}
