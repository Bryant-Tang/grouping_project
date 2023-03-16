import './data_model.dart';
import '../service/firestore_service.dart';

/// to get any data from firebase, you need a DataController
class DataController {
  String? userId;
  String? groupId;

  /// auto get current user id if not given group id
  DataController({this.groupId});

  /// to upload any data to database, use this method and pass the data to it.
  /// including upload new data and existed data.
  ///
  /// remember to check the data has a correct id if you want update an existed data.
  ///
  /// remember to use await in front of this method.
  Future<void> upload<T extends DataModel<T>>({required T uploadData}) async {
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
    throw UnimplementedError();
  }

  /// remember to check the data has a correct id.
  ///
  /// remember to use await in front of this method.
  Future<void> remove<T extends DataModel<T>>({required T uploadData}) async {
    return;
  }
}
