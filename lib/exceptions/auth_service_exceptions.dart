class AuthServiceException implements Exception {
  final dynamic message;
  final dynamic code;
  AuthServiceException({required this.code, required this.message});

  @override
  String toString() {
    if (message == null || code == null) {
      return 'Exception';
    }
    return 'Auth Service Exception: $code\n$message';
  }
}
