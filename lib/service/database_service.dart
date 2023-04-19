import 'dart:typed_data';

import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/exception.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void _throwUnknownException() {
  throw GroupingProjectException(
      message: 'Something went wrong. Please retry or contact developers.',
      stackTrace: StackTrace.current);
}

class DatabaseService {
  final String _ownerUid;
  final bool _forUser;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance.ref();

  DatabaseService({required String ownerUid, bool forUser = true})
      // ignore: unnecessary_this
      : this._ownerUid = ownerUid,
        // ignore: unnecessary_this
        this._forUser = forUser;

  Future<String> _setMapDataFirestore(
      {required Map<String, dynamic> data,
      required String collectionPath,
      String? dataId}) async {
    if (dataId != null) {
      await _firestore.collection(collectionPath).doc(dataId).set(data);
    } else {
      dataId = (await _firestore.collection(collectionPath).add(data)).id;
    }
    return dataId;
  }

  Future<String> _addStorageRef() async {
    return await _setMapDataFirestore(data: {}, collectionPath: 'storage_data');
  }

  Future<String> _setDataModelFirestore(BaseDataModel data) async {
    return await _setMapDataFirestore(
        data: data.toFirestore(),
        collectionPath: data.databasePath,
        dataId: data.id);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getDocSnapFirestore(
      {required String collectionPath, required String dataId}) async {
    return await _firestore.collection(collectionPath).doc(dataId).get();
  }

  Future<int> _getCountFirestore({required String collectionPath}) async {
    return (await _firestore.collection(collectionPath).count().get()).count;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _getDataFitMapFirestore(
          {required String collectionPath,
          required Map<String, dynamic> condition}) async {
    var firstKey = condition.keys.first;
    var query = _firestore
        .collection(collectionPath)
        .where(firstKey, isEqualTo: condition[firstKey]);
    for (var key in condition.keys.skip(1)) {
      query = query.where(key, isEqualTo: condition[key]);
    }
    return (await query.get()).docs;
  }

  Future<String> _getOwnerAccountId() async {
    if (_forUser) {
      var userAccountRelationSnap = await _getDocSnapFirestore(
          collectionPath: 'user_account_relation', dataId: _ownerUid);
      if ((userAccountRelationSnap.data())?['account_id'] is String) {
        return (userAccountRelationSnap.data())?['account_id'];
      } else {
        throw GroupingProjectException(
            message: 'The owner account id is not exist in database, please '
                'check if it is a user id. Then retry or contact developers.',
            code: GroupingProjectExceptionCode.wrongParameter,
            stackTrace: StackTrace.current);
      }
    } else {
      return _ownerUid;
    }
  }

  Future<void> _setUint8ListStorage(
      {required Uint8List processData, required String dataId}) async {
    await _storage.child(dataId).putData(processData);
    return;
  }

  Future<Uint8List?> _getUint8ListStorage({required String dataId}) async {
    Uint8List? data;
    try {
      data = await _storage.child(dataId).getData();
    } catch (e) {
      _throwUnknownException();
    }
    return data;
  }

  Future<int> _getAccountAmount() async {
    return _getCountFirestore(
        collectionPath: AccountModel.defaultAccount.databasePath);
  }

  Future<String> _createAccount() async {
    int accountAmount = (await _getAccountAmount());
    String newAccountId = (accountAmount + 1).toString();
    _setMapDataFirestore(
        data: {},
        collectionPath: AccountModel.defaultAccount.databasePath,
        dataId: newAccountId);
    return newAccountId;
  }

  Future<AccountModel> _getSingleAccount(
      {String? ownerUid, required String accountId}) async {
    var snap = await _getDocSnapFirestore(
        collectionPath: AccountModel.defaultAccount.databasePath,
        dataId: accountId);
    AccountModel account = AccountModel.defaultAccount
        .fromFirestore(uid: ownerUid, id: snap.id, data: snap.data() ?? {});

    String? photoId = snap.data()?['photo_id'];
    Uint8List? photo;
    if (photoId != null) {
      photo = await _getUint8ListStorage(dataId: photoId);
    }

    account.setAttributeFromStorage(data: {if (photo != null) 'photo': photo});

    return account;
  }

  Future<void> setAccount({required AccountModel account}) async {
    if (account.toStorage()['photo'] != null) {
      if (account.photoId == AccountModel.defaultAccount.photoId) {
        account.photoId = await _addStorageRef();
      }
      await _setUint8ListStorage(
          processData: account.toStorage()['photo']!, dataId: account.photoId);
    }

    await _setDataModelFirestore(account);

    return;
  }

  Future<AccountModel> getAccount() async {
    AccountModel account = await _getSingleAccount(
        ownerUid: _ownerUid, accountId: await _getOwnerAccountId());
    List<String> associateEntityId = account.associateEntityId;
    List<AccountModel> associateEntityAccount = [];
    for (var accountId in associateEntityId) {
      associateEntityAccount.add(await _getSingleAccount(accountId: accountId));
    }
    account.associateEntityAccount = associateEntityAccount;
    return account;
  }

  Future<String> createUserAccount() async {
    String newAccountId = await _createAccount();
    if (_forUser) {
      _setMapDataFirestore(
          data: {'account_id': newAccountId},
          collectionPath: 'user_account_relation',
          dataId: _ownerUid);
      return newAccountId;
    } else {
      throw GroupingProjectException(
          message:
              'Can not use a group Database service to create user account.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
  }

  Future<String> createGroupAccount() async {
    return await _createAccount();
  }

  Future<void> setEvent({required EventModel event}) async {
    String eventId = await _setDataModelFirestore(event);
    await _setMapDataFirestore(
        data: {'account_id': await _getOwnerAccountId()},
        collectionPath: 'event_account_relation',
        dataId: eventId);
    return;
  }

  Future<EventModel> getEvent({required String eventId}) async {
    String ownerAccountId = await _getOwnerAccountId();
    String? eventBelongAccountId = (await _getDocSnapFirestore(
            collectionPath: 'event_account_relation', dataId: eventId))
        .data()?['account_id'];
    if (eventBelongAccountId == null) {
      throw GroupingProjectException(
          message: 'The event is not exist.',
          code: GroupingProjectExceptionCode.notExistInDatabase,
          stackTrace: StackTrace.current);
    } else if (eventBelongAccountId != ownerAccountId) {
      throw GroupingProjectException(
          message: 'The event is not belong to this account.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }

    var docSnap = await _getDocSnapFirestore(
        collectionPath: EventModel.defaultEvent.databasePath, dataId: eventId);

    EventModel event = EventModel.defaultEvent
        .fromFirestore(id: docSnap.id, data: docSnap.data() ?? {});

    event.setOwner(
        ownerAccount: await _getSingleAccount(accountId: ownerAccountId));

    return event;
  }

  Future<List<EventModel>> _getSingleAccountAllEvent() async {
    String ownerAccountId = await _getOwnerAccountId();
    var eventSnapList = await _getDataFitMapFirestore(
        collectionPath: 'event_account_relation',
        condition: {'account_id': ownerAccountId});

    List<String> eventIdList = [];
    for (var docSnap in eventSnapList) {
      eventIdList.add(docSnap.id);
    }

    List<EventModel> eventList = [];

    for (var eventId in eventIdList) {
      var docSnap = await _getDocSnapFirestore(
          collectionPath: EventModel.defaultEvent.databasePath,
          dataId: eventId);
      EventModel event = EventModel.defaultEvent
          .fromFirestore(id: docSnap.id, data: docSnap.data() ?? {});
      event.setOwner(
          ownerAccount: await _getSingleAccount(accountId: ownerAccountId));
      eventList.add(event);
    }

    return eventList;
  }

  Future<List<EventModel>> getAllEvent() async {
    List<EventModel> eventList = await _getSingleAccountAllEvent();
    AccountModel ownerAccount = await getAccount();
    if (_forUser) {
      for (var associateGroupId in ownerAccount.associateEntityId) {
        eventList.addAll(
            await DatabaseService(ownerUid: associateGroupId, forUser: false)
                .getAllEvent());
      }
    }
    return eventList;
  }

  Future<List<MissionModel>> getAllMisison() async {
    //un implement
    return [MissionModel.defaultMission, MissionModel.defaultMission];
  }

  Future<List<MissionStateModel>> getAllState() async {
    return [
      MissionStateModel.defaultFinishState,
      MissionStateModel.defaultPendingState,
      MissionStateModel.defaultProgressState,
      MissionStateModel.defaultTimeOutState
    ];
  }

  /// ## download *'one'* data from database.
  // /// * retrun one object of the type you specify.
  // /// * [dataTypeToGet] : the data type you want to get, suppose to be
  // /// `T<T extends DataModel>.defaultModel`
  // /// * [dataId] : the id of the data
  // /// ------
  // /// **Notice below :**
  // /// * remember to use ***await*** in front of this method.
  // /// * if you want to get `ProfileModel` , just pass `ProfileModel.defaultProfile.id!` to [dataId]
  // Future<T> download<T extends BaseDataModel<T>>(
  //     {required T dataTypeToGet, required String dataId}) async {
  //   var firestoreSnap =
  //       await FirestoreController(forUser: _forUser, ownerId: _ownerId)
  //           .get(collectionPath: dataTypeToGet.databasePath, dataId: dataId);

  //   if (firestoreSnap.exists != true) {
  //     throw GroupingProjectException(
  //         message: 'Data does not exist in the database.',
  //         code: GroupingProjectExceptionCode.notExistInDatabase,
  //         stackTrace: StackTrace.current);
  //   } else {
  //     T processData = await dataTypeToGet.fromFirestore(
  //         id: firestoreSnap.id,
  //         data: firestoreSnap.data() ?? {},
  //         ownerController: this);
  //     if (processData.storageRequired && processData is BaseStorageData) {
  //       (processData as BaseStorageData).setAttributeFromStorage(
  //           data: await StorageController(forUser: _forUser, ownerId: _ownerId)
  //               .getAllInFile(
  //                   collectionPath:
  //                       '${processData.databasePath}/${processData.id}'));
  //     }

  //     return processData;
  //   }
  // }

  // /// ## download a lot of data from database, which are all same type
  // /// and belong to same user.
  // /// * retrun a list of the type you specify.
  // /// * [dataTypeToGet] : an object of the type you want to get, suppose to be
  // /// `T<T extends DataModel>()`
  // /// ------
  // /// **Notice below :**
  // /// * remember to use ***await*** in front of this method.
  // /// * if this is a user controller, this method will auto get all the other
  // /// data in the specific type belong to the associate group of the user.
  // Future<List<T>> downloadAll<T extends BaseDataModel<T>>(
  //     {required T dataTypeToGet}) async {
  //   // if (dataTypeToGet.runtimeType == ProfileModel) {
  //   //   throw GroupingProjectException(
  //   //       message: 'you are using downloadAll() method to get a ProfileModel, '
  //   //           'please use download() instead.',
  //   //       code: GroupingProjectExceptionCode.wrongParameter,
  //   //       stackTrace: StackTrace.current);
  //   // }

  //   List<T> dataList = [];

  //   var firestoreSnapList =
  //       await FirestoreController(forUser: _forUser, ownerId: _ownerId)
  //           .getAll(collectionPath: dataTypeToGet.databasePath);

  //   for (var snap in firestoreSnapList) {
  //     T temp = await dataTypeToGet.fromFirestore(
  //         id: snap.id, data: snap.data(), ownerController: this);
  //     if (temp.storageRequired && temp is BaseStorageData) {
  //       (temp as BaseStorageData).setAttributeFromStorage(
  //           data: await StorageController(forUser: _forUser, ownerId: _ownerId)
  //               .getAllInFile(
  //                   collectionPath: '${temp.databasePath}/${temp.id}'));
  //     }
  //     dataList.add(temp);
  //   }

  //   if (_forUser == true) {
  //     ProfileModel ownerProfile = await download(
  //         dataTypeToGet: ProfileModel.defaultProfile,
  //         dataId: ProfileModel.defaultProfile.id!);
  //     for (var groupId in ownerProfile.associateEntityId) {
  //       var dataListForGroup = await DataController(groupId: groupId)
  //           .downloadAll(dataTypeToGet: dataTypeToGet);
  //       dataList.addAll(dataListForGroup);
  //     }
  //   }

  //   return dataList;
  // }

  // /// ## remove the data you specific from database.
  // /// * [removeData] : the data you wnat to remove.
  // /// ------
  // /// **Notice below :**
  // /// - remember to check the data has a correct id.
  // /// - remember to use ***await*** in front of this method.
  // Future<void> remove<T extends BaseDataModel<T>>(
  //     {required T removeData}) async {
  //   if (removeData.id != null) {
  //     await FirestoreController(forUser: _forUser, ownerId: _ownerId).delete(
  //         collectionPath: removeData.databasePath, dataId: removeData.id!);

  //     if (removeData.storageRequired) {
  //       StorageController(forUser: _forUser, ownerId: _ownerId).deleteAll(
  //           collectionPath: '${removeData.databasePath}/${removeData.id}');
  //     }
  //   } else {
  //     throw GroupingProjectException(
  //         message: 'Data id should be pass in',
  //         code: GroupingProjectExceptionCode.wrongParameter,
  //         stackTrace: StackTrace.current);
  //   }

  //   return;
  // }

  // /// ## create user with the [userProfile] and current login user id
  // /// * [userProfile] : the new user profile
  // /// ------
  // /// **Notice below :**
  // /// - remember to use ***await*** in front of this method.
  // Future<void> createUser({required ProfileModel userProfile}) async {
  //   if (_forUser == false) {
  //     throw GroupingProjectException(
  //         message: 'You are using a controller for group to create user, '
  //             'please make sure don\'t create entity from a group.',
  //         code: GroupingProjectExceptionCode.wrongParameter,
  //         stackTrace: StackTrace.current);
  //   }
  //   await upload(uploadData: userProfile);
  //   await upload(uploadData: MissionStateModel.defaultProgressState);
  //   await upload(uploadData: MissionStateModel.defaultPendingState);
  //   await upload(uploadData: MissionStateModel.defaultFinishState);
  //   await upload(uploadData: MissionStateModel.defaultTimeOutState);
  //   return;
  // }

  // /// ## create group from current user
  // /// * [groupProfile] : the new group profile
  // /// ------
  // /// **Notice below :**
  // /// - remember to use ***await*** in front of this method.
  // Future<String> createGroup({required ProfileModel groupProfile}) async {
  //   if (_forUser == false) {
  //     throw GroupingProjectException(
  //         message: 'You are using a controller for group to create group, '
  //             'please make sure don\'t create entity from a group.',
  //         code: GroupingProjectExceptionCode.wrongParameter,
  //         stackTrace: StackTrace.current);
  //   }
  //   String groupId = await FirestoreController.createGroup();

  //   var userProfile = await download(
  //       dataTypeToGet: ProfileModel.defaultProfile,
  //       dataId: ProfileModel.defaultProfile.id!);
  //   userProfile.addEntity(groupId);
  //   await upload(uploadData: userProfile);

  //   DataController groupController = DataController(groupId: groupId);
  //   groupProfile.addEntity(_ownerId);
  //   await groupController.upload(uploadData: groupProfile);
  //   await groupController.upload(
  //       uploadData: MissionStateModel.defaultProgressState);
  //   await groupController.upload(
  //       uploadData: MissionStateModel.defaultPendingState);
  //   await groupController.upload(
  //       uploadData: MissionStateModel.defaultFinishState);
  //   await groupController.upload(
  //       uploadData: MissionStateModel.defaultTimeOutState);

  //   return groupId;
  // }
}
