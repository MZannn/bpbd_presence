import 'package:bpbd_presence/app/modules/business_trip/provider/business_trip_provider.dart';
import 'package:get/get.dart';

import '../controllers/business_trip_controller.dart';

class BusinessTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessTripController>(
      () => BusinessTripController(Get.find()),
    );
    Get.lazyPut(() => BusinessTripProvider(Get.find()));
  }
}
