import 'dart:io';

import 'package:bkd_presence/app/services/api_service.dart';
import 'package:bkd_presence/app/utils/typedef.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class VacationProvider {
  VacationProvider(this._apiService);
  final ApiService _apiService;

  Future sendVacation(JSON body, File? file) async {
    final form = FormData({
      'employee_id': body['employee_id'],
      'office_id': body['office_id'],
      'presence_id': body['presence_id'],
      'start_date': body['start_date'],
      'end_date': body['end_date'],
      'reason': body['reason'],
    });
    if (file != null) {
      form.files.add(
        MapEntry(
          'file',
          MultipartFile(
            file.path,
            filename: basename(file.path),
          ),
        ),
      );
    }

    final response = await _apiService.post(
      body: form,
      endpoint: '/vacation',
      requiresAuthToken: true,
    );
    return response;
  }
}
