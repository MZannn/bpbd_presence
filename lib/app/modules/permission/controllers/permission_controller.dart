import 'dart:io';

import 'package:bpbd_presence/app/modules/permission/provider/permission_provider.dart';
import 'package:bpbd_presence/app/routes/app_pages.dart';
import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PermissionController extends GetxController {
  final PermissionProvider _permissionProvider;
  PermissionController(this._permissionProvider);
  RxString fileName = ''.obs;
  File? file;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

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

  Future<void> selectStartDate(BuildContext context) async {
    MaterialLocalizations.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      startDateController.text = formattedDate;
      update();
    } else {
      Get.rawSnackbar(
        message: 'Silahkan Pilih Tanggal',
        backgroundColor: ColorConstants.redColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );
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
      'nip': Get.arguments['nip'],
      'office_id': Get.arguments['office_id'],
      'presence_id': Get.arguments['presence_id'],
      'start_date': startDateController.text,
      'end_date': endDateController.text,
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

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      endDateController.text = formattedDate;
      update();
    } else {
      Get.rawSnackbar(
        message: 'Silahkan Pilih Tanggal',
        backgroundColor: ColorConstants.redColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void onInit() {
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }
}
