/// Stage of mission state
enum MissionStage { progress, pending, close }

/// convert `MissionStage` to `String`
String? stageToString(MissionStage stage) {
  if (stage == MissionStage.progress) {
    return 'progress';
  } else if (stage == MissionStage.pending) {
    return 'pending';
  } else if (stage == MissionStage.close) {
    return 'close';
  }
  return null;
}

/// convert `String` to `MissionStage`
MissionStage? stringToStage(String stage) {
  if (stage == 'progress') {
    return MissionStage.progress;
  } else if (stage == 'pending') {
    return MissionStage.pending;
  } else if (stage == 'close') {
    return MissionStage.close;
  }
  return null;
}
