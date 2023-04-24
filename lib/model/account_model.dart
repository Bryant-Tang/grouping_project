// ignore_for_file: unnecessary_this
import 'dart:typed_data';
import 'data_model.dart';

/// ## the type for [AccountModel.tags]
/// * [tag] : the key for this tag
/// * [content] : the value for this tag
class AccountTag {
  String tag;
  String content;
  AccountTag({required this.tag, required this.content});

  @override
  String toString() {
    return 'Account Tag: $tag : $content';
  }
}

/// ## a data model for account, either user or group
/// * ***DO NOT*** pass or set id for AccountModel
/// * to upload/download, use `DataController`
class AccountModel extends BaseDataModel<AccountModel>
    implements BaseStorageData {
  String name;
  String email;
  int color;
  String nickname;
  String slogan;
  String introduction;
  List<AccountTag> tags;
  String photoId;
  Uint8List photo;
  List<String> associateEntityId;
  List<AccountModel> associateEntityAccount;

  /// default account that all attribute is set to a default value
  static final AccountModel defaultAccount = AccountModel._default();

  /// default constructor, only for default account
  AccountModel._default()
      : this.name = 'unknown',
        this.color = 0xFFFCBF49,
        this.email = 'unknown',
        this.nickname = 'unknown',
        this.slogan = 'unknown',
        this.introduction = 'unknown',
        this.tags = [],
        this.photoId = 'unknown',
        this.photo = Uint8List(0),
        this.associateEntityId = [],
        this.associateEntityAccount = [],
        super(
            id: 'default_account',
            databasePath: 'account',
            storageRequired: true);

  /// ## a data model for account, either user or group
  /// * ***DO NOT*** pass or set id for AccountModel
  /// * to upload/download, use `DataController`
  AccountModel({
    String? accountId,
    String? name,
    String? email,
    int? color,
    String? nickname,
    String? slogan,
    String? introduction,
    List<AccountTag>? tags,
    String? photoId,
    Uint8List? photo,
    List<String>? associateEntityId,
    List<AccountModel>? associateEntityAccount,
  })  : this.name = name ?? defaultAccount.name,
        this.email = email ?? defaultAccount.email,
        this.color = color ?? defaultAccount.color,
        this.nickname = nickname ?? defaultAccount.nickname,
        this.slogan = slogan ?? defaultAccount.slogan,
        this.introduction = introduction ?? defaultAccount.introduction,
        this.tags = tags ?? List.from(defaultAccount.tags),
        this.photoId = photoId ?? defaultAccount.photoId,
        this.photo = photo ?? defaultAccount.photo,
        this.associateEntityId =
            associateEntityId ?? List.from(defaultAccount.associateEntityId),
        this.associateEntityAccount =
            associateEntityAccount ?? List.from(defaultAccount.associateEntityAccount),
        super(
          id: accountId,
          databasePath: defaultAccount.databasePath,
          storageRequired: defaultAccount.storageRequired,
          // setOwnerRequired: false
        );

  /// ### A method to copy an instance from this instance, and change some data with given.
  AccountModel copyWith({
    String? accountId,
    String? name,
    String? email,
    int? color,
    String? nickname,
    String? slogan,
    String? introduction,
    List<AccountTag>? tags,
    String? photoId,
    Uint8List? photo,
    List<String>? associateEntityId,
    List<AccountModel>? associateEntityAccount,
  }) {
    return AccountModel(
      accountId: accountId ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      color: color ?? this.color,
      nickname: nickname ?? this.nickname,
      slogan: slogan ?? this.slogan,
      introduction: introduction ?? this.introduction,
      tags: tags ?? this.tags,
      photoId: photoId ?? this.photoId,
      photo: photo ?? this.photo,
      associateEntityId: associateEntityId ?? this.associateEntityId,
    );
  }

  /// convert `List<AccountTag>` to `List<String>` with `AccountTag.tag`
  List<String> _toFirestoreTag(List<AccountTag> accountTagList) {
    List<String> processList = [];
    for (AccountTag accountTag in accountTagList) {
      processList.add(accountTag.tag);
    }
    return processList;
  }

  /// convert `List<AccountTag>` to `List<String>` with `AccountTag.content`
  List<String> _toFirestoreTagContent(List<AccountTag> accountTagList) {
    List<String> processList = [];
    for (AccountTag accountTag in accountTagList) {
      processList.add(accountTag.content);
    }
    return processList;
  }

  /// convert two `List<String>` to `List<AccountTag>`
  List<AccountTag> _fromFirestoreTags(
      List<String> tagList, List<String> tagContentList) {
    List<AccountTag> processList = [];
    for (var i = 0; i < tagList.length; i++) {
      if (i < tagContentList.length) {
        processList
            .add(AccountTag(tag: tagList[i], content: tagContentList[i]));
      }
    }
    return processList;
  }

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Map<String, dynamic> toFirestore() {
    return {
      if (name != defaultAccount.name) 'name': name,
      if (email != defaultAccount.email) 'email': email,
      if (color != defaultAccount.color) 'color': color,
      if (nickname != defaultAccount.nickname) 'nickname': nickname,
      if (slogan != defaultAccount.slogan) 'slogan': slogan,
      if (introduction != defaultAccount.introduction)
        'introduction': introduction,
      if (tags != defaultAccount.tags) 'tags': _toFirestoreTag(tags),
      if (tags != defaultAccount.tags)
        'tag_contents': _toFirestoreTagContent(tags),
      if (photoId != defaultAccount.photoId) 'photo_id': photoId,
      if (associateEntityId != defaultAccount.associateEntityId)
        'associate_entity_id': associateEntityId,
    };
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  /// [id] : the account id of this account
  @override
  AccountModel fromFirestore(
      {String? uid, required String id, required Map<String, dynamic> data}) {
    AccountModel processData = AccountModel(
        accountId: id,
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
        photoId: data['photo_id'],
        associateEntityId: data['associate_entity_id'] is Iterable
            ? List.from(data['associate_entity_id'])
            : null);

    return processData;
  }

  /// ### collect the data in this instance which need to upload to storage
  /// * ***DO NOT*** use this method in frontend
  @override
  Map<String, Uint8List> toStorage() {
    return {if (photo != defaultAccount.photo) 'photo': photo};
  }

  /// ### set the data in this instance which need to downlaod from storage
  /// * ***DO NOT*** use this method in frontend
  @override
  void setAttributeFromStorage({required Map<String, Uint8List> data}) {
    photo = data['photo'] ?? defaultAccount.photo;
  }

  /// ### add an associate entity id to this account
  void addEntity(String id) {
    if (associateEntityId.contains(id) == false) {
      associateEntityId.add(id);
    }
  }

  /// ### remove an associate entity id to this account
  void removeEntity(String id) {
    if (associateEntityId.contains(id) == true) {
      associateEntityId.remove(id);
    }
  }
}
