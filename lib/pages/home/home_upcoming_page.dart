import 'package:grouping_project/component/card_view.dart';

import 'package:flutter/material.dart';

class UpcomingPage extends StatefulWidget{
  UpcomingPage({super.key});
  @override
  State<UpcomingPage> createState() => UpcomingPageState();
}

List<Widget> upcomingCards = [];

class UpcomingPageState extends State<UpcomingPage>{
  @override
  Widget build(BuildContext content){
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center ,
            children: upcomingCards + <Widget>[
              TextButton(onPressed: (){
                setState(() {
                  addUpcoming();
                });
              }, child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Center(child: Icon(Icons.add, color: Colors.amber,)),
              ))
            ],
          )
        ],
      ),
    );
  }
}

void addUpcoming(){
  upcomingCards.add(
    const SizedBox(height: 2,)
  );
  upcomingCards.add(
      Upcoming(
        group: 'flutter 讀書會',
        title: '例行性讀書會',
        descript: '討論 UI 設計與狀態儲存',
        date1: '9:00 PM, FEB2, 2023',
        date2: '11:00 PM, FEB 2, 2023'
      ),
  );
}