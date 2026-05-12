/// Base class for all UPI-related exceptions in the package.
class UpiException implements Exception {
  /// Message describing the error.
  final String message;

  /// Optional error code.
  final String? code;

  /// Creates a new [UpiException].
  UpiException(this.message, {this.code});

  @override
  String toString() => 'UpiException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when the requested UPI app is not installed on the device.
class UpiAppNotInstalledException extends UpiException {
  /// Creates a new [UpiAppNotInstalledException] for the given [appName].
  UpiAppNotInstalledException(String appName)
      : super('UPI App "$appName" is not installed on this device.');
}

/// Exception thrown when the parameters provided for the UPI payment are invalid.
class UpiInvalidParamsException extends UpiException {
  /// Creates a new [UpiInvalidParamsException] with the given [message].
  UpiInvalidParamsException(super.message);
}
