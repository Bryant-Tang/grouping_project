import './data_model.dart';
import '../service/firestore_service.dart';
import '../service/auth_service.dart';

/// to get any data from firebase, you need a DataController
class DataController {
  late bool forUser;
  late String ownerId;

  /// auto get current user id if not given group id
  DataController({String? groupId}) {
    forUser = (groupId == null);
    ownerId = groupId ?? AuthService().getUid();
  }

  /// to upload any data to database, use this method and pass the data to it.
  /// including upload new data and existed data.
  ///
  /// remember to check the data has a correct id if you want update an existed data.
  ///
  /// remember to use await in front of this method.
  Future<void> upload<T extends DataModel<T>>({required T uploadData}) async {
    uploadData.id == null
        ? await FirestoreController(forUser: forUser, ownerId: ownerId).set(
            processData: uploadData.toFirestore(),
            collectionPath: uploadData.databasePath)
        : await FirestoreController(forUser: forUser, ownerId: ownerId).update(
            processData: uploadData.toFirestore(),
            collectionPath: uploadData.databasePath,
            dataId: uploadData.id!);
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
  Future<List<T>> downloadAll<T extends DataModel<T>>(
      {required T dataTypeToGet}) async {
    var snapList = await FirestoreController(forUser: forUser, ownerId: ownerId)
        .getAll(collectionPath: dataTypeToGet.databasePath);
    List<T> dataList = [];
    for (var snap in snapList) {
      T temp = dataTypeToGet.makeInstance();
      temp.fromFirestore(snap.data());
      // temp.setOwner(data);
    }
    throw UnimplementedError();
  }

  /// remember to check the data has a correct id.
  ///
  /// remember to use await in front of this method.
  Future<void> remove<T extends DataModel<T>>({required T uploadData}) async {
    return;
  }
}
