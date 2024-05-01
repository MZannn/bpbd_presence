import 'dart:developer';
import 'dart:io';

import 'package:bpbd_presence/app/services/api_service.dart';
import 'package:bpbd_presence/app/utils/typedef.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class EmergencyAttendanceProvider extends GetConnect {
  EmergencyAttendanceProvider(this._apiService);
  final ApiService _apiService;
  Future fetchTime() async {
    var response = await get(
        'https://www.timeapi.io/api/Time/current/zone?timeZone=Asia/Jakarta');
    return response.body;
  }

  Future sendEmergencyAttendance(JSON body, XFile? file) async {
    final form = FormData({
      'nip': body['nip'],
      'office_id': body['office_id'],
      'presence_id': body['presence_id'],
      'presence_date': body['presence_date'],
    });
    if (file != null) {
      form.files.add(
        MapEntry(
          'image',
          MultipartFile(
            file.path,
            filename: basename(file.path),
          ),
        ),
      );
    }

    final response = await _apiService.post(
      body: form,
      endpoint: '/emergency-presence',
      requiresAuthToken: true,
    );
    log('Response: $response');
    return response;
  }
}
