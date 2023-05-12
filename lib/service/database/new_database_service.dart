library database_service;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouping_project/exception.dart';

part 'account.dart';
part 'data_result.dart';
part 'event.dart';
part 'profile.dart';
part 'database_document.dart';

abstract class _DatabaseCollectionName {
  static const String account = 'account';
  static const String profile = 'profile';
  static const String uidCorrespondAccount = 'uid_account';
  static const String event = 'event';
}

abstract class _DefaultFieldValue {
  static String unknownStr = 'unknown';
  static int zeroInt = 0;
  static List emptyList = [];
  static Timestamp zeroTimestamp = Timestamp(0, 0);
}

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;

  final Account _account;

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

  static Future<Account> getUserAccount(String uid) async {
    return Account._fromDatabase(
        accountSnap: (await _firestore
            .collection(_DatabaseCollectionName.uidCorrespondAccount)
            .doc(uid)
            .get()));
  }

  static Future<Event> _createEventWithoutBinding() async {
    final eventRef =
        await _firestore.collection(_DatabaseCollectionName.event).add({});
    Event event = Event._create(eventRef: eventRef);
    //TODO: set event
    return event;
  }

  static Future<Profile> _createProfileWithoutBinding() async {
    final profileRef =
        await _firestore.collection(_DatabaseCollectionName.profile).add({});
    // Profile profile = Profile._create(profileRef: profileRef, photo: photo)
    //TODO: set profile
    throw UnimplementedError();
    // return profile;
  }

  static Future<Account> _createAccountWithoutBinding() async {
    Profile profile = await _createProfileWithoutBinding();
    final accountRef =
        await _firestore.collection(_DatabaseCollectionName.account).add({});
    Account account = Account._create(
        isUser: true, accountRef: accountRef, profile: profile._ref);
    //TODO: set account
    return account;
  }

  static Future<Account> createUserAccount({required String uid}) async {
    Account account = await _createAccountWithoutBinding();
    await _firestore
        .collection(_DatabaseCollectionName.uidCorrespondAccount)
        .doc(uid)
        .set({_DatabaseCollectionName.account: account._ref});
    return account;
  }

  static Future<Profile> getSimpleProfile(
      DocumentReference<Map<String, dynamic>> profileRef) async {
    return Profile._fromDatabase(profileSnap: await profileRef.get());
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
    //TODO: set _account
    newAccount._addAssociateAccountRef(_account._ref);
    //TODO: set newAccount
    return newAccount;
  }

  Future<Event> createEvent() async {
    Event event = await _createEventWithoutBinding();
    _account._addEventRef(event._ref);
    //TODO: set _account
    return event;
  }

  
}
