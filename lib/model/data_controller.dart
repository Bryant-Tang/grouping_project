import 'package:grouping_project/model/mission_state_model.dart';

import 'data_model.dart';
import 'profile_model.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:grouping_project/exception.dart';

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

  /// ## upload *'one'* data from database.
  /// * [uploadData] : the data you want to upload
  /// ------
  /// **Notice below :**
  /// * remember to use ***await*** in front of this method.
  /// * if [uploadData.id] exist, would be updating the data
  /// * throw exception if the database does not has the data of the id.
  Future<void> upload<T extends BaseDataModel<T>>(
      {required T uploadData}) async {
    String dataId;
    if ((uploadData.id == null) ||
        ((uploadData.id?.contains('default')) ?? false)) {
      dataId = await FirestoreController(forUser: _forUser, ownerId: _ownerId)
          .set(
              processData: await uploadData.toFirestore(ownerController: this),
              collectionPath: uploadData.databasePath,
              dataId: uploadData.id);
    } else {
      await FirestoreController(forUser: _forUser, ownerId: _ownerId).update(
          processData: await uploadData.toFirestore(ownerController: this),
          collectionPath: uploadData.databasePath,
          dataId: uploadData.id!);
      dataId = uploadData.id!;
    }

    if (uploadData.storageRequired && uploadData is BaseStorageData) {
      var uploadFileMap = (uploadData as BaseStorageData).toStorage();
      StorageController storageController =
          StorageController(forUser: _forUser, ownerId: _ownerId);
      for (String key in uploadFileMap.keys) {
        storageController.set(
            processData: uploadFileMap[key]!,
            collectionPath: '${uploadData.databasePath}/$dataId',
            dataId: key);
      }
    }
    return;
  }

  /// ## download *'one'* data from database.
  /// * retrun one object of the type you specify.
  /// * [dataTypeToGet] : the data type you want to get, suppose to be
  /// `T<T extends DataModel>()`
  /// * [dataId] : the id of the data
  /// ------
  /// **Notice below :**
  /// * remember to use ***await*** in front of this method.
  /// * if you want to get [ProfileModel] , just pass `ProfileModel().id!` to [dataId]
  Future<T> download<T extends BaseDataModel<T>>(
      {required T dataTypeToGet, required String dataId}) async {
    var firestoreSnap =
        await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .get(collectionPath: dataTypeToGet.databasePath, dataId: dataId);

    if (firestoreSnap.exists != true) {
      throw GroupingProjectException(
          message: 'Data does not exist in the database.',
          code: GroupingProjectExceptionCode.notExistInDatabase,
          stackTrace: StackTrace.current);
    } else {
      T processData = await dataTypeToGet.fromFirestore(
          id: firestoreSnap.id,
          data: firestoreSnap.data() ?? {},
          ownerController: this);
      if (processData.storageRequired && processData is BaseStorageData) {
        (processData as BaseStorageData).setAttributeFromStorage(
            data: await StorageController(forUser: _forUser, ownerId: _ownerId)
                .getAllInFile(
                    collectionPath:
                        '${processData.databasePath}/${processData.id}'));
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
  /// * if you want to get ProfileModel, use `download()`.
  Future<List<T>> downloadAll<T extends BaseDataModel<T>>(
      {required T dataTypeToGet}) async {
    if (dataTypeToGet.runtimeType == ProfileModel) {
      throw GroupingProjectException(
          message: 'you are using downloadAll() method to get a ProfileModel, '
              'please use download() instead.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }

    List<T> dataList = [];

    var firestoreSnapList =
        await FirestoreController(forUser: _forUser, ownerId: _ownerId)
            .getAll(collectionPath: dataTypeToGet.databasePath);

    for (var snap in firestoreSnapList) {
      T temp = await dataTypeToGet.fromFirestore(
          id: snap.id, data: snap.data(), ownerController: this);
      if (temp.storageRequired && temp is BaseStorageData) {
        (temp as BaseStorageData).setAttributeFromStorage(
            data: await StorageController(forUser: _forUser, ownerId: _ownerId)
                .getAllInFile(
                    collectionPath: '${temp.databasePath}/${temp.id}'));
      }
      dataList.add(temp);
    }

    if (_forUser == true) {
      ProfileModel ownerProfile = await download(
          dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
      for (var groupId in ownerProfile.associateEntityId ?? []) {
        var dataListForGroup = await DataController(groupId: groupId)
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
  Future<void> remove<T extends BaseDataModel<T>>(
      {required T removeData}) async {
    if (removeData.id != null) {
      await FirestoreController(forUser: _forUser, ownerId: _ownerId).delete(
          collectionPath: removeData.databasePath, dataId: removeData.id!);

      if (removeData.storageRequired) {
        StorageController(forUser: _forUser, ownerId: _ownerId).deleteAll(
            collectionPath: '${removeData.databasePath}/${removeData.id}');
      }
    } else {
      debugPrint('[Exception] data id should be pass');
      throw Exception('[Exception] data id should be pass');
    }

    return;
  }

  Future<void> createUser(ProfileModel userProfile) async {
    if (_forUser == false) {
      throw GroupingProjectException(
          message: 'You are using a controller for group to create user, '
              'please make sure don\'t create entity from a group.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    await upload(uploadData: userProfile);
    await upload(uploadData: MissionStateModel.defaultProgressState);
    await upload(uploadData: MissionStateModel.defaultPendingState);
    await upload(uploadData: MissionStateModel.defaultFinishState);
    await upload(uploadData: MissionStateModel.defaultTimeOutState);
    return;
  }

  /// create a group from current user
  /// return new group id
  Future<String> createGroup(ProfileModel groupProfile) async {
    if (_forUser == false) {
      throw GroupingProjectException(
          message: 'You are using a controller for group to create group, '
              'please make sure don\'t create entity from a group.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    String groupId = await FirestoreController.createGroup();

    var userProfile = await download(
        dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!);
    userProfile.addEntity(groupId);
    await upload(uploadData: userProfile);

    DataController groupController = DataController(groupId: groupId);
    groupProfile.addEntity(_ownerId);
    await groupController.upload(uploadData: groupProfile);
    await groupController.upload(uploadData: MissionStateModel.defaultProgressState);
    await groupController.upload(uploadData: MissionStateModel.defaultPendingState);
    await groupController.upload(uploadData: MissionStateModel.defaultFinishState);
    await groupController.upload(uploadData: MissionStateModel.defaultTimeOutState);

    return groupId;
  }
}
