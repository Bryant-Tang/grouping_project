import 'package:grouping_project/component/business_card.dart';

import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget{
  GroupPage({super.key});
  @override
  State<GroupPage> createState() => groupPageState();
}

List<Widget> groups = [];

class groupPageState extends State<GroupPage>{
  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center ,
            children: groups + <Widget>[
              TextButton(onPressed: (){
                setState(() {
                  addGroup();
                });
              }, child: Container(width: MediaQuery.of(context).size.width - 20, height: 20, child: Text('add'),))
            ],
          )
        ],
      ),
    );
  }
}

void addGroup(){
  groups.add(
    SizedBox(height: 2,)
  );
  groups.add(
    GroupCard(title: 'add new title', descript: 'add new descript')
  );
}