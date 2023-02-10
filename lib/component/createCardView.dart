import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Container CreateUpcoming(String group, String title, String descript, String date1, String date2){
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
        Positioned(
          left: 15,
          top: 3,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CreateAntiLabel(group),
                SizedBox(height: 1,),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                SizedBox(height: 1,),
                Text(descript, style: TextStyle(fontSize: 13),),
                SizedBox(height: 1,),
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

Container CreateTracked(String group, String title, String descript, String date1, String date2, int state){
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
        Positioned(
          left: 15,
          top: 3,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CreateAntiLabel(group),
                SizedBox(height: 1,),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                SizedBox(height: 1,),
                Text(descript, style: TextStyle(fontSize: 13),),
                SizedBox(height: 1,),
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
        Positioned(
          left: 300,
          top: 60,
          child: _CreateState(state),
        )
      ],
    )
  );
}

Container _CreateAntiLabel(String group){
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

Container _CreateState(int state){
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