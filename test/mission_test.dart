import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService().emailLogIn('test@mail.com', 'password');

  DataController controller = DataController();
  ProfileModel userProfile;
  try {
    userProfile = await controller.download(
        dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
  } catch (e) {
    userProfile = ProfileModel(name: 'test user', email: 'test@mail.com');
  }

  await controller.createUser(userProfile);

  MissionModel testUploadData = MissionModel(
      title: 'test event',
      deadline: DateTime.now(),
      contributorIds: ['test_user_id_1', 'test_user_id_2', 'test_user_id_3'],
      introduction: 'this is a test mission',
      state: MissionStateModel.defaultProgressState,
      tags: ['test_tag_1', 'test_tag_2', 'test_tag_3'],
      notifications: [DateTime(2023), DateTime(2024), DateTime(2025)],
      parentMissionIds: ['test_root_mission'],
      childMissionIds: [
        'test_child_mission_1',
        'test_child_mission_2',
        'test_child_mission_3'
      ]);

  print('test data uploading...\n');
  await controller.upload(uploadData: testUploadData);
  print('test data finish upload\n');
  print('test data downloading...\n');
  var testDownloadData =
      await controller.downloadAll(dataTypeToGet: MissionModel());
  print(AuthService().getUid());
  print('${testDownloadData[0].title}\n'
      '${testDownloadData[0].deadline}\n'
      '${testDownloadData[0].contributorIds}\n'
      '${testDownloadData[0].introduction}\n'
      '${testDownloadData[0].stateModelId}\n'
      '${testDownloadData[0].stage}\n'
      '${testDownloadData[0].stateName}\n'
      '${testDownloadData[0].tags}\n'
      '${testDownloadData[0].notifications}\n'
      '${testDownloadData[0].parentMissionIds}\n'
      '${testDownloadData[0].childMissionIds}\n');
  print('test over');
}
