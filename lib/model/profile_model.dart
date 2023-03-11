import 'package:grouping_project/model_lib.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel extends DataModel {
  String? name;
  String? email;
  String? color;
  ProfileModel({this.name, this.email, this.color}) : super(id: '') {
    super.typeForPath = 'profile';
  }

  @override
  Future<ProfileModel> fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) async {
    final data = snapshot.data();

    return ProfileModel(
      name: data['name'],
      email: data['email'],
      color: data['color'],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (color != null) 'color': color,
    };
  }
}

// Future<Map<String, String>> getGroupList({required String userId}) async {
//   final groupsLocation = FirebaseFirestore.instance
//       .collection('group_properties')
//       .doc(userId)
//       .collection('groups');
//   final groupListSnap = await groupsLocation.get();
//   Map<String, String> groupList = {};
//   for (var groupSnap in groupListSnap.docs) {
//     groupList.addAll({groupSnap.id: groupSnap.data()['name'] as String});
//   }
//   return groupList;
// }
