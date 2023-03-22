import 'profile_model.dart';

/// ## a base class of every data in database, can only use as POLYMORPHISM
abstract class DataModel<T extends DataModel<T>> {
  final String? id;
  String databasePath;
  bool storageRequired;
  bool setOwnerRequired;

  /// every subclass should pass all follow attribute to this superclass
  /// * [id] : the id of this data
  /// * [databasePath] : the collection path of this type of data
  /// * [storageRequired] : whether this type of data need firebase storage
  /// * [setOwnerRequired] : whether this type of data need to set owner data
  /// while downloading from firestore
  DataModel(
      {required this.id,
      required this.databasePath,
      required this.storageRequired,
      required this.setOwnerRequired});

  /// return a `map` data in order to upload to firestore
  /// * every subclass should override this method
  Map<String, dynamic> toFirestore();

  /// return a `T<T extends DataModel>` data in order to download from firestore
  /// * every subclass should override this method
  T fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      ProfileModel? ownerProfile});
}
