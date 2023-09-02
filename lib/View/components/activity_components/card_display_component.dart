// TODO: unused file but could be rewrite by other.
import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';

// class ContentDisplayBlock extends StatelessWidget {
//   final String blockTitle;
//   final Widget child;
//   const ContentDisplayBlock(
//       {Key? key, required this.blockTitle, required this.child})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     TextStyle blockTitleTextStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: Theme.of(context).colorScheme.secondary);
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(blockTitle, style: blockTitleTextStyle),
//             const Divider(thickness: 3),
//             child
//           ],
//         ));
//   }
// }

// class DateTimeDisplayBlock extends StatelessWidget {
//   final String timeText;
//   const DateTimeDisplayBlock({Key? key, required this.timeText})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(Icons.timer,
//             color: Theme.of(context).colorScheme.secondary, size: 16),
//         const SizedBox(width: 4),
//         Text(
//           timeText,
//           style: Theme.of(context).textTheme.labelSmall!.copyWith(
//               fontSize: 14,
//               color: Theme.of(context).colorScheme.secondary,
//               fontWeight: FontWeight.bold),
//         )
//       ],
//     );
//   }
// }

// // build IntroductionDisplayBlock Widget
// // class InformationDisplayBlock extends StatelessWidget {
// //   final Object model;
// //   const InformationDisplayBlock({Key? key, required this.model})
// //       : super(key: key);
// //   @override
// //   Widget build(BuildContext context) {
// //     TextStyle titleTextStyle = Theme.of(context)
// //         .textTheme
// //         .titleMedium!
// //         .copyWith(fontWeight: FontWeight.bold, fontSize: 28);
// //     Widget eventOwnerLabel = Row(
// //       children: [
// //         ColorTagChip(
// //             tagString: "事件 - ${model.eventModel.ownerAccount.nickname} 的工作區",
// //             color: Theme.of(context).colorScheme.primary,
// //             fontSize: 14),
// //       ],
// //     );
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       mainAxisAlignment: MainAxisAlignment.start,
// //       children: [
// //         eventOwnerLabel,
// //         TextFormField(
// //           initialValue: model.title,
// //           style: titleTextStyle,
// //           onChanged: model.updateTitle,
// //           decoration: const InputDecoration(
// //               hintText: "輕觸開始編輯標題",
// //               isDense: true,
// //               contentPadding: EdgeInsets.symmetric(vertical: 2),
// //               border: OutlineInputBorder(
// //                 borderSide: BorderSide(
// //                   width: 0,
// //                   style: BorderStyle.none,
// //                 ),
// //               )),
// //           validator: model.titleValidator,
// //         ),
// //         getDateTime(model)
// //       ],
// //     );
// //   }
// // }
