import 'dart:async';
import 'dart:math';

import 'package:bkd_presence/app/models/user_model.dart';
import 'package:bkd_presence/app/modules/home/provider/home_provider.dart';
import 'package:bkd_presence/app/routes/app_pages.dart';
import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:bkd_presence/app/themes/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController with StateMixin<UserModel> {
  final HomeProvider _homeProvider;
  HomeController(this._homeProvider);
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool isWaiting = false.obs;
  RxInt selectedIndex = 0.obs;
  late DateTime now;
  late bool isMockLocation;
  late DateTime clockOut;
  late DateTime maximalLate;
  late DateTime attendanceStartHour;

  late Duration difference;
  late CameraPosition cameraPosition;
  UserModel? user;
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    Position positon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
    return positon;
  }

  Future<bool> mockGpsChecker() async {
    bool isMock = await getUserCurrentLocation().then((value) {
      return value.isMocked;
    });
    return isMockLocation = isMock;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openAppSettings();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }

    return await Geolocator.getCurrentPosition();
  }

  // check distance with haversine formula
  double sphericalLawOfCosines(
      double lat1, double lon1, double lat2, double lon2) {
    var latToRad1 = lat1 * (pi / 180);
    var latToRad2 = lat2 * (pi / 180);
    var lonToRad1 = lon1 * (pi / 180);
    var lonToRad2 = lon2 * (pi / 180);
    var d = acos(sin(latToRad1) * sin(latToRad2) +
        cos(latToRad1) * cos(latToRad2) * cos(lonToRad2 - lonToRad1));
    return d * 6371 * 1000;
  }

  void checkLocationChanges() {
    Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) async {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      try {
        final mock = await mockGpsChecker();
        final userPresence = state?.data?.presences?.first;

        if (userPresence?.attendanceClock == null) {
          final distance = sphericalLawOfCosines(Constants.latitude,
              Constants.longitude, position.latitude, position.longitude);
          final isLate = now.isAfter(Constants.maxAttendanceHour);
          final entryStatus = isLate ? 'TERLAMBAT' : 'HADIR';
          if (distance <= Constants.maxAttendanceDistance &&
              !mock &&
              attendanceStartHour.isAfter(now) &&
              maximalLate.isBefore(now)) {
            if (state != null) {
              change(null, status: RxStatus.loading());
            }
            final presence = await sendAttendanceToServer(
                userPresence!.id!, position, entryStatus);
            change(
              presence,
              status: RxStatus.success(),
            );
            final message =
                isLate ? 'Anda Hadir Terlambat' : 'Anda Hadir Tepat Waktu';

            Get.rawSnackbar(
              message: message,
              backgroundColor: ColorConstants.mainColor,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
              borderRadius: 8,
              duration: const Duration(seconds: 3),
            );
          } else if (mock) {
            Get.rawSnackbar(
              message: 'Anda terdeteksi menggunakan fake GPS',
              backgroundColor: ColorConstants.redColor,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
              borderRadius: 8,
              duration: const Duration(seconds: 3),
            );
          }
        }
      } catch (e) {
        change(null, status: RxStatus.error(e.toString()));
      }
    });
  }

  Future sendAttendanceToServer(
      int id, Position position, String entryStatus) async {
    final attendanceClock = DateFormat('HH:mm:ss').format(now);
    final entryPosition = "${position.latitude}, ${position.longitude}";
    final entryDistance = sphericalLawOfCosines(Constants.latitude,
        Constants.longitude, position.latitude, position.longitude);

    final presence = await _homeProvider.presenceIn(
      id,
      {
        'attendance_clock': attendanceClock,
        'entry_position': entryPosition,
        'entry_distance': entryDistance * 1000, // convert to meter
        'attendance_entry_status': entryStatus,
      },
    );
    return presence;
  }

  presenceOut() async {
    final userPresence = state?.data?.presences?.first;
    final exitDistance = sphericalLawOfCosines(Constants.latitude,
        Constants.longitude, latitude.value, longitude.value);
    var body = {
      "attendance_clock_out": DateFormat('HH:mm:ss').format(now),
      "attendance_exit_status": "HADIR",
      "exit_position": "${latitude.value}, ${longitude.value}",
      "exit_distance": exitDistance,
    };
    try {
      if (userPresence?.attendanceClockOut == null) {
        change(null, status: RxStatus.loading());
        final presence =
            await _homeProvider.presenceOut(userPresence!.id!, body);
        change(presence, status: RxStatus.success());
        Get.rawSnackbar(
          message: 'Presensi keluar berhasil',
          backgroundColor: ColorConstants.mainColor,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.rawSnackbar(
          message: 'Anda sudah melakukan presensi keluar',
          backgroundColor: ColorConstants.redColor,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  getUser() async {
    change(null, status: RxStatus.loading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final user = await _homeProvider.getUsers();
      Constants.latitude = double.parse(user!.data!.user!.office!.latitude!);
      Constants.longitude = double.parse(user.data!.user!.office!.longitude!);
      Constants.maxAttendanceDistance =
          double.parse(user.data!.user!.office!.radius!);
      change(user, status: RxStatus.success());
      this.user = user;

      if (user.data?.user?.deviceId == null && token != null) {
        await _homeProvider.logout();
        prefs.clear();
        Get.dialog(
          AlertDialog(
            title: const Text('Permintaan Penggantian Device Anda Di Setujui'),
            content: const Text(
                'Silahkan Login Kembali Untuk Melanjutkan Penggunaan Aplikasi'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.login);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<String> formatDate(String date) async {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(dateTime);

    return formattedDate;
  }

  Future<DateTime> fetchTime() async {
    var response = await _homeProvider.fetchTime();
    var dateTimeString = response['dateTime'];
    final formattedDateTimeString = dateTimeString.split('.')[0];
    final dateTime = DateTime.parse(formattedDateTimeString);
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final date = formatter.format(dateTime);
    DateTime formattedDateTime = DateTime.parse(date);
    return formattedDateTime;
  }

  Future<void> presenceOutChecker() async {
    await mockGpsChecker();
    var distance = sphericalLawOfCosines(Constants.latitude,
        Constants.longitude, latitude.value, longitude.value);
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      Get.rawSnackbar(
        message: 'Anda tidak dapat melakukan presensi karena ini hari libur',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (state?.data?.presences?.first.attendanceEntryStatus == null) {
      Get.rawSnackbar(
        message: 'Anda belum melakukan presensi masuk',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (now.isBefore(clockOut)) {
      Get.rawSnackbar(
        message:
            'Anda tidak dapat melakukan presensi keluar karena belum jam 15.30',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (isMockLocation == true) {
      Get.rawSnackbar(
        message: 'Anda Terdeteksi Menggunakan Fake GPS',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (isMockLocation == false &&
        now.isAfter(clockOut) &&
        distance <= Constants.maxAttendanceDistance) {
      await presenceOut();
    } else {
      Get.rawSnackbar(
        message: 'Anda Berada Diluar Zona Presensi',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future hourAttendance() async {
    clockOut = DateTime(now.year, now.month, now.day, 15, 30, 0);
    Constants.maxAttendanceHour =
        DateTime(now.year, now.month, now.day, 8, 0, 0);
    maximalLate = DateTime(now.year, now.month, now.day, 8, 45, 0);
    attendanceStartHour = DateTime(now.year, now.month, now.day, 7, 0, 0);
  }

  @override
  void onInit() async {
    isLoading.value = true;
    isWaiting.value = true;
    now = await fetchTime();
    await hourAttendance();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      now = now.add(const Duration(seconds: 1));
    });
    await getUser();
    isWaiting.value = false;
    checkLocationChanges();
    await determinePosition().then((value) async {
      difference = now.difference(value.timestamp!);
      cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
    });
    isLoading.value = false;
    super.onInit();
  }
}
