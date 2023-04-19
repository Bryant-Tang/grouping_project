// import 'dart:io';
// import 'dart:typed_data';

// import 'package:grouping_project/service/auth_service.dart';
// import 'package:grouping_project/model/model_lib.dart';

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:grouping_project/firebase_options.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

// void main() async {
//   print('Starting Storage test ...');

//   print('Initializing Firebase ...');
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   print('Initialize Firebase finish');

//   print('Login to Firebase with test account ...');
//   await AuthService().emailLogIn('test@mail.com', 'password');
//   print('Login finish');

//   print('Picking a test image ...');
//   XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
//   print('Pick image finish');

//   // await FirebaseStorage.instance
//   //     .ref('user_properties/yAsG52sqrwORStZAxxmIE3VMhuu2')
//   //     .child('profile/profile')
//   //     .putFile(File(image!.path));

//   // // final Directory systemTempDir = Directory.systemTemp;
//   // // final File tempFile = File(
//   // // '${systemTempDir.path}/grouping_project/user_properties/yAsG52sqrwORStZAxxmIE3VMhuu2/profile/profile');
//   // File processData = File(
//   //     '${(await getTemporaryDirectory()).path}/temp-yAsG52sqrwORStZAxxmIE3VMhuu2');
//   // print('path:${(await getTemporaryDirectory()).path}');
//   // try {
//   //   await FirebaseStorage.instance
//   //       .ref('user_properties/yAsG52sqrwORStZAxxmIE3VMhuu2')
//   //       .child('profile/profile')
//   //       .writeToFile(processData);
//   // } catch (e) {
//   //   print('!!!!!!$e!!!!!!');
//   // }

//   // print(processData.absolute);

//   print('Uploading test profile ...');
//   ProfileModel testProfie = ProfileModel(
//       name: 'test user', email: 'test@mail.com', photo: File(image!.path));
//   await DataController().upload(uploadData: testProfie);
//   print('Upload test profile finish');

//   print('Downloading test profile ...');
//   var testData = await DataController()
//       .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
//   print('Download test profile finish');

//   print('test profile photo exist : ${await testData.photo.exists()}');
// }
