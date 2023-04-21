import 'dart:typed_data';

import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/exception.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void _throwUnknownException(StackTrace stackTrace) {
  throw GroupingProjectException(
      message: 'Something went wrong. Please retry or contact developers.',
      stackTrace: stackTrace);
}

class DatabaseService {
  final String _ownerUid;
  String? _ownerAccountId;
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

  // Future<int> _getCountFirestore({required String collectionPath}) async {
  //   return (await _firestore.collection(collectionPath).count().get()).count;
  // }

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
    if (_ownerAccountId != null) {
      return _ownerAccountId!;
    } else if (_forUser) {
      var userAccountRelationSnap = await _getDocSnapFirestore(
          collectionPath: 'user_account_relation', dataId: _ownerUid);
      if ((userAccountRelationSnap.data())?['account_id'] is String) {
        _ownerAccountId = (userAccountRelationSnap.data())?['account_id'];
        return _ownerAccountId!;
      } else {
        throw GroupingProjectException(
            message: 'The owner account id is not exist in database, please '
                'check if it is a user id. Then retry or contact developers.',
            code: GroupingProjectExceptionCode.wrongParameter,
            stackTrace: StackTrace.current);
      }
    } else {
      _ownerAccountId = _ownerUid;
      return _ownerAccountId!;
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
      _throwUnknownException(StackTrace.current);
    }
    return data;
  }

  Future<String> _createAccount() async {
    String newAccountId = await _setMapDataFirestore(
        data: {}, collectionPath: AccountModel.defaultAccount.databasePath);
    await _addDataModelRelationWithAccount(
        dataId: MissionStateModel.defaultFinishState.id!,
        dataType: MissionStateModel.defaultFinishState.databasePath);
    await _addDataModelRelationWithAccount(
        dataId: MissionStateModel.defaultPendingState.id!,
        dataType: MissionStateModel.defaultPendingState.databasePath);
    await _addDataModelRelationWithAccount(
        dataId: MissionStateModel.defaultProgressState.id!,
        dataType: MissionStateModel.defaultProgressState.databasePath);
    await _addDataModelRelationWithAccount(
        dataId: MissionStateModel.defaultTimeOutState.id!,
        dataType: MissionStateModel.defaultTimeOutState.databasePath);
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
    if (account.id == null) {
      account = account.copyWith(accountId: await _getOwnerAccountId());
    }

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

  Future<void> _checkDataModelRelationWithAccount(
      {required String accountId,
      required String dataId,
      required String dataType}) async {
    String? eventBelongAccountId = (await _getDocSnapFirestore(
            collectionPath: '${dataType}_account_relation', dataId: dataId))
        .data()?['account_id'];
    if (eventBelongAccountId == null) {
      throw GroupingProjectException(
          message: 'The $dataType is not exist in any account.',
          code: GroupingProjectExceptionCode.notExistInDatabase,
          stackTrace: StackTrace.current);
    } else if (eventBelongAccountId != accountId) {
      throw GroupingProjectException(
          message: 'The $dataType is not belong to this account.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
  }

//
//single set
  Future<void> _addDataModelRelationWithAccount(
      {required String dataId, required String dataType}) async {
    await _setMapDataFirestore(
        data: {'account_id': await _getOwnerAccountId()},
        collectionPath: '${dataType}_account_relation',
        dataId: dataId);
  }

  Future<void> _setDataModelToFire<T extends BaseDataModel<T>>(
      {required T data}) async {
    if (data.id != null) {
      await _checkDataModelRelationWithAccount(
          accountId: await _getOwnerAccountId(),
          dataId: data.id!,
          dataType: data.databasePath);
    }
    String dataId = await _setDataModelFirestore(data);
    await _addDataModelRelationWithAccount(
        dataId: dataId, dataType: data.databasePath);
  }

  Future<void> setEvent({required EventModel event}) async {
    _setDataModelToFire(data: event);
  }

  Future<void> setMission({required MissionModel mission}) async {
    _setDataModelToFire(data: mission);
  }

  Future<void> setMissionState({required MissionStateModel state}) async {
    _setDataModelToFire(data: state);
  }

//
//single get

  Future<T> _getSingleDataModelFromFire<T extends BaseDataModel<T>>(
      {String? ownerAccountId,
      required String dataId,
      required T defaultData}) async {
    ownerAccountId ??= await _getOwnerAccountId();
    await _checkDataModelRelationWithAccount(
        accountId: ownerAccountId,
        dataId: dataId,
        dataType: defaultData.databasePath);

    var docSnap = await _getDocSnapFirestore(
        collectionPath: defaultData.databasePath, dataId: dataId);

    return defaultData.fromFirestore(
        id: docSnap.id, data: docSnap.data() ?? {});
  }

  Future<EventModel> getEvent({required String eventId}) async {
    String ownerAccountId = await _getOwnerAccountId();
    EventModel event = await _getSingleDataModelFromFire(
        ownerAccountId: ownerAccountId,
        dataId: eventId,
        defaultData: EventModel.defaultEvent);

    event.setOwner(
        ownerAccount: await _getSingleAccount(accountId: ownerAccountId));

    return event;
  }

  Future<MissionModel> getMission({required String missionId}) async {
    String ownerAccountId = await _getOwnerAccountId();

    MissionModel mission = await _getSingleDataModelFromFire(
        ownerAccountId: ownerAccountId,
        dataId: missionId,
        defaultData: MissionModel.defaultMission);

    mission.setOwner(
        ownerAccount: await _getSingleAccount(accountId: ownerAccountId));
    mission
        .setStateByStateModel(await getMissionState(stateId: mission.stateId));

    return mission;
  }

  Future<MissionStateModel> getMissionState({required String stateId}) async {
    MissionStateModel state = await _getSingleDataModelFromFire(
        dataId: stateId, defaultData: MissionStateModel.defaultUnknownState);
    return state;
  }

//
//getSingleAccountAll
  Future<List<T>>
      _getSingleAccountAllDataModelFromFire<T extends BaseDataModel<T>>(
          {String? ownerAccountId, required T defaultData}) async {
    ownerAccountId ??= await _getOwnerAccountId();
    var idSnapList = await _getDataFitMapFirestore(
        collectionPath: '${defaultData.databasePath}_account_relation',
        condition: {'account_id': ownerAccountId});

    List<String> dataIdList = [];
    for (var idSnap in idSnapList) {
      dataIdList.add(idSnap.id);
    }

    List<T> eventList = [];

    for (var dataId in dataIdList) {
      var docSnap = await _getDocSnapFirestore(
          collectionPath: defaultData.databasePath, dataId: dataId);
      T event =
          defaultData.fromFirestore(id: docSnap.id, data: docSnap.data() ?? {});
      eventList.add(event);
    }

    return eventList;
  }

  Future<List<EventModel>> _getSingleAccountAllEvent() async {
    String ownerAccountId = await _getOwnerAccountId();
    List<EventModel> eventList = await _getSingleAccountAllDataModelFromFire(
        ownerAccountId: ownerAccountId, defaultData: EventModel.defaultEvent);

    var ownerAccount = await _getSingleAccount(accountId: ownerAccountId);
    for (var event in eventList) {
      event.setOwner(ownerAccount: ownerAccount);
    }
    return eventList;
  }

  Future<List<MissionModel>> _getSingleAccountAllMission() async {
    String ownerAccountId = await _getOwnerAccountId();
    List<MissionModel> missionList =
        await _getSingleAccountAllDataModelFromFire(
            ownerAccountId: ownerAccountId,
            defaultData: MissionModel.defaultMission);

    var ownerAccount = await _getSingleAccount(accountId: ownerAccountId);
    for (var mission in missionList) {
      mission.setOwner(ownerAccount: ownerAccount);
      mission.setStateByStateModel(
          await getMissionState(stateId: mission.stateId));
    }

    return missionList;
  }

  Future<List<MissionStateModel>> _getSingleAccountAllMissionState() async {
    String ownerAccountId = await _getOwnerAccountId();
    var missionStateSnapList = await _getDataFitMapFirestore(
        collectionPath: 'missionState_account_relation',
        condition: {'account_id': ownerAccountId});

    List<String> missionStateIdList = [];
    for (var docSnap in missionStateSnapList) {
      missionStateIdList.add(docSnap.id);
    }

    List<MissionStateModel> missionStateList = [];

    for (var missionStateId in missionStateIdList) {
      var docSnap = await _getDocSnapFirestore(
          collectionPath: MissionStateModel.defaultUnknownState.databasePath,
          dataId: missionStateId);
      MissionStateModel missionState = MissionStateModel.defaultUnknownState
          .fromFirestore(id: docSnap.id, data: docSnap.data() ?? {});
      missionStateList.add(missionState);
    }

    return missionStateList;
  }

//
//getAll
  Future<List<EventModel>> getAllEvent() async {
    List<EventModel> eventList = await _getSingleAccountAllEvent();
    AccountModel ownerAccount = await _getSingleAccount(
        ownerUid: _ownerUid, accountId: await _getOwnerAccountId());
    if (_forUser) {
      for (var associateGroupId in ownerAccount.associateEntityId) {
        eventList.addAll(
            await DatabaseService(ownerUid: associateGroupId, forUser: false)
                .getAllEvent());
      }
    }
    return eventList;
  }

  Future<List<MissionModel>> getAllMission() async {
    List<MissionModel> missionList = await _getSingleAccountAllMission();
    AccountModel ownerAccount = await _getSingleAccount(
        ownerUid: _ownerUid, accountId: await _getOwnerAccountId());
    if (_forUser) {
      for (var associateGroupId in ownerAccount.associateEntityId) {
        missionList.addAll(
            await DatabaseService(ownerUid: associateGroupId, forUser: false)
                .getAllMission());
      }
    }
    return missionList;
  }

  Future<List<MissionStateModel>> getAllMissionState() async {
    return await _getSingleAccountAllMissionState();
  }
}
