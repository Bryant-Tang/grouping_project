// ignore_for_file: unnecessary_this
import 'data_model.dart';
import 'mission_state_stage.dart';

/// ## a data model for misison state
/// * to upload/download, use `DataController`
class MissionStateModel extends BaseDataModel<MissionStateModel> {
  MissionStage stage;
  String stateName;

  ///the default unknown state
  static final MissionStateModel defaultUnknownState =
      MissionStateModel._default(
          id: 'default_mission_state', stage: MissionStage.progress, stateName: 'unknown');

  ///the default state of progress stage, called progress
  static final MissionStateModel defaultProgressState =
      MissionStateModel._default(
          id: 'progress',
          stage: MissionStage.progress,
          stateName: 'in progress');

  ///the default state of pending stage, called pending
  static final MissionStateModel defaultPendingState =
      MissionStateModel._default(
          id: 'pending',
          stage: MissionStage.pending,
          stateName: 'pending');

  ///the default state of close stage, called finish
  static final MissionStateModel defaultFinishState =
      MissionStateModel._default(
          id: 'finish',
          stage: MissionStage.close,
          stateName: 'finish');

  ///the default state of progress stage, called time out
  static final MissionStateModel defaultTimeOutState =
      MissionStateModel._default(
          id: 'time_out',
          stage: MissionStage.pending,
          stateName: 'time out');

  MissionStateModel._default(
      {String? id, required this.stage, required this.stateName})
      : super(id: id, databasePath: 'mission_state', storageRequired: false);

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
  Map<String, dynamic> toFirestore() {
    return {
      if (this != defaultUnknownState) 'stage': stage.label,
      if (this != defaultUnknownState) 'state_name': stateName,
    };
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  MissionStateModel fromFirestore(
      {required String id, required Map<String, dynamic> data}) {
    return MissionStateModel(
      id: id,
      stage: MissionStage.fromLabel(data['stage']),
      // stage: stringToStage(data['stage']),
      stateName: data['state_name'],
    );
  }
}