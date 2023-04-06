import 'dart:convert';
import 'dart:developer';

import 'package:crud_api_app/constants/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthService {
  // ! Dibikin singleton biar mastiin yg dibikin program hanya 1 object yg dibuat dari class ini
  AuthService._();

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}';
      final data = {
        'email': email,
        'password': password,
      };
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final token = responseJson['access_token'];
          final user = User.fromJson(responseJson['data']);
        }
      }
    } catch (e) {
      log('$e');
    }
  }
}
