import 'package:bpbd_presence/app/modules/change_device/provider/change_device_provider.dart';
import 'package:bpbd_presence/app/routes/app_pages.dart';
import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeDeviceController extends GetxController {
  final ChangeDeviceProvider _changeDeviceProvider;
  ChangeDeviceController(this._changeDeviceProvider);
  late TextEditingController reasonController;

  changeDevice() async {
    var body = {
      'nip': Get.arguments[0],
      'office_id': Get.arguments[1],
      'reason': reasonController.text,
    };
    try {
      final changeDevice = await _changeDeviceProvider.changeDevice(body);
      if (changeDevice['code'] == 200) {
        Get.rawSnackbar(
          message: changeDevice['message'],
          backgroundColor: ColorConstants.mainColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(Routes.home);
      } else {
        Get.rawSnackbar(
          message: changeDevice['message'],
          backgroundColor: ColorConstants.redColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    reasonController = TextEditingController();
  }
}
