class UpiException implements Exception {
  final String message;
  final String? code;

  UpiException(this.message, {this.code});

  @override
  String toString() => 'UpiException: $message${code != null ? ' (Code: $code)' : ''}';
}

class UpiAppNotInstalledException extends UpiException {
  UpiAppNotInstalledException(String appName)
      : super('UPI App "$appName" is not installed on this device.');
}

class UpiInvalidParamsException extends UpiException {
  UpiInvalidParamsException(super.message);
}
