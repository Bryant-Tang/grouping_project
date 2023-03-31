import 'package:flutter/material.dart';

class EnlargeObjectTemplate extends StatelessWidget {
  const EnlargeObjectTemplate(
      {super.key, required this.title, required this.contextOfTitle});

  final String title;
  final Widget contextOfTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 121, 121, 121)),
          ),
          const Divider(
            thickness: 1.5,
            color: Color.fromARGB(255, 209, 209, 209),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: contextOfTitle,
          )
        ],
      ),
    );
  }
}
