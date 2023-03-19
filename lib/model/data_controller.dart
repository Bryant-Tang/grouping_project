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
  /// * remember to use ***await*** in front of this method.
  /// * if [uploadData.id] exist, would be updating the data
  /// * throw error if the database does not has the data of the id.
  Future<void> upload<T extends DataModel<T>>({required T uploadData}) async {
    if ((uploadData.id == null) || (uploadData.id == 'profile')) {
      await FirestoreController(forUser: _forUser, ownerId: _ownerId).set(
          processData: uploadData.toFirestore(),
          collectionPath: uploadData.databasePath,
          dataId: uploadData.id);
    } else {
      await FirestoreController(forUser: _forUser, ownerId: _ownerId).update(
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
  /// `T<T extends DataModel>()`
  /// * [dataId] : the id of the data
  /// ------
  /// **Notice below :**
  /// * remember to use ***await*** in front of this method.
  /// * if you want to get [ProfileModel] , just pass `ProfileModel().id!` to [dataId]
  Future<T> download<T extends DataModel<T>>(
      {required T dataTypeToGet, required String dataId}) async {
    if (_forUser == false && dataTypeToGet.runtimeType == GroupModel) {
      debugPrint('[Error] not allow to get group model of a group');
      throw ErrorDescription('[Error] not allow to get group model of a group');
    }
    var firestoreSnap =
        await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .get(collectionPath: dataTypeToGet.databasePath, dataId: dataId);

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

    if (firestoreSnap.exists != true) {
      debugPrint('[Error] data does not exist');
      throw ErrorDescription('[Error] data does not exist');
    } else {
      T processData = dataTypeToGet.fromFirestore(
          id: firestoreSnap.id,
          data: firestoreSnap.data() ?? {},
          ownerProfile: ownerProfile);
      if (storageSnap != null) {
        throw UnimplementedError();
      }

      return processData;
    }
  }

  /// ## download a lot of data from database, which are all same type
  /// and belong to same user.
  /// * retrun a list of the type you specify.
  /// * [dataTypeToGet] : an object of the type you want to get, suppose to be
  /// `T<T extends DataModel>()`
  /// ------
  /// **Notice below :**
  /// * remember to use ***await*** in front of this method.
  /// * if you want to get ProfileModel, use `download()` is better.
  Future<List<T>> downloadAll<T extends DataModel<T>>(
      {required T dataTypeToGet}) async {
    if (_forUser == false && dataTypeToGet.runtimeType == GroupModel) {
      debugPrint(
          '[Warning] not suppose to happened. trying to get group model list of a group!');
      return [];
    }

    List<T> dataList = [];

    var firestoreSnapList =
        await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .getAll(collectionPath: dataTypeToGet.databasePath);

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

    for (var snap in firestoreSnapList) {
      T temp = dataTypeToGet.fromFirestore(
          id: snap.id, data: snap.data(), ownerProfile: ownerProfile);
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

    if (_forUser == true && dataTypeToGet.runtimeType != GroupModel) {
      List<GroupModel> groupList =
          await downloadAll(dataTypeToGet: GroupModel());
      for (var group in groupList) {
        var dataListForGroup = await DataController(groupId: group.id)
            .downloadAll(dataTypeToGet: dataTypeToGet);
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
  /// - remember to use ***await*** in front of this method.
  Future<void> remove<T extends DataModel<T>>({required T removeData}) async {
    if (removeData.id != null) {
      await FirestoreController(forUser: _forUser, ownerId: _ownerId).delete(
          collectionPath: removeData.databasePath, dataId: removeData.id!);

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
      debugPrint("[Error] data id should be pass");
      throw ErrorDescription('[Error] data id should be pass');
    }

    return;
  }
}
