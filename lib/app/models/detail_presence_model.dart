class DetailPresenceModel {
  DetailPresenceModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int? code;
  String? status;
  String? message;
  Data? data;

  factory DetailPresenceModel.fromJson(Map<String, dynamic> json) =>
      DetailPresenceModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.detailPresence,
  });

  DetailPresence? detailPresence;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        detailPresence: json["detail_presence"] == null
            ? null
            : DetailPresence.fromJson(json["detail_presence"]),
      );
}

class DetailPresence {
  DetailPresence({
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

  factory DetailPresence.fromJson(Map<String, dynamic> json) => DetailPresence(
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
