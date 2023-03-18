import 'package:flutter/material.dart';

class Progress extends StatefulWidget{
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress>{
  Widget build(BuildContext context){
    return Container(
      // height: 100,
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      ),
    );
  }
}