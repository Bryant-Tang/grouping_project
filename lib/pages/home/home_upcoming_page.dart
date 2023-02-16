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
                _inquireInputDialog(context);
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

  String upcomingTitle = "";
  String upcomingDescript = "";
  String titleWarning = "";
  String descriptWarning = "";
  _inquireInputDialog(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
    return AlertDialog(
      title: Text('Create New Upcoming', style: TextStyle(fontWeight: FontWeight.bold),),
      content: Column(
        children: [
          TextField(
            onChanged: (value){
              setState(() {
                upcomingTitle = value;
              });
            },
            decoration: InputDecoration(hintText: "Please input upcoming title"),
          ),
          TextField(
            onChanged: (value){
              setState(() {
                upcomingDescript = value;
              });
            },
            decoration: InputDecoration(hintText: "Please input upcoming descript"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: (){
            setState(() {
              Navigator.pop(context);
            });
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.redAccent)))
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
        ),
        TextButton(
          onPressed: (){
            setState(() {
              // titleWarning = "";
              // descriptWarning = "";
              addUpcoming(upcomingTitle, upcomingDescript);
              Navigator.pop(context);
            });
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.greenAccent)))
          ),
          child: const Text('Done', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
        )
      ],
    );
    });
  }
}

void addUpcoming(String usingUpcomingTitle, String usingUpcomingDescript){
  upcomingCards.add(
    const SizedBox(height: 2,)
  );
  upcomingCards.add(
      Upcoming(
        group: 'personal',
        title: usingUpcomingTitle,
        descript: usingUpcomingDescript,
        date1: '9:00 PM, FEB2, 2023',
        date2: '11:00 PM, FEB 2, 2023'
      ),
  );
}