import 'package:bpbd_presence/app/modules/bussiness_trip/provider/bussiness_trip_provider.dart';
import 'package:get/get.dart';

import '../controllers/bussiness_trip_controller.dart';

class BussinessTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BussinessTripController>(
      () => BussinessTripController(Get.find()),
    );
    Get.lazyPut(() => BussinessTripProvider(Get.find()));
  }
}
