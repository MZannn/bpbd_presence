import 'package:bpbd_presence/app/modules/emergency_attendance/provider/emergency_attendance_provider.dart';
import 'package:get/get.dart';

import '../controllers/emergency_attendance_controller.dart';

class EmergencyAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmergencyAttendanceController>(
      () => EmergencyAttendanceController(Get.find()),
    );
    Get.lazyPut(() => EmergencyAttendanceProvider(Get.find()));
  }
}
