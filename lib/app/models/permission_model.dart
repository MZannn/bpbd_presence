class PermissionModel {
  PermissionModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int? code;
  String? status;
  String? message;
  Data? data;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.nip,
    this.officeId,
    this.presenceId,
    this.date,
    this.file,
    this.id,
  });

  String? nip;
  String? officeId;
  String? presenceId;
  DateTime? date;
  String? file;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        nip: json["nip"],
        officeId: json["office_id"],
        presenceId: json["presence_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        file: json["file"],
        id: json["id"],
      );
}
