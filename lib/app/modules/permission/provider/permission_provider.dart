import 'dart:io';

import 'package:bkd_presence/app/services/api_service.dart';
import 'package:bkd_presence/app/utils/typedef.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class PermissionProvider {
  final ApiService _apiService;
  PermissionProvider(this._apiService);

  Future permission(JSON body, File file) async {
    final form = FormData({
      'employee_id': body['employee_id'],
      'office_id': body['office_id'],
      'presence_id': body['presence_id'],
      'date': body['date'],
    });
    form.files.add(
      MapEntry(
        'file',
        MultipartFile(
          file.path,
          filename: basename(file.path),
        ),
      ),
    );
    final response = await _apiService.post(
      endpoint: '/permission-and-sick',
      body: form,
      requiresAuthToken: true,
    );

    return response;
  }
}
