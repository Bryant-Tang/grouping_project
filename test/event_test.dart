import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/service/database_service.dart';
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
  EventModel testUploadData = EventModel(
      title: 'test event',
      startTime: DateTime.now(),
      contributorIds: ['test user id 1', 'test user id 2'],
      notifications: [DateTime(2023), DateTime(2024)]);

  var databaseService = DatabaseService(ownerUid: AuthService().getUid());

  debugPrint('test data uploading...\n');
  await databaseService
      .setEvent(event: testUploadData);
  debugPrint('test data finish upload\n');
  debugPrint('test data downloading...\n');
  var testDownloadData =
      await databaseService.getAllEvent();
  debugPrint('${testDownloadData[0].title}\n'
      '${testDownloadData[0].startTime}\n'
      '${(testDownloadData[0].contributorIds)[1]}\n'
      '${(testDownloadData[0].notifications)[1]}\n');
  debugPrint('test over');
}
