// ignore: file_names

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/approver_page.dart';
import 'package:leave_management_system/auth_page.dart';
import 'package:leave_management_system/componets/button.dart';
import 'package:leave_management_system/componets/my_button.dart';
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:leave_management_system/componets/no_field.dart';
//import 'package:searchfield/searchfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:leave_management_system/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:leave_management_system/profile_page.dart';
import 'package:open_file/open_file.dart';

const primaryColor = Color.fromARGB(255, 41, 41, 41);
const secondaryColor = Color.fromARGB(255, 41, 41, 41);
const accentColor = Color.fromARGB(0, 255, 206, 206);
const errorColor = Color(0xffEF4444);

PlatformFile? file;

String strStartDate = '';
String strEndDate = '';
DateTime? startDate = DateTime.now();
DateTime? endDate;
DateTime selectedDate = DateTime.now();
List<DropdownMenuItem<String>> get leaveDropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(
        value: "Maternity Leave", child: Text("Maternity Leave")),
    const DropdownMenuItem(
        value: "Restricted Holiday", child: Text("Restricted Holiday")),
    const DropdownMenuItem(value: "Casual Leave", child: Text("Casual Leave")),
    const DropdownMenuItem(value: "Earned Leave", child: Text("Earned Leave")),
    const DropdownMenuItem(
        value: "Earned Leave on Medical Ground",
        child: Text("EL on Medical Ground ")),
    const DropdownMenuItem(
        value: "Child Care Leave", child: Text("Child Care Leave")),
    const DropdownMenuItem(
        value: "Medical Leave", child: Text("Medical Leave")),
    // Add more leave types as needed
  ];
  return menuItems;
}

//tobar variables
final List<PopupMenuItem<String>> _popupItems = [
  const PopupMenuItem<String>(
    value: 'Profile',
    child: ListTile(
      leading: Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 0)),
      title: Text('Profile'),
    ),
  ),
  const PopupMenuItem<String>(
    value: 'Approver View',
    child: ListTile(
      leading: Icon(Icons.check_circle,
          color: Color.fromARGB(
              255, 34, 34, 34)), // Add the icon for Approver View
      title: Text('Approver View'),
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
// void _onPopupMenuSelected(String value) {
//   // Implement actions based on the selected option
//   print('Selected: $value');
// }
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
    case 'Approver View':
      // Navigate to the ApproverPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ApproverPage()),
      );
      break;
    case 'Sign Out':
      signUserOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AuthPage()));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
      // Navigate to the SignInPage and remove all previous routes from the stack

      break;
  }
}

final approverController = TextEditingController();
final noteController = TextEditingController();
String mail = '';
String userMail = '';
String userName = '';
String dropdownValue = 'Casual Leave';
List<String> employeeNames = [];

Future<String?> getData() async {
  if (FirebaseAuth.instance.currentUser != null) {
    userMail = (FirebaseAuth.instance.currentUser?.email)!;
    userName = (FirebaseAuth.instance.currentUser?.displayName)!;
    employeeNames = await getFirebaseDatabase();

    return FirebaseAuth.instance.currentUser?.email;
  } else {
    return null;
  }
}

Future<LoginPage> signUserOut() async {
  if (FirebaseAuth.instance.currentUser != null) {}
  await FirebaseAuth.instance.signOut();

  return LoginPage();
}

final noOfDaysController = TextEditingController();

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    getData();

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

                    const SizedBox(
                      height: 20,
                    ),
                    // const nameBar(name: "arshad", id: "cj001"),
                    // const SizedBox(height: 30),

                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        // border: Border.all(),
                        color: const Color(0XFFD2DAFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Leave type  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),

                          //leave type
                          Container(
                            //width: 244,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              dropdownColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              itemHeight: null,
                              items: leaveDropdownItems,
                              value: dropdownValue,
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              underline: const SizedBox(),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    //no of days
                    NumInput(
                        inputController: noOfDaysController,
                        type: 'No of Days',
                        obscure: false),
                    const SizedBox(
                      height: 30,
                    ),

                    //date selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // NumInput(inputController: noOfDaysConroller, type: 'No. of days', obscure: false),
                        MaterialButton(
                          minWidth: 150,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          onPressed: () async {
                            final DateTime? dateTime = await showDatePicker(
                              context: context,
                              initialDate: startDate!,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2500),
                            );
                            if (dateTime != null) {
                              setState(() {
                                startDate = dateTime;
                                strStartDate =
                                    startDate.toString().substring(0, 10);
                              });
                            }
                          },
                          color: const Color(0XFFD2DAFF),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Start Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  strStartDate,
                                )
                              ],
                            ),
                          ),
                        ),
                        MaterialButton(
                          minWidth: 150,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          onPressed: () async {
                            final DateTime? dateTime = await showDatePicker(
                              context: context,
                              initialDate: startDate!,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2500),
                            );
                            if (dateTime != null) {
                              setState(() {
                                endDate = dateTime;
                                strEndDate =
                                    endDate.toString().substring(0, 10);
                              });
                            }
                          },
                          color: const Color(0XFFD2DAFF),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text(
                                  'End Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  strEndDate,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //approver
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFFD2DAFF),
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0XFFD2DAFF),
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded corners
                          ),
                          child: TypeAheadFormField<String>(
                            autoFlipDirection:
                                true, // Enable auto-flip direction
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: approverController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0), // Adjust padding
                                border: InputBorder.none, // Remove underline
                                hintText: 'Select an Approver',
                              ),
                            ),
                            suggestionsCallback: (pattern) {
                              return employeeNames.where((name) => name
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()));
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(title: Text(suggestion));
                            },
                            onSuggestionSelected: (String? suggestion) {
                              // Set the selected value to the text field
                              if (suggestion != null) {
                                approverController.text = suggestion;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //note

                    SizedBox(
                      height: 200,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color(0XFFD2DAFF),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(12, 26),
                                  blurRadius: 50,
                                  spreadRadius: 0,
                                  color: Colors.grey.withOpacity(.1)),
                            ]),
                        child: TextField(
                          expands: true,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                          controller: noteController,
                          onChanged: (value) {
                            //Do something wi
                          },
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          obscureText: false,
                          decoration: InputDecoration(
                            label: const Text('Note'),
                            alignLabelWithHint: true,

                            labelStyle: const TextStyle(color: primaryColor),
                            // prefixIcon: Icon(Icons.email),
                            filled: true,

                            fillColor: accentColor,
                            hintText: '',
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(.75)),
                            // contentPadding: const EdgeInsets.symmetric(
                            //     vertical: 0.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: secondaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: errorColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //attachment

                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          GradientButtonFb1(
                            text: 'Attachment',
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles();
                              if (result == null) {
                                return;
                              }
                              setState(() {
                                file = result.files.first;
                              });
                            },
                          ),
                          if (file != null)
                            Text(
                              file!.name,
                            ),
                        ],
                      ),
                    ),

                    //approver selection

                    MyButton(
                      name: 'Apply',
                      onTap: () {
                        if (dropdownValue == 'Earned Leave') {
                          if (startDate!.isBefore(
                              DateTime.now().add(const Duration(days: 21)))) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Invalid Start Date",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  content: const Text(
                                      "To avail your earned leave, you have to apply before 21 days "),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            createApplication();
                          }
                        }
                        {
                          createApplication();
                        }
                      },
                      //createApplication,
                    ),
                    // apply() async {
//     final application = <String, dynamic>{
//       "leave Type": typeOfLeave,
//       "approver": approver,
//       "no of days": noOfDaysController.text,
//       "start date": selectedDate,
//       "note": noteController.text,
//     };

// // Add a new document with a generated ID
//     await employeeref.add(application);
//   }
// }eApplication, name: 'Apply'),
                    const SizedBox(
                      height: 20,
                    ),

                    // MyButton(onTap: signUserOut, name: 'Sign Out'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//   apply() async {
//     final application = <String, dynamic>{
//       "leave Type": typeOfLeave,
//       "approver": approver,
//       "no of days": noOfDaysController.text,
//       "start date": selectedDate,
//       "note": noteController.text,
//     };

// // Add a new document with a generated ID
//     await employeeref.add(application);
//   }
// }
  Future createApplication() async {
    final db =
        FirebaseFirestore.instance.collection('Applications').doc(userMail);

    final json = {
      "leave Type": dropdownValue,
      "approver": approverController.text,
      "no of days": noOfDaysController.text,
      "start date": startDate,
      "end date": endDate,
      "email": userMail,
      "name": userName,
      "status": "pending",
      'note': noteController.text,
      //"note": noteController.text,
    };

    try {
      await db.set(json);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Congratulations",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            content: const Text("Application submitted"),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error uploading application"),
            content: Text(e.toString()),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
    if (file != null) {
      try {
        final uploadFile = File(file!.path!);
        final path = '${userMail}/${strStartDate}';
        final ref = FirebaseStorage.instance.ref().child(path);

        ref.putFile(uploadFile);
      } catch (e) {}
    }
  }
}

onTapMenu() {}

void openFile(PlatformFile file) {
  OpenFile.open(file.path!);
}

Future<List<String>> getFirebaseDatabase() async {
  List<String> names = [];
  final snapshot = await FirebaseDatabase.instance.ref('employee').get();

  for (var element in snapshot.children) {
    String i = element.child('name').value.toString();
    names.add(i);
  }

  // print(names);
  return names;
}
