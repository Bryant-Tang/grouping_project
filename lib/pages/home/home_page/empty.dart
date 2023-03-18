/*

**  ATTENTION  **
This is a empty test Widget, it don't have any usage, but don't delete it.

*/
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget{
  const EmptyWidget({super.key});
  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.amber,
    );
  }
}