import '../enums/payment_status.dart';

class UpiPaymentResponse {
  final String? transactionId;
  final String? responseCode;
  final String? approvalRefNo;
  final String? transactionRefId;
  final PaymentStatus status;
  final String rawResponse;

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
