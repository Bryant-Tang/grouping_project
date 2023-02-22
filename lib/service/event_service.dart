import 'package:grouping_project/model/user_model.dart';
import 'auth_service.dart';
import 'profile_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventData {
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<UserModel>? contributors;
  final String? introduction;
  final List<String>? tags;
  final List<DateTime>? notifications;
  String belongName = 'unknown';
  String belongColor = '0xFFFCBF49';
  String id = '';

  EventData(
      {this.title,
      this.startTime,
      this.endTime,
      this.contributors,
      this.introduction,
      this.tags,
      this.notifications});

  factory EventData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    List<UserModel> fromFireContributors = [];
    if (data?['notifications'] is Iterable) {
      for (String element in List.from(data?['contributors'])) {
        fromFireContributors.add(UserModel(uid: element));
      }
    }

    List<DateTime> fromFireNotifications = [];
    if (data?['notifications'] is Iterable) {
      for (Timestamp element in List.from(data?['notifications'])) {
        fromFireNotifications.add(element.toDate());
      }
    }

    return EventData(
      title: data?['title'],
      startTime: data?['start_time'].toDate(),
      endTime: data?['end_time'].toDate(),
      contributors: fromFireContributors,
      introduction: data?['introduction'],
      tags: data?['tags'] is Iterable ? List.from(data?['tags']) : const [],
      notifications: fromFireNotifications,
    );
  }

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
}

Future<void> createEventDataForPerson(
    {required String title,
    required DateTime startTime,
    required DateTime endTime,
    List<UserModel> contributors = const [],
    String introduction = '',
    List<String> tags = const [],
    List<DateTime> notifications = const []}) async {
  final String userId = AuthService().getUid();
  final newEvent = EventData(
    title: title,
    startTime: startTime,
    endTime: endTime,
    contributors: contributors,
    introduction: introduction,
    tags: tags,
    notifications: notifications,
  );
  final newEventLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userId)
      .collection("events")
      .doc()
      .withConverter(
        fromFirestore: EventData.fromFirestore,
        toFirestore: (EventData event, options) => event.toFirestore(),
      );
  await newEventLocation.set(newEvent);
  return;
}

Future<void> createEventDataForGroup(
    {required String groupId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    List<UserModel> contributors = const [],
    String introduction = '',
    List<String> tags = const [],
    List<DateTime> notifications = const []}) async {
  final newEvent = EventData(
    title: title,
    startTime: startTime,
    endTime: endTime,
    contributors: contributors,
    introduction: introduction,
    tags: tags,
    notifications: notifications,
  );
  final newEventLocation = FirebaseFirestore.instance
      .collection("group_properties")
      .doc(groupId)
      .collection("events")
      .doc()
      .withConverter(
        fromFirestore: EventData.fromFirestore,
        toFirestore: (EventData event, options) => event.toFirestore(),
      );
  await newEventLocation.set(newEvent);
  return;
}

Future<void> updateEventData(
    {required String userOrGroupId,
    required String eventId,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    List<UserModel>? contributors,
    String? introduction,
    List<String>? tags,
    List<DateTime>? notifications}) async {
  final newEvent = EventData(
    title: title,
    startTime: startTime,
    endTime: endTime,
    contributors: contributors,
    introduction: introduction,
    tags: tags,
    notifications: notifications,
  );
  final newEventLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userOrGroupId)
      .collection("events")
      .doc()
      .withConverter(
        fromFirestore: EventData.fromFirestore,
        toFirestore: (EventData event, options) => event.toFirestore(),
      );
  await newEventLocation.set(newEvent, SetOptions(merge: true));
  return;
}

Future<EventData?> getOneEventData(
    {required String userOrGroupId, required String eventId}) async {
  final eventLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userOrGroupId)
      .collection("events")
      .doc(eventId)
      .withConverter(
        fromFirestore: EventData.fromFirestore,
        toFirestore: (EventData event, options) => event.toFirestore(),
      );
  final eventSnap = await eventLocation.get();
  EventData? event = eventSnap.data();

  UserProfile? belongSnap = await getProfileForPerson(userId: userOrGroupId);
  event?.belongName = belongSnap?.userName ?? 'unknown';
  event?.belongColor = belongSnap?.color ?? '0xFFFCBF49';
  
  return event;
}

Future<List<EventData>> getAllEventDataForGroup(
    {required String groupId}) async {
  final eventLocation = FirebaseFirestore.instance
      .collection('group_properties')
      .doc(groupId)
      .collection('events')
      .withConverter(
        fromFirestore: EventData.fromFirestore,
        toFirestore: (EventData event, options) => event.toFirestore(),
      );
  final eventListSnap = await eventLocation.get();
  GroupProfile? belongSnap = await getProfileForGroup(groupId: groupId);

  List<EventData> eventDataList = [];
  for (var eventSnap in eventListSnap.docs) {
    EventData event = eventSnap.data();
    event.id = eventSnap.id;
    event?.belongName = belongSnap?.userName ?? 'unknown';
    event?.belongColor = belongSnap?.color ?? '0xFFFCBF49';
    eventDataList.add(event);
  }

  return eventDataList;
}

Future<List<EventData>> getAllEventDataForPerson(
    {required String userId}) async {
  final eventLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userId)
      .collection("events")
      .withConverter(
        fromFirestore: EventData.fromFirestore,
        toFirestore: (EventData event, options) => event.toFirestore(),
      );
  final eventListSnap = await eventLocation.get();
  UserProfile? belongSnap = await getProfileForPerson(userId: userId);

  List<EventData> eventDataList = [];
  for (var eventSnap in eventListSnap.docs) {
    EventData event = eventSnap.data();
    event.id = eventSnap.id;
    event?.belongName = belongSnap?.userName ?? 'unknown';
    event?.belongColor = belongSnap?.color ?? '0xFFFCBF49';
    eventDataList.add(event);
  }

  final Map<String, String> groupList = await getGroupList(userId: userId);
  for (var groupId in groupList.keys) {
    List<EventData> tempGroupEventList =
        await getAllEventDataForGroup(groupId: groupId);
    eventDataList.addAll(tempGroupEventList);
  }
  
  return eventDataList;
}
