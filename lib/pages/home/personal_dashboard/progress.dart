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
          Text('PRGRESSING',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const Divider(
            thickness: 2,
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Colors.black.withOpacity(0.25),
                  //       spreadRadius: 0,
                  //       blurRadius: 10,
                  //       offset: const Offset(0, 0))
                  // ],
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text("TO BE COUNTINUE", textAlign: TextAlign.center)),
            ),
          ))
        ],
      ),
    );
  }
}
