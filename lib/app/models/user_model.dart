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
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  User? user;
  List<Presence>? presences;
  List<dynamic>? leaveRules;

  Data({
    this.user,
    this.presences,
    this.leaveRules,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        presences: json["presences"] == null
            ? []
            : List<Presence>.from(
                json["presences"]!.map((x) => Presence.fromJson(x))),
        leaveRules: json["leaveRules"],
      );
}

class Presence {
  int? id;
  String? nip;
  int? officeId;
  String? attendanceClock;
  String? attendanceClockOut;
  DateTime? presenceDate;
  String? attendanceEntryStatus;
  String? attendanceExitStatus;
  String? entryPosition;
  double? entryDistance;
  String? exitPosition;
  double? exitDistance;

  Presence({
    this.id,
    this.nip,
    this.officeId,
    this.attendanceClock,
    this.attendanceClockOut,
    this.presenceDate,
    this.attendanceEntryStatus,
    this.attendanceExitStatus,
    this.entryPosition,
    this.entryDistance,
    this.exitPosition,
    this.exitDistance,
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
        entryDistance: json["entry_distance"],
        exitPosition: json["exit_position"],
        exitDistance: json["exit_distance"],
      );
}

class User {
  String? nip;
  String? name;
  String? position;
  String? phoneNumber;
  dynamic profilePhotoPath;
  String? deviceId;
  int? officeId;
  Office? office;

  User({
    this.nip,
    this.name,
    this.position,
    this.phoneNumber,
    this.profilePhotoPath,
    this.deviceId,
    this.officeId,
    this.office,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        nip: json["nip"],
        name: json["name"],
        position: json["position"],
        phoneNumber: json["phone_number"],
        profilePhotoPath: json["profile_photo_path"],
        deviceId: json["device_id"],
        officeId: json["office_id"],
        office: json["office"] == null ? null : Office.fromJson(json["office"]),
      );
}

class Office {
  int? id;
  String? name;
  String? address;
  double? latitude;
  double? longitude;
  double? radius;
  String? startWork;
  String? startBreak;
  String? lateTolerance;
  String? endWork;

  Office({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.radius,
    this.startWork,
    this.startBreak,
    this.lateTolerance,
    this.endWork,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        radius: json["radius"],
        startWork: json["start_work"],
        startBreak: json["start_break"],
        lateTolerance: json["late_tolerance"],
        endWork: json["end_work"],
      );
}
