import 'dart:async';

import 'package:bpbd_presence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  SharedPreferences? prefs;

  @override
  void onReady() async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs!.getString('token');
    print('token: $token');
    Future.delayed(const Duration(seconds: 1, milliseconds: 15), () async {
      if (token == null) {
        Get.offAllNamed(Routes.login);
      } else {
        Get.offAllNamed(Routes.home);
      }
    });
    super.onReady();
  }
}
