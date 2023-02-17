import 'package:grouping_project/model/user_model.dart';
import 'profile_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum EventState { upComing, inProgress, finish }

dynamic _convertEventState(dynamic state) {
  if (state.runtimeType == int) {
    switch (state) {
      case 0:
        {
          return EventState.upComing;
        }

      case 1:
        {
          return EventState.inProgress;
        }

      case 2:
        {
          return EventState.finish;
        }
    }
  } else if (state.runtimeType == EventState) {
    switch (state) {
      case EventState.upComing:
        {
          return 0;
        }

      case EventState.inProgress:
        {
          return 1;
        }

      case EventState.finish:
        {
          return 2;
        }
    }
  } else {
    return null;
  }
}

class EventData {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final List<UserModel>? contributors;
  final String introduction;
  final EventState state;
  final List<String> tags;
  final List<DateTime>? notifications;
  String belong = 'unknown';
  String id = '';

  EventData(
      {required this.title,
      required this.startTime,
      required this.endTime,
      this.contributors,
      this.introduction = '',
      this.state = EventState.inProgress,
      this.tags = const [],
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
      state: _convertEventState(data?['state']),
      tags: List.from(data?['tags']),
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
      if (startTime != null) "start_time": Timestamp.fromDate(startTime),
      if (endTime != null) "end_time": Timestamp.fromDate(endTime),
      if (toFireContributors.isNotEmpty) "contributors": toFireContributors,
      if (introduction != '') "introduction": introduction,
      if (state != null) "state": _convertEventState(state),
      if (tags.isNotEmpty) "tags": tags,
      if (toFireNotifications.isNotEmpty) "notifications": toFireNotifications,
    };
  }
}

Future<void> createEventData(
    {required String userOrGroupId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    List<UserModel>? contributors,
    String introduction = '',
    EventState state = EventState.inProgress,
    List<String> tags = const [],
    List<DateTime>? notifications}) async {
  final newEvent = EventData(
    title: title,
    startTime: startTime,
    endTime: endTime,
    contributors: contributors,
    introduction: introduction,
    state: state,
    tags: tags,
    notifications: notifications,
  );
  final newEventLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userOrGroupId)
      .collection("events")
      .doc('test_event_1')
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

  UserProfile? belongSnap = await getProfile(userId: userOrGroupId);
  if (belongSnap?.userName != null) {
    event?.belong = belongSnap?.userName as String;
  } else {
    event?.belong = 'unknown';
  }

  return event;
}

Future<List<EventData>> getAllEventData({required String userOrGroupId}) async {
  final eventLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userOrGroupId)
      .collection("events")
      .withConverter(
        fromFirestore: EventData.fromFirestore,
        toFirestore: (EventData event, options) => event.toFirestore(),
      );
  final eventListSnap = await eventLocation.get();
  UserProfile? belongSnap = await getProfile(userId: userOrGroupId);

  List<EventData> eventDataList = [];
  for (var eventSnap in eventListSnap.docs) {
    EventData event = eventSnap.data();
    event.id = eventSnap.id;
    if (belongSnap?.userName != null) {
      event.belong = belongSnap?.userName as String;
    } else {
      event.belong = 'unknown';
    }
    eventDataList.add(event);
  }

  return eventDataList;
}
