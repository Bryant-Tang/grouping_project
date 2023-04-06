import 'package:grouping_project/exception.dart';

enum MissionStage { progress, pending, close }

String stageToString(MissionStage stage) {
  if (stage == MissionStage.progress) {
    return 'progress';
  } else if (stage == MissionStage.pending) {
    return 'pending';
  } else if (stage == MissionStage.close) {
    return 'close';
  }
  throw GroupingProjectException(
      message:
          'Some thing went wrong during convert the type of mission stage. '
          'Please contact developer.',
      code: GroupingProjectExceptionCode.wrongConstructParameter,
      stackTrace: StackTrace.current);
}

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
