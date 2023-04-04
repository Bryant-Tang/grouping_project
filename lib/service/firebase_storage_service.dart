import 'dart:io' as io show File;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StorageController {
  late Reference ownerPath;

  StorageController({required bool forUser, required String ownerId}) {
    ownerPath = FirebaseStorage.instance
        .ref('${forUser ? 'user_properties' : 'group_properties'}/$ownerId');
  }

  Future<void> set(
      {required io.File processData,
      required String collectionPath,
      required String dataId}) async {
    await ownerPath.child('$collectionPath/$dataId}').putFile(processData);
    return;
  }

  Future<Uint8List> getInMemory(
      {required String collectionPath, required String dataId}) async {
    Uint8List? processData =
        await ownerPath.child('$collectionPath/$dataId').getData();
    if (processData == null) {
      throw Exception(
          '[Exception] something went wrong while downloading, please retry later.');
    } else {
      return processData;
    }
  }

  Future<io.File> getInFile(
      {required String collectionPath, required String dataId}) async {
    io.File processData = io.File(
        '${(await getTemporaryDirectory()).path}/${ownerPath.fullPath}/$collectionPath/$dataId');
    await ownerPath.child('$collectionPath/$dataId').writeToFile(processData);
    return processData;
  }

  Future<Map<String, io.File>> getAllInFile(
      {required String collectionPath}) async {
    var fileRefList = (await ownerPath.child(collectionPath).list()).items;
    Map<String, io.File> resultMap = {};
    for (var ref in fileRefList) {
      io.File tempFile =
          io.File('${(await getTemporaryDirectory()).path}/${ref.fullPath}');
      await ref.writeToFile(tempFile);
      resultMap.addAll({path.basenameWithoutExtension(ref.name): tempFile});
    }
    return resultMap;
  }

  Future<void> deleteAll({required String collectionPath}) async {
    await ownerPath.child(collectionPath).delete();
    return;
  }
}
