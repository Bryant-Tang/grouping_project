import 'package:grouping_project/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum EventState { upComing, inProgress, finish }

class _Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final List<UserModel>? contributors;
  final String introduction;
  final EventState state;
  final List<String>? tags;
  final List<DateTime>? notifications;

  _Event(
      {required this.title,
      required this.startTime,
      required this.endTime,
      this.contributors,
      this.introduction = '',
      this.state = EventState.inProgress,
      this.tags,
      this.notifications});

  factory _Event.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return _Event(
      title: data?['title'],
      startTime: data?['start_time'],
      endTime: data?['end_time'],
      contributors: data?['contributors'] is Iterable
          ? List.from(data?['contributors'])
          : null,
      introduction: data?['introduction'],
      state: data?['state'],
      tags: data?['tags'] is Iterable ? List.from(data?['tags']) : null,
      notifications: data?['notifications'] is Iterable
          ? List.from(data?['notifications'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (startTime != null) "start_time": startTime,
      if (endTime != null) "end_time": endTime,
      if (contributors != null) "contributors": contributors,
      if (introduction != null) "introduction": introduction,
      if (state != null) "state": state,
      if (tags != null) "tags": tags,
      if (notifications != null) "notifications": notifications,
    };
  }
}

void createEventData(
    {required String locationId,
    required String eventId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    List<UserModel>? contributors,
    String introduction = '',
    EventState state = EventState.inProgress,
    List<String>? tags,
    List<DateTime>? notifications}) {
  final newEvent = _Event(
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
      .doc(locationId)
      .collection("events")
      .withConverter(
        fromFirestore: _Event.fromFirestore,
        toFirestore: (_Event event, options) => event.toFirestore(),
      )
      .doc(eventId);
  newEventLocation.set(newEvent);
}
