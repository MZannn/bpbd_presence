import 'dart:developer';

import 'package:bpbd_presence/app/services/base_provider.dart';
import 'package:bpbd_presence/app/utils/typedef.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final BaseProvider _baseProvider;
  ApiService(this._baseProvider);

  String? token;
  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenStorage = prefs.getString('token');
    log('Token: $tokenStorage');
    if (tokenStorage != null) {
      token = tokenStorage;
    }
  }

  get<T>({
    required String endpoint,
    JSON? query,
    Map<String, String>? headers,
    bool requiresAuthToken = false,
  }) async {
    if (requiresAuthToken) {
      await _getToken();
    }

    var customHeaders = requiresAuthToken
        ? {'Accept': 'application/json', 'Authorization': 'Bearer $token'}
        : {'Accept': 'application/json'};

    if (headers != null) {
      customHeaders.addAll(headers);
    }

    final response =
        await _baseProvider.get(endpoint, headers: customHeaders, query: query);

    return response.body;
  }

  post<T>({
    required String endpoint,
    dynamic body,
    JSON? query,
    Map<String, String>? headers,
    bool requiresAuthToken = false,
  }) async {
    if (requiresAuthToken) {
      await _getToken();
    }
    var customHeaders = requiresAuthToken
        ? {'Accept': 'application/json', 'Authorization': 'Bearer $token'}
        : {'Accept': 'application/json'};

    if (headers != null) {
      customHeaders.addAll(headers);
    }

    final response = await _baseProvider.post(endpoint, body,
        headers: customHeaders, query: query);

    return response.body;
  }

  put<T>({
    required String endpoint,
    dynamic body,
    JSON? query,
    Map<String, String>? headers,
    bool requiresAuthToken = false,
  }) async {
    if (requiresAuthToken) {
      await _getToken();
    }

    var customHeaders = requiresAuthToken
        ? {'Accept': 'application/json', 'Authorization': 'Bearer $token'}
        : {'Accept': 'application/json'};

    if (headers != null) {
      customHeaders.addAll(headers);
    }

    final response = await _baseProvider.put(endpoint, body,
        headers: customHeaders, query: query);

    return response.body;
  }
}
