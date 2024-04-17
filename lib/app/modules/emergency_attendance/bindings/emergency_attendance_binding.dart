import 'package:get/get.dart';

import '../controllers/emergency_attendance_controller.dart';

class EmergencyAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmergencyAttendanceController>(
      () => EmergencyAttendanceController(),
    );
  }
}
