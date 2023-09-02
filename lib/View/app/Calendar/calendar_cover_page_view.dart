// import 'package:flutter/material.dart';
// import 'package:grouping_project/View/app/Calendar/calendar_group_calendar_page_view.dart';
// import 'package:grouping_project/View/app/Calendar/calendar_personal_calendar_page_view.dart';
// import 'package:grouping_project/ViewModel/workspace/workspace_view_model_lib.dart';
// import 'package:provider/provider.dart';

// class CalendarCoverPage extends StatefulWidget {
//   const CalendarCoverPage({super.key});

//   @override
//   State<CalendarCoverPage> createState() => _CalendarCoverPageState();
// }

// class _CalendarCoverPageState extends State<CalendarCoverPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WorkspaceDashBoardViewModel>(
//       builder: (context, workspaceVM, child) => workspaceVM.isPersonalAccount
//           ? const CalendarPersonalViewPage()
//           : const CalendarGroupViewPage(),
//     );
//   }
// }
