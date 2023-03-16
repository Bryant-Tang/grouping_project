/// !! NOTICE !!
/// this is a super class of every data in database,
/// can only use as POLYMORPHISM
abstract class DataModel<T extends DataModel<T>> {
  final String? id;
  String databasePath = 'unknown';
  bool firestoreRequired = false;
  bool storageRequired = false;
  bool getOwner = false;

  /// !! NOTICE !!
  /// every subclass should return id to this superclass,
  /// either get it or set a value to it in constructor
  DataModel({required this.id});

  /// !! NOTICE !!
  /// every subclass should override this method
  T makeInstance();

  /// !! NOTICE !!
  /// every subclass should override this method
  Map<String, dynamic> toFirestore();

  /// !! NOTICE !!
  /// every subclass should override this method
  void fromFirestore(Map<String, dynamic> data);

  /// !! NOTICE !!
  /// every subclass should override this method
  void setOwner(Map<String, dynamic> data);
}
