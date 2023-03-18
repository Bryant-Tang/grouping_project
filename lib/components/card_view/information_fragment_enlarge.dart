<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/service/auth_service.dart';
=======
// import 'package:flutter/material.dart';
// import 'package:grouping_project/components/card_view.dart';
// import 'package:grouping_project/service/auth_service.dart';
>>>>>>> upstream/master

// class AntiLabel extends StatelessWidget {
//   /// 標籤反白的 group
  
//   const AntiLabel({super.key, required this.group});
//   final String group;
//   final Color usingColor = Colors.black12;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             color: usingColor, borderRadius: BorderRadius.circular(10)),
//         child: Text(
//           ' •$group ',
//           style: const TextStyle(color: Colors.white, fontSize: 10),
//         ));
//   }
// }

// class Contributors extends StatelessWidget{
//   //參與的所有使用者
  
<<<<<<< HEAD
  const Contributors({super.key, required this.contributors});
  final List<UserModel> contributors;

  Container createHeadShot(UserModel person){
    /// 回傳 contributor 的頭貼
    return Container(
      height: 15,
      width: 15,
      decoration: const ShapeDecoration(shape: CircleBorder(side: BorderSide())),
    );
  }
=======
//   const Contributors({super.key, required this.contributors});
//   final List<UserProfile> contributors;

//   Container createHeadShot(UserProfile person){
//     /// 回傳 contributor 的頭貼
//     return Container(
//       height: 15,
//       width: 15,
//       decoration: const ShapeDecoration(shape: CircleBorder(side: BorderSide())),
//     );
//   }
>>>>>>> upstream/master

//   List<Container> datas(){
//     List<Container> tmp = [];
//     for(int i = 0; i < contributors.length; i++){
//       tmp.add(createHeadShot(contributors[i]));
//     }
//     return tmp;
//   }

//   @override
//   Widget build(BuildContext context){
//     return Row(
//       children: datas(),
//     );
//   }
// } 
