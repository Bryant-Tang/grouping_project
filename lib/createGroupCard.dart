import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Container CreateGroupCardView(String title, String descript){
  return Container(
        margin: EdgeInsets.all(5),
        width: 340,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        // 使用 Stack 來製造出重疊的效果
        // https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
        child: Stack(  
          children: [
            ClipPath(
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
              clipper: CardCustomClipPath(),
            ),
            Positioned(
              top: 15,
              left: 40,
              child: ClipPath(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    image: DecorationImage(
                      image: AssetImage('assets/groupTest.png'),
                      fit: BoxFit.contain
                    )
                  ),
                ),
                clipper: hexagon(),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        descript,
                        style: TextStyle(fontSize: 13),
                        softWrap: false,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ]
                )
              )
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
