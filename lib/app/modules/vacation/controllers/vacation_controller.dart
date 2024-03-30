import 'dart:io';

import 'package:bkd_presence/app/modules/vacation/provider/vacation_provider.dart';
import 'package:bkd_presence/app/routes/app_pages.dart';
import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:bkd_presence/app/utils/typedef.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VacationController extends GetxController {
  VacationController(this._vacationProvider);
  final VacationProvider _vacationProvider;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController reasonController;

  RxString fileName = ''.obs;
  RxBool isLoading = false.obs;
  File? file;

  late DateTime now;
  Future<void> selectStartDate(BuildContext context) async {
    MaterialLocalizations.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
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

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
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

  vacation() async {
    try {
      JSON body = {
        'employee_id': Get.arguments['employee_id'],
        'office_id': Get.arguments['office_id'],
        'presence_id': Get.arguments['presence_id'],
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'reason': reasonController.text,
      };

      final response = await _vacationProvider.sendVacation(body, file);
      if (DateTime.parse(startDateController.text).weekday ==
              DateTime.saturday ||
          DateTime.parse(startDateController.text).weekday == DateTime.sunday ||
          DateTime.parse(endDateController.text).weekday == DateTime.saturday ||
          DateTime.parse(endDateController.text).weekday == DateTime.sunday) {
        Get.rawSnackbar(
          message:
              'Anda Tidak Bisa Mengajukan Perjalanan Dinas Pada Hari Sabtu '
              'Atau Minggu',
          backgroundColor: ColorConstants.redColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
        );
      } else if (file == null) {
        Get.dialog(
          AlertDialog(
            title: const Text('File Surat Dinas Tidak Boleh Kosong'),
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
      } else if (response['code'] == 200) {
        Get.rawSnackbar(
          message: 'Berhasil Mengajukan Cuti',
          backgroundColor: ColorConstants.mainColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(Routes.home);
      } else {
        Get.rawSnackbar(
          message: '${response["message"]}',
          backgroundColor: ColorConstants.redColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  void onInit() {
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    reasonController = TextEditingController();
    super.onInit();
  }
}
