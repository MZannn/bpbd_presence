import 'dart:io';

import 'package:bkd_presence/app/modules/permission/provider/permission_provider.dart';
import 'package:bkd_presence/app/routes/app_pages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionController extends GetxController {
  final PermissionProvider _permissionProvider;
  PermissionController(this._permissionProvider);
  RxString fileName = ''.obs;
  File? file;

  Future pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
      );
      if (result != null) {
        file = File(result.files.single.path!);
        fileName.value = result.files.single.name;
        final fileSize = await file!.length();

        if (fileSize > 2 * 1024 * 1024) {
          await file!.delete();
          fileName.value = '';
          Get.dialog(
            AlertDialog(
              title: const Text('Ukuran File Terlalu Besar'),
              content: const Text('Ukuran File Tidak Boleh Lebih Dari 2 MB'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      e.toString();
    }
  }

  delete() async {
    try {
      await file!.delete();
      file = null;
      fileName.value = '';
    } catch (e) {
      e.toString();
    }
  }

  Future sendPermission() async {
    var body = {
      'employee_id': Get.arguments['employee_id'],
      'office_id': Get.arguments['office_id'],
      'presence_id': Get.arguments['presence_id'],
      'date': Get.arguments['date'],
    };
    try {
      if (file == null) {
        Get.dialog(
          AlertDialog(
            title: const Text('File Tidak Boleh Kosong'),
            content: const Text('Silahkan Pilih File'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        var response = await _permissionProvider.permission(body, file!);
        if (response['code'] == 200) {
          Get.dialog(
            barrierDismissible: false,
            AlertDialog(
              title: const Text('Berhasil'),
              content: Text(response['message'].toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.home);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          Get.dialog(
            barrierDismissible: false,
            AlertDialog(
              title: const Text('Gagal'),
              content: Text(response['message'].toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      e.toString();
    }
  }
}
