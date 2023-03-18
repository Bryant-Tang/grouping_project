import 'package:flutter/material.dart';
import 'package:grouping_project/components/overview_choice.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  int overViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height,
      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('OVERVIEW', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),),
          const Divider(height: 7, thickness: 3,),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    overViewIndex = 0;
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: OverViewChoice(
                      textColor: (overViewIndex == 0
                          ? Colors.white
                          : Colors.black),
                      backgroundColor: (overViewIndex == 0
                          ? const Color(0xFFFCBF49)
                          : Colors.white),
                      total: 4,
                      inform: '事件 - 即將到來',
                      icon: Icons.calendar_month_rounded),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    overViewIndex = 1;
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: OverViewChoice(
                      textColor: (overViewIndex == 1
                          ? Colors.white
                          : Colors.black),
                      backgroundColor: (overViewIndex == 1
                          ? const Color(0xFFFCBF49)
                          : Colors.white),
                      total: 10,
                      inform: '任務 - 追蹤中',
                      icon: Icons.list),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    overViewIndex = 2;
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: OverViewChoice(
                      textColor: (overViewIndex == 2
                          ? Colors.white
                          : Colors.black),
                      backgroundColor: (overViewIndex == 2
                          ? const Color(0xFFFCBF49)
                          : Colors.white),
                      total: 20,
                      inform: '話題 - 待回覆',
                      icon: Icons.message),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}
