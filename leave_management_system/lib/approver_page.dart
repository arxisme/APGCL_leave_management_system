import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/action_page.dart';
import 'package:leave_management_system/auth_page.dart';

import 'package:leave_management_system/home_page.dart';

import 'package:leave_management_system/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leave_management_system/profile_page.dart';

Future getAppliactions() async {
  List items = [];
  final CollectionReference applications =
      FirebaseFirestore.instance.collection('Applications');
  try {
    await applications.get().then((value) {
      for (var element in value.docs) {
        items.add(element.data());
      }
    });
    return items;
  } catch (e) {
    return null;
  }
}

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
        Icons.exit_to_app,
        color: Color.fromARGB(255, 34, 34, 34),
      ),
      title: Text('Sign Out'),
    ),
  ),
  // Add more options as needed
];

//topbar variables

Future<LoginPage> signUserOut(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {}
  await FirebaseAuth.instance.signOut();

  return LoginPage();
}

Future<String?> getData() async {
  if (FirebaseAuth.instance.currentUser != null) {
    userMail = (FirebaseAuth.instance.currentUser?.email)!;
    userName = (FirebaseAuth.instance.currentUser?.displayName)!;


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
    case 'Sign Out':
      signUserOut(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AuthPage()));
      // Navigate to the SignInPage and remove all previous routes from the stack

      break;
  }
}

class ApproverPage extends StatefulWidget {
  const ApproverPage({Key? key}) : super(key: key);

  @override
  State<ApproverPage> createState() => _ApproverPage();
}

class _ApproverPage extends State<ApproverPage> {
  List applicationList = [];

  @override
  void initState() {
    super.initState();
    getData();
    fetchApplications();
  }

  fetchApplications() async {
    dynamic result = await getAppliactions();
    if (result != null) {
      setState(() {
        applicationList = result;
      });
    } else {
    }
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

                      //list

                      SizedBox(
                        height: MediaQuery.of(context).size.height - 60,
                        child: ListView.builder(
                          itemCount: applicationList.length,
                          itemBuilder: (context, index) {
                            // print(applicationList[Index]['approver']
                            //     .toString());

                            if (applicationList[index]['approver'].toString() ==
                                    userName &&
                                applicationList[index]['status'] == 'pending') {
                              mail = applicationList[index]['status'];
                              int i = index;
                              return Card(
                                color: const Color(0XFFD2DAFF),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActionPage(
                                            requestMail: applicationList[i]['email']),
                                      ),
                                    );
                                  },
                                  title: Text(applicationList[index]['name']),
                                  subtitle: Text(
                                      applicationList[index]['leave Type']),
                                  trailing: Text(
                                      applicationList[index]['no of days']),
                                ),
                              );
                            } else {
                              return const Card();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
