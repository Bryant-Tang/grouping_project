import 'package:grouping_project/model_lib.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel extends DataModel {
  String? title;
  DateTime? startTime;
  DateTime? endTime;
  List<UserModel>? contributors;
  String? introduction;
  List<String>? tags;
  List<DateTime>? notifications;
  String ownerName = 'unknown';
  String color = '0xFFFCBF49';

  EventModel(
      {super.id = '',
      this.title,
      this.startTime,
      this.endTime,
      this.contributors,
      this.introduction,
      this.tags,
      this.notifications}) {
    super.typeForPath = 'events';
  }

  @override
  Future<EventModel> fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) async {
    final data = snapshot.data();

    List<UserModel> fromFireContributors = [];
    if (data['notifications'] is Iterable) {
      for (String element in List.from(data['contributors'])) {
        fromFireContributors.add(UserModel(uid: element));
      }
    }

    List<DateTime> fromFireNotifications = [];
    if (data['notifications'] is Iterable) {
      for (Timestamp element in List.from(data['notifications'])) {
        fromFireNotifications.add(element.toDate());
      }
    }

    EventModel processData = EventModel(
      id: snapshot.id,
      title: data['title'],
      startTime: data['start_time'].toDate(),
      endTime: data['end_time'].toDate(),
      contributors: fromFireContributors,
      introduction: data['introduction'],
      tags: data['tags'] is Iterable ? List.from(data['tags']) : const [],
      notifications: fromFireNotifications,
    );

    ProfileModel ownerProfile = (await DataController()
        .getAllMethod(dataTypeToGet: ProfileModel()))[0] as ProfileModel;
    if (ownerProfile.name != null) {
      processData.ownerName = ownerProfile.name as String;
    }
    if (ownerProfile.color != null) {
      processData.ownerName = ownerProfile.color as String;
    }

    return processData;
  }

  @override
  Map<String, dynamic> toFirestore() {
    List<String> toFireContributors = [];
    contributors?.forEach((element) {
      toFireContributors.add(element.uid);
    });

    List<Timestamp> toFireNotifications = [];
    notifications?.forEach((element) {
      toFireNotifications.add(Timestamp.fromDate(element));
    });

    return {
      if (title != null) "title": title,
      if (startTime != null) "start_time": Timestamp.fromDate(startTime!),
      if (endTime != null) "end_time": Timestamp.fromDate(endTime!),
      if (contributors != null) "contributors": toFireContributors,
      if (introduction != null) "introduction": introduction,
      if (tags != null) "tags": tags,
      if (notifications != null) "notifications": toFireNotifications,
    };
  }

  @override
  Future<void> set({String? groupId}) async {
    await DataController(groupId: groupId).setMethod(processData: this);
  }

  @override
  Future<List<EventModel>> getAll({String? groupId}) async {
    List<EventModel> processData = await DataController(groupId: groupId)
        .getAllMethod(dataTypeToGet: this) as dynamic;
    return processData;
  }
}
