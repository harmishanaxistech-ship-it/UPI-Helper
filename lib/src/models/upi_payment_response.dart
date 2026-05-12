import '../enums/payment_status.dart';

/// Response details from a UPI payment transaction.
class UpiPaymentResponse {
  /// The transaction ID returned by the UPI app.
  final String? transactionId;

  /// The response code returned by the UPI app.
  final String? responseCode;

  /// The approval reference number.
  final String? approvalRefNo;

  /// The transaction reference ID passed during the request.
  final String? transactionRefId;

  /// The status of the payment.
  final PaymentStatus status;

  /// The raw response string received from the UPI app.
  final String rawResponse;

  /// Creates a new [UpiPaymentResponse] instance.
  UpiPaymentResponse({
    this.transactionId,
    this.responseCode,
    this.approvalRefNo,
    this.transactionRefId,
    required this.status,
    required this.rawResponse,
  });

  @override
  String toString() {
    return 'UpiPaymentResponse(transactionId: $transactionId, responseCode: $responseCode, approvalRefNo: $approvalRefNo, status: $status)';
  }
}
