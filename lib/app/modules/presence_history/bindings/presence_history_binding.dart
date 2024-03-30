import 'package:bkd_presence/app/modules/presence_history/provider/presence_history_provider.dart';
import 'package:get/get.dart';

import '../controllers/presence_history_controller.dart';

class PresenceHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresenceHistoryController>(
      () => PresenceHistoryController(Get.find()),
    );
    Get.lazyPut(() => PresenceHistoryProvider(Get.find()));
  }
}
