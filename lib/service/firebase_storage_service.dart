// import 'dart:io' as io show File;
// import 'dart:typed_data';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;

// /// ## a `StorageController` instance controll all things with Storage
// /// * an instance can controll all data of one user/group
// class StorageController {
//   late Reference ownerPath;

//   /// ## a `StorageController` instance controll all things with Storage
//   /// * an instance can controll all data of one user/group
//   /// -----
//   /// * [forUser] : whether this instance is going to controll data of a user or not
//   /// * [ownerId] : the id of user/group this instance is going to controll
//   StorageController({required bool forUser, required String ownerId}) {
//     ownerPath = FirebaseStorage.instance
//         .ref('${forUser ? 'user_properties' : 'group_properties'}/$ownerId');
//   }

//   /// ### add a new file to the specific path
//   /// * [processData] : the data to be added
//   /// * [collectionPath] : the path to add data
//   /// * [dataId] : the data id, should be obtain from Firestore
//   Future<void> set(
//       {required io.File processData,
//       required String collectionPath,
//       required String dataId}) async {
//     await ownerPath.child('$collectionPath/$dataId').putFile(processData);
//     return;
//   }

//   /// ### get a file into memory
//   /// * [collectionPath] : the path where data store at
//   /// * [dataId] : the data id, should be obtain from Firestore
//   /// * return a `Uint8List` store in memory
//   Future<Uint8List> getInMemory(
//       {required String collectionPath, required String dataId}) async {
//     Uint8List? processData =
//         await ownerPath.child('$collectionPath/$dataId').getData();
//     if (processData == null) {
//       throw Exception(
//           '[Exception] something went wrong while downloading, please retry later.');
//     } else {
//       return processData;
//     }
//   }

//   /// ### get a file into disk
//   /// * [collectionPath] : the path where data store at
//   /// * [dataId] : the data id, should be obtain from Firestore
//   /// * return a `File` store in temorary directory
//   Future<io.File> getInFile(
//       {required String collectionPath, required String dataId}) async {
//     Reference downloadRef = ownerPath.child('$collectionPath/$dataId');
//     io.File processData =
//         io.File('${(await getTemporaryDirectory()).path}/temp-'
//             '${_takeOutSlash(downloadRef.fullPath)}');
//     await downloadRef.writeToFile(processData);

//     return processData;
//   }

//   /// ### get all file in the [collectionPath] into disk
//   /// * [collectionPath] : the path where data store at
//   /// * return a `Map` which the key is data id and value is data in the type of `File`
//   Future<Map<String, io.File>> getAllInFile(
//       {required String collectionPath}) async {
//     var fileRefList = (await ownerPath.child(collectionPath).list()).items;
//     Map<String, io.File> resultMap = {};

//     for (var ref in fileRefList) {
//       io.File tempFile = io.File('${(await getTemporaryDirectory()).path}/temp-'
//           '${_takeOutSlash(ref.fullPath)}');
//       await ref.writeToFile(tempFile);
//       resultMap.addAll({path.basenameWithoutExtension(ref.name): tempFile});
//     }

//     return resultMap;
//   }

//   /// ### delete a file
//   /// * [collectionPath] : the path where data store at
//   /// * [dataId] : the data id, should be obtain from Firestore
//   Future<void> delete(
//       {required String collectionPath, required String dataId}) async {
//     await ownerPath.child('$collectionPath/$dataId').delete();
//     return;
//   }

//   /// ### delete all file in the [collectionPath]
//   /// * [collectionPath] : the path where data store at
//   Future<void> deleteAll({required String collectionPath}) async {
//     await ownerPath.child(collectionPath).delete();
//     return;
//   }
// }

// /// take out all slash in the given path and return it
// String _takeOutSlash(String path) {
//   String newPath = '';
//   for (String s in path.split('/')) {
//     newPath += s;
//   }
//   return newPath;
// }
