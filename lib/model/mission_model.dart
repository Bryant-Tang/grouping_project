import 'data_model.dart';
import 'profile_model.dart';
import 'user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

/// to create a MissionState use such like this
///
/// MissionState state = MissionState.upComing;
enum MissionState { upComing, inProgress, finish }

/// to create a MissionModel use MissionModel()
/// and pass all things you want to add
///
/// to upload a MissionModel use .set() method
///
/// to get all MissionModel of a user/group use MissionModel().getAll()
class MissionModel extends DataModel {
  String? title;
  DateTime? startTime;
  DateTime? endTime;
  List<UserModel>? contributors;
  String? introduction;
  MissionState? state;
  List<String>? tags;
  List<DateTime>? notifications;
  String ownerName = 'unknown';
  int color = 0xFFFCBF49;

  MissionModel(
      {super.id = '',
      this.title,
      this.startTime,
      this.endTime,
      this.contributors,
      this.introduction,
      this.state,
      this.tags,
      this.notifications}) {
    super.typeForPath = 'missions';
  }

  dynamic _convertMissionState({int? stateCode}) {
    if (stateCode != null) {
      switch (stateCode) {
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
        default:
          {
            return null;
          }
      }
    } else {
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
        default:
          {
            return -1;
          }
      }
    }
  }

  @override
  Future<MissionModel> fromFirestore(
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

    MissionModel processData = MissionModel(
      id: snapshot.id,
      title: data['title'],
      startTime: data['start_time'].toDate(),
      endTime: data['end_time'].toDate(),
      contributors: fromFireContributors,
      introduction: data['introduction'],
      state: _convertMissionState(stateCode: data['state']),
      tags: data['tags'] is Iterable ? List.from(data['tags']) : const [],
      notifications: fromFireNotifications,
    );

    ProfileModel ownerProfile = (await DataController()
        .getAllMethod(dataTypeToGet: ProfileModel()))[0] as ProfileModel;
    if (ownerProfile.name != null) {
      processData.ownerName = ownerProfile.name as String;
    }
    if (ownerProfile.color != null) {
      processData.color = ownerProfile.color as int;
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
      if (state != null) 'state': _convertMissionState(),
      if (tags != null) "tags": tags,
      if (notifications != null) "notifications": toFireNotifications,
    };
  }

  /// if it is a group mission, remember to pass group id
  /// 
  /// remember to add await
  @override
  Future<void> set({String? groupId}) async {
    await DataController(groupId: groupId).setMethod(processData: this);
  }

  /// if it is a group mission, remember to pass group id
  /// 
  /// remember to add await
  @override
  Future<List<MissionModel>> getAll({String? groupId}) async {
    List<MissionModel> processData = await DataController(groupId: groupId)
        .getAllMethod(dataTypeToGet: this) as dynamic;
    return processData;
  }
}
