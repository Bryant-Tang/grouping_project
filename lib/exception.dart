/// A generic class which provides exceptions in a GroupingProject-friendly format
/// to users.
///
/// * learn from Firebase
///
/// ```dart
/// try {
///   //do something
/// } catch (e) {
///   print(e.toString());
/// }
/// ```
class GroupingProjectException implements Exception {
  /// A generic class which provides exceptions in a GroupingProject-friendly format
  /// to users.
  ///
  /// * learn from Firebase
  ///
  /// ```dart
  /// try {
  ///   //do something
  /// } catch (e) {
  ///   print(e.toString());
  /// }
  /// ```
  GroupingProjectException({
    this.message,
    String? code,
    this.stackTrace,
    // ignore: unnecessary_this
  }) : this.code = code ?? 'unknown';

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GroupingProjectException) return false;
    return other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(code, message);

  @override
  String toString() {
    String output = '[$code] $message';

    if (stackTrace != null) {
      output += '\n\n$stackTrace';
    }
    return output;
  }
}

class GroupingProjectExceptionCode {
  GroupingProjectExceptionCode._();
  static const String wrongConstructParameter = 'wrong-construct-parameter';
  static const String notExistInDatabase = 'not-exist-in-database';
}
