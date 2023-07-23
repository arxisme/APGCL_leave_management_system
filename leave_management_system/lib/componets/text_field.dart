import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final TextEditingController inputController;
  final String type;
  final bool obscure;
  const TextInput(
      {Key? key,
      required this.inputController,
      required this.type,
      required this.obscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 41, 41, 41);
    const secondaryColor = Color.fromARGB(255, 41, 41, 41);
    const accentColor = Color.fromARGB(0, 255, 206, 206);
    const errorColor = Color(0xffEF4444);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            
            controller: inputController,
            onChanged: (value) {
              //Do something wi
            },
           
            style: const TextStyle(fontSize: 14, color: Colors.black),
            obscureText: obscure,
            
            decoration: InputDecoration(
              label: Text(type),

              labelStyle: const TextStyle(color: primaryColor),
              // prefixIcon: Icon(Icons.email),
              filled: true,
              
              fillColor: accentColor,
              hintText: '',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: errorColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}
