import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

import 'dart:math';

List<Color> randomColor = [Colors.amber, Colors.redAccent, Colors.lightBlue, Colors.greenAccent,
          Colors.orangeAccent, Colors.pinkAccent, Colors.purple];

class Message extends StatelessWidget{
  Message({super.key, required this.messageNumber});
  final int messageNumber;
  
  /// 隨機選擇使用的顏色
  Color UsingColor = randomColor[Random().nextInt(randomColor.length)];
  var cardHeight = 30.0;

  @override
  Widget build(BuildContext context){
    return Container(
    width: 338,
    height: cardHeight + 40 * messageNumber,
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black45,
          spreadRadius:0.5,
          blurRadius: 2,
        )
      ]
    ),
    child: Stack(
      children: [
        // 左方的矩形方塊
        Positioned(
          child: Container(
            width: 8,
            height: cardHeight + 40 * messageNumber,
            decoration: BoxDecoration(
              color: UsingColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))
            ),
          ),
        ),
        // 建立右方資訊
        Positioned(
          left: 15,
          top: 3,
          child: Container(
            width: 300,
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start ,
              children: [
                createAntiLabel('flutter', UsingColor),
                SizedBox(height: 5,),
                // message 位置尚未解決
                oneTaggedMessage('Ammy', '@QUAN 幫我確認一下是否正確')
                // 每次建立 message 都會新增 SizedBox(height: 5) 跟 onTaggedMessage(name, message)
              ],
            ),
          ),
        ),
      ],
    )
 
  );
  }
}


// 標示反白的標籤
// event/missions屬於來自哪裡的那個標籤
Container createAntiLabel(String group, Color UsingColor){
  return Container(
    decoration: BoxDecoration(
      color: UsingColor,
      borderRadius: BorderRadius.circular(10)
    ),
    child: RichText(
      text: TextSpan(
        children: [
          WidgetSpan(child: Text(' '), alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: Icon(Icons.circle, size: 7, color: Colors.white,),alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: Text(group, style: TextStyle(color: Colors.white, fontSize: 10)), alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: Text(' '), alignment: PlaceholderAlignment.middle),
        ]
      ),
    ),
    //child: Text(' ·' + group + ' ', style: TextStyle(color: Colors.white),),
  );
}

Container oneTaggedMessage(String name, String message){
  return Container(
    width: 300,
    height: 40,
    child: Stack(
      children: [
        //Text('test', style: TextStyle(fontSize: 15),),
        Positioned(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('../assets/groupTest.png', fit: BoxFit.contain,),
            )
          )
        ),
        Positioned(
          left: 30,
          child: Text(name, style: TextStyle(fontSize: 12),),
        ),
        Positioned(
          bottom: 5,
          child: Text(message, style: TextStyle(fontSize: 12),),
        ),
        Positioned(
          bottom: 5,
          right: 25,
          child: Icon(Icons.send_rounded, size: 12,),
        ),
        Positioned(
          bottom: 5,
          right: 15,
          child: Icon(Icons.close, size: 12,),
        )
      ],
    ),
  );
}
