import 'dart:math' as math;
import 'dart:developer';
import 'dart:async';

import 'package:bpbd_presence/app/models/user_model.dart';
import 'package:bpbd_presence/app/modules/home/provider/home_provider.dart';
import 'package:bpbd_presence/app/routes/app_pages.dart';
import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:bpbd_presence/app/themes/constants.dart';
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
  Rx<DateTime> now = DateTime.now().obs;

  RxBool isMockLocation = false.obs;
  late DateTime clockOut;
  late DateTime maximalLate;
  late DateTime attendanceStartHour;

  late CameraPosition cameraPosition;
  UserModel? user;
  // mengecek posisi user
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
    double ladToRad1 = math.pi * lat1 / 180;
    double ladToRad2 = math.pi * lat2 / 180;
    double lonToRad1 = math.pi * lon1 / 180;
    double lonToRad2 = math.pi * lon2 / 180;

    var sloc = math.acos(math.sin(ladToRad1) * math.sin(ladToRad2) +
            math.cos(ladToRad1) *
                math.cos(ladToRad2) *
                math.cos(lonToRad1 - lonToRad2)) *
        6371;
    var distance = sloc; //convert to meter
    return distance;
  }

  checkLocationChanges() {
    Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) async {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      isMockLocation.value = position.isMocked;
      cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
      );
      log('latitude ${latitude.value}');
      log('longitude ${longitude.value}');
      try {
        final userPresence = state?.data?.presences?.first;
        log('${userPresence?.attendanceClock == null}');
        if (userPresence?.attendanceClock == null) {
          final distance = sphericalLawOfCosines(
              state!.data!.user!.office!.latitude!,
              state!.data!.user!.office!.longitude!,
              position.latitude,
              position.longitude);
          log('distance $distance');
          log('radius ${state!.data!.user!.office!.radius!}');
          log('ini ${distance <= state!.data!.user!.office!.radius!}');
          final isLate = now.value.isAfter(maximalLate);
          final entryStatus = isLate ? 'TERLAMBAT' : 'HADIR';
          if (distance <= state!.data!.user!.office!.radius! &&
              isMockLocation.value == false &&
              now.value.isAfter(attendanceStartHour) &&
              now.value.isBefore(maximalLate)) {
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
          } else if (isMockLocation.value == true) {
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

  // send attendance in to server
  Future sendAttendanceToServer(
      int id, Position position, String entryStatus) async {
    final attendanceClock = DateFormat('HH:mm:ss').format(now.value);
    final entryPosition = "${position.latitude}, ${position.longitude}";
    final entryDistance = sphericalLawOfCosines(
        state!.data!.user!.office!.latitude!,
        state!.data!.user!.office!.longitude!,
        position.latitude,
        position.longitude);

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

  // send attendance out to server
  presenceOut() async {
    final userPresence = state?.data?.presences?.first;
    final exitDistance = sphericalLawOfCosines(
        state!.data!.user!.office!.latitude!,
        state!.data!.user!.office!.longitude!,
        latitude.value,
        longitude.value);
    var body = {
      "attendance_clock_out": DateFormat('HH:mm:ss').format(now.value),
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

  // get user data
  getUser() async {
    change(null, status: RxStatus.loading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final user = await _homeProvider.getUsers();
      change(user, status: RxStatus.success());
      this.user = user;
      if (user!.data?.user?.deviceId == null && token != null) {
        await _homeProvider.logout();
        change(null, status: RxStatus.error('Device Id Tidak Ditemukan'));
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

  // format date to indonesian format
  Future<String> formatDate(String date) async {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(dateTime);

    return formattedDate;
  }

  // format time to indonesian format
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

  // presence in checker
  Future<void> presenceOutChecker() async {
    var distance = sphericalLawOfCosines(state!.data!.user!.office!.latitude!,
        state!.data!.user!.office!.longitude!, latitude.value, longitude.value);
    if (now.value.weekday == DateTime.saturday ||
        now.value.weekday == DateTime.sunday) {
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
    } else if (state?.data?.presences?.first.attendanceExitStatus != null) {
      Get.rawSnackbar(
        message: 'Anda sudah melakukan presensi keluar',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (now.value.isBefore(clockOut)) {
      final dateFormat = DateFormat('HH:mm').format(clockOut);
      Get.rawSnackbar(
        message:
            'Anda tidak dapat melakukan presensi keluar karena belum jam $dateFormat',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (isMockLocation.value == true) {
      Get.rawSnackbar(
        message: 'Anda Terdeteksi Menggunakan Fake GPS',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (isMockLocation.value == false &&
        now.value.isAfter(clockOut) &&
        distance <= state!.data!.user!.office!.radius!) {
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

  // parsing hour attendance
  Future hourAttendance() async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    var today = dateFormat.format(now.value);
    log('${state!.data!.user!.office!.startWork}');
    DateTime startHour =
        DateTime.parse('$today ${state?.data!.user!.office!.startWork!}');
    DateTime startBreakHour =
        DateTime.parse('$today ${state?.data!.user!.office!.startBreak!}');
    DateTime lateTolerance =
        DateTime.parse('$today ${state?.data!.user!.office!.lateTolerance!}');
    DateTime endHour =
        DateTime.parse('$today ${state?.data!.user!.office!.endWork!}');
    attendanceStartHour = DateTime(now.value.year, now.value.month,
        now.value.day, startHour.hour, startHour.minute, startHour.second);
    Constants.maxAttendanceHour = DateTime(
        now.value.year,
        now.value.month,
        now.value.day,
        startBreakHour.hour,
        startBreakHour.minute,
        startBreakHour.second);
    maximalLate = DateTime(now.value.year, now.value.month, now.value.day,
        lateTolerance.hour, lateTolerance.minute, lateTolerance.second);
    clockOut = DateTime(now.value.year, now.value.month, now.value.day,
        endHour.hour, endHour.minute, endHour.second);
  }

  @override
  void onInit() async {
    isLoading.value = true;
    await getUser();
    now.value = await fetchTime();
    log("now ${now.value}");
    await hourAttendance();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      now.value = now.value.add(const Duration(seconds: 1));
    });
    checkLocationChanges();
    await determinePosition().then((value) {
      cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
    });
    isLoading.value = false;
    super.onInit();
  }
}
