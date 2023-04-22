import 'package:flutter/material.dart';
import 'package:grouping_project/VM/workspace/workspace_dashboard_view_model.dart';
import 'package:grouping_project/View/create_sheet_view.dart';
import 'package:grouping_project/View/workspace/workspace_view.dart';
import 'package:grouping_project/components/create/create_lib.dart';
import 'package:provider/provider.dart';

class CreateButton extends StatefulWidget {
  const CreateButton({super.key});

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  // TODO: make every widget to stateful widget
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) =>
      FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              // isScrollControlled: true,
              context: context,
              barrierColor: Colors.black12,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (BuildContext context) {
                return ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
                  value: model,
                  child: const CreateButtonSheetView(),
                );
              });
              
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 30,
        ),
      ),
    );
  }
}

class CreateButtonSheetView extends StatelessWidget {
  const CreateButtonSheetView({Key? key}) : super(key: key);
  final List<Widget> createsPng = const [
    CreateTopic(), //not yet
    CreateEvent(),
    CreateNote(), //not yet
    CreateMission()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => SafeArea(
        child: Container(
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 390,
                child: GridView.builder(
                    itemCount: 4,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return createsPng[index];
                    }),
              ),
            ])),
      ),
    );
  }
}
