import 'data_model.dart';

import 'package:flutter/material.dart';

/// ## the type for [ProfileModel.tags]
/// * [tag] : the key for this tag
/// * [content] : the value for this tag
class ProfileTag {
  String tag;
  String content;
  ProfileTag({required this.tag, required this.content});
}

/// ## a data model for profile, either user or group
/// * ***DO NOT*** pass or set id for ProfileModel
class ProfileModel extends DataModel<ProfileModel> {
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
      : super(
            id: 'profile',
            databasePath: 'profiles',
            storageRequired: false,
            setOwnerRequired: false);

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Map<String, dynamic> toFirestore() {
    List<String> toFirestoreTagList = [];
    List<String> toFirestoreTagContentList = [];

    for (var profileTag in tags ?? <ProfileTag>[]) {
      toFirestoreTagList.add(profileTag.tag);
      toFirestoreTagContentList.add(profileTag.content);
    }

    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (color != null) 'color': color,
      if (nickname != null) 'nickname': nickname,
      if (slogan != null) 'slogan': slogan,
      if (introduction != null) 'introduction': introduction,
      if (tags != null) 'tag': toFirestoreTagList,
      if (tags != null) 'tag_content': toFirestoreTagContentList,
    };
  }

  /// ### set the data from firestore for this instance, and also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  ProfileModel fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      ProfileModel? ownerProfile}) {
    List<ProfileTag> fromFirestoreTags = [];
    for (String tag in List.from(data['tag'])) {
      fromFirestoreTags.add(ProfileTag(tag: tag, content: ''));
    }
    int i = 0;
    for (String content in List.from(data['tag_content'])) {
      fromFirestoreTags[i].content = content;
    }

    ProfileModel processData = ProfileModel(
        name: data['name'],
        email: data['email'],
        color: data['color'],
        nickname: data['nickname'],
        slogan: data['slogan'],
        introduction: data['introduction'],
        tags: fromFirestoreTags);

    return processData;
  }
}
