part of database_service;

abstract class _FieldNameForState {
  static String name = 'name';
  static String stage = 'stage';
}

class Stage {
  String stage;
  static final Stage inProgress = Stage._(stage: 'in_progress');
  static final Stage pending = Stage._(stage: 'pending');
  static final Stage close = Stage._(stage: 'close');
  static final Stage unknown = Stage._(stage: 'unknown');
  Stage._({required this.stage});
  factory Stage.fromString({String? stageStr}) {
    if (stageStr == inProgress.stage) {
      return inProgress;
    } else if (stageStr == pending.stage) {
      return pending;
    } else if (stageStr == close.stage) {
      return close;
    } else {
      return unknown;
    }
  }
  @override
  String toString() {
    return 'Stage[$stage]';
  }
}

class State extends DatabaseDocument {
  Stage stage;
  String name;

  State._create({required DocumentReference<Map<String, dynamic>> stateRef})
      : stage = _DefaultFieldValue.unknownStage,
        name = _DefaultFieldValue.unknownStr,
        super._create(ref: stateRef);

  State._fromDatabase(
      {required DocumentSnapshot<Map<String, dynamic>> stateSnap})
      : stage = Stage.fromString(
            stageStr: stateSnap.data()?[_FieldNameForState.stage]),
        name = stateSnap.data()?[_FieldNameForProfile.name] ??
            _DefaultFieldValue.unknownStr,
        super._fromDatabase(snap: stateSnap);

  Map<String, dynamic> _toDatabase() {
    return {
      _FieldNameForState.name: name,
      _FieldNameForState.stage: stage.stage,
    };
  }
}
