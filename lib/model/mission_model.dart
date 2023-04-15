// ignore_for_file: unnecessary_this
import 'data_controller.dart';
import 'data_model.dart';
import 'profile_model.dart';
import 'mission_state_model.dart';
import 'mission_state_stage.dart';
import 'package:grouping_project/exception.dart';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

/// ## a data model for misison
/// * to upload/download, use `DataController`
class MissionModel extends BaseDataModel<MissionModel> {
  String title;
  DateTime deadline;
  List<String> contributorIds;
  String introduction;
  String stateModelId;
  MissionStage stage;
  String stateName;
  List<String> tags;
  List<DateTime> notifications;
  List<String> parentMissionIds;
  List<String> childMissionIds;
  String ownerName;
  int color;

  static final MissionModel defaultMission = MissionModel._default();

  MissionModel._default()
      : this.title = 'unknown',
        this.deadline = DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
        this.contributorIds = [],
        this.introduction = 'unknown',
        this.stateModelId = MissionStateModel.defaultProgressState.id!,
        this.stage = MissionStateModel.defaultProgressState.stage,
        this.stateName = MissionStateModel.defaultProgressState.stateName,
        this.tags = [],
        this.notifications = [],
        this.parentMissionIds = [],
        this.childMissionIds = [],
        this.color = ProfileModel.defaultProfile.color,
        this.ownerName = ProfileModel.defaultProfile.name,
        super(id: null, databasePath: 'missions', storageRequired: false);

  /// ## a data model for mission
  /// * to upload/download, use `DataController`
  /// -----
  /// - recommend to pass state using [state]
  /// - if [state] is not given, will then seek [stateModelId], [stage], [stateName]
  /// - if all above is not given, seek the attribute of [defaultMission]
  MissionModel(
      {super.id,
      String? title,
      DateTime? deadline,
      List<String>? contributorIds,
      String? introduction,
      MissionStateModel? state,
      String? stateModelId,
      MissionStage? stage,
      String? stateName,
      List<String>? tags,
      List<DateTime>? notifications,
      List<String>? parentMissionIds,
      List<String>? childMissionIds,
      int? color,
      String? ownerName})
      : this.title = title ?? defaultMission.title,
        this.deadline = deadline ?? defaultMission.deadline,
        this.contributorIds = contributorIds ?? defaultMission.contributorIds,
        this.introduction = introduction ?? defaultMission.introduction,
        this.stateModelId =
            state?.id ?? (stateModelId ?? defaultMission.stateModelId),
        this.stage = state?.stage ?? (stage ?? defaultMission.stage),
        this.stateName =
            state?.stateName ?? (stateName ?? defaultMission.stateName),
        this.tags = tags ?? defaultMission.tags,
        this.notifications = notifications ?? defaultMission.notifications,
        this.parentMissionIds =
            parentMissionIds ?? defaultMission.parentMissionIds,
        this.childMissionIds =
            childMissionIds ?? defaultMission.childMissionIds,
        this.color = defaultMission.color,
        this.ownerName = defaultMission.ownerName,
        super(
          databasePath: defaultMission.databasePath,
          storageRequired: defaultMission.storageRequired,
          // setOwnerRequired: true
        );

  /// ### This is the perfered method to change state of mission
  /// - please make sure the [stateModel] is a correct model in database
  void setStateByStateModel(MissionStateModel stateModel) {
    if (stateModel.id == null) {
      throw GroupingProjectException(
          message: 'This state model is not from the database.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    stateModelId = stateModel.id!;
    stage = stateModel.stage;
    stateName = stateModel.stateName;
  }

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

  /// check if the state of this instance is exist in the database
  Future<MissionStateModel?> _checkIfStateExist(
      {String? stateModelId,
      MissionStage? stage,
      String? stateName,
      required DataController ownerController}) async {
    List<MissionStateModel> stateModelList = await ownerController.downloadAll(
        dataTypeToGet: MissionStateModel.defaultProgressState);
    for (var stateModel in stateModelList) {
      if (stateModel.id != null && stateModelId == stateModel.id) {
        return stateModel;
      } else if (stage == stateModel.stage &&
          stateName == stateModel.stateName) {
        return stateModel;
      }
    }
    return null;
  }

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController}) async {
    MissionStateModel? stateModelChecked = await _checkIfStateExist(
        stateModelId: stateModelId,
        stage: stage,
        stateName: stateName,
        ownerController: ownerController);
    if (stateModelChecked == null) {
      throw GroupingProjectException(
          message: 'The state of this mission is not exist in the state model '
              'pool for this entity. Please make sure assign a correct state.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    return {
      if (title != defaultMission.title) 'title': title,
      if (deadline != defaultMission.deadline)
        'deadline': Timestamp.fromDate(deadline),
      if (contributorIds != defaultMission.contributorIds)
        'contributor_ids': contributorIds,
      if (introduction != defaultMission.introduction)
        'introduction': introduction,
      'state_model_id': stateModelChecked.id,
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
  Future<MissionModel> fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      required DataController ownerController}) async {
    MissionStateModel? stateModelChecked = await _checkIfStateExist(
        stateModelId: data['state_model_id'], ownerController: ownerController);

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
      state: stateModelChecked,
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

    processData._setOwner(await ownerController.download(
        dataTypeToGet: ProfileModel.defaultProfile,
        dataId: ProfileModel.defaultProfile.id!));

    return processData;
  }

  /// set the data about owner for this instance
  void _setOwner(ProfileModel ownerProfile) {
    ownerName = ownerProfile.name;
    color = ownerProfile.color;
  }
}
