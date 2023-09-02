import 'package:flutter/foundation.dart';

/// Stage of mission 
/// print(MissionStage.progress.label) => progress
enum MissionStage {
  progress(label: 'progress'),
  pending(label: 'pending'),
  close(label: 'close');
  
  final String label;
  const MissionStage({required this.label});

  factory MissionStage.fromLabel(String label){
    switch(label){
      case 'progress':
        return MissionStage.progress;
      case 'pending':
        return MissionStage.pending;
      case 'close':
        return MissionStage.close;
      default:
        return MissionStage.progress;
    }
  }
}

// /// convert `MissionStage` to `String`
// String? stageToString(MissionStage stage) {
//   if (stage == MissionStage.progress) {
//     return 'progress';
//   } else if (stage == MissionStage.pending) {
//     return 'pending';
//   } else if (stage == MissionStage.close) {
//     return 'close';
//   }
//   return null;
// }

// /// convert `String` to `MissionStage`
// MissionStage? stringToStage(String stage) {
//   if (stage == 'progress') {
//     return MissionStage.progress;
//   } else if (stage == 'pending') {
//     return MissionStage.pending;
//   } else if (stage == 'close') {
//     return MissionStage.close;
//   }
//   return null;
// }
