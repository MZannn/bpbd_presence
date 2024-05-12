import 'dart:developer';

import 'package:bpbd_presence/app/models/user_model.dart';
import 'package:bpbd_presence/app/services/api_service.dart';
import 'package:get/get.dart';

class HomeProvider extends GetConnect {
  final ApiService _apiService;
  HomeProvider(this._apiService);
  Future<UserModel?> getUsers() async {
    final response = await _apiService.get(
      endpoint: '/user',
      requiresAuthToken: true,
    );
    log('Response: $response');
    return UserModel.fromJson(response);
  }

  Future<UserModel?> presenceIn(int id, Map<String, dynamic> body) async {
    final response = await _apiService.put(
      body: body,
      endpoint: '/presence-in/$id',
      requiresAuthToken: true,
    );
    return UserModel.fromJson(response);
  }

  Future<UserModel?> presenceOut(int id, body) async {
    final response = await _apiService.put(
      body: body,
      endpoint: '/presence-out/$id',
      requiresAuthToken: true,
    );
    return UserModel.fromJson(response);
  }

  Future logout() async {
    final response = await _apiService.post(
      endpoint: '/logout',
      requiresAuthToken: true,
    );
    return response;
  }

  Future fetchTime() async {
    var response = await get(
        'https://www.timeapi.io/api/Time/current/zone?timeZone=Asia/Jakarta');
    return response.body;
  }
}
