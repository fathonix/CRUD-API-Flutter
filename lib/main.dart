import 'package:crud_api_app/locals/secure_storage.dart';
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialRoute = '';

  @override
  void initState() {
    SecureStorage.getToken().then((value) {
      if (value == null) {
        setState(() {
          initialRoute = AppRoutes.loginPage;
        });
      } else {
        setState(() {
          initialRoute = AppRoutes.homePage;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
