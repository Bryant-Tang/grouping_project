// ignore_for_file: unnecessary_this

import 'package:grouping_project/exception.dart';

import 'data_controller.dart';
import 'data_model.dart';
import 'mission_state_stage.dart';

/// ## a data model for misison state
/// * to upload/download, use `DataController`
class MissionStateModel extends BaseDataModel<MissionStateModel> {
  MissionStage stage;
  String stateName;

  ///the default state of progress stage, called progress
  static final MissionStateModel defaultProgressState =
      MissionStateModel._default(
          id: 'default_progress',
          stage: MissionStage.progress,
          stateName: 'in_progress');

  ///the default state of pending stage, called pending
  static final MissionStateModel defaultPendingState =
      MissionStateModel._default(
          id: 'default_pending',
          stage: MissionStage.pending,
          stateName: 'pending');

  ///the default state of close stage, called finish
  static final MissionStateModel defaultFinishState =
      MissionStateModel._default(
          id: 'default_finish',
          stage: MissionStage.close,
          stateName: 'in_progress');

  ///the default state of progress stage, called time out
  static final MissionStateModel defaultTimeOutState =
      MissionStateModel._default(
          id: 'default_time_out',
          stage: MissionStage.progress,
          stateName: 'time_out');

  MissionStateModel._default(
      {required String id, required this.stage, required this.stateName})
      : super(id: id, databasePath: 'mission_states', storageRequired: false);

  /// ## a data model for misison state
  /// * to upload/download, use `DataController`
  MissionStateModel({super.id, MissionStage? stage, String? stateName})
      : this.stage = stage ?? defaultProgressState.stage,
        this.stateName = stateName ?? defaultProgressState.stateName,
        super(
          databasePath: defaultProgressState.databasePath,
          storageRequired: defaultProgressState.storageRequired,
          // setOwnerRequired: false
        );

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController}) async {
    if ((stage == defaultProgressState.stage &&
            stateName == defaultProgressState.stateName &&
            id != defaultProgressState.id) ||
        (stage == defaultPendingState.stage &&
            stateName == defaultPendingState.stateName &&
            id != defaultPendingState.id) ||
        (stage == defaultFinishState.stage &&
            stateName == defaultFinishState.stateName &&
            id != defaultFinishState.id) ||
        (stage == defaultTimeOutState.stage &&
            stateName == defaultTimeOutState.stateName &&
            id != defaultTimeOutState.id)) {
      throw GroupingProjectException(
          message:
              'The stage and state name is equal to a default state but the id is not.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    } else {
      return {
        if (stageToString(stage) != null) 'stage': stageToString(stage),
        'state_name': stateName,
      };
    }
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  Future<MissionStateModel> fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      required DataController ownerController}) async {
    return MissionStateModel(
      id: id,
      stage: stringToStage(data['stage']),
      stateName: data['state_name'],
    );
  }
}
