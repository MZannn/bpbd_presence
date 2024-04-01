import 'package:bpbd_presence/app/modules/change_device/provider/change_device_provider.dart';
import 'package:get/get.dart';

import '../controllers/change_device_controller.dart';

class ChangeDeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeDeviceController>(
      () => ChangeDeviceController(Get.find()),
    );
    Get.lazyPut(() => ChangeDeviceProvider(Get.find()));
  }
}
