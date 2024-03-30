import 'package:bkd_presence/app/services/api_service.dart';
import 'package:bkd_presence/app/utils/typedef.dart';

class ChangeDeviceProvider {
  ChangeDeviceProvider(this._apiService);
  final ApiService _apiService;

  Future changeDevice(JSON body) async {
    final response = await _apiService.post(
      body: body,
      endpoint: '/report-change-device',
      requiresAuthToken: true,
    );
    return response;
  }
}
