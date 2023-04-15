// ignore_for_file: unnecessary_this
import 'data_controller.dart';
import 'data_model.dart';

import 'dart:io' as io show File;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/services.dart' as flutter_services show AssetBundle;

/// ## the type for [ProfileModel.tags]
/// * [tag] : the key for this tag
/// * [content] : the value for this tag
class ProfileTag {
  String tag;
  String content;
  ProfileTag({required this.tag, required this.content});

  @override
  String toString() {
    return 'Profile Tag: $tag : $content';
  }
}

/// ## a data model for profile, either user or group
/// * ***DO NOT*** pass or set id for ProfileModel
/// * to upload/download, use `DataController`
class ProfileModel extends BaseDataModel<ProfileModel>
    implements BaseStorageData {
  String name;
  String email;
  int color;
  String nickname;
  String slogan;
  String introduction;
  List<ProfileTag> tags;
  io.File photo;
  List<String> associateEntityId;

  /// default profile that all attribute is set to a default value
  static final ProfileModel defaultProfile = ProfileModel._default();

  /// default constructor, only for default profile
  ProfileModel._default()
      : this.name = 'unknown',
        this.color = 0xFFFCBF49,
        this.email = 'unknown',
        this.nickname = 'unknown',
        this.slogan = 'unknown',
        this.introduction = 'unknown',
        this.tags = [],
        this.photo = io.File(''),
        this.associateEntityId = [],
        super(
            id: 'profile_default',
            databasePath: 'profiles',
            storageRequired: true);

  /// ## a data model for profile, either user or group
  /// * ***DO NOT*** pass or set id for ProfileModel
  /// * to upload/download, use `DataController`
  ProfileModel(
      {String? name,
      String? email,
      int? color,
      String? nickname,
      String? slogan,
      String? introduction,
      List<ProfileTag>? tags,
      io.File? photo,
      List<String>? associateEntityId})
      : this.name = name ?? defaultProfile.name,
        this.email = email ?? defaultProfile.email,
        this.color = color ?? defaultProfile.color,
        this.nickname = nickname ?? defaultProfile.nickname,
        this.slogan = slogan ?? defaultProfile.slogan,
        this.introduction = introduction ?? defaultProfile.introduction,
        this.tags = tags ?? defaultProfile.tags,
        this.photo = photo ?? defaultProfile.photo,
        this.associateEntityId =
            associateEntityId ?? defaultProfile.associateEntityId,
        super(
          id: defaultProfile.id,
          databasePath: defaultProfile.databasePath,
          storageRequired: defaultProfile.storageRequired,
          // setOwnerRequired: false
        );

  /// ### A method to copy an instance from this instance, and change some data with given.
  ProfileModel copyWith({
    String? name,
    String? email,
    int? color,
    String? nickname,
    String? slogan,
    String? introduction,
    List<ProfileTag>? tags,
    io.File? photo,
    List<String>? associateEntityId,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      color: color ?? this.color,
      nickname: nickname ?? this.nickname,
      slogan: slogan ?? this.slogan,
      introduction: introduction ?? this.introduction,
      tags: tags ?? this.tags,
      photo: photo ?? this.photo,
      associateEntityId: associateEntityId ?? this.associateEntityId,
    );
  }

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
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController}) async {
    return {
      if (name != defaultProfile.name) 'name': name,
      if (email != defaultProfile.email) 'email': email,
      if (color != defaultProfile.color) 'color': color,
      if (nickname != defaultProfile.nickname) 'nickname': nickname,
      if (slogan != defaultProfile.slogan) 'slogan': slogan,
      if (introduction != defaultProfile.introduction)
        'introduction': introduction,
      if (tags != defaultProfile.tags) 'tags': _toFirestoreTag(tags),
      if (tags != defaultProfile.tags)
        'tag_contents': _toFirestoreTagContent(tags),
      if (associateEntityId != defaultProfile.associateEntityId)
        'associate_entity_id': associateEntityId,
    };
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  Future<ProfileModel> fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      required DataController ownerController}) async {
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
            : null,
        associateEntityId: data['associate_entity_id'] is Iterable
            ? List.from(data['associate_entity_id'])
            : null);

    return processData;
  }

  /// ### collect the data in this instance which need to upload to storage
  /// * ***DO NOT*** use this method in frontend
  @override
  Map<String, io.File> toStorage() {
    return {if (photo != defaultProfile.photo) 'photo': photo};
  }

  /// ### set the data in this instance which need to downlaod from storage
  /// * ***DO NOT*** use this method in frontend
  @override
  void setAttributeFromStorage({required Map<String, io.File> data}) {
    photo = data['photo'] ?? defaultProfile.photo;
  }

  /// ### add an associate entity id to this profile
  void addEntity(String id) {
    if (associateEntityId.contains(id) == false) {
      associateEntityId.add(id);
    }
  }

  /// ### remove an associate entity id to this profile
  void removeEntity(String id) {
    if (associateEntityId.contains(id) == true) {
      associateEntityId.remove(id);
    }
  }
}
