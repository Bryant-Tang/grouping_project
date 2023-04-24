// ignore_for_file: unnecessary_this
import 'data_model.dart';
import 'account_model.dart';
import 'mission_state_model.dart';
import 'package:grouping_project/exception.dart';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

/// ## a data model for misison
/// * to upload/download, use `DataController`
class MissionModel extends BaseDataModel<MissionModel> {
  String title;
  DateTime deadline;
  List<String> contributorIds;
  String introduction;
  String stateId;
  MissionStateModel state;
  List<String> tags;
  List<DateTime> notifications;
  List<String> parentMissionIds;
  List<String> childMissionIds;
  AccountModel ownerAccount;

  static final MissionModel defaultMission = MissionModel._default();

  MissionModel._default()
      : this.title = 'unknown',
        this.deadline = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        this.contributorIds = [],
        this.introduction = 'unknown',
        this.stateId = MissionStateModel.defaultUnknownState.id!,
        this.state = MissionStateModel.defaultUnknownState,
        this.tags = [],
        this.notifications = [],
        this.parentMissionIds = [],
        this.childMissionIds = [],
        this.ownerAccount = AccountModel.defaultAccount,
        super(
            id: 'default_mission',
            databasePath: 'mission',
            storageRequired: false);

  /// ## a data model for mission
  /// * to upload/download, use `DataController`
  /// -----
  /// - recommend to pass state using [state]
  /// - if [state] is not given, will then seek [stateModelId], [stage], [stateName]
  /// - if all above is not given, seek the attribute of [defaultMission]
  MissionModel({
    super.id,
    String? title,
    DateTime? deadline,
    List<String>? contributorIds,
    String? introduction,
    String? stateId,
    MissionStateModel? state,
    List<String>? tags,
    List<DateTime>? notifications,
    List<String>? parentMissionIds,
    List<String>? childMissionIds,
    AccountModel? ownerAccount,
  })  : this.title = title ?? defaultMission.title,
        this.deadline = deadline ?? defaultMission.deadline,
        this.contributorIds = contributorIds ?? defaultMission.contributorIds,
        this.introduction = introduction ?? defaultMission.introduction,
        this.stateId = state?.id ?? (stateId ?? defaultMission.stateId),
        this.state = state ?? defaultMission.state,
        this.tags = tags ?? defaultMission.tags,
        this.notifications = notifications ?? defaultMission.notifications,
        this.parentMissionIds =
            parentMissionIds ?? defaultMission.parentMissionIds,
        this.childMissionIds =
            childMissionIds ?? defaultMission.childMissionIds,
        this.ownerAccount = defaultMission.ownerAccount,
        super(
          databasePath: defaultMission.databasePath,
          storageRequired: defaultMission.storageRequired,
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
      if (title != defaultMission.title) 'title': title,
      if (deadline != defaultMission.deadline)
        'deadline': Timestamp.fromDate(deadline),
      if (contributorIds != defaultMission.contributorIds)
        'contributor_ids': contributorIds,
      if (introduction != defaultMission.introduction)
        'introduction': introduction,
      if (stateId != defaultMission.stateId) 'state_model_id': stateId,
      if (tags != defaultMission.tags) 'tags': tags,
      if (parentMissionIds != defaultMission.parentMissionIds)
        'parent_mission_ids': parentMissionIds,
      if (childMissionIds != defaultMission.childMissionIds)
        'child_mission_ids': childMissionIds,
      if (notifications != defaultMission.notifications)
        'notifications': _toFirestoreTimeList(notifications),
    };
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  MissionModel fromFirestore(
      {required String id, required Map<String, dynamic> data}) {
    MissionModel processData = MissionModel(
      id: id,
      title: data['title'],
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      contributorIds: data['contributor_ids'] is Iterable
          ? List.from(data['contributor_ids'])
          : null,
      introduction: data['introduction'],
      stateId: data['state_model_id'],
      tags: data['tags'] is Iterable ? List.from(data['tags']) : null,
      parentMissionIds: data['parent_mission_ids'] is Iterable
          ? List.from(data['parent_mission_ids'])
          : null,
      childMissionIds: data['child_mission_ids'] is Iterable
          ? List.from(data['child_mission_ids'])
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

  /// ### This is the perfered method to change state of mission
  /// - please make sure the [stateModel] is a correct model in database
  void setStateByStateModel(MissionStateModel stateModel) {
    if (stateModel.id != null) {
      stateId = stateModel.id!;
      state = stateModel;
    } else {
      throw GroupingProjectException(
          message: 'This state model is not from the database.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
  }
}
