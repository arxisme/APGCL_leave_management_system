import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/componets/button.dart';
import 'package:leave_management_system/componets/nameBar.dart';
import 'package:leave_management_system/login_page.dart';

import 'componets/textfields.dart';

Future<LoginPage> signUserOut() async {
  await FirebaseAuth.instance.signOut();
  return LoginPage();
}

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});
  String name = 'Arshad Ahmed';
  String id = 'CJ1001';
    String leaveType = 'One Day'; // Default leave type
  DateTime? startDate;
  DateTime? endDate;
  String selectedApprover = '';
  String note = '';

  List<String> approvers = ['Manager', 'Supervisor', 'Human Resources'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "lib/images/apgcl-1.png",
                    height: 90,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  nameBar(name: name, id: id),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
