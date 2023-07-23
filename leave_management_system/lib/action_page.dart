import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:leave_management_system/profile_page.dart';
import 'package:open_file/open_file.dart';

final List<PopupMenuItem<String>> _popupItems = [
  const PopupMenuItem<String>(
    value: 'Profile',
    child: ListTile(
      leading: Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 0)),
      title: Text('Profile'),
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
        Icons.check_circle,
        color: Color.fromARGB(255, 34, 34, 34),
      ),
      title: Text('Approver view'),
    ),
  ),
  // Add more options as needed
];

Future getAppliactions() async {
  List items = [];
  final CollectionReference applications =
      FirebaseFirestore.instance.collection('Applications');
  try {
    await applications.get().then((value) {
      value.docs.forEach((element) {
        items.add(element.data());
      });
    });
    return items;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<LoginPage> signUserOut(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {}
  await FirebaseAuth.instance.signOut();

  return LoginPage();
}

Future<String?> getData() async {
  if (FirebaseAuth.instance.currentUser != null) {
    mail = (FirebaseAuth.instance.currentUser?.email)!;
    userName = (FirebaseAuth.instance.currentUser?.displayName)!;

    final db = FirebaseFirestore.instance;

    return FirebaseAuth.instance.currentUser?.email;
  } else {
    return null;
  }
}

void _onPopupMenuSelected(String value, BuildContext context) {
  // Implement actions based on the selected option

  switch (value) {
    case 'Profile':
      // Navigate to the ProfilePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
      break;
    case 'Home':
      // Navigate to the ApproverPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      break;
    case 'Approver view':
      signUserOut(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ApproverPage()));
      // Navigate to the SignInPage and remove all previous routes from the stack

      break;
  }
}

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key, required this.requestMail}) : super(key: key);
  final String requestMail;

  @override
  State<ActionPage> createState() => _ActionPage();
}

class _ActionPage extends State<ActionPage> {
  List applicationList = [];
  int? editIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchApplications();
    print(mail);
  }

  fetchApplications() async {
    dynamic result = await getAppliactions();
    if (result != null) {
      setState(() {
        applicationList = result;
        print(applicationList.toString());
      });
    } else {
      print('unable to retrieve');
    }
  }

  @override
  Widget build(BuildContext context) {
    String rmail = widget.requestMail.trim();
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
                                color: const Color.fromARGB(255, 255, 255, 255),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 60,
                      child: ListView.builder(
                        itemCount: applicationList.length,
                        itemBuilder: (context, Index) {
                          // print(applicationList[Index]['approver']
                          //     .toString());

                          if (applicationList[Index]['approver'].toString() ==
                                  userName &&
                              applicationList[Index]['status'] == 'pending' &&
                              applicationList[Index]['email'].toString().trim() == rmail) {
                            editIndex = Index;
                            print('lolol');
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: const Color(0XFFD2DAFF),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title:
                                          Text(applicationList[Index]['name']),
                                      subtitle: Text(
                                          applicationList[Index]['leave Type']),
                                      trailing: Text(
                                          applicationList[Index]['no of days']),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'From',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              applicationList[Index]
                                                  ['start date'].toDate().toString().substring(0,10),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'To',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              applicationList[Index]
                                                  ['end date'].toDate().toString().substring(0,10),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Note',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: TextField(
                                            maxLines:
                                                9, // Set the number of lines to display
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: ''),
                                            readOnly:
                                                true, // Set to true if you want the text to be non-editable
                                            controller: TextEditingController(
                                                text: applicationList[Index]
                                                    ['note']),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // NumInput(inputController: noOfDaysConroller, type: 'No. of days', obscure: false),
                                        MaterialButton(
                                          minWidth: 120,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          onPressed: () {
                                            print(' lllll$rmail \n');
                                            // Replace "collectionName" with the actual name of your Firestore collection
                                            // Replace "documentId" with the ID of the document you want to update
                                            FirebaseFirestore.instance
                                                .collection('Applications')
                                                .doc(rmail)
                                                .update({
                                              'status':
                                                  'reschedule', // Replace "fieldName" with the field you want to update
                                            }).then((_) {
                                              // Success, do something if needed
                                              print(
                                                  'Value updated in Firestore!');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ApproverPage()));
                                            }).catchError((error) {
                                              // Handle any errors that occurred during the update process
                                              print(
                                                  'Error updating value:$rmail $error');
                                            });
                                          },
                                          color: const Color.fromARGB(
                                              255, 211, 211, 211),
                                          child: const Text(
                                            'Reschedule',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          onPressed: () {
                                            // Replace "collectionName" with the actual name of your Firestore collection
                                            // Replace "documentId" with the ID of the document you want to update
                                            FirebaseFirestore.instance
                                                .collection('Applications')
                                                .doc(rmail)
                                                .update({
                                              'status':
                                                  'approved', // Replace "fieldName" with the field you want to update
                                            }).then((_) {
                                              // Success, do something if needed
                                              print(
                                                  'Value updated in Firestore!');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ApproverPage()));
                                            }).catchError((error) {
                                              // Handle any errors that occurred during the update process
                                              print(
                                                  'Error updating value: $error');
                                            });
                                          },
                                          color: Color.fromARGB(
                                              202, 166, 255, 125),
                                          child: const Text(
                                            'Approve',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        MaterialButton(
                                          minWidth: 120,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          onPressed: () {
                                            // Replace "collectionName" with the actual name of your Firestore collection
                                            // Replace "documentId" with the ID of the document you want to update
                                            FirebaseFirestore.instance
                                                .collection('Applications')
                                                .doc(rmail)
                                                .update({
                                              'status':
                                                  'rejected', // Replace "fieldName" with the field you want to update
                                            }).then((_) {
                                              // Success, do something if needed
                                              print(
                                                  'Value updated in Firestore!');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ApproverPage()));
                                            }).catchError((error) {
                                              // Handle any errors that occurred during the update process
                                              print(
                                                  'Error updating value: $error');
                                            });
                                          },
                                          color:
                                              Color.fromARGB(160, 248, 77, 90),
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Card();
                          }
                        },
                      ),
                    ),
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
