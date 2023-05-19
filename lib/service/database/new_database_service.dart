library database_service;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouping_project/exception.dart';

part 'account.dart';
part 'data_result.dart';
part 'event.dart';
part 'profile.dart';
part 'database_document.dart';

abstract class _DatabaseCollectionName {
  static String account = 'account';
  static String profile = 'profile';
  static String uidCorrespondAccount = 'uid_account';
  static String event = 'event';
  static String mission = 'mission';
  static String state = 'state';
}

abstract class _DefaultFieldValue {
  static String unknownStr = 'unknown';
  static int zeroInt = 0;
  static List emptyList = [];
  static Timestamp zeroTimestamp = Timestamp(0, 0);
  static Map emptyMap = {};
}

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;

  //
  // For constructing DatabaseService
  Account _account;
  DatabaseService._create(Account account) : _account = account;
  static Future<DatabaseService> withAccountChecking(Account account) async {
    if ((await account._ref.get()).exists) {
      return DatabaseService._create(account);
    }
    throw GroupingProjectException(
        message: 'This account is not exist in database.'
            ' Please create account first.',
        code: GroupingProjectExceptionCode.notExistInDatabase,
        stackTrace: StackTrace.current);
  }

  //
  // For simply create document in database without binding
  static Future<Event> _createEventWithoutBinding() async {
    final eventRef = await _firestore
        .collection(_DatabaseCollectionName.event)
        .add(_DefaultFieldValue.emptyMap as Map<String, dynamic>);
    Event event = Event._create(eventRef: eventRef);
    return event;
  }

  static Future<Profile> _createProfileWithoutBinding() async {
    final profileRef = await _firestore
        .collection(_DatabaseCollectionName.profile)
        .add(_DefaultFieldValue.emptyMap as Map<String, dynamic>);
    // Profile profile = Profile._create(profileRef: profileRef, photo: photo);
    //TODO: implement photo type
    throw UnimplementedError();
    // return profile;
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
      throw GroupingProjectException(
          message:
              'It is not allow to create group account for a group account.',
          code: GroupingProjectExceptionCode.wrongParameter,
          stackTrace: StackTrace.current);
    }
    Account newAccount = await _createAccountWithoutBinding();
    _account._addAssociateAccountRef(newAccount._ref);
    await _setAccount();
    newAccount._addAssociateAccountRef(_account._ref);
    await (await DatabaseService.withAccountChecking(newAccount))._setAccount();
    return newAccount;
  }

  Future<Event> createEvent() async {
    Event event = await _createEventWithoutBinding();
    _account._addEventRef(event._ref);
    await _setAccount();
    return event;
  }

  //
  // For get only document itself without owner profile
  static Future<Account> getUserAccount(String uid) async {
    return Account._fromDatabase(
        accountSnap: (await _firestore
            .collection(_DatabaseCollectionName.uidCorrespondAccount)
            .doc(uid)
            .get()));
  }

  static Future<Profile> getSimpleProfile(
      DocumentReference<Map<String, dynamic>> profileRef) async {
    return Profile._fromDatabase(profileSnap: await profileRef.get());
  }

  Future<void> _reloadAccount() async {
    _account = Account._fromDatabase(accountSnap: await _account._ref.get());
  }

  //
  // For set document
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

  Future<void> _setDocument(DatabaseDocument document) async {
    await document._ref.set(document._toDatabase());
  }

  Future<void> _setAccount() async {
    await _setDocument(_account);
  }

  Future<void> setProfile(Profile profile) async {
    _checkDocumentRefBelongTo(
        refList: [_account.profile], documentRef: profile._ref);
    await _setDocument(profile);
  }

  Future<void> setEvent(Event event) async {
    _checkDocumentRefBelongTo(refList: _account.event, documentRef: event._ref);
    await _setDocument(event);
  }

  //
  // For get document with owner account and profile
  Future<DataResult<Null>> getProfile() async {
    return await DataResult._withProfileGetting(
        ownerAccount: _account, data: []);
  }

  Future<DataResult<Event>> getEvent(
      DocumentReference<Map<String, dynamic>> eventRef) async {
    _checkDocumentRefBelongTo(refList: _account.event, documentRef: eventRef);
    return await DataResult._withProfileGetting(
        ownerAccount: _account,
        data: [Event._fromDatabase(eventSnap: await eventRef.get())]);
  }
}
