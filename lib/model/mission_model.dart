import 'data_controller.dart';
import 'data_model.dart';
import 'profile_model.dart';
import 'mission_state_model.dart';
import 'mission_state_stage.dart';
import 'package:grouping_project/exception.dart';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class MissionModel extends BaseDataModel<MissionModel> {
  String? title;
  DateTime? deadline;
  List<String>? contributorIds;
  String? introduction;
  String? stateModelId;
  MissionStage? stage;
  String? stateName;
  List<String>? tags;
  List<DateTime>? notifications;
  List<String>? parentMissionIds;
  List<String>? childMissionIds;
  String ownerName = 'unknown';
  int color = 0xFFFCBF49;

  MissionModel({
    super.id,
    this.title,
    this.deadline,
    this.contributorIds,
    this.introduction,
    MissionStateModel? state,
    this.stateModelId,
    this.stage,
    this.stateName,
    this.tags,
    this.notifications,
    this.parentMissionIds,
    this.childMissionIds,
  }) : super(
          databasePath: 'missions',
          storageRequired: false,
          // setOwnerRequired: true
        ) {
    if (state != null) {
      setStateByStateModel(state);
    } else if (stage != null) {
      if (stage == MissionStage.progress) {
        setStateByStateModel(MissionStateModel.defaultProgressState);
      } else if (stage == MissionStage.pending) {
        setStateByStateModel(MissionStateModel.defaultPendingState);
      } else if (stage == MissionStage.close) {
        setStateByStateModel(MissionStateModel.defaultFinishState);
      }
    }
  }

  void setStateByStateModel(MissionStateModel stateModel) {
    if (stateModel.stage == null || stateModel.stateName == null) {
      throw GroupingProjectException(
          message: 'The state model is lack of stage or stateName, '
              'please make sure you are using the correct state.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    stateModelId = stateModel.id;
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

  Future<String?> _checkIfStateExist(DataController ownerController) async {
    List<MissionStateModel> stateModelList =
        await ownerController.downloadAll(dataTypeToGet: MissionStateModel());
    for (var stateModel in stateModelList) {
      if (stateModel.id != null && stateModelId == stateModel.id) {
        return stateModel.id;
      } else if (stateModel.stage != null &&
          stage == stateModel.stage &&
          stateModel.stateName != null &&
          stateName == stateModel.stateName) {
        return stateModel.id;
      }
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController}) async {
    if (stateModelId == null && stage == null && stateName == null) {
      setStateByStateModel(MissionStateModel.defaultProgressState);
    }

    String? stateModelCheckedId = await _checkIfStateExist(ownerController);
    if (stateModelCheckedId == null) {
      throw GroupingProjectException(
          message: 'The state of this mission is not exist in the state model '
              'pool for this entity. Please make sure assign a correct state.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    return {
      if (title != null) 'title': title,
      if (deadline != null) 'deadline': Timestamp.fromDate(deadline!),
      if (contributorIds != null) 'contributor_ids': contributorIds,
      if (introduction != null) 'introduction': introduction,
      'state_model_id': stateModelCheckedId,
      if (tags != null) 'tags': tags,
      if (parentMissionIds != null) 'parent_mission_ids': parentMissionIds,
      if (childMissionIds != null) 'child_mission_ids': childMissionIds,
      if (notifications != null)
        'notifications': _toFirestoreTimeList(notifications!),
    };
  }

  @override
  Future<MissionModel> fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      required DataController ownerController}) async {
    List<MissionStateModel> stateModelList =
        await ownerController.downloadAll(dataTypeToGet: MissionStateModel());
    MissionStateModel? stateModelChecked;
    for (var stateModel in stateModelList) {
      if (stateModel.id != null && data['state_model_id'] == stateModel.id) {
        stateModelChecked = stateModel;
        break;
      }
    }
    if (stateModelChecked == null) {
      throw GroupingProjectException(
          message: 'The state of this mission record in database is not exist '
              'in the state model pool for this entity. This is not suppose '
              'to happend, please contact developer.',
          code: GroupingProjectExceptionCode.notExistInDatabase,
          stackTrace: StackTrace.current);
    }
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
      stateModelId: stateModelChecked.id,
      stage: stateModelChecked.stage,
      stateName: stateModelChecked.stateName,
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
        dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!));

    return processData;
  }

  void _setOwner(ProfileModel ownerProfile) {
    ownerName = ownerProfile.name ?? 'unknown';
    color = ownerProfile.color ?? 0xFFFCBF49;
  }
}
