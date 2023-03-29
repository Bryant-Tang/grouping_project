import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouping_project/model/data_controller.dart';

import '../model/data_model.dart';
import '../model/profile_model.dart';
import '../model/group_model.dart';

import 'package:grouping_project/service/service_lib.dart';
import 'package:path_provider/path_provider.dart';

class StorageController extends DataController {
  final Reference _firebaseStorageRef = FirebaseStorage.instance.ref();

  update() async {
    Reference imagesRef = _firebaseStorageRef.child("images");

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.absolute}/file-to-upload.png';
    File file = File(filePath);

    try {
      await imagesRef.putFile(file);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  get() {}
  getAll() {}
  delete() {}
}
