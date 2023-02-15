import 'package:flutter/material.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';


Container CreateGroupCardView(String title, String descript){
  return Container(
        margin: EdgeInsets.all(5),
        width: 340,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              spreadRadius:0.5,
              blurRadius: 2,
            )
          ]
        ),
        // 使用 Stack 來製造出重疊的效果
        // https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
        child: Stack(  
          children: [
            ClipPath(
              clipper: CardCustomClipPath(),
              child: Container(
                width: 80,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)
                  )
                ),
              ),
            ),
            // 創造頭貼空間的邊框
            Positioned(
              top: 13.75,
              left: 38.75,
              // 創造六角形的空間
              child: ClipPath(
                clipper: hexagon(),
                child: Container(
                  width: 53,
                  height: 26.5 * sqrt(3),
                  color: Colors.black,
                ),
              )
            ),
            // 創造頭貼的空間
            Positioned(
              top: 15,
              left: 40,
              child: ClipPath(
                clipper: hexagon(),
                child: Container(
                  width: 50,
                  height: 25 * sqrt(3),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    image: DecorationImage(
                      image: AssetImage('../assets/groupTest.png'),
                      fit: BoxFit.contain
                    )
                  ),
                ),
              )
            ),
            Positioned(
              top: 4,
              left: 120,
              child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            Positioned(
              top: 25,
              left: 120,
              child: Container(
                width: 220,
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        descript,
                        style: TextStyle(fontSize: 14),
                        softWrap: false,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ]
                )
              )
            ),
            Positioned(
              top: 60,
              left: 120,
              child: Row(
                children: [
                  _CreateLabel('Flutter'),
                  SizedBox(width: 5,),
                  _CreateLabel('Figma')
                ],
              ),
            )
          ],
        )
      );
}

// 將長方形裁剪出左方的五角形
class CardCustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width*0.7, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclip) => false;
}

// 將長方形裁剪出六角形
// https://educity.app/flutter/custom-clipper-in-flutter
class hexagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    Path path = Path();
    path.moveTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.25, size.height);
    path.lineTo(0, size.height * 0.5);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclip) => false;
}

Container _CreateLabel(String label){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.amber),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Text(' #'+label+' ', style: TextStyle(color: Colors.amber, fontSize: 10),),
  );
}