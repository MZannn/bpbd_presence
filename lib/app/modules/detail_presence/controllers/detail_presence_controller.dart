import 'package:bpbd_presence/app/models/detail_presence_model.dart';

import 'package:bpbd_presence/app/modules/detail_presence/provider/detail_presence_provider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailPresenceController extends GetxController
    with StateMixin<DetailPresenceModel?> {
  DetailPresenceController(this._detailPresenceProvider);
  final DetailPresenceProvider _detailPresenceProvider;

  Future getDetailPresence(int id) async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _detailPresenceProvider.getDetailPresence(id);
      change(response, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future formattedDate(String date) async {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(dateTime);

    return formattedDate;
  }

  final count = 0.obs;
  @override
  void onInit() {
    getDetailPresence(Get.arguments);
    super.onInit();
  }
}
