import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/workspace/Calendar/workspace_group_calendar_page_view.dart';
import 'package:grouping_project/View/workspace/Calendar/workspace_personal_calendar_page_view.dart';
import 'package:provider/provider.dart';

class CalendarCoverPage extends StatefulWidget {
  const CalendarCoverPage({super.key});

  @override
  State<CalendarCoverPage> createState() => _CalendarCoverPageState();
}

class _CalendarCoverPageState extends State<CalendarCoverPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, workspaceVM, child) => workspaceVM.isPersonalAccount
          ? const CalendarPersonalViewPage()
          : const CalendarGroupViewPage(),
    );
  }
}
