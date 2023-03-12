import 'package:grouping_project/service/auth_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

/// !! NOTICE !!
/// this is a super class of every data in database,
/// can only use as POLYMORPHISM
abstract class DataModel<T extends DataModel<T>> {
  final String id;
  String typeForPath = 'unknown_data_type_should_not_appear';

  /// !! NOTICE !!
  /// every subclass should return id to this superclass,
  /// either get it or set a value to it in constructor
  DataModel({required this.id});

  /// !! NOTICE !!
  /// every subclass should override this method
  Future<T> fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  );

  /// !! NOTICE !!
  /// every subclass should override this method
  Map<String, dynamic> toFirestore();

  /// if it is a group data, remember to pass group id
  ///
  /// remember to add await
  Future<void> set({String? groupId}) async {
    await DataController(groupId: groupId).setMethod(processData: this);
  }

  /// if it is a group data, remember to pass group id
  ///
  /// remember to add await
  Future<List<T>> getAll({String? groupId}) async {
    List<T> processData = await DataController(groupId: groupId)
        .getAllMethod<T>(dataTypeToGet: this as T);
    return processData;
  }
}

/// to get any data from database, you need a DataController
class DataController {
  String? userId;
  String? groupId;
  late DocumentReference ownerPath;

  /// auto get current user id if not given group id
  DataController({this.groupId}) {
    if (groupId == null) {
      userId = AuthService().getUid();
      ownerPath = FirebaseFirestore.instance
          .collection("client_properties")
          .doc(userId);
    } else {
      ownerPath = FirebaseFirestore.instance
          .collection("group_properties")
          .doc(groupId);
    }
  }

  /// to upload any data to database, use this method and pass the data to it.
  ///
  /// remember to use await in front of this method.
  Future<void> setMethod({required DataModel processData}) async {
    DocumentReference dataPath;
    if (processData.id != '') {
      dataPath =
          ownerPath.collection(processData.typeForPath).doc(processData.id);
    } else {
      dataPath = ownerPath.collection(processData.typeForPath).doc();
    }

    final Map<String, dynamic> passData = processData.toFirestore();

    await dataPath.set(passData, SetOptions(merge: true));

    return;
  }

  /// to get any data from database,
  /// use this method and pass an empty object in the type you want.
  ///
  /// retrun a list of the type you specify.
  ///
  /// remember to use await in front of this method.
  ///
  /// !! special case for ProfileModel !!
  /// if you want to get ProfileModel, theoretically,
  /// this method will only return one ProfileModel in the list,
  /// unless the uploader done something wrong.
  Future<List<T>> getAllMethod<T extends DataModel<T>>(
      {required T dataTypeToGet}) async {
    CollectionReference dataPath =
        ownerPath.collection(dataTypeToGet.typeForPath);

    List<T> processData = [];
    for (var dataSnap in (await dataPath.get()).docs) {
      T temp = await dataTypeToGet.fromFirestore(
          dataSnap as QueryDocumentSnapshot<Map<String, dynamic>>, null);
      processData.add(temp);
    }
    if (userId != null) {
      for (var groupSnap in (await ownerPath.collection('groups').get()).docs) {
        processData.addAll(await DataController(groupId: groupSnap.id)
            .getAllMethod<T>(dataTypeToGet: dataTypeToGet));
      }
    }

    return processData;
  }
}
