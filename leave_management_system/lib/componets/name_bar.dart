import 'package:flutter/material.dart';

// ignore: camel_case_types
class nameBar extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables

  final String name;
  final String id;

  const nameBar({
    super.key,
    required this.name,
    required this.id,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,

      //color: Colors.black,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      padding: const EdgeInsets.all(15),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'CJ1001',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // child: Text(
      //   'Hello',
      //   style: TextStyle(
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //     ),
      // ),
    );
  }
}
