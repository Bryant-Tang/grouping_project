import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/mission_information.dart';

class AddMission extends StatefulWidget {
  const AddMission({super.key});

  @override
  State<AddMission> createState() => _AddMissionState();
}

class _AddMissionState extends State<AddMission> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        debugPrint('create mission');
        await Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const MissionEditPage())));
        setState(() {});
      },
      splashFactory: InkRipple.splashFactory,
      child: Card(
        child: Container(
          width: 190,
          height: 300,
          color: const Color(0xFFFFE8D8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/Mission.png'),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  '任務 MISSION',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    '建立一個新的任務、作業、里程碑，利用狀態來去做追蹤。',
                    softWrap: true,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
