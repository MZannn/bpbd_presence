import 'package:bpbd_presence/app/modules/splash/controllers/splash_controller.dart';
import 'package:bpbd_presence/app/services/api_service.dart';
import 'package:bpbd_presence/app/services/base_provider.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseProvider(), permanent: true);
    Get.put(ApiService(Get.find()), permanent: true);
    Get.put(SplashController());
  }
}
