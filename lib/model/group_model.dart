import 'profile_model.dart';
import 'data_model.dart';

/// ## a simple model only for user
/// * in order to record what groups a user attend
class GroupModel extends DataModel<GroupModel> {
  GroupModel({super.id})
      : super(
            databasePath: 'groups',
            storageRequired: false,
            setOwnerRequired: false);

  /// ### convert data from this instance to the type accepted for firestore
  /// * ***DO NOT*** use this method in frontend
  @override
  Map<String, dynamic> toFirestore() {
    return {};
  }

  /// ### return an instance with data from firestore
  /// * also seting attribute about owner if given
  /// * ***DO NOT*** use this method in frontend
  @override
  GroupModel fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      ProfileModel? ownerProfile}) {
    return GroupModel(id: id);
  }
}
