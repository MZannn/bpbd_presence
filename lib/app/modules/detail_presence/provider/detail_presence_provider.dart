import 'package:bkd_presence/app/models/detail_presence_model.dart';
import 'package:bkd_presence/app/services/api_service.dart';

class DetailPresenceProvider {
  DetailPresenceProvider(this._apiService);
  final ApiService _apiService;

  Future<DetailPresenceModel?> getDetailPresence(int id) async {
    final response = await _apiService.get(
      endpoint: '/detail-presence/$id',
      requiresAuthToken: true,
    );

    return DetailPresenceModel.fromJson(response);
  }
}
