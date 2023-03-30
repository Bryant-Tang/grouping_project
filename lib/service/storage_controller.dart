import 'dart:io';

import 'package:grouping_project/service/service_lib.dart';
import 'package:grouping_project/model/data_controller.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

enum PicturePurpose { profilepicture, other }

/// Before use, do this -> StorageController _storageController = StorageController();
class StorageController extends DataController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();

  /// Used to upload file
  /// * [picturePurpose]: To used name the picture on storage
  update(
      {String? targetId,
      required String filePath,
      required PicturePurpose type}) async {
    targetId = targetId ?? _authService.getUid();
    Reference imagesRef;
    if (type != PicturePurpose.other) {
      imagesRef = _firebaseStorage.ref().child("${targetId}/${type.name}");
    } else {
      imagesRef = _firebaseStorage
          .ref()
          .child("${targetId}/${type.name}/${DateTime.now()}");
    }

    File file = File(filePath);
    debugPrint(filePath);

    try {
      await imagesRef.putFile(file);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<XFile?> get({String? targetId, required PicturePurpose type}) async {
    targetId = targetId ?? _authService.getUid();

    //Here you'll specify the file it should download from Cloud Storage
    String toBeGet = '$targetId/${type.name}';

    try {
      String url = await _firebaseStorage.ref().child(toBeGet).getDownloadURL();
      // debugPrint(url);

      var file = await DefaultCacheManager().getSingleFile(url);
      XFile result = XFile(file.path);
      return result;
    } catch (e) {
      // e.g, e.code == 'canceled'
      debugPrint(e.toString());
    }
  }

  Future<List<XFile>?> getAll(
      {String? targetId, required PicturePurpose type}) async {
    targetId = targetId ?? _authService.getUid();

    List<XFile> list = [];
    String toBeGet = '$targetId/${type.name}';

    try {
      ListResult listResult =
          await _firebaseStorage.ref().child(toBeGet).listAll();
      // debugPrint(url);
      for (Reference element in listResult.items) {
        String url = await element.getDownloadURL();
        var file = await DefaultCacheManager().getSingleFile(url);
        list.add(XFile(file.path));
      }
      return list;
    } catch (e) {
      // e.g, e.code == 'canceled'
      debugPrint(e.toString());
    }
  }

  Future<void> delete(
      {String? targetId, required PicturePurpose type, required name}) async {
    switch (type) {
      case PicturePurpose.profilepicture:
        _firebaseStorage.ref().child('$targetId/${type.name}').delete();
        break;
      default:
        ListResult listResult = await _firebaseStorage
            .ref()
            .child('$targetId/${PicturePurpose.other.name}/')
            .listAll();
        for (Reference element in listResult.items) {
          if (element.name == name) {
            element.delete();
          }
        }
    }
  }
}
