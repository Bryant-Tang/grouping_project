import './auth_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  DocumentReference ownerPath;

  FirestoreController({required this.ownerPath});

  Future<void> set(
      {required Map<String, dynamic> processData,
      required String collectionPath}) async {
    return;
  }

  Future<void> update(
      {required Map<String, dynamic> processData,
      required String documentPath}) async {
    return;
  }

  Future<DocumentSnapshot> get({required String documentPath}) async {
    throw UnimplementedError();
  }

  Future<List<QueryDocumentSnapshot>> getAll(
      {required String collectionPath}) async {
    throw UnimplementedError();
  }

  Future<void> delete({required String collectionPath}) async {
    return;
  }
}
