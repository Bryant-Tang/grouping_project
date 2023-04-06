import 'data_controller.dart';
import 'data_model.dart';
import 'mission_state_stage.dart';

class MissionStateModel extends DataModel<MissionStateModel> {
  MissionStage? stage;
  String? stateName;

  MissionStateModel({super.id, this.stage, this.stateName})
      : super(
            databasePath: 'mission_states',
            storageRequired: false,
            setOwnerRequired: false);

  @override
  Future<Map<String, dynamic>> toFirestore(
      {required DataController ownerController}) async {
    return {
      if (stage != null) 'stage': stageToString(stage!),
      if (stateName != null) 'state_name': stateName,
    };
  }

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
