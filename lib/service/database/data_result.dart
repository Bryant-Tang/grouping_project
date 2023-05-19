part of database_service;

class DataResult<T extends DatabaseDocument?> {
  DocumentReference<Map<String, dynamic>> ownerAccountRef;
  Profile ownerProfile;
  List<T> data;
  DataResult._create(
      {required this.ownerAccountRef,
      required this.ownerProfile,
      required this.data});
  static Future<DataResult<T>> _withProfileGetting<T extends DatabaseDocument?>(
      {required Account ownerAccount, required List<T> data}) async {
    return DataResult<T>._create(
        ownerAccountRef: ownerAccount._ref,
        ownerProfile: await DatabaseService.getSimpleProfile(
            profileRef: ownerAccount._profile),
        data: data);
  }
}
