import 'package:bpbd_presence/app/modules/vacation/provider/vacation_provider.dart';
import 'package:get/get.dart';

import '../controllers/vacation_controller.dart';

class VacationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VacationController>(
      () => VacationController(Get.find()),
    );
    Get.lazyPut(() => VacationProvider(Get.find()));
  }
}
