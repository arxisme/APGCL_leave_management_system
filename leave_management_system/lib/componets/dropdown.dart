import 'package:flutter/material.dart';
class DropDown extends StatefulWidget{
  List<String> names = ['John', 'Emily', 'Michael'];

String selectedName = names[0]; // Initialize with the first name

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 35.0),
    child: DropdownButtonFormField<String>(
      value: selectedName,
      onChanged: (newValue) {
        setState(() {
          selectedName = newValue!;
        });
      },
      items: names.map((name) {
        return DropdownMenuItem<String>(
          value: name,
          child: Text(name),
        );
      }).toList(),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: 'Select a name',
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
      ),
    ),
  );
}

  void setState(Null Function() param0) {}


}