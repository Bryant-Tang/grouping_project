import 'package:flutter/material.dart';
import 'package:grouping_project/components/create/create_lib.dart';

class CreateButton extends StatefulWidget {
  const CreateButton({super.key});

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  final List<StatelessWidget> createsPng = const [
    AddTopic(),
    AddEvent(),
    AddNote(),
    AddMission()
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                barrierColor: Colors.black12,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                builder: (BuildContext context) {
                  return SizedBox(
                      height: 460,
                      child: Column(children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFFB782),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                        ),
                        const SizedBox(
                          height: 37,
                          child: Center(
                              child: Text(
                            'Create',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        ),
                        Positioned(
                          bottom: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 390,
                            child: GridView.builder(
                                itemCount: 4,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return createsPng[index];
                                }),
                          ),
                        ),
                      ]));
                });
          },
          child: const Icon(
            Icons.add,
            color: Color(0xFFFFFFFF),
            size: 30,
          ),
        ));
  }
}
