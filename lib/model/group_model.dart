import 'profile_model.dart';
import 'data_model.dart';

class GroupModel extends DataModel<GroupModel> {
  GroupModel({super.id})
      : super(
            databasePath: 'groups',
            firestoreRequired: true,
            storageRequired: false,
            setOwnerRequired: false);

  @override
  GroupModel makeEmptyInstance() {
    return GroupModel();
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {};
  }

  @override
  void fromFirestore(
      {required Map<String, dynamic> data, ProfileModel? ownerProfile}) {
    return;
  }

  @override
  void setOwner(ProfileModel ownerProfile) {
    return;
  }
}
