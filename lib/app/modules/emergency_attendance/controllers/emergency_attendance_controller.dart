import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bpbd_presence/app/modules/emergency_attendance/provider/emergency_attendance_provider.dart';
import 'package:bpbd_presence/app/routes/app_pages.dart';
import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:bpbd_presence/app/utils/typedef.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EmergencyAttendanceController extends GetxController {
  EmergencyAttendanceController(this._emergencyAttendanceProvider);
  final EmergencyAttendanceProvider _emergencyAttendanceProvider;
  Rx<XFile?> compressedImage = Rx<XFile?>(null);
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool isMockLocation = false.obs;
  RxString address = ''.obs;
  List<Placemark> placemarks = [];

  @override
  void onInit() async {
    await checkLocationChanges();
    super.onInit();
  }

  @override
  onReady() {
    Timer.periodic(Duration(seconds: 2), (timer) {});
    super.onReady();
  }

  Future<void> scanImage() async {
    try {
      final XFile? pictureFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pictureFile == null) {
        print('No image picked');
        return;
      } else {
        print('Image picked: ${pictureFile.path}');
        final String sourcePath = pictureFile.path;
        final String targetPath =
            '${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
        compressedImage.value = await FlutterImageCompress.compressAndGetFile(
          sourcePath,
          targetPath,
          quality: 50,
        );
        update();
        print('Compressed image: ${compressedImage.value!.path}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  emergencyAttendance() async {
    try {
      JSON body = {
        'nip': Get.arguments['nip'],
        'office_id': Get.arguments['office_id'],
        'presence_id': Get.arguments['presence_id'],
        'presence_date': DateTime.now(),
        'latitude': latitude.value,
        'longitude': longitude.value,
        'address': address.value,
      };
      log('Body: $body');
      log('Compressed Image: ${compressedImage.value!.path}');
      final response = await _emergencyAttendanceProvider
          .sendEmergencyAttendance(body, compressedImage.value!);
      log('Response: $response');
      if (response['code'] == 200) {
        Get.rawSnackbar(
          message: 'Berhasil Mengajukan Presensi Darurat',
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

  Future<void> checkLocationChanges() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openAppSettings();
        throw Exception('Location permission is denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('Location permission is permanently denied.');
    }

    // Mulai mendengarkan posisi
    Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      isMockLocation.value = position.isMocked;
      placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // address.value = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      address.value = placemarks[0].street.toString();
      update();
    }, onError: (error) {
      print('Error getting location: $error');
    });

    try {
      Position initialPosition = await Geolocator.getCurrentPosition();
      latitude.value = initialPosition.latitude;
      longitude.value = initialPosition.longitude;
      isMockLocation.value = initialPosition.isMocked;
      placemarks =
          await placemarkFromCoordinates(latitude.value, longitude.value);
      address.value = placemarks[0].street.toString();
      update();
    } catch (e) {
      print('Error getting initial position: $e');
    }
  }
}
