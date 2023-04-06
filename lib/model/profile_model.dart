import 'data_model.dart';

import 'dart:io' as io show File;

/// ## the type for [ProfileModel.tags]
/// * [tag] : the key for this tag
/// * [content] : the value for this tag
class ProfileTag {
  String tag;
  String content;
  ProfileTag({required this.tag, required this.content});

  @override
  String toString() {
    return "Profile Tag: $tag : $content";
  }
}

/// ## a data model for profile, either user or group
/// * ***DO NOT*** pass or set id for ProfileModel
class ProfileModel extends DataModel<ProfileModel> implements StorageData {
  String? name;
  String? email;
  int? color;
  String? nickname;
  String? slogan;
  String? introduction;
  List<ProfileTag>? tags;
  io.File? photo;
  List<String>? associateEntityId;

  ProfileModel(
      {this.name,
      this.email,
      this.color,
      this.nickname,
      this.slogan,
      this.introduction,
      this.tags,
      this.photo,
      this.associateEntityId})
      : super(
            id: 'profile',
            databasePath: 'profiles',
            storageRequired: true,
            setOwnerRequired: false);

  /// convert `List<ProfileTag>` to `List<String>` with `ProfileTag.tag`
  List<String> _toFirestoreTag(List<ProfileTag> profileTagList) {
    List<String> processList = [];
    for (ProfileTag profileTag in profileTagList) {
      processList.add(profileTag.tag);
    }
    return processList;
  }

  /// convert `List<ProfileTag>` to `List<String>` with `ProfileTag.content`
  List<String> _toFirestoreTagContent(List<ProfileTag> profileTagList) {
    List<String> processList = [];
    for (ProfileTag profileTag in profileTagList) {
      processList.add(profileTag.content);
    }
    return processList;
  }

  /// convert two `List<String>` to `List<ProfileTag>`
  List<ProfileTag> _fromFirestoreTags(
      List<String> tagList, List<String> tagContentList) {
    List<ProfileTag> processList = [];
    for (var i = 0; i < tagList.length; i++) {
      if (i < tagContentList.length) {
        processList
            .add(ProfileTag(tag: tagList[i], content: tagContentList[i]));
      }
    }
    return processList;
  }

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (color != null) 'color': color,
      if (nickname != null) 'nickname': nickname,
      if (slogan != null) 'slogan': slogan,
      if (introduction != null) 'introduction': introduction,
      if (tags != null) 'tags': _toFirestoreTag(tags!),
      if (tags != null) 'tag_contents': _toFirestoreTagContent(tags!),
    };
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  ProfileModel fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      ProfileModel? ownerProfile}) {
    ProfileModel processData = ProfileModel(
        name: data['name'],
        email: data['email'],
        color: data['color'],
        nickname: data['nickname'],
        slogan: data['slogan'],
        introduction: data['introduction'],
        tags: (data['tags'] is Iterable) && (data['tag_contents'] is Iterable)
            ? _fromFirestoreTags(
                List.from(data['tags']), List.from(data['tag_contents']))
            : null);

    return processData;
  }

  @override
  Map<String, io.File> toStorage() {
    return {if (photo != null) 'photo': photo!};
  }

  @override
  void setAttributeFromStorage({required Map<String, io.File> data}) {
    photo = data['photo'];
  }

  void addEntity(String id) {
    if (associateEntityId?.contains(id) == false) {
      associateEntityId?.add(id);
    }
  }

  void removeEntity(String id) {
    if (associateEntityId?.contains(id) == true) {
      associateEntityId?.remove(id);
    }
  }
}
