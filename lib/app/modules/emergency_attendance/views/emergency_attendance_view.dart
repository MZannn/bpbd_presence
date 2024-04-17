import 'dart:io';

import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:bpbd_presence/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/emergency_attendance_controller.dart';

class EmergencyAttendanceView extends GetView<EmergencyAttendanceController> {
  const EmergencyAttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Presensi Darurat',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => controller.compressedImage.value == null
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Image.file(
                          File(controller.compressedImage.value!.path),
                          width: Get.width * 0.8,
                          height: Get.height * 0.5,
                        ),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.scanImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.greyColor,
              ),
              child: const Text('Ambil Gambar'),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                'Latitude: ${controller.latitude.value}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Obx(
              () => Text(
                'Longitude: ${controller.longitude.value}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ElevatedButton(
          onPressed: () {controller.sendEmergencyAttendance();},
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.mainColor,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text(
            'Kirim',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
