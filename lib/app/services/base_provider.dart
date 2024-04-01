import 'package:bpbd_presence/app/services/api_constant.dart';
import 'package:get/get.dart';

class BaseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstant.apiUrl;
    httpClient.timeout = const Duration(seconds: 10);
  }
}
