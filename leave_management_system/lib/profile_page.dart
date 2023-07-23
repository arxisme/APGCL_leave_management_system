// ignore_for_file: void_checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/approver_page.dart';
import 'package:leave_management_system/auth_page.dart';
import 'package:leave_management_system/componets/button.dart';
import 'package:leave_management_system/componets/my_button.dart';

import 'package:leave_management_system/componets/no_field.dart';
import 'package:leave_management_system/home_page.dart';

import 'package:leave_management_system/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_database/firebase_database.dart';

String status = '';
//topbar variables
final List<PopupMenuItem<String>> _popupItems = [
  const PopupMenuItem<String>(
    value: 'Approver View',
    child: ListTile(
      leading: Icon(Icons.check_circle, color: Color.fromARGB(255, 0, 0, 0)),
      title: Text('Approver View'),
    ),
  ),
  const PopupMenuItem<String>(
    value: 'Home',
    child: ListTile(
      leading: Icon(Icons.home,
          color: Color.fromARGB(
              255, 34, 34, 34)), // Add the icon for Approver View
      title: Text('Home'),
    ),
  ),
  const PopupMenuItem<String>(
    value: 'Sign Out',
    child: ListTile(
      leading: Icon(
        Icons.exit_to_app,
        color: Color.fromARGB(255, 34, 34, 34),
      ),
      title: Text('Sign Out'),
    ),
  ),
  // Add more options as needed
];

Future<LoginPage> signUserOut(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {}
  await FirebaseAuth.instance.signOut();

  return LoginPage();
}

Future<String?> getData() async {
  if (FirebaseAuth.instance.currentUser != null) {
    //databaseRef =  FirebaseDatabase.instance.ref('employee');
    mail = (FirebaseAuth.instance.currentUser?.email)!;
    userName = (FirebaseAuth.instance.currentUser?.displayName)!;
    // print(userName);
    // final Map<String, int> updates = {};
    // updates['/employee/0/Child Care Leave'] =54;
    // FirebaseDatabase.instance.ref().update(updates);
    return FirebaseAuth.instance.currentUser?.email;
  } else {
    return null;
  }
}

void _onPopupMenuSelected(String value, BuildContext context) {
  // Implement actions based on the selected option

  switch (value) {
    case 'Approver View':
      // Navigate to the ProfilePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ApproverPage()),
      );
      break;
    case 'Home':
      // Navigate to the ApproverPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      break;
    case 'Sign Out':
      signUserOut(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AuthPage()));
      // Navigate to the SignInPage and remove all previous routes from the stack

      break;
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  reallyGetStatus() {
    getStatus().then((value) {
      setState(() {
        status = value;
      });
    });
  }

  final ref = getFirebaseDatabaseUser();

  @override
  void initState() {
    super.initState();
    reallyGetStatus();
    getFirebaseDatabaseUser();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF1FF),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      // Image.asset(
                      //   "lib/images/apgcl-1.png",
                      //   height: 90,
                      // ),
                      //tobar

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  backgroundColor: const Color(0XFFD2DAFF),
                                ),

                                // icon: const Icon(Icons.menu),

                                // label: Text('menu'),
                                onPressed: () {},
                                child: PopupMenuButton<String>(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Color.fromARGB(255, 54, 54, 54),
                                  ),
                                  itemBuilder: (context) {
                                    return _popupItems;
                                  },
                                  onSelected: (value) =>
                                      _onPopupMenuSelected(value, context),
                                )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("hello",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                                Text(userName,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: const Color(0XFFD2DAFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        child: CustomListTile(
                          leading: 'Previous Application Status',
                          title: status,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: Expanded(
                          child: FirebaseAnimatedList(
                              query: ref,
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                if (index < 7) {
                                  return Card(
                                    color: const Color(0XFFD2DAFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 5,
                                    child: CustomListTile(
                                        leading: ' ${snapshot.key}:',
                                        title: snapshot.value.toString()),
                                  );
                                } else {
                                  return Card();
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String leading;
  final String title;

  const CustomListTile({super.key, required this.leading, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFFD2DAFF),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Align leading to the left and title to the right
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            leading,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional
                  .centerEnd, // Align the title to the right
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> getStatus() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Applications').get();

  for (var element in snapshot.docs) {
    if (FirebaseAuth.instance.currentUser?.email == element.get('email')) {
      return element.get('status');
    }
  }

  return 'no active application'; // Return this if the user's email is not found in any document
}

getFirebaseDatabaseUser() async {
  final snapshot = await FirebaseDatabase.instance.ref('employee').get();

  for (var element in snapshot.children) {
    if (element.child('email').value.toString() ==
        FirebaseAuth.instance.currentUser?.email) {
      return element;
    }
  }

  // print(names);
}
