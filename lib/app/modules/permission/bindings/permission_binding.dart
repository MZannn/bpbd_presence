import 'package:bpbd_presence/app/modules/permission/provider/permission_provider.dart';
import 'package:get/get.dart';

import '../controllers/permission_controller.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionController>(
      () => PermissionController(Get.find()),
    );
    Get.lazyPut(() => PermissionProvider(Get.find()));
  }
}
