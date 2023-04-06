import 'data_controller.dart';
import 'data_model.dart';
import 'profile_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

/// ## a data model for event
/// * to upload/download, use `DataController`
class EventModel extends BaseDataModel<EventModel> {
  String? title;
  DateTime? startTime;
  DateTime? endTime;
  List<String>? contributorIds;
  String? introduction;
  List<String>? tags;
  List<DateTime>? notifications;
  List<String>? relatedMissionIds;
  String ownerName = 'unknown';
  int color = 0xFFFCBF49;

  EventModel(
      {super.id,
      this.title,
      this.startTime,
      this.endTime,
      this.contributorIds,
      this.introduction,
      this.tags,
      this.relatedMissionIds,
      this.notifications})
      : super(
          databasePath: 'events',
          storageRequired: false,
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
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController}) async {
    return {
      if (title != null) 'title': title,
      if (startTime != null) 'start_time': Timestamp.fromDate(startTime!),
      if (endTime != null) 'end_time': Timestamp.fromDate(endTime!),
      if (contributorIds != null) 'contributor_ids': contributorIds,
      if (introduction != null) 'introduction': introduction,
      if (tags != null) 'tags': tags,
      if (relatedMissionIds != null) 'related_mission_ids': relatedMissionIds,
      if (notifications != null)
        'notifications': _toFirestoreTimeList(notifications!),
    };
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  Future<EventModel> fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      required DataController ownerController}) async {
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

    processData._setOwner(await ownerController.download(
        dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!));

    return processData;
  }

  /// set the data about owner for this instance
  void _setOwner(ProfileModel ownerProfile) {
    ownerName = ownerProfile.name ?? 'unknown';
    color = ownerProfile.color ?? 0xFFFCBF49;
  }
}
