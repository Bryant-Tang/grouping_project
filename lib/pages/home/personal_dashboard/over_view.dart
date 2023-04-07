import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/components/card_view/card_view_template.dart';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/components/overview_choice.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
import 'package:grouping_project/pages/home/personal_dashboard/home_mission_page.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  int overViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OVERVIEW',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0XFF717171)),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0XFF999898),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        overViewIndex = 0;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: OverViewChoice(
                        textColor: (overViewIndex == 0
                            ? Colors.white
                            : const Color(0XFF5C5C5C)),
                        backgroundColor: (overViewIndex == 0
                            ? const Color(0xFFFCBF49)
                            : const Color(0XFFFFFDF9)),
                        totalNumber: Text(
                          "10",
                          style: TextStyle(
                            color: overViewIndex == 0
                                ? const Color(0XFFFFFDF9)
                                : const Color(0xFFFCBF49),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        inform: '事件 - 即將到來',
                        icon: SvgPicture.asset(
                          "assets/icons/calendartick.svg",
                          colorFilter: ColorFilter.mode(
                              overViewIndex == 0
                                  ? const Color(0XFFFFFDF9)
                                  : const Color(0XFF5C5C5C),
                              BlendMode.srcIn),
                        )),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      overViewIndex = 1;
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: OverViewChoice(
                        textColor: (overViewIndex == 1
                            ? Colors.white
                            : const Color(0XFF5C5C5C)),
                        backgroundColor: (overViewIndex == 1
                            ? const Color(0xFFFCBF49)
                            : const Color(0XFFFFFDF9)),
                        totalNumber: Text(
                          "30",
                          style: TextStyle(
                            color: overViewIndex == 1
                                ? const Color(0XFFFFFDF9)
                                : const Color(0xFFFCBF49),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        inform: '任務 - 追蹤中',
                        icon: SvgPicture.asset(
                          "assets/icons/task.svg",
                          colorFilter: ColorFilter.mode(
                              overViewIndex == 1
                                  ? const Color(0XFFFFFDF9)
                                  : const Color(0XFF5C5C5C),
                              BlendMode.srcIn),
                        )),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      overViewIndex = 2;
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: OverViewChoice(
                        textColor: (overViewIndex == 2
                            ? Colors.white
                            : const Color(0XFF5C5C5C)),
                        backgroundColor: (overViewIndex == 2
                            ? const Color(0xFFFCBF49)
                            : const Color(0XFFFFFDF9)),
                        totalNumber: Text(
                          "5+",
                          style: TextStyle(
                            color: overViewIndex == 2
                                ? const Color(0XFFFFFDF9)
                                : const Color(0xFFFCBF49),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        inform: '話題 - 代回覆',
                        icon: SvgPicture.asset(
                          "assets/icons/messagetick.svg",
                          colorFilter: ColorFilter.mode(
                              overViewIndex == 2
                                  ? const Color(0XFFFFFDF9)
                                  : const Color(0XFF5C5C5C),
                              BlendMode.srcIn),
                        )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(child: pages[overViewIndex]),
            // child: Container(
            //   decoration:
            //       BoxDecoration(border: Border.all(color: Colors.black)),
            // ),
          )
        ],
      ),
    );
  }
}

// 待確認是否應該是要將 listview 放在 container 裡面
List<ListView> pages = [
  // Expanded(child: ListView(children: const [EventPage()])),
  // Expanded(child: ListView(
  //   children: const [MissionPage()],
  // )),
  ListView(
    children: [
      Container(
        height: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      ),
      const EventPage(),
      // CardViewTemplate(detailShrink: EventInformationShrink(eventModel: EventModel()), detailEnlarge: EventInformationEnlarge(eventModel: EventModel()))
    ],
  ),
  ListView(
    children: [
      Container(
        height: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      ),
    ],
  ),
  ListView(
    children: [
      Container(
        height: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      ),
    ],
  ),
];
