import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class SecureStorage {
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  static const _storage = FlutterSecureStorage(aOptions: _androidOptions);

  static const _keyUser = '_user';
  static const _keyToken = '_token';

  Future<void> cacheToken({
    required String token,
  }) async {
    try {
      await _storage.write(
        key: _keyUser,
        value: jsonEncode(value),
      );
    } catch (e) {}
  }

  Future<void> cacheUser({
    required User user,
  }) async {
    try {
      final value = {
        'token': token,
        'user': jsonEncode(user.toJson()),
      };
      await _storage.write(
        key: _keyUser,
        value: jsonEncode(value),
      );
    } catch (e) {
      log('$e');
    }
  }

  Future getCredential() async {
    try {
      final data = await _storage.read(key: _keyUser);
      if (data != null) {
        final valJson = jsonDecode(data);
        return valJson;
      }
    } catch (e) {
      log('$e');
    }
  }
}
