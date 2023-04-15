import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/home_page/base_page.dart';
import 'package:grouping_project/components/card_view/mission_information.dart';
import 'package:grouping_project/ViewModel/enlarge_edit_viewmodel.dart';
import 'dart:math';

/*
* this file is used to create mission or edit existed mission 
*/
List<Color> allColors = const <Color>[
  Color(0xFFFF6565),
  Color(0xFFFF61DF),
  Color(0xFFFCBF49),
  Color(0xFF73C0FF),
  Color(0xFFB3FFB7)
];

class MissionEditPage extends StatefulWidget {
  const MissionEditPage({super.key, this.missionModel});

  final MissionModel? missionModel;

  @override
  State<MissionEditPage> createState() => _MissionEditPageState();
}

class _MissionEditPageState extends State<MissionEditPage> {
  late TextEditingController titleController;
  late TextEditingController descriptController;
  late String group;
  late DateTime deadline;
  // TODO: check color is random or not
  late Color color;
  late List<String> contributorIds;

  @override
  void initState() {
    super.initState();
    if (widget.missionModel == null) {
      titleController = TextEditingController(text: '');
      descriptController = TextEditingController(text: '');
      // TODO: check is group or personal
      group = 'personal';
      deadline = DateTime.now().add(const Duration(days: 1));
      color = allColors[Random().nextInt(allColors.length)];
      contributorIds = [];
    } else {
      titleController = TextEditingController(text: widget.missionModel!.title);
      descriptController =
          TextEditingController(text: widget.missionModel!.introduction);
      group = widget.missionModel!.ownerName;
      deadline = widget.missionModel!.deadline!;
      color = Color(widget.missionModel!.color);
      contributorIds = widget.missionModel!.contributorIds ?? [];
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> createMission() async {
      await DataController().upload(
          uploadData: MissionModel(
        title: titleController.text,
        introduction: descriptController.text,
        deadline: deadline,
        contributorIds: contributorIds
      ));
    }

    void updateMission() async {
      await DataController().upload(
          uploadData: MissionModel(
        id: widget.missionModel!.id,
        title: titleController.text,
        introduction: descriptController.text,
        deadline: deadline,
        contributorIds: contributorIds
      ));
    }

    void removeMission() async {
      await DataController().remove(removeData: widget.missionModel!);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      debugPrint('back');
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel)),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          debugPrint('remove');
                          if (widget.missionModel != null) {
                            removeMission();
                            // Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const BasePage()),
                                (route) => false);
                          } else {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return const AlertDialog(
                                    content: Text(
                                        "You can't delete the mission which is not existed yet."),
                                  );
                                }));
                          }
                        },
                        icon: const Icon(Icons.delete)),
                    IconButton(
                        onPressed: () async {
                          if (titleController.text.isNotEmpty &&
                              descriptController.text.isNotEmpty &&
                              deadline.isAfter(DateTime.now())) {
                            // debugPrint('Done');
                            if (widget.missionModel != null) {
                              updateMission();
                            }
                            else {
                              await createMission();
                            }
                            // Navigator.pop(context);
                            if(context.mounted) {Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const BasePage()),
                                (route) => false);}
                          } else {
                            debugPrint('error occur');
                          }
                        },
                        icon: const Icon(Icons.done)),
                  ],
                )
              ],
            ),
            const Divider(
              thickness: 1.5,
              color: Color.fromARGB(255, 170, 170, 170),
            ),
            TitleDateOfMission(
                titleController: titleController,
                deadline: deadline,
                group: group,
                color: color,
                callback: (p0) {
                  deadline = p0;
                }),
            EnlargeObjectTemplate(
                title: '參與成員',
                contextOfTitle: Contributors(
                  contributorIds: contributorIds,
                  callback: (p0) {
                    contributorIds = p0;
                  },
                )),
            const SizedBox(
              height: 1,
            ),
            EnlargeObjectTemplate(
              title: '敘述',
              contextOfTitle: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                controller: descriptController,
                onChanged: (value) {
                  descriptController.text = value;
                  descriptController.selection = TextSelection.fromPosition(
                      TextPosition(offset: value.length));
                  setState(() {});
                },
                decoration: InputDecoration(
                    hintText: '輸入標題',
                    errorText: descriptController.text.isEmpty ? '不可為空' : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    border: const OutlineInputBorder()),
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            // TODO: connect mission and mission
            const EnlargeObjectTemplate(
              title: '相關任務',
              contextOfTitle: CollabMissons(),
            ),
            const SizedBox(
              height: 2,
            ),
            // TODO: connect note and mission
            const EnlargeObjectTemplate(
                title: '相關共筆', contextOfTitle: CollabNotes()),
            const SizedBox(
              height: 2,
            ),
            // TODO: connect mission and meeting
            const EnlargeObjectTemplate(
              title: '相關會議',
              contextOfTitle: CollabMeetings(),
            ),
          ],
        ),
      ),
    );
  }
}
