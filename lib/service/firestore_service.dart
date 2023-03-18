import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class FirestoreController {
  late DocumentReference ownerPath;

  FirestoreController({required bool forUser, required String ownerId}) {
    ownerPath = FirebaseFirestore.instance
        .collection(forUser ? 'user_properties' : 'group_properties')
        .doc(ownerId);
  }

  Future<void> set(
      {required Map<String, dynamic> processData,
      required String collectionPath}) async {
    await ownerPath.collection(collectionPath).add(processData);
    return;
  }

  Future<void> update(
      {required Map<String, dynamic> processData,
      required String collectionPath,
      required String dataId}) async {
    await ownerPath.collection(collectionPath).doc(dataId).update(processData);
    return;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> get(
      {required String collectionPath, required String dataId}) async {
    return await ownerPath.collection(collectionPath).doc(dataId).get();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAll(
      {required String collectionPath}) async {
    return (await ownerPath.collection(collectionPath).get()).docs;
  }

  Future<void> delete(
      {required String collectionPath, required String dataId}) async {
    await ownerPath.collection(collectionPath).doc(dataId).delete();
    return;
  }
}
