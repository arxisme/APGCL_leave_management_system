import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/componets/button.dart';
import 'package:leave_management_system/componets/nameBar.dart';
import 'package:leave_management_system/login_page.dart';

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
  int _selectedValue = 0;

  final List<String> _approvers = ['John', 'Jane', 'Smith', 'Michael'];
  String _selectedApprover = 'John';
  String _selectedName = 'Casual leave'; // Initially 'John' is selected

  final List<String> _names = ['Casual leave', 'maternal ', 'sick leave'];

  get nothing => null;
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

                  const SizedBox(
                    height: 30,
                  ),

                  //radio
                  Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Text('One day'),
                      const Spacer(),
                      Radio<int>(
                        value: 0,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Text('More than one day'),
                    ],
                  ),

                  const SizedBox(height: 16),
                  //leave type
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.grey[70],
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(10.0),
                      child: DropdownButton<String>(
                        value: _selectedName,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedName = newValue!;
                          });
                        },
                        items: _names.map((String name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.grey[70],
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(10.0),
                      child: DropdownButton<String>(
                        value: _selectedApprover,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedApprover = newValue!;
                          });
                        },
                        items: _approvers.map((String approver) {
                          return DropdownMenuItem<String>(
                            value: approver,
                            child: Text(approver),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyButton(onTap: signUserOut, name: 'Sign Out')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
