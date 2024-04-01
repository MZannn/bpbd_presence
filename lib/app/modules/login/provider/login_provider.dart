import 'package:bpbd_presence/app/services/api_service.dart';
import 'package:bpbd_presence/app/utils/typedef.dart';

class LoginProvider {
  final ApiService _apiService;
  LoginProvider(this._apiService);

  Future login(JSON body) async {
    final response = await _apiService.post(
      endpoint: '/login',
      body: body,
      requiresAuthToken: false,
    );
    return response;
  }
}
