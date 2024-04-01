import 'package:bpbd_presence/app/modules/login/provider/login_provider.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find()),
    );
    Get.lazyPut(() => LoginProvider(Get.find()));
  }
}
