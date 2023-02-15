import 'package:grouping_project/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MissionState { upComing, inProgress, finish }

dynamic _convertMissionState(dynamic state) {
  if (state.runtimeType == int) {
    switch (state) {
      case 0:
        {
          return MissionState.upComing;
        }

      case 1:
        {
          return MissionState.inProgress;
        }

      case 2:
        {
          return MissionState.finish;
        }
    }
  } else if (state.runtimeType == MissionState) {
    switch (state) {
      case MissionState.upComing:
        {
          return 0;
        }

      case MissionState.inProgress:
        {
          return 1;
        }

      case MissionState.finish:
        {
          return 2;
        }
    }
  } else {
    return null;
  }
}

class MissionData {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final List<UserModel>? contributors;
  final String introduction;
  final MissionState state;
  final List<String>? tags;
  final List<DateTime>? notifications;

  MissionData(
      {required this.title,
      required this.startTime,
      required this.endTime,
      this.contributors,
      this.introduction = '',
      this.state = MissionState.inProgress,
      this.tags,
      this.notifications});

  factory MissionData.fromFirestore(
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

    return MissionData(
      title: data?['title'],
      startTime: data?['start_time'].toDate(),
      endTime: data?['end_time'].toDate(),
      contributors: fromFireContributors,
      introduction: data?['introduction'],
      state: _convertMissionState(data?['state']),
      tags: data?['tags'] is Iterable ? List.from(data?['tags']) : null,
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
      "title": title,
      "start_time": Timestamp.fromDate(startTime),
      "end_time": Timestamp.fromDate(endTime),
      "contributors": toFireContributors,
      "introduction": introduction,
      "state": _convertMissionState(state),
      "tags": tags,
      "notifications": toFireNotifications,
    };
  }
}

Future<void> createMissionData(
    {required String userOrGroupId,
    required String missionId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    List<UserModel>? contributors,
    String introduction = '',
    MissionState state = MissionState.inProgress,
    List<String>? tags,
    List<DateTime>? notifications}) async {
  final newMission = MissionData(
    title: title,
    startTime: startTime,
    endTime: endTime,
    contributors: contributors,
    introduction: introduction,
    state: state,
    tags: tags,
    notifications: notifications,
  );
  final newMissionLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userOrGroupId)
      .collection("missions")
      .doc(missionId)
      .withConverter(
        fromFirestore: MissionData.fromFirestore,
        toFirestore: (MissionData mission, options) => mission.toFirestore(),
      );
  await newMissionLocation.set(newMission);
  return;
}

Future<MissionData?> getOneMissionData(
    {required String userOrGroupId, required String missionId}) async {
  final missionLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userOrGroupId)
      .collection("missions")
      .doc(missionId)
      .withConverter(
        fromFirestore: MissionData.fromFirestore,
        toFirestore: (MissionData mission, options) => mission.toFirestore(),
      );
  final missionSnap = await missionLocation.get();
  return missionSnap.data();
}

Future<List<MissionData?>> getAllMissionData(
    {required String userOrGroupId}) async {
  final missionLocation = FirebaseFirestore.instance
      .collection("client_properties")
      .doc(userOrGroupId)
      .collection("missions")
      .withConverter(
        fromFirestore: MissionData.fromFirestore,
        toFirestore: (MissionData mission, options) => mission.toFirestore(),
      );
  final missionListSnap = await missionLocation.get();
  List<MissionData?> missionDataList = [];
  for (var missionSnap in missionListSnap.docs) {
    missionDataList.add(missionSnap.data());
  }
  return missionDataList;
}
