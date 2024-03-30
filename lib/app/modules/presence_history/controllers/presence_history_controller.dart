import 'package:bkd_presence/app/models/presences_model.dart';
import 'package:bkd_presence/app/modules/presence_history/provider/presence_history_provider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PresenceHistoryController extends GetxController
    with StateMixin<PresenceModel?> {
  final PresenceHistoryProvider _presenceHistoryProvider;
  PresenceHistoryController(this._presenceHistoryProvider);

  getAllPresences() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _presenceHistoryProvider.getAllPresence();
      change(response, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<String> formatDate(String date) async {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(dateTime);

    return formattedDate;
  }

  @override
  void onInit() async {
    await getAllPresences();
    super.onInit();
  }
}
