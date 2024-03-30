import 'package:bkd_presence/app/modules/home/provider/home_provider.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
    Get.lazyPut(() => HomeProvider(Get.find()));
  }
}
