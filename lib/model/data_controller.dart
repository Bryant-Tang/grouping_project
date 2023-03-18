import 'data_model.dart';
import 'profile_model.dart';
import 'group_model.dart';
import 'package:grouping_project/service/service_lib.dart';

import 'package:flutter/material.dart';

/// ## to get any data from firebase, you need a DataController
class DataController {
  late bool _forUser;
  late String _ownerId;

  /// ## construct a DataController to communicate with firebase database
  /// * auto get current user id if not given group id
  DataController({String? groupId}) {
    _forUser = (groupId == null);
    _ownerId = groupId ?? AuthService().getUid();
  }

  /// ## upload *"one"* data from database.
  /// * [uploadData] : the data you want to upload
  /// ------
  /// **Notice below :**
  /// * remember to use await in front of this method.
  /// * if [uploadData.id] exist, would be updating the data, and throw error
  /// if the database does not has the data if the id.
  Future<void> upload<T extends DataModel<T>>({required T uploadData}) async {
    if (uploadData.firestoreRequired) {
      uploadData.id == null
          ? await FirestoreController(forUser: _forUser, ownerId: _ownerId).set(
              processData: uploadData.toFirestore(),
              collectionPath: uploadData.databasePath)
          : await FirestoreController(forUser: _forUser, ownerId: _ownerId)
              .update(
                  processData: uploadData.toFirestore(),
                  collectionPath: uploadData.databasePath,
                  dataId: uploadData.id!);
    }
    if (uploadData.storageRequired) {
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
      throw UnimplementedError();
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
    }
    return;
  }

  /// ## download *"one"* data from database.
  /// * retrun one object of the type you specify.
  /// * [dataTypeToGet] : the data type you want to get, suppose to be
  /// `T<T extends DataModel>().makeEmptyInstance()`
  /// * [dataId] : the id of the data
  /// ------
  /// **Notice below :**
  /// * remember to use await in front of this method.
  /// * if you want to get [ProfileModel] , just pass `ProfileModel().id!` to [dataId]
  Future<T> download<T extends DataModel<T>>(
      {required T dataTypeToGet, required String dataId}) async {
    var firestoreSnap = dataTypeToGet.firestoreRequired
        ? await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .get(collectionPath: dataTypeToGet.databasePath, dataId: dataId)
        : null;

    var storageSnap = dataTypeToGet.storageRequired
        ? throw UnimplementedError()
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        : null;

    var ownerProfile = dataTypeToGet.setOwnerRequired
        ? await download(
            dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        : null;

    T processData = dataTypeToGet.makeEmptyInstance();

    if (firestoreSnap != null && firestoreSnap.exists) {
      processData.fromFirestore(
          data: firestoreSnap.data() ?? {}, ownerProfile: ownerProfile);
      if (storageSnap != null) {
        throw UnimplementedError();
      }
    } else if (storageSnap != null) {
      throw UnimplementedError();
    } else {
      debugPrint("[Error] !!! data does not exist !!!");
    }

    return processData;
  }

  /// ## download a lot of data from database, which are all same type
  /// and belong to same user.
  /// * retrun a list of the type you specify.
  /// * [dataTypeToGet] : an object of the type you want to get, suppose to be
  /// `T<T extends DataModel>.makeEmptyInstance()`
  /// ------
  /// **Notice below :**
  /// * remember to use await in front of this method.
  /// * if you want to get ProfileModel, use `download()` is better.
  Future<List<T>> downloadAll<T extends DataModel<T>>(
      {required T dataTypeToGet}) async {
    List<T> dataList = [];

    var firestoreSnapList = dataTypeToGet.firestoreRequired
        ? await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .getAll(collectionPath: dataTypeToGet.databasePath)
        : null;

    var storageSnapList = dataTypeToGet.storageRequired
        ? throw UnimplementedError()
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        : null;

    var ownerProfile = dataTypeToGet.setOwnerRequired
        ? await download(
            dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        : null;

    if (firestoreSnapList != null) {
      for (var snap in firestoreSnapList) {
        T temp = dataTypeToGet.makeEmptyInstance();
        temp.fromFirestore(data: snap.data(), ownerProfile: ownerProfile);
        if (storageSnapList != null) {
          // !!!!!! unimplement yet !!!!!!
          // !!!!!! unimplement yet !!!!!!
          // !!!!!! unimplement yet !!!!!!
          throw UnimplementedError();
          // !!!!!! unimplement yet !!!!!!
          // !!!!!! unimplement yet !!!!!!
          // !!!!!! unimplement yet !!!!!!
        }
        dataList.add(temp);
      }
    } else if (storageSnapList != null) {
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
      throw UnimplementedError();
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
      // !!!!!! unimplement yet !!!!!!
      // for (var snap in storageSnapList) {
      //   T temp = dataTypeToGet.makeEmptyInstance();

      //   if (ownerProfile != null) {
      //     temp.setOwner(ownerProfile);
      //   }
      //   dataList.add(temp);
      // }
    }

    if (_forUser) {
      List<GroupModel> groupList =
          await downloadAll(dataTypeToGet: GroupModel());
      for (var group in groupList) {
        var dataListForGroup = await DataController(groupId: group.id)
            .downloadAll(dataTypeToGet: dataTypeToGet.makeEmptyInstance());
        dataList.addAll(dataListForGroup);
      }
    }

    return dataList;
  }

  /// ## remove the data you specific from database.
  /// * [removeData] : the data you wnat to remove.
  /// ------
  /// **Notice below :**
  /// - remember to check the data has a correct id.
  /// - remember to use await in front of this method.
  Future<void> remove<T extends DataModel<T>>({required T removeData}) async {
    if (removeData.id != null) {
      if (removeData.firestoreRequired) {
        await FirestoreController(forUser: _forUser, ownerId: _ownerId).delete(
            collectionPath: removeData.databasePath, dataId: removeData.id!);
      }
      if (removeData.storageRequired) {
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        throw UnimplementedError();
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
        // !!!!!! unimplement yet !!!!!!
      }
    } else {
      debugPrint("[Error] !!! data does not exist !!!");
    }

    return;
  }
}
