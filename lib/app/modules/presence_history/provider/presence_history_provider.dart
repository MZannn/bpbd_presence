import 'package:bpbd_presence/app/models/presences_model.dart';
import 'package:bpbd_presence/app/services/api_service.dart';

class PresenceHistoryProvider {
  final ApiService _apiService;
  PresenceHistoryProvider(this._apiService);

  Future<PresenceModel?> getAllPresence() async {
    final response = await _apiService.get(
      endpoint: '/presence',
      requiresAuthToken: true,
    );
    return PresenceModel?.fromJson(response);
  }
}
