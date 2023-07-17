import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leave_management_system/auth_page.dart';
// import 'package:leave_management_system/homePage.dart';
// import 'package:leave_management_system/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => const AuthPage(),
        // Add more routes for other pages/screens
      },
    );
  }
}
