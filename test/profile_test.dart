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
  ProfileModel testProfie =
      ProfileModel(name: 'test user', email: 'test@mail.com');

  await DataController().createUser(userProfile: testProfie);
  print('123');
  var testData = await DataController().downloadAll(
    dataTypeToGet: ProfileModel(),
    // dataId: ProfileModel().id!
  );
  print(testData);
}
