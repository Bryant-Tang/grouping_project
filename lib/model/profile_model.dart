import 'data_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// to create a ProfileTag use ProfileTag()
/// and pass all things you want to add
class ProfileTag {
  String tag;
  String content;
  ProfileTag({required this.tag, required this.content});
}

/// to create a ProfileModel use ProfileModel()
/// and pass all things you want to add
///
/// to upload a ProfileModel use .set() method
///
/// to get a ProfileModel use .getAll() method
class ProfileModel extends DataModel {
  String? name;
  String? email;
  int? color;
  String? nickname;
  String? slogan;
  String? introduction;
  List<ProfileTag>? tags;
  Image? photo;

  ProfileModel(
      {this.name,
      this.email,
      this.color,
      this.nickname,
      this.slogan,
      this.introduction,
      this.tags,
      this.photo})
      : super(id: '') {
    super.typeForPath = 'profile';
  }

  @override
  Future<ProfileModel> fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) async {
    final data = snapshot.data();

    List<ProfileTag> fromFirestoreTags = [];
    for (String tag in List.from(data['tag'])) {
      fromFirestoreTags.add(ProfileTag(tag: tag, content: ''));
    }
    int i = 0;
    for (String content in List.from(data['tag_content'])) {
      fromFirestoreTags[i].content = content;
    }

    return ProfileModel(
      name: data['name'],
      email: data['email'],
      color: data['color'],
      nickname: data['nickname'],
      slogan: data['slogan'],
      introduction: data['introduction'],
      tags: fromFirestoreTags,
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    List<String> toFirestoreTags = [];
    List<String> toFirestoreTagContents = [];
    for (ProfileTag tag in tags ?? []) {
      toFirestoreTags.add(tag.tag);
      toFirestoreTagContents.add(tag.content);
    }

    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (color != null) 'color': color,
      if (nickname != null) 'nickname': nickname,
      if (slogan != null) 'slogan': slogan,
      if (introduction != null) 'introduction': introduction,
      if (tags != null) 'tag': toFirestoreTags,
      if (tags != null) 'tag_content': toFirestoreTagContents,
    };
  }

  /// if it is a group profile, remember to pass group id
  /// 
  /// remember to add await
  @override
  Future<void> set({String? groupId}) async {
    await DataController(groupId: groupId).setMethod(processData: this);
  }

  /// if it is a group profile, remember to pass group id
  /// 
  /// remember to add await
  @override
  Future<ProfileModel> getAll({String? groupId}) async {
    ProfileModel processData = (await DataController(groupId: groupId)
        .getAllMethod(dataTypeToGet: this))[0] as dynamic;
    return processData;
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
