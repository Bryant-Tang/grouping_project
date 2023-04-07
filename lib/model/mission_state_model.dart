import 'data_controller.dart';
import 'data_model.dart';
import 'mission_state_stage.dart';

/// ## a data model for misison state
/// * to upload/download, use `DataController`
class MissionStateModel extends BaseDataModel<MissionStateModel> {
  MissionStage? stage;
  String? stateName;

  ///the default state of progress stage, called progress
  static final MissionStateModel defaultProgressState = MissionStateModel(
      id: 'default_progress',
      stage: MissionStage.progress,
      stateName: 'in_progress');

  ///the default state of pending stage, called pending
  static final MissionStateModel defaultPendingState = MissionStateModel(
      id: 'default_pending', stage: MissionStage.pending, stateName: 'pending');

  ///the default state of close stage, called finish
  static final MissionStateModel defaultFinishState = MissionStateModel(
      id: 'default_finish',
      stage: MissionStage.close,
      stateName: 'in_progress');

  ///the default state of progress stage, called time out
  static final MissionStateModel defaultTimeOutState = MissionStateModel(
      id: 'default_time_out',
      stage: MissionStage.progress,
      stateName: 'time_out');

  /// ## a data model for misison state
  /// * to upload/download, use `DataController`
  MissionStateModel({super.id, this.stage, this.stateName})
      : super(
          databasePath: 'mission_states',
          storageRequired: false,
          // setOwnerRequired: false
        );

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController}) async {
    return {
      if (stage != null) 'stage': stageToString(stage!),
      if (stateName != null) 'state_name': stateName,
    };
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
