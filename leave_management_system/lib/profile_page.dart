// ignore_for_file: void_checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/approver_page.dart';
import 'package:leave_management_system/auth_page.dart';

import 'package:leave_management_system/home_page.dart';
import 'package:leave_management_system/leave_history_page.dart';

import 'package:leave_management_system/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

String ref = '0';
dynamic currentApplication = {
  'leave Type': 'not available',
  'start date': Timestamp.fromDate(DateTime.now()),
  'end date': Timestamp.fromDate(DateTime.now()),
  'no of days': '0',
  'approver': 'not available',
  'status': 'No active application',
};
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
    getAppliaction().then((value) {
      setState(() {
        currentApplication = value;
      });
    });
  }

  reallyGetUserData() {
    getFirebaseDatabaseUser().then((value) {
      setState(() {
        ref = value;
      });
    });
  }

  cancelApplication() async {
    await FirebaseFirestore.instance
        .collection('Applications')
        .doc(userMail)
        .update({'status': 'cancelled'});
    reallyGetStatus();
  }

  // dynamic ref = FirebaseDatabase.instance.ref('employee').child('0');
  @override
  void initState() {
    super.initState();
    reallyGetStatus();
    reallyGetUserData();

    // getFirebaseDatabaseUser();

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
                      //t
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
                      // Card(
                      //   color: const Color(0XFFD2DAFF),
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15)),
                      //   elevation: 5,
                      //   child: CustomListTile(
                      //     leading: 'Previous Application Status',
                      //     title: currentApplication['status'],
                      //   ),
                      // ),
                      Card(
                        color: const Color(0XFFD2DAFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              _buildAttributeRow(
                                  'Leave Type',
                                  currentApplication['leave Type'],
                                  Colors.black),
                              _buildAttributeRow(
                                  'Start Date',
                                  currentApplication['start date']
                                      .toDate()
                                      .toString()
                                      .substring(0, 10),
                                  Colors.black),
                              _buildAttributeRow(
                                  'End Date',
                                  currentApplication['end date']
                                      .toDate()
                                      .toString()
                                      .substring(0, 10),
                                  Colors.black),
                              _buildAttributeRow(
                                  'Number of Days',
                                  currentApplication['no of days'],
                                  Colors.black),
                              _buildAttributeRow('Approver',
                                  currentApplication['approver'], Colors.black),
                              _buildAttributeRow(
                                  'Status',
                                  currentApplication['status'],
                                  Color.fromARGB(255, 3, 124, 29)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        color: const Color.fromARGB(
                                            255, 137, 177, 247),
                                        child: Text('View all applications'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LeaveApplicationsPage()),
                                          );
                                        }),
                                  ),
                                  Center(
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        color: Color.fromARGB(255, 255, 90, 90),
                                        child: Text('cancel'),
                                        onPressed: () {
                                          print('hhhhhhhhhhh');

                                          if (currentApplication['status'] ==
                                                  'pending' &&
                                              DateTime.now().isBefore(
                                                  currentApplication[
                                                          'start date']
                                                      .toDate())) {
                                            cancelApplication();
                                            showDialog(
                                              
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  title: const Text("Alert!"),
                                                  content: Text(
                                                      'Application  cancelled'),
                                                  actions: <Widget>[
                                                    Center(
                                                      child: ElevatedButton(
                                                        child: const Text("OK"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          if (currentApplication['status'] ==
                                              'cancelled') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  title: const Text("Alert!"),
                                                  content: Text(
                                                      'Application already cancelled'),
                                                  actions: <Widget>[
                                                    Center(
                                                      child: ElevatedButton(
                                                        child: const Text("OK"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          if (!DateTime.now().isBefore(
                                              currentApplication['start date']
                                                  .toDate())) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  title: const Text(
                                                      "Alert!"),
                                                  content: Text("Can't cancel"),
                                                  actions: <Widget>[
                                                    Center(
                                                      child: ElevatedButton(
                                                        child: const Text("OK"),
                                                        style: ButtonStyle(
                                                          shape: MaterialStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15))),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 500,
                        child: FirebaseAnimatedList(
                            query:
                                FirebaseDatabase.instance.ref("employee/$ref"),
                            itemBuilder: (context, snapshot, animation, index) {
                              if (index < 7) {
                                return Card(
                                  shadowColor: Color.fromARGB(0, 5, 5, 5),
                                  color: const Color(0XFFD2DAFF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
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

                      // FirebaseAnimatedList(
                      //     query: FirebaseDatabase.instance.ref("employee/$ref"),
                      //     itemBuilder: (context, snapshot, animation, index) {
                      //       // if (index < 7) {
                      //       return Card(
                      //         color: const Color(0XFFD2DAFF),
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(15)),
                      //         elevation: 5,
                      //         child: CustomListTile(
                      //             leading: ' ${snapshot.key}:',
                      //             title: snapshot.value.toString()),
                      //       );
                      //       // } else {
                      //       //   return const Card();
                      //       // }
                      //     }),
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
              fontSize: 14,
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
                  fontSize: 14,
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

Future<Object?> getAppliaction() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Applications').get();

  for (var element in snapshot.docs) {
    if (FirebaseAuth.instance.currentUser?.email == element.get('email')) {
      print(element.data());

      return element.data();
    } else {}
  }

  return currentApplication; // Return this if the user's email is not found in any document
}

getFirebaseDatabaseUser() async {
  final snapshot = await FirebaseDatabase.instance.ref('employee').get();

  for (var element in snapshot.children) {
    if (element.child('email').value.toString() ==
        FirebaseAuth.instance.currentUser?.email) {
      print(element.key);

      return element.key;
    }
  }

  // print(names);
}

//  getFirebaseDatabaseUser() {
//   return FirebaseDatabase.instance
//       .ref()
//       .child('employee')
//       .orderByChild('email')
//       .equalTo(FirebaseAuth.instance.currentUser?.email ?? '')
//       .limitToFirst(1

Widget _buildAttributeRow(String attribute, String value, Color _color) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            attribute + ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  color: _color,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
