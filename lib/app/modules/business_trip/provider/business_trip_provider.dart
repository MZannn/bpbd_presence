import 'dart:io';

import 'package:bpbd_presence/app/services/api_service.dart';
import 'package:bpbd_presence/app/utils/typedef.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class BusinessTripProvider extends GetConnect {
  BusinessTripProvider(this._apiService);
  final ApiService _apiService;
  Future fetchTime() async {
    var response = await get(
        'https://www.timeapi.io/api/Time/current/zone?timeZone=Asia/Jakarta');
    return response.body;
  }

  Future sendBusinessTrip(JSON body, File? file) async {
    final form = FormData({
      'nip': body['nip'],
      'office_id': body['office_id'],
      'presence_id': body['presence_id'],
      'start_date': body['start_date'],
      'end_date': body['end_date'],
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
      endpoint: '/bussiness-trip',
      requiresAuthToken: true,
    );
    return response;
  }
}
