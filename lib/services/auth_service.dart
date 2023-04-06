import 'dart:developer';

class AuthService {
  // ! Dibikin singleton biar mastiin yg dibikin program hanya 1 object yg dibuat dari class ini
  AuthService._();

  Future login() async {
    try {
      const url = 'http://127.0.0.1:9001/api/login';
    } catch (e) {
      log('$e');
    }
  }
}
