part of database_service;

abstract class _FieldNameForMission {
  static String title = 'title';
  static String deadline = 'deadline';
  static String contributor = 'contributor';
  static String introduction = 'intro';
  static String state = 'state';
  static String tag = 'tag';
  static String notification = 'notification';
  static String parentMission = 'parent_mission';
  static String childMission = 'child_mission';
}

class Mission extends DatabaseDocument {
  String title;
  Timestamp _deadline;
  final List<DocumentReference<Map<String, dynamic>>> _contributor;
  String introduction;
  final DocumentReference<Map<String, dynamic>> _state;
  final List<String> _tag;
  final List<Timestamp> _notification;
  final List<DocumentReference<Map<String, dynamic>>> _parentMission;
  final List<DocumentReference<Map<String, dynamic>>> _childMission;

  Mission._create(
      {required DocumentReference<Map<String, dynamic>> missionRef,
      required DocumentReference<Map<String, dynamic>> state})
      : title = _DefaultFieldValue.unknownStr,
        _deadline = _DefaultFieldValue.zeroTimestamp,
        _contributor = List.from(_DefaultFieldValue.emptyList),
        introduction = _DefaultFieldValue.unknownStr,
        _state = state,
        _tag = List.from(_DefaultFieldValue.emptyList),
        _notification = List.from(_DefaultFieldValue.emptyList),
        _parentMission = List.from(_DefaultFieldValue.emptyList),
        _childMission = List.from(_DefaultFieldValue.emptyList),
        super._create(ref: missionRef);

  Mission._fromDatabase(
      {required DocumentSnapshot<Map<String, dynamic>> missionSnap})
      : title = missionSnap.data()?[_FieldNameForMission.title] ??
            _DefaultFieldValue.unknownStr,
        _deadline = missionSnap.data()?[_FieldNameForMission.deadline] != null
            ? Timestamp.fromDate(
                missionSnap.data()?[_FieldNameForMission.deadline])
            : _DefaultFieldValue.zeroTimestamp,
        _contributor = List.from(
            missionSnap.data()?[_FieldNameForMission.contributor] ??
                _DefaultFieldValue.emptyList),
        introduction = missionSnap.data()?[_FieldNameForMission.introduction] ??
            _DefaultFieldValue.unknownStr,
        _state = missionSnap.data()?[_FieldNameForMission.state],
        _tag = List.from(missionSnap.data()?[_FieldNameForMission.tag] ??
            _DefaultFieldValue.emptyList),
        _notification = List.from(
            missionSnap.data()?[_FieldNameForMission.notification] ??
                _DefaultFieldValue.emptyList),
        _parentMission = List.from(
            missionSnap.data()?[_FieldNameForMission.parentMission] ??
                _DefaultFieldValue.emptyList),
        _childMission = List.from(
            missionSnap.data()?[_FieldNameForMission.childMission] ??
                _DefaultFieldValue.emptyList),
        super._fromDatabase(snap: missionSnap);

  Map<String, dynamic> _toDatabase() {
    return {
      _FieldNameForMission.title: title,
      _FieldNameForMission.deadline: _deadline,
      _FieldNameForMission.contributor: _contributor,
      _FieldNameForMission.introduction: introduction,
      _FieldNameForMission.state: _state,
      _FieldNameForMission.tag: _tag,
      _FieldNameForMission.notification: _notification,
      _FieldNameForMission.parentMission: _parentMission,
      _FieldNameForMission.childMission: _childMission,
    };
  }

  DateTime get deadline => _deadline.toDate();
  List<DocumentReference<Map<String, dynamic>>> get contributor => _contributor;
  DocumentReference<Map<String, dynamic>> get stateRef => _state;
  List<String> get tag => _tag;
  List<DateTime> get notification =>
      List.from(_notification.map((t) => t.toDate()));
  List<DocumentReference<Map<String, dynamic>>> get parentMissionRef =>
      _parentMission;
  List<DocumentReference<Map<String, dynamic>>> get childMissionRef =>
      _childMission;

  set deadline(DateTime deadline) => _deadline = Timestamp.fromDate(deadline);

  void addContributorProfileRef(
          DocumentReference<Map<String, dynamic>> profileRef) =>
      _contributor.add(profileRef);
  void addTag(String tag) => _tag.add(tag);
  void addNotification(DateTime notification) =>
      _notification.add(Timestamp.fromDate(notification));
  void addParentMissionRef(
          DocumentReference<Map<String, dynamic>> missionRef) =>
      _parentMission.add(missionRef);
  void addChildMissionRef(DocumentReference<Map<String, dynamic>> missionRef) =>
      _childMission.add(missionRef);

  void removeContributorProfileRef(
          DocumentReference<Map<String, dynamic>> profileRef) =>
      _contributor.remove(profileRef);
  void removeTag(String tag) => _tag.remove(tag);
  void removeNotification(DateTime notification) =>
      _notification.remove(Timestamp.fromDate(notification));
  void removeParentMissionRef(
          DocumentReference<Map<String, dynamic>> missionRef) =>
      _parentMission.remove(missionRef);
  void removeChildMissionRef(
          DocumentReference<Map<String, dynamic>> missionRef) =>
      _childMission.remove(missionRef);

  void clearContributorProfileRef() => _contributor.clear();
  void clearTag() => _tag.clear();
  void clearNotification() => _notification.clear();
  void clearParentMissionRef() => _parentMission.clear();
  void clearChildMissionRef() => _childMission.clear();
}
