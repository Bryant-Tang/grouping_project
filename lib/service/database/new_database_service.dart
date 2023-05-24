library database_service;

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grouping_project/exception.dart';

part 'account.dart';
part 'data_result.dart';
part 'event.dart';
part 'profile.dart';
part 'database_document.dart';
part 'image.dart';
part 'mission_state.dart';

abstract class _DatabaseCollectionName {
  static String account = 'account';
  static String profile = 'profile';
  static String uidCorrespondAccount = 'uid_account';
  static String event = 'event';
  static String mission = 'mission';
  static String state = 'state';
  static String image = 'image';
}

abstract class _DefaultFieldValue {
  static String unknownStr = 'unknown';
  static int zeroInt = 0;
  static List emptyList = [];
  static Timestamp zeroTimestamp = Timestamp(0, 0);
  static Map emptyMap = {};
  static Uint8List emptyUint8List = Uint8List(0);
  static Stage unknownStage = Stage.unknown;
}

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();
  static final List<ImageData> _imageCache = [];

  //
  // For constructing DatabaseService
  Account _account;
  DatabaseService._create({required Account account}) : _account = account;
  static Future<DatabaseService> withAccountChecking(
      {required Account account}) async {
    if ((await account._ref.get()).exists) {
      return DatabaseService._create(account: account);
    }
    throw GroupingProjectException(
        message: 'This account is not exist in database.'
            ' Please create account first.',
        code: GroupingProjectExceptionCode.notExistInDatabase,
        stackTrace: StackTrace.current);
  }

  //
  // For simply create document in database without binding
  static Future<State> _createStateWithoutBinding() async {
    final stateRef = await _firestore
        .collection(_DatabaseCollectionName.state)
        .add(_DefaultFieldValue.emptyMap as Map<String, dynamic>);
    State state = State._create(stateRef: stateRef);
    return state;
  }

  static Future<Event> _createEventWithoutBinding() async {
    final eventRef = await _firestore
        .collection(_DatabaseCollectionName.event)
        .add(_DefaultFieldValue.emptyMap as Map<String, dynamic>);
    Event event = Event._create(eventRef: eventRef);
    return event;
  }

  static Future<ImageData> _createImageWithoutBinding() async {
    final imageRef = await _firestore
        .collection(_DatabaseCollectionName.image)
        .add(_DefaultFieldValue.emptyMap as Map<String, dynamic>);
    ImageData image = ImageData._create(imageRef: imageRef);
    return image;
  }

  static Future<Profile> _createProfileWithoutBinding() async {
    final profileRef = await _firestore
        .collection(_DatabaseCollectionName.profile)
        .add(_DefaultFieldValue.emptyMap as Map<String, dynamic>);
    ImageData image = await _createImageWithoutBinding();
    Profile profile = Profile._create(profileRef: profileRef, photo: image);
    return profile;
  }

  static Future<Account> _createAccountWithoutBinding() async {
    Profile profile = await _createProfileWithoutBinding();
    final accountRef = await _firestore
        .collection(_DatabaseCollectionName.account)
        .add(_DefaultFieldValue.emptyMap as Map<String, dynamic>);
    Account account = Account._create(
        isUser: true, accountRef: accountRef, profile: profile._ref);
    return account;
  }

  //
  // For create document and bind it to the specific place
  static Future<Account> createUserAccount({required String uid}) async {
    Account account = await _createAccountWithoutBinding();
    await _firestore
        .collection(_DatabaseCollectionName.uidCorrespondAccount)
        .doc(uid)
        .set({_DatabaseCollectionName.account: account._ref});
    return account;
  }

  Future<Account> createGroupAccount() async {
    if (_account.isUser == false) {
      _throwExceptionNotAllowGroupAccount();
    }
    Account newAccount = await _createAccountWithoutBinding();
    _reloadAccount();
    _account._addAssociateAccountRef(newAccount._ref);
    await _setAccount();
    newAccount._addAssociateAccountRef(_account._ref);
    await (await DatabaseService.withAccountChecking(account: newAccount))
        ._setAccount();
    return newAccount;
  }

  Future<Event> createEvent() async {
    Event event = await _createEventWithoutBinding();
    _reloadAccount();
    _account._addEventRef(event._ref);
    await _setAccount();
    return event;
  }

  Future<State> createState() async {
    State state = await _createStateWithoutBinding();
    _reloadAccount();
    _account._addStateRef(state._ref);
    await _setAccount();
    return state;
  }

  //
  // For get only document itself without owner profile
  static Future<Account> getUserAccount({required String uid}) async {
    return Account._fromDatabase(
        accountSnap: (await _firestore
            .collection(_DatabaseCollectionName.uidCorrespondAccount)
            .doc(uid)
            .get()));
  }

  static Future<ImageData> _getImage(
      {required DocumentReference<Map<String, dynamic>> imageRef}) async {
    var imageSnap = await imageRef.get();
    if (_imageCache.map((i) => i._ref.id).contains(imageRef.id)) {
      ImageData imageCache =
          _imageCache.singleWhere((i) => i._ref.id == imageRef.id);
      Timestamp databaseLastModified =
          imageSnap.data()?[_FieldNameForImage.lastModified] ??
              Timestamp.fromMicrosecondsSinceEpoch(0);
      if (imageCache.lastModified
          .toDate()
          .isAfter(databaseLastModified.toDate())) {
        return ImageData._fromCache(imageCache);
      }
    }

    ImageData image = ImageData._fromDatabase(
        imageSnap: imageSnap,
        storageData: (await _storage.child(imageRef.id).getData()) ??
            _DefaultFieldValue.emptyUint8List);
    return image;
  }

  static Future<Profile> getSimpleProfile(
      {required DocumentReference<Map<String, dynamic>> profileRef}) async {
    var profileSnap = await profileRef.get();
    ImageData image = await _getImage(
        imageRef: profileSnap.data()?[_FieldNameForProfile.photo]);
    return Profile._fromDatabase(profileSnap: profileSnap, photo: image);
  }

  Future<Event> _getSimpleEvent(
      {required DocumentReference<Map<String, dynamic>> eventRef}) async {
    return Event._fromDatabase(eventSnap: await eventRef.get());
  }

  Future<State> _getSimpleState(
      {required DocumentReference<Map<String, dynamic>> stateRef}) async {
    return State._fromDatabase(stateSnap: await stateRef.get());
  }

  Future<void> _reloadAccount() async {
    _account = Account._fromDatabase(accountSnap: await _account._ref.get());
  }

  Future<Account> getGroupAccount(
      {required DocumentReference<Map<String, dynamic>>
          groupAccountRef}) async {
    _reloadAccount();
    if (_account.isUser == false) {
      _throwExceptionNotAllowGroupAccount();
    }
    _checkDocumentRefBelongTo(
        refList: _account._associateAccount, documentRef: groupAccountRef);
    return Account._fromDatabase(accountSnap: await groupAccountRef.get());
  }

  Future<List<Account>> getAllGroupAccount() async {
    _reloadAccount();
    return List.from(_account._associateAccount.map((groupAccountRef) async =>
        (await getGroupAccount(groupAccountRef: groupAccountRef))));
  }

  Future<Account> getOwnerAccount({required DataResult dataResult}) async {
    return await getGroupAccount(groupAccountRef: dataResult.ownerAccountRef);
  }

  //
  // For throw exception
  void _throwExceptionNotAllowGroupAccount() {
    throw GroupingProjectException(
        message: 'This action is not for group account.',
        code: GroupingProjectExceptionCode.notCorrectAccount,
        stackTrace: StackTrace.current);
  }

  void _throwExceptionDocumentNotBelongToAccount() {
    throw GroupingProjectException(
        message: 'This document is not belong to the controlled account.',
        code: GroupingProjectExceptionCode.wrongParameter,
        stackTrace: StackTrace.current);
  }

  void _checkDocumentRefBelongTo(
      {required List<DocumentReference<Map<String, dynamic>>> refList,
      required DocumentReference<Map<String, dynamic>> documentRef}) {
    _reloadAccount();
    if (!(List.from(refList.map((ref) => ref.path))
        .contains(documentRef.path))) {
      _throwExceptionDocumentNotBelongToAccount();
    }
  }

  //
  // For set document
  Future<void> _setDocument({required DatabaseDocument document}) async {
    await document._ref.set(document._toDatabase());
  }

  Future<void> _setAccount() async {
    await _setDocument(document: _account);
  }

  Future<void> setProfile({required Profile profile}) async {
    _checkDocumentRefBelongTo(
        refList: [_account.profile], documentRef: profile._ref);
    await _setDocument(document: profile);
    await _setImage(image: profile.photo);
  }

  Future<void> _setImage({required ImageData image}) async {
    image._lastModified = Timestamp.now();
    await _setDocument(document: image);
    _imageCache.removeWhere((i) => i._ref.id == image._ref.id);
    _imageCache.add(image.toCache());
    await _storage.child(image._ref.id).putData(image._data);
  }

  Future<void> setEvent({required Event event}) async {
    _checkDocumentRefBelongTo(refList: _account.event, documentRef: event._ref);
    await _setDocument(document: event);
  }

  Future<void> setState({required State state}) async {
    _checkDocumentRefBelongTo(refList: _account.state, documentRef: state._ref);
    await _setDocument(document: state);
  }

  //
  // For get document with owner account and profile
  Future<DataResult<Null>> getProfile() async {
    return await DataResult._withProfileGetting(
        ownerAccount: _account, data: []);
  }

  Future<DataResult<Event>> getEvent(
      {required DocumentReference<Map<String, dynamic>> eventRef}) async {
    _checkDocumentRefBelongTo(refList: _account.event, documentRef: eventRef);
    return await DataResult._withProfileGetting(
        ownerAccount: _account,
        data: [await _getSimpleEvent(eventRef: eventRef)]);
  }

  Future<DataResult<State>> getState(
      {required DocumentReference<Map<String, dynamic>> stateRef}) async {
    _checkDocumentRefBelongTo(refList: _account.state, documentRef: stateRef);
    return await DataResult._withProfileGetting(
        ownerAccount: _account,
        data: [await _getSimpleState(stateRef: stateRef)]);
  }

  //
  // For get all documents of the same kind, in the account
  Future<DataResult<Event>> getAllEvent() async {
    _reloadAccount();
    List<Event> data = [];
    for (var eventRef in _account._event) {
      data.add(await _getSimpleEvent(eventRef: eventRef));
    }
    return await DataResult._withProfileGetting(
        ownerAccount: _account, data: data);
  }

  Future<DataResult<State>> getAllState() async {
    _reloadAccount();
    List<State> data = [];
    for (var stateRef in _account._state) {
      data.add(await _getSimpleState(stateRef: stateRef));
    }
    return await DataResult._withProfileGetting(
        ownerAccount: _account, data: data);
  }

  //
  // special get method
  Future<List<DataResult<Event>>> getContributingEvent() async {
    if (_account.isUser == false) {
      _throwExceptionNotAllowGroupAccount();
    }
    List<DataResult<Event>> data = [await getAllEvent()];
    for (var account in (await getAllGroupAccount())) {
      var groupEvents =
          await (await DatabaseService.withAccountChecking(account: account))
              .getAllEvent();
      groupEvents.data.removeWhere((event) => !(event.contributor
          .map((ref) => ref.id)
          .contains(_account.profile.id)));
      data.add(groupEvents);
    }
    return data;
  }

  //
  // For delete document
  Future<void> _removeDocument(
      {required DocumentReference<Map<String, dynamic>> ref}) async {
    await ref.delete();
  }

  Future<void> removeState(
      {required DocumentReference<Map<String, dynamic>> stateRef}) async {
    _checkDocumentRefBelongTo(refList: _account._state, documentRef: stateRef);
    _account._removeStateRef(stateRef);
    await _setAccount();
    await _removeDocument(ref: stateRef);
  }

  Future<void> removeEvent(
      {required DocumentReference<Map<String, dynamic>> eventRef}) async {
    _checkDocumentRefBelongTo(refList: _account._event, documentRef: eventRef);
    _account._removeEventRef(eventRef);
    await _setAccount();
    await _removeDocument(ref: eventRef);
  }

  Future<void> leaveGroup(
      {required DocumentReference<Map<String, dynamic>> accountRef}) async {
    _checkDocumentRefBelongTo(
        refList: _account._associateAccount, documentRef: accountRef);
    var groupAccountService = await DatabaseService.withAccountChecking(
        account: await getGroupAccount(groupAccountRef: accountRef));
    _account._removeAssociateAccountRef(accountRef);
    await _setAccount();
    groupAccountService._removeUser(accountRef: _account._ref);
  }

  Future<void> _removeUser(
      {required DocumentReference<Map<String, dynamic>> accountRef}) async {
    _checkDocumentRefBelongTo(
        refList: _account._associateAccount, documentRef: accountRef);
    _account._removeAssociateAccountRef(accountRef);
    await _setAccount();
  }
}
