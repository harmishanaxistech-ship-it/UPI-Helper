/// Represents the status of a UPI payment transaction.
enum PaymentStatus {
  /// Payment completed successfully.
  success,

  /// Payment failed.
  failed,

  /// Payment was cancelled by the user.
  cancelled,

  /// Payment was submitted but is pending confirmation.
  submitted,

  /// Payment status could not be determined.
  unknown;

  /// Parses a string status into a [PaymentStatus] enum.
  static PaymentStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'txn_success':
        return PaymentStatus.success;
      case 'failure':
      case 'failed':
      case 'txn_failure':
        return PaymentStatus.failed;
      case 'cancel':
      case 'cancelled':
        return PaymentStatus.cancelled;
      case 'submitted':
        return PaymentStatus.submitted;
      default:
        return PaymentStatus.unknown;
    }
  }
}
