import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leave_management_system/componets/button.dart';
import 'package:leave_management_system/registration_page.dart';
import 'componets/textfields.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordConctroller = TextEditingController();

  void signUserIn() async {
    
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordConctroller.text,
      );
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:Column(
            children: [
    
              Image.asset(
                "lib/images/apgcl-1.png",
                height: 150,
                // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
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
                controller: passwordConctroller,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                onTap: signUserIn,
                name: 'Sign in',
              ),
              const SizedBox(
                height: 20,
              ),
               RichText(
                text: TextSpan(
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    color: Color.fromARGB(255, 93, 175, 241),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Register',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()),
                            );
                          },
                        style: const TextStyle(
                          color: Colors.blue,
                        )),
                  ],
                ),
              
              ),
            ],
          ),
        ),),
      ),
    );
  }
}
