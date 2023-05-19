part of database_service;

abstract class _FieldNameForProfile {
  static String name = 'name';
  static String email = 'email';
  static String color = 'color';
  static String nickname = 'nickname';
  static String slogan = 'slogan';
  static String introduction = 'intro';
  static String tag = 'tag';
  static String photo = 'photo';
}

class ProfileTag {
  String tag;
  String content;
  ProfileTag({required this.tag, required this.content});
  List<String> get toList => [tag, content];
  factory ProfileTag.fromTwoElementList({required List<String> list}) {
    if (list.length != 2) {
      throw GroupingProjectException(
          message: 'The given parameter is not fit the format,'
              ' which is a list containing two string.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    return ProfileTag(tag: list[0], content: list[1]);
  }
}

class Profile extends DatabaseDocument {
  String realName;
  String email;
  int color;
  String userName;
  String slogan;
  String introduction;
  final List<ProfileTag> _tag;
  final DocumentReference<Map<String, dynamic>> _photo;

  Profile._create({
    required DocumentReference<Map<String, dynamic>> profileRef,
    required DocumentReference<Map<String, dynamic>> photo,
  })  : realName = _DefaultFieldValue.unknownStr,
        email = _DefaultFieldValue.unknownStr,
        color = _DefaultFieldValue.zeroInt,
        userName = _DefaultFieldValue.unknownStr,
        slogan = _DefaultFieldValue.unknownStr,
        introduction = _DefaultFieldValue.unknownStr,
        _tag = List.from(_DefaultFieldValue.emptyList),
        _photo = photo,
        super._create(ref: profileRef);

  Profile._fromDatabase(
      {required DocumentSnapshot<Map<String, dynamic>> profileSnap})
      : realName = profileSnap.data()?[_FieldNameForProfile.name] ??
            _DefaultFieldValue.unknownStr,
        email = profileSnap.data()?[_FieldNameForProfile.email] ??
            _DefaultFieldValue.unknownStr,
        color = profileSnap.data()?[_FieldNameForProfile.color] ??
            _DefaultFieldValue.zeroInt,
        userName = profileSnap.data()?[_FieldNameForProfile.nickname] ??
            _DefaultFieldValue.unknownStr,
        slogan = profileSnap.data()?[_FieldNameForProfile.slogan] ??
            _DefaultFieldValue.unknownStr,
        introduction = profileSnap.data()?[_FieldNameForProfile.introduction] ??
            _DefaultFieldValue.unknownStr,
        _tag = List.from(List.from(
                profileSnap.data()?[_FieldNameForProfile.tag] ??
                    _DefaultFieldValue.emptyList)
            .map(
                (tagInList) => ProfileTag.fromTwoElementList(list: tagInList))),
        _photo = profileSnap.data()?[_FieldNameForProfile.photo],
        super._fromDatabase(snap: profileSnap);

  Map<String, dynamic> _toDatabase() {
    return {
      _FieldNameForProfile.name: realName,
      _FieldNameForProfile.email: email,
      _FieldNameForProfile.color: color,
      _FieldNameForProfile.nickname: userName,
      _FieldNameForProfile.slogan: slogan,
      _FieldNameForProfile.introduction: introduction,
      _FieldNameForProfile.tag: _tag.map((tag) => tag.toList),
      _FieldNameForProfile.photo: _photo,
    };
  }

  List<ProfileTag> get tag => _tag;
  DocumentReference<Map<String, dynamic>> get photo => _photo;

  void addTag(ProfileTag tag) => _tag.add(tag);
  void removeTag(ProfileTag tag) => _tag.remove(tag);
  void clearTag() => _tag.clear();
}
