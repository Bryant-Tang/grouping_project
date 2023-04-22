// import 'package:grouping_project/components/business_card.dart';

// import 'package:flutter/material.dart';

// class GroupPage extends StatefulWidget {
//   const GroupPage({super.key});
//   @override
//   State<GroupPage> createState() => GroupPageState();
// }

// List<Widget> groups = [];

// class GroupPageState extends State<GroupPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width - 20,
//       height: MediaQuery.of(context).size.height - 80,
//       child: ListView(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: groups +
//                 <Widget>[
//                   TextButton(
//                       onPressed: () {
//                         setState(() {
//                           addGroup();
//                         });
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width - 20,
//                         height: 30,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.amber, width: 2),
//                             borderRadius: BorderRadius.circular(10)),
//                         child: const Center(
//                             child: Icon(
//                           Icons.add,
//                           color: Colors.amber,
//                         )),
//                       ))
//                 ],
//           )
//         ],
//       ),
//     );
//   }
// }

// void addGroup() {
//   groups.add(const SizedBox(
//     height: 2,
//   ));
//   groups.add(GroupCard(title: 'add new title', descript: 'add new descript'));
// }
