import 'package:crud_api_app/pages/home_page.dart';
import 'package:crud_api_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const homePage = '/home';
  static const loginPage = '/login';

  static final routes = <String, WidgetBuilder>{
    loginPage: (_) => const LoginPage(),
    homePage: (_) => const HomePage(),
  };
}
