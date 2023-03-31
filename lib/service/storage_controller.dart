import 'dart:io';

import 'package:grouping_project/service/service_lib.dart';
import 'package:grouping_project/model/data_controller.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

enum FilePurpose { profilepicture, other }

enum FileType { picture, video }

/// Before use, do this -> StorageController _storageController = StorageController();
class StorageController extends DataController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();

  /// Used to upload file
  /// * [FilePurpose]: To used name the picture on storage
  update({
    String? targetId,
    required String filePath,
    required FilePurpose purpose,
  }) async {
    targetId = targetId ?? _authService.getUid();
    Reference imagesRef;
    if (purpose != FilePurpose.other) {
      imagesRef = _firebaseStorage.ref().child("${targetId}/${purpose.name}");
    } else {
      imagesRef = _firebaseStorage
          .ref()
          .child("${targetId}/${purpose.name}/${DateTime.now()}");
    }

    File file = File(filePath);
    debugPrint(filePath);

    try {
      await imagesRef.putFile(file);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<XFile?> get(
      {String? targetId,
      required FilePurpose purpose,
      required FileType type}) async {
    targetId = targetId ?? _authService.getUid();

    //Here you'll specify the file it should download from Cloud Storage
    String toBeGet = '$targetId/${purpose.name}';

    try {
      String url = await _firebaseStorage.ref().child(toBeGet).getDownloadURL();
      // debugPrint(url);

      if (type == FileType.picture) {
        // DefaultCacheManager only works on Android and Ios
        var file = await DefaultCacheManager().getSingleFile(url);
        XFile result = XFile(file.path);
        return result;
      } else {}
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        try {
          XFile? thridPartyPhoto = await _authService.getProfilePicture();
          if (thridPartyPhoto != null) {
            await update(
                filePath: thridPartyPhoto.path,
                purpose: FilePurpose.profilepicture);
            return thridPartyPhoto;
          }
        } catch (e) {
          debugPrint('Exception:==>> $e');
        }
      }
      debugPrint('Exception:=> ${e.code}');
    }
  }

  Future<List<XFile>?> getAll(
      {String? targetId, required FilePurpose purpose}) async {
    targetId = targetId ?? _authService.getUid();

    List<XFile> list = [];
    String toBeGet = '$targetId/${purpose.name}';

    try {
      ListResult listResult =
          await _firebaseStorage.ref().child(toBeGet).listAll();
      // debugPrint(url);
      for (Reference element in listResult.items) {
        // DefaultCacheManager only works on Android and Ios
        String url = await element.getDownloadURL();
        var file = await DefaultCacheManager().getSingleFile(url);
        list.add(XFile(file.path));
        debugPrint(XFile(file.path).mimeType);
      }
      return list;
    } catch (e) {
      // e.g, e.code == 'canceled'
      debugPrint(e.toString());
    }
  }

  Future<void> delete(
      {String? targetId, required FilePurpose purpose, required name}) async {
    switch (purpose) {
      case FilePurpose.profilepicture:
        _firebaseStorage.ref().child('$targetId/${purpose.name}').delete();
        break;
      default:
        ListResult listResult = await _firebaseStorage
            .ref()
            .child('$targetId/${FilePurpose.other.name}/')
            .listAll();
        for (Reference element in listResult.items) {
          if (element.name == name) {
            element.delete();
          }
        }
    }
  }
}
