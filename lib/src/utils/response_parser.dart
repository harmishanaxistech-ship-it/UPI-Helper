import '../enums/payment_status.dart';
import '../models/upi_payment_response.dart';

class UpiResponseParser {
  static UpiPaymentResponse parse(String response) {
    // Typical response format: txnId=...&responseCode=...&Status=...&txnRef=...
    final Map<String, String> data = {};
    
    final List<String> parts = response.split('&');
    for (var part in parts) {
      final List<String> kv = part.split('=');
      if (kv.length == 2) {
        data[kv[0].toLowerCase()] = kv[1];
      }
    }

    final String statusStr = data['status'] ?? 'unknown';
    
    return UpiPaymentResponse(
      transactionId: data['txnid'],
      responseCode: data['responsecode'],
      approvalRefNo: data['approvalrefno'],
      transactionRefId: data['txnref'],
      status: PaymentStatus.fromString(statusStr),
      rawResponse: response,
    );
  }
}
