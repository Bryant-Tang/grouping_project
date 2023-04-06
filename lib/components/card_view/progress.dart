import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          const Text(
            'PRGRESSING',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0XFF717171)),
          ),
          const Divider(
            thickness: 1,
            height: 7,
            color: Color(0XFF999898),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 0))
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text("TO BE COUNTINUE", textAlign: TextAlign.center)),
            ),
          ))
        ],
      ),
    );
  }
}
