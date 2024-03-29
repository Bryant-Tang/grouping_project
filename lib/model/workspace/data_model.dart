import 'dart:typed_data';

/// ## a base class of every data in database, can only use as ***Polymorphism***
/// every subclass should pass all follow attribute to this superclass
/// * [id] : the id of this data
/// * [databasePath] : the collection path of this type of data
/// * [storageRequired] : whether this type of data need firebase storage
abstract class BaseDataModel<T extends BaseDataModel<T>> {
  final String? id;
  String databasePath;
  bool storageRequired;
  // bool setOwnerRequired;

  /// ## a base class of every data in database, can only use as ***Polymorphism***
  /// every subclass should pass all follow attribute to this superclass
  /// * [id] : the id of this data
  /// * [databasePath] : the collection path of this type of data
  /// * [storageRequired] : whether this type of data need firebase storage
  BaseDataModel({
    required this.id,
    required this.databasePath,
    required this.storageRequired,
    // required this.setOwnerRequired
  });

  /// return a 'map' data in order to upload to django backend
  /// * every subclass should override this method
  Map<String, dynamic> toJson();

  /// return a 'T<T extends DataModel>' data in order to download from django backend
  /// * every subclass should override this method
  T fromJson({required String id, required Map<String, dynamic> data});

  /// return a `map` data in order to upload to firestore
  /// * every subclass should override this method
  // Map<String, dynamic> toFirestore();

  /// return a `T<T extends DataModel>` data in order to download from firestore
  /// * every subclass should override this method
  // T fromFirestore({required String id, required Map<String, dynamic> data});
}

/// ## a base class of every data in storage, can only be implement
abstract class BaseStorageData {
  Map<String, Uint8List> toStorage();
  void setAttributeFromStorage({required Map<String, Uint8List> data});
}
