import 'package:bkd_presence/app/modules/edit_profile/provider/edit_profile_provider.dart';
import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(Get.find()),
    );
    Get.lazyPut(() => EditProfileProvider(Get.find()));
  }
}
