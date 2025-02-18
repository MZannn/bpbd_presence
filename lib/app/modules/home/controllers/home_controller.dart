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
      log('timenow ${now.value}');
      log("ABSEN");
      try {
        final isPresenceEmpty = state?.data?.presences?.isEmpty ?? true;
        if (isPresenceEmpty) {
          return;
        } else {
          final userPresence = state?.data?.presences?.first;
          log('${userPresence?.attendanceClock == null}');
          if (userPresence?.attendanceClock == null) {
            presence();
          }
        }
      } catch (e) {
        log(e.toString());
      }
    });
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

  // send attendance in to server
  Future sendAttendanceToServer(
      int id, double latitude, double longitude, String entryStatus) async {
    final attendanceClock = DateFormat('HH:mm:ss').format(now.value);
    final entryPosition = "$latitude, $longitude";
    final entryDistance = sphericalLawOfCosines(
        Constants.latitude, Constants.longitude, latitude, longitude);

    final presence = await _homeProvider.presenceIn(
      id,
      {
        'attendance_clock': attendanceClock,
        'entry_position': entryPosition,
        'entry_distance': entryDistance * 1000, // convert to meter
        'attendance_entry_status': entryStatus,
      },
    );
    if (presence!.code == 200) {
      var user = getUser();
      change(user, status: RxStatus.success());
    }
    return presence;
  }

  // send attendance out to server
  presenceOut() async {
    final userPresence = state?.data?.presences?.first;
    final exitDistance = sphericalLawOfCosines(Constants.latitude,
        Constants.longitude, latitude.value, longitude.value);
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
        if (presence!.code == 200) {
          var user = getUser();
          change(user, status: RxStatus.success());
        }
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
      log(e.toString());
    }
  }

  // get user data
  getUser() async {
    change(null, status: RxStatus.loading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final user = await _homeProvider.getUsers();
      if (user?.data?.user?.office != null) {
        Constants.latitude = double.parse(user!.data!.user!.office!.latitude!);
        Constants.longitude = double.parse(user.data!.user!.office!.longitude!);
        Constants.maxAttendanceDistance =
            double.parse(user.data!.user!.office!.radius!);
      }
      change(user, status: RxStatus.success());
      this.user = user;
      log('user ${user?.data?.user!.deviceId}');
      if (user?.data?.user?.deviceId == null && token != null) {
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
    var distance = sphericalLawOfCosines(Constants.latitude,
        Constants.longitude, latitude.value, longitude.value);
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

  Future<void> presenceInChecker() async {
    var distance = sphericalLawOfCosines(Constants.latitude,
        Constants.longitude, latitude.value, longitude.value);
    if (isMockLocation.value == false &&
        now.value.isAfter(attendanceStartHour) &&
        now.value.isBefore(maximalLate) &&
        distance <= Constants.maxAttendanceDistance &&
        state?.data?.presences?.first.attendanceClock == null) {
      var isLate = now.value.isAfter(maximalLate) ? 'TERLAMBAT' : 'HADIR';
      sendAttendanceToServer(state!.data!.presences!.first.id!, latitude.value,
          longitude.value, isLate);
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

  void presence() async {
    var distance = sphericalLawOfCosines(Constants.latitude,
        Constants.longitude, latitude.value, longitude.value);
    if (isMockLocation.value == false &&
        now.value.isAfter(attendanceStartHour) &&
        now.value.isBefore(maximalLate) &&
        distance <= Constants.maxAttendanceDistance &&
        state?.data?.presences?.first.attendanceClock == null) {
      await presenceInChecker();
    } else if (state?.data?.presences?.first.attendanceClock != null &&
        now.value.isAfter(clockOut) &&
        state?.data?.presences?.first.attendanceClockOut == null &&
        distance <= Constants.maxAttendanceDistance &&
        isMockLocation.value == false) {
      await presenceOutChecker();
    } else if (now.value.weekday == DateTime.saturday ||
        now.value.weekday == DateTime.sunday) {
      Get.rawSnackbar(
        message: 'Anda tidak dapat melakukan presensi karena ini hari libur',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (state?.data?.presences?.first.attendanceClock == null &&
        now.value.isBefore(attendanceStartHour)) {
      final dateFormat = DateFormat('HH:mm').format(attendanceStartHour);
      Get.rawSnackbar(
        message:
            'Anda tidak dapat melakukan presensi masuk karena belum jam $dateFormat',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (state?.data?.presences?.first.attendanceClock == null &&
        now.value.isAfter(maximalLate) &&
        now.value.isBefore(clockOut)) {
      final dateFormat = DateFormat('HH:mm').format(maximalLate);
      Get.rawSnackbar(
        message:
            'Anda tidak dapat melakukan presensi masuk karena sudah melewati jam toleransi keterlambatan pada jam $dateFormat',
        backgroundColor: ColorConstants.redColor,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else if (state?.data?.presences?.first.attendanceClock == null &&
        now.value.isAfter(maximalLate)) {
      final dateFormat = DateFormat('HH:mm').format(maximalLate);
      Get.rawSnackbar(
        message:
            'Anda tidak dapat melakukan presensi masuk karena sudah melewati jam toleransi keterlambatan pada jam $dateFormat',
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
    } else if (state?.data?.presences?.first.attendanceClock != null &&
        now.value.isBefore(clockOut)) {
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
    }
  }

  @override
  void onInit() async {
    isLoading.value = true;
    try {
      await getUser();
      now.value = await fetchTime();
      log("now ${now.value}");
      await hourAttendance();
      Timer.periodic(const Duration(seconds: 1), (timer) {
        now.value = now.value.add(const Duration(seconds: 1));
      });
      await checkLocationChanges();
      await determinePosition().then((value) {
        cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14,
        );
      });
    } catch (e) {
      log("Error during initialization: $e");
    } finally {
      isLoading.value = false;
    }
    super.onInit();
  }
}
