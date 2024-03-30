import 'package:bkd_presence/app/modules/detail_presence/provider/detail_presence_provider.dart';
import 'package:get/get.dart';

import '../controllers/detail_presence_controller.dart';

class DetailPresenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPresenceController>(
      () => DetailPresenceController(Get.find()),
    );
    Get.lazyPut(() => DetailPresenceProvider(Get.find()));
  }
}
