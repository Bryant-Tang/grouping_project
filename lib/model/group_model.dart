import 'profile_model.dart';
import 'data_model.dart';

class GroupModel extends DataModel<GroupModel> {
  GroupModel({super.id})
      : super(
            databasePath: 'groups',
            storageRequired: false,
            setOwnerRequired: false);

  @override
  Map<String, dynamic> toFirestore() {
    return {};
  }

  @override
  GroupModel fromFirestore(
      {required String id,
      required Map<String, dynamic> data,
      ProfileModel? ownerProfile}) {
    return GroupModel(id: id);
  }
}
