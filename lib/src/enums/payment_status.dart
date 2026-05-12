enum PaymentStatus {
  success,
  failed,
  cancelled,
  submitted,
  unknown;

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
