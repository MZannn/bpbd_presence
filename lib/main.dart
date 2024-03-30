import 'package:bkd_presence/app/binding/global_binding.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id');
  runApp(
    GetMaterialApp(
      title: "BKD Presensi",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.splash,
      getPages: AppPages.routes,
      initialBinding: GlobalBinding(),
    ),
  );
}
