import 'constants.dart';

class UpiUriBuilder {
  static Uri build({
    required String upiId,
    required String receiverName,
    required double amount,
    String? note,
    String? transactionRefId,
    String? merchantCode,
    String currency = 'INR',
  }) {
    final Map<String, String> queryParams = {
      UpiConstants.paramPa: upiId,
      UpiConstants.paramPn: receiverName,
      UpiConstants.paramAm: amount.toStringAsFixed(2),
      UpiConstants.paramCu: currency,
    };

    if (note != null && note.isNotEmpty) {
      queryParams[UpiConstants.paramTn] = note;
    }

    if (transactionRefId != null && transactionRefId.isNotEmpty) {
      queryParams[UpiConstants.paramTr] = transactionRefId;
    }

    if (merchantCode != null && merchantCode.isNotEmpty) {
      queryParams[UpiConstants.paramMc] = merchantCode;
    }

    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: queryParams,
    );
  }
}
