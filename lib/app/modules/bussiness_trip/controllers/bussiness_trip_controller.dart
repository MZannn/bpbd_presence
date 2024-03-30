import 'dart:io';

import 'package:bkd_presence/app/modules/bussiness_trip/provider/bussiness_trip_provider.dart';
import 'package:bkd_presence/app/routes/app_pages.dart';
import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:bkd_presence/app/utils/typedef.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BussinessTripController extends GetxController {
  BussinessTripController(this._bussinessTripProvider);
  final BussinessTripProvider _bussinessTripProvider;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
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

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      String formattedTime = DateFormat("HH:mm:ss").format(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
      startTimeController.text = formattedTime;
      update();
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      String formattedTime = DateFormat("HH:mm:ss").format(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
      endTimeController.text = formattedTime;
      update();
    }
  }

  Future<DateTime> fetchTime() async {
    var response = await _bussinessTripProvider.fetchTime();
    var dateTimeString = response['dateTime'];
    final formattedDateTimeString = dateTimeString.split('.')[0];
    final dateTime = DateTime.parse(formattedDateTimeString);
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final date = formatter.format(dateTime);
    DateTime formattedDateTime = DateTime.parse(date);
    return formattedDateTime;
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

  bussinessTrip() async {
    try {
      JSON body = {
        'employee_id': Get.arguments['employee_id'],
        'office_id': Get.arguments['office_id'],
        'presence_id': Get.arguments['presence_id'],
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'start_time': startTimeController.text,
        'end_time': endTimeController.text,
      };

      final response =
          await _bussinessTripProvider.sendBusinessTrip(body, file);
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
          message: 'Berhasil Melakukan Presensi Darurat',
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
  void onInit() async {
    isLoading.value = true;
    now = await fetchTime();
    startDateController = TextEditingController(text: "");
    endDateController = TextEditingController(text: "");
    startTimeController = TextEditingController(text: "");
    endTimeController = TextEditingController(text: "");
    super.onInit();
    isLoading.value = false;
  }
}
