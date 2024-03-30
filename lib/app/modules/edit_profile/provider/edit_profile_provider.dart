import 'dart:io';

import 'package:bkd_presence/app/models/user_model.dart';
import 'package:bkd_presence/app/services/api_service.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class EditProfileProvider {
  final ApiService _apiService;
  EditProfileProvider(this._apiService);

  Future<UserModel?> editProfile(String phoneNumber, File? file) async {
    final form = FormData({
      'phone_number': phoneNumber,
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
      endpoint: '/user',
      body: form,
      requiresAuthToken: true,
    );
    return UserModel.fromJson(response);
  }
}
