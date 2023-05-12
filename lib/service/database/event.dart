part of database_service;

abstract class _FieldNameForEvent {
  static String title = 'title';
  static String startTime = 'start_time';
  static String endTime = 'end_time';
  static String contributor = 'contributor';
  static String introduction = 'intro';
  static String tag = 'tag';
  static String notification = 'notification';
  static String relatedMission = 'related_mission';
}

class Event extends DatabaseDocument {
  String title;
  Timestamp _startTime;
  Timestamp _endTime;
  final List<DocumentReference<Map<String, dynamic>>> _contributor;
  String introduction;
  final List<String> _tag;
  final List<Timestamp> _notification;
  final List<DocumentReference<Map<String, dynamic>>> _relatedMission;

  Event._create({required DocumentReference<Map<String, dynamic>> eventRef})
      : title = _DefaultFieldValue.unknownStr,
        _startTime = _DefaultFieldValue.zeroTimestamp,
        _endTime = _DefaultFieldValue.zeroTimestamp,
        _contributor = List.from(_DefaultFieldValue.emptyList),
        introduction = _DefaultFieldValue.unknownStr,
        _tag = List.from(_DefaultFieldValue.emptyList),
        _notification = List.from(_DefaultFieldValue.emptyList),
        _relatedMission = List.from(_DefaultFieldValue.emptyList),
        super._create(ref: eventRef);

  Event._fromDatabase(
      {required DocumentSnapshot<Map<String, dynamic>> eventSnap})
      : title = eventSnap.data()?[_FieldNameForEvent.title] ??
            _DefaultFieldValue.unknownStr,
        _startTime = eventSnap.data()?[_FieldNameForEvent.startTime] != null
            ? Timestamp.fromDate(
                eventSnap.data()?[_FieldNameForEvent.startTime])
            : _DefaultFieldValue.zeroTimestamp,
        _endTime = eventSnap.data()?[_FieldNameForEvent.endTime] != null
            ? Timestamp.fromDate(eventSnap.data()?[_FieldNameForEvent.endTime])
            : _DefaultFieldValue.zeroTimestamp,
        _contributor = List.from(
            eventSnap.data()?[_FieldNameForEvent.contributor] ??
                _DefaultFieldValue.emptyList),
        introduction = eventSnap.data()?[_FieldNameForEvent.introduction] ??
            _DefaultFieldValue.unknownStr,
        _tag = List.from(eventSnap.data()?[_FieldNameForEvent.tag] ??
            _DefaultFieldValue.emptyList),
        _notification = List.from(
            eventSnap.data()?[_FieldNameForEvent.notification] ??
                _DefaultFieldValue.emptyList),
        _relatedMission = List.from(
            eventSnap.data()?[_FieldNameForEvent.relatedMission] ??
                _DefaultFieldValue.emptyList),
        super._fromDatabase(snap: eventSnap);

  Map<String, dynamic> _toDatabase() {
    return {
      _FieldNameForEvent.title: title,
      _FieldNameForEvent.startTime: _startTime,
      _FieldNameForEvent.endTime: _endTime,
      _FieldNameForEvent.contributor: _contributor,
      _FieldNameForEvent.introduction: introduction,
      _FieldNameForEvent.tag: _tag,
      _FieldNameForEvent.notification: _notification,
      _FieldNameForEvent.relatedMission: _relatedMission,
    };
  }

  DateTime get startTime => _startTime.toDate();
  DateTime get endTime => _endTime.toDate();
  List<DocumentReference<Map<String, dynamic>>> get contributor => _contributor;
  List<String> get tag => _tag;
  List<DateTime> get notification =>
      List.from(_notification.map((t) => t.toDate()));
  List<DocumentReference<Map<String, dynamic>>> get relatedMission =>
      _relatedMission;

  set startTime(DateTime startTime) =>
      _startTime = Timestamp.fromDate(startTime);
  set endTime(DateTime endTime) => _endTime = Timestamp.fromDate(endTime);

  void addContributorProfileRef(
          DocumentReference<Map<String, dynamic>> profileRef) =>
      _contributor.add(profileRef);
  void addTag(String tag) => _tag.add(tag);
  void addNotification(DateTime notification) =>
      _notification.add(Timestamp.fromDate(notification));
  void addRelatedMissionRef(
          DocumentReference<Map<String, dynamic>> missionRef) =>
      _relatedMission.add(missionRef);

  void removeContributorProfileRef(
          DocumentReference<Map<String, dynamic>> profileRef) =>
      _contributor.remove(profileRef);
  void removeTag(String tag) => _tag.remove(tag);
  void removeNotification(DateTime notification) =>
      _notification.remove(Timestamp.fromDate(notification));
  void removeRelatedMissionRef(
          DocumentReference<Map<String, dynamic>> missionRef) =>
      _relatedMission.remove(missionRef);

  void clearContributorProfileRef() => _contributor.clear();
  void clearTag() => _tag.clear();
  void clearNotification() => _notification.clear();
  void clearRelatedMissionRef() => _relatedMission.clear();
}
