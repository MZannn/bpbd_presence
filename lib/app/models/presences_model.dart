class PresenceModel {
  PresenceModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int? code;
  String? status;
  String? message;
  Data? data;

  factory PresenceModel.fromJson(Map<String, dynamic> json) => PresenceModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.presences,
  });

  List<Presence>? presences;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        presences: json["presences"] == null
            ? []
            : List<Presence>.from(
                json["presences"]!.map((x) => Presence.fromJson(x))),
      );
}

class Presence {
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

  int? id;
  String? nip;
  String? officeId;
  String? attendanceClock;
  String? attendanceClockOut;
  DateTime? presenceDate;
  String? attendanceEntryStatus;
  String? attendanceExitStatus;
  String? entryPosition;
  String? entryDistance;
  String? exitPosition;
  String? exitDistance;

  factory Presence.fromJson(Map<String, dynamic> json) => Presence(
        id: json["id"],
        nip: json["nip"],
        officeId: json["office_id"],
        attendanceClock: json["attendance_clock"],
        attendanceClockOut: json["attendance_clock_out"],
        presenceDate: json["presence_date"] == null
            ? null
            : DateTime.parse(json["presence_date"]),
        attendanceEntryStatus: json["attendance_entry_status"],
        attendanceExitStatus: json["attendance_exit_status"],
        entryPosition: json["entry_position"],
        entryDistance: json["entry_distance"],
        exitPosition: json["exit_position"],
        exitDistance: json["exit_distance"],
      );
}
