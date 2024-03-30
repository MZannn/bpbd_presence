import 'dart:developer';

import 'package:bkd_presence/app/services/api_constant.dart';
import 'package:get/get.dart';

class BaseProvider extends GetConnect {
  @override
  void onInit() {
    log('Api Url: ${ApiConstant.apiUrl}');
    baseUrl = ApiConstant.apiUrl;
    httpClient.baseUrl = ApiConstant.apiUrl;
  }
}
