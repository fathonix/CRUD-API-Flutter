import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class SecureStorage {
  // ! Private Constructor
  SecureStorage._();

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
      // !Nyimpen di storage
      await _storage.write(
        key: _keyToken,
        value: token,
      );
    } catch (e) {
      log('$e');
    }
  }

  Future<String?> getToken() async {
    try {
      // ? Ambil dari local storage
      final token = await _storage.read(
        key: _keyToken,
      );
      // ? Pengecekan data null
      if (token != null) {
        // ? Ketika nggak null, maka kembalikan data tokennya
        return token;
      } else {
        return null;
      }
    } catch (e) {
      log('$e');
      return null;
    }
  }

  Future<void> cacheUser({
    required User user,
  }) async {
    try {
      final userData = jsonEncode(
        user.toJson(),
      );
      await _storage.write(
        key: _keyUser,
        value: userData,
      );
    } catch (e) {
      log('$e');
    }
  }

  Future<User?> getUser() async {
    try {
      final json = await _storage.read(key: _keyUser);
      if (json != null) {
        final jsonValue = jsonDecode(json);
        final user = User.fromJson(jsonValue);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
