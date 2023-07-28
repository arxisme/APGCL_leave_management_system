import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/auth_page.dart';
import 'package:leave_management_system/componets/button.dart';
import 'componets/textfields.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();
final userNameController = TextEditingController();

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  "lib/images/apgcl-1.png",
                  height: 150,
                ),
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                //userid
                myTextField(
                  controller: emailController,
                  hintText: 'email ',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),
                //password
                myTextField(
                  controller: userNameController,
                  hintText: 'Name',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                myTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyButton(
                  onTap: () => registerUser(context),
                  name: 'Register',
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> registerUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    FirebaseAuth.instance.currentUser
        ?.updateDisplayName(userNameController.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Registration Successful"),
          content: Text('Press Ok to go to login page'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
            )
          ],
        );
      },
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error in Registering"),
            content: Text('Weak Password'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    } else if (e.code == 'email-already-in-use') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error uploading application"),
            content: Text('Email Already in use'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  } catch (e) {
    print(e);
  }
}
