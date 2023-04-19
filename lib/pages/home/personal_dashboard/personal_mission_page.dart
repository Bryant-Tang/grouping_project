//import 'package:grouping_project/components/card_view.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:grouping_project/components/card_view/mission_information.dart';

import 'package:flutter/material.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({super.key});
  @override
  State<MissionPage> createState() => MissionPageState();
}

List<Widget> missionCards = [];

class MissionPageState extends State<MissionPage> {
  @override
  void initState() {
    super.initState();
    showMissions().then((value) {
      if(mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: missionCards)
        ],
      ),
    );
  }
}

Future<void> showMissions() async {
  // var allDatas =
  //     await DataController().downloadAll(dataTypeToGet: MissionModel());

  // missionCards = [];
  // for (int index = 0; index < allDatas.length; index++) {
  //   var mission = allDatas[index];
  //   missionCards.add(const SizedBox(
  //     height: 10,
  //   ));
  //   missionCards.add(MissionCardViewTemplate(missionModel: mission));
  // }
}
