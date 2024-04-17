import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EmergencyAttendanceController extends GetxController {
  Rx<XFile?> compressedImage = Rx<XFile?>(null);
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool isMockLocation = false.obs;

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

  void sendEmergencyAttendance() {}

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
    ).listen((Position position) {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      isMockLocation.value = position.isMocked;
      update();
    }, onError: (error) {
      print('Error getting location: $error');
    });

    // Dapatkan posisi awal
    try {
      Position initialPosition = await Geolocator.getCurrentPosition();
      latitude.value = initialPosition.latitude;
      longitude.value = initialPosition.longitude;
      isMockLocation.value = initialPosition.isMocked;
      update();
    } catch (e) {
      print('Error getting initial position: $e');
    }
  }
}
