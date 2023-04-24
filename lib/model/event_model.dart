// ignore_for_file: unnecessary_this
import 'data_model.dart';
import 'account_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

/// ## a data model for event
/// * to upload/download, use `DataController`
class EventModel extends BaseDataModel<EventModel> {
  String title;
  DateTime startTime;
  DateTime endTime;
  List<String> contributorIds;
  String introduction;
  List<String> tags;
  List<DateTime> notifications;
  List<String> relatedMissionIds;
  AccountModel ownerAccount;

  static final EventModel defaultEvent = EventModel._default();

  EventModel._default()
      : this.title = 'unknown',
        this.startTime = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        this.endTime = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        this.contributorIds = [],
        this.introduction = 'unknown',
        this.tags = [],
        this.relatedMissionIds = [],
        this.notifications = [],
        this.ownerAccount = AccountModel.defaultAccount,
        super(
            id: 'default_event', databasePath: 'event', storageRequired: false);

  /// ## a data model for event
  /// * to upload/download, use `DataController`
  EventModel(
      {super.id,
      String? title,
      DateTime? startTime,
      DateTime? endTime,
      List<String>? contributorIds,
      String? introduction,
      List<String>? tags,
      List<String>? relatedMissionIds,
      List<DateTime>? notifications})
      : this.title = title ?? defaultEvent.title,
        this.startTime = startTime ?? defaultEvent.startTime,
        this.endTime = endTime ?? defaultEvent.endTime,
        this.contributorIds =
            contributorIds ?? List.from(defaultEvent.contributorIds),
        this.introduction = introduction ?? defaultEvent.introduction,
        this.tags = tags ?? List.from(defaultEvent.tags),
        this.relatedMissionIds =
            relatedMissionIds ?? List.from(defaultEvent.relatedMissionIds),
        this.notifications =
            notifications ?? List.from(defaultEvent.notifications),
        this.ownerAccount = defaultEvent.ownerAccount,
        super(
          databasePath: defaultEvent.databasePath,
          storageRequired: defaultEvent.storageRequired,
          // setOwnerRequired: true
        );

  /// convert `List<DateTime>` to `List<Timestamp>`
  List<Timestamp> _toFirestoreTimeList(List<DateTime> dateTimeList) {
    List<Timestamp> processList = [];
    for (DateTime dateTime in dateTimeList) {
      processList.add(Timestamp.fromDate(dateTime));
    }
    return processList;
  }

  /// convert `List<Timestamp>` to `List<DateTime>`
  List<DateTime> _fromFirestoreTimeList(List<Timestamp> timestampList) {
    List<DateTime> processList = [];
    for (Timestamp timestamp in timestampList) {
      processList.add(timestamp.toDate());
    }
    return processList;
  }

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Map<String, dynamic> toFirestore() {
    return {
      if (title != defaultEvent.title) 'title': title,
      if (startTime != defaultEvent.startTime)
        'start_time': Timestamp.fromDate(startTime),
      if (endTime != defaultEvent.endTime)
        'end_time': Timestamp.fromDate(endTime),
      if (contributorIds != defaultEvent.contributorIds)
        'contributor_ids': contributorIds,
      if (introduction != defaultEvent.introduction)
        'introduction': introduction,
      if (tags != defaultEvent.tags) 'tags': tags,
      if (relatedMissionIds != defaultEvent.relatedMissionIds)
        'related_mission_ids': relatedMissionIds,
      if (notifications != defaultEvent.notifications)
        'notifications': _toFirestoreTimeList(notifications),
    };
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  EventModel fromFirestore(
      {required String id, required Map<String, dynamic> data}) {
    EventModel processData = EventModel(
      id: id,
      title: data['title'],
      startTime: data['start_time'] != null
          ? (data['start_time'] as Timestamp).toDate()
          : null,
      endTime: data['end_time'] != null
          ? (data['end_time'] as Timestamp).toDate()
          : null,
      contributorIds: data['contributor_ids'] is Iterable
          ? List.from(data['contributor_ids'])
          : null,
      introduction: data['introduction'],
      tags: data['tags'] is Iterable ? List.from(data['tags']) : null,
      relatedMissionIds: data['related_mission_ids'] is Iterable
          ? List.from(data['related_mission_ids'])
          : null,
      notifications: data['notifications'] is Iterable
          ? _fromFirestoreTimeList(List.from(data['notifications']))
          : null,
    );

    return processData;
  }

  /// set the data about owner for this instance
  void setOwner({required AccountModel ownerAccount}) {
    this.ownerAccount = ownerAccount;
  }
}
