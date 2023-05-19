part of database_service;

abstract class _FieldNameForAccount {
  static String isUser = 'is_user';
  static String profile = 'profile';
  static String associateAccount = 'asso_account';
  static String event = 'event';
  static String mission = 'mission';
  static String state = 'state';
}

class Account extends DatabaseDocument {
  final bool _isUser;
  final DocumentReference<Map<String, dynamic>> _profile;
  final List<DocumentReference<Map<String, dynamic>>> _associateAccount;
  final List<DocumentReference<Map<String, dynamic>>> _event;
  final List<DocumentReference<Map<String, dynamic>>> _mission;
  final List<DocumentReference<Map<String, dynamic>>> _state;

  Account._create(
      {required bool isUser,
      required DocumentReference<Map<String, dynamic>> accountRef,
      required DocumentReference<Map<String, dynamic>> profile})
      : _isUser = isUser,
        _profile = profile,
        _associateAccount = List.from(_DefaultFieldValue.emptyList),
        _event = List.from(_DefaultFieldValue.emptyList),
        _mission = List.from(_DefaultFieldValue.emptyList),
        _state = List.from(_DefaultFieldValue.emptyList),
        super._create(ref: accountRef);

  Account._fromDatabase(
      {required DocumentSnapshot<Map<String, dynamic>> accountSnap})
      : _isUser = accountSnap.data()?[_FieldNameForAccount.isUser],
        _profile = accountSnap.data()?[_FieldNameForAccount.profile],
        _associateAccount = List.from(
            accountSnap.data()?[_FieldNameForAccount.associateAccount] ?? []),
        _event =
            List.from(accountSnap.data()?[_FieldNameForAccount.event] ?? []),
        _mission =
            List.from(accountSnap.data()?[_FieldNameForAccount.mission] ?? []),
        _state =
            List.from(accountSnap.data()?[_FieldNameForAccount.state] ?? []),
        super._fromDatabase(snap: accountSnap);

  Map<String, dynamic> _toDatabase() {
    return {
      _FieldNameForAccount.isUser: _isUser,
      _FieldNameForAccount.profile: _profile,
      _FieldNameForAccount.associateAccount: _associateAccount,
      _FieldNameForAccount.event: _event,
      _FieldNameForAccount.mission: _mission,
      _FieldNameForAccount.state: _state,
    };
  }

  bool get isUser => _isUser;
  DocumentReference<Map<String, dynamic>> get profile => _profile;
  List<DocumentReference<Map<String, dynamic>>> get associateAccount =>
      _associateAccount;
  List<DocumentReference<Map<String, dynamic>>> get event => _event;
  List<DocumentReference<Map<String, dynamic>>> get mission => _mission;
  List<DocumentReference<Map<String, dynamic>>> get state => _state;
  void _addAssociateAccountRef(
          DocumentReference<Map<String, dynamic>> associateAccountRef) =>
      _associateAccount.add(associateAccountRef);

  void _addEventRef(DocumentReference<Map<String, dynamic>> eventRef) =>
      _event.add(eventRef);

  void _addMissionRef(DocumentReference<Map<String, dynamic>> missionRef) =>
      _mission.add(missionRef);

  void _addStateRef(DocumentReference<Map<String, dynamic>> stateRef) =>
      _state.add(stateRef);

  void _removeAssociateAccountRef(
          DocumentReference<Map<String, dynamic>> associateAccountRef) =>
      _associateAccount.remove(associateAccountRef);

  void _removeEventRef(DocumentReference<Map<String, dynamic>> eventRef) =>
      _event.remove(eventRef);

  void _removeMissionRef(DocumentReference<Map<String, dynamic>> missionRef) =>
      _mission.remove(missionRef);

  void _removeStateRef(DocumentReference<Map<String, dynamic>> stateRef) =>
      _state.remove(stateRef);

  void _clearAssociateAccountRef() => _associateAccount.clear();

  void _clearEventRef() => _event.clear();

  void _clearMissionRef() => _mission.clear();

  void _clearStateRef() => _state.clear();
}
