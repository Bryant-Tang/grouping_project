part of database_service;

/// all subclass should implements `_create() constructor`,`_fromDatabase() constructor`,
/// `Map<String, dynamic> _toDatabase()`
///
/// any subclass should ***ONLY*** have private constructor, in order to prevent unacceptable construct.
abstract class DatabaseDocument {
  final DocumentReference<Map<String, dynamic>> _ref;
  String get id => _ref.id;
  DatabaseDocument._create(
      {required DocumentReference<Map<String, dynamic>> ref})
      : _ref = ref;
  DatabaseDocument._fromDatabase(
      {required DocumentSnapshot<Map<String, dynamic>> snap})
      : _ref = snap.reference;
  Map<String, dynamic> _toDatabase();
}
