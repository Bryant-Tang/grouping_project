import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

// 建立 upcoming component
Container createUpcoming(String group, String title, String descript, String date1, String date2){
  return Container(
    width: 338,
    height: 84,
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
            height: 84,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))
            ),
          ),
        ),
        // 建立右方資訊
        Positioned(
          left: 15,
          top: 3,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createAntiLabel(group),
                SizedBox(height: 1,),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                SizedBox(height: 1,),
                Text(descript, style: TextStyle(fontSize: 13),),
                SizedBox(height: 1,),
                // 建立時間, 尚未完成
                Container(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: date1, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        WidgetSpan(child: Icon(Icons.arrow_right_alt, size: 20, color: Colors.amber,), alignment: PlaceholderAlignment.top),
                        TextSpan(text: date2, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                      ]
                    ),
                  )
                )
              ],
            ),
          ),
        )
      ],
    )
  );
}

// 建立track component
Container createTracked(String group, String title, String descript, String date1, String date2, int state){
  return Container(
    width: 338,
    height: 84,
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
            height: 84,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))
            ),
          ),
        ),
        // 建立右方資訊
        Positioned(
          left: 15,
          top: 3,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createAntiLabel(group),
                SizedBox(height: 1,),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                SizedBox(height: 1,),
                Text(descript, style: TextStyle(fontSize: 13),),
                SizedBox(height: 1,),
                // 建立時間, 尚未完成
                Container(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: date1, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        WidgetSpan(child: Icon(Icons.arrow_right_alt, size: 20, color: Colors.amber,), alignment: PlaceholderAlignment.top),
                        TextSpan(text: date2, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                      ]
                    ),
                  )
                )
              ],
            ),
          ),
        ),
        // 建立狀態
        Positioned(
          right: 15,
          top: 60,
          child: createState(state),
        )
      ],
    )
  );
}

// 標示反白的標籤
// event/missions屬於來自哪裡的那個標籤
Container createAntiLabel(String group){
  return Container(
    decoration: BoxDecoration(
      color: Colors.amber,
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

// 建立狀態
// 尚未完工
Container createState(int state){
  Color stateColor = (state == 0 ? Colors.grey : state == 1 ? Colors.lightBlueAccent : Colors.greenAccent);
  String stateName = (state == 0 ? 'Not Start 未開始' : state == 1 ? 'In progress 進行中' : 'Done 完成');
  
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: stateColor.withOpacity(0.3)
    ),
    child: RichText(
      text: TextSpan(
        children: [
          WidgetSpan(child: Text(' '), alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: Icon(Icons.circle, size: 7, color: stateColor,),alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: Text(stateName, style: TextStyle(color: stateColor, fontSize: 10)), alignment: PlaceholderAlignment.middle),
          WidgetSpan(child: Text(' '), alignment: PlaceholderAlignment.middle),
        ]
      ),
    ),
  );
}
