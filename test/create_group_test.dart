import 'dart:io';
import 'dart:typed_data';

import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  print('Starting Storage test ...');

  print('Initializing Firebase ...');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Initialize Firebase finish');

  print('Login to Firebase with test account ...');
  await AuthService().emailLogIn('test@mail.com', 'password');
  print('Login finish');

  print('Picking a test image ...');
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  print('Pick image finish');

  print('creating a group ...');
  ProfileModel testProfie = ProfileModel(
      name: 'test user', email: 'test@mail.com', photo: File(image!.path));
  String groupId = await DataController().createGroup(groupProfile: testProfie);
  print('create group finish');

  print('downloading user and group profile ...');
  ProfileModel userProfile = await DataController()
      .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
  ProfileModel groupProfile = await DataController(groupId: groupId)
      .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
  print('downlaodiing profile finish');

  print('user profile associate entities: ${userProfile.associateEntityId}');
  print('group profile associate entities: ${groupProfile.associateEntityId}');
}
