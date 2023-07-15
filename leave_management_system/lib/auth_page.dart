
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leave_management_system/login_page.dart';
import 'package:leave_management_system/homePage.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key
  });
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?> (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            return  HomePage();
          }
          else {
            return LoginPage();
          }


        },
      ),
    );

  }
  
}