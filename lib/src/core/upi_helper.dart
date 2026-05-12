import '../enums/upi_app.dart';
import '../models/upi_app_info.dart';
import '../models/upi_payment_response.dart';
import 'upi_service.dart';
import 'uri_builder.dart';
import '../exceptions/upi_exception.dart';

/// Main entry point for the UPI Helper package.
/// 
/// Provides methods to detect installed UPI apps and initiate payments.
class UpiHelper {
  static final UpiService _service = UpiService();

  /// Returns a list of installed UPI apps on the device.
  static Future<List<UpiAppInfo>> getInstalledApps() async {
    return await _service.getInstalledApps();
  }

  /// Initiates a UPI payment.
  /// 
  /// [upiId] - The receiver's UPI ID (e.g. merchant@upi).
  /// [receiverName] - The name of the receiver.
  /// [amount] - The amount to pay.
  /// [note] - An optional note for the payment.
  /// [app] - The specific UPI app to use. If null, a chooser will be shown on Android.
  /// [transactionRefId] - A unique reference ID for the transaction.
  /// [merchantCode] - Optional merchant code.
  static Future<UpiPaymentResponse> pay({
    required String upiId,
    required String receiverName,
    required double amount,
    String? note,
    UpiApp? app,
    String? transactionRefId,
    String? merchantCode,
  }) async {
    if (upiId.isEmpty || !upiId.contains('@')) {
      throw UpiInvalidParamsException('Invalid UPI ID');
    }
    if (amount <= 0) {
      throw UpiInvalidParamsException('Amount must be greater than zero');
    }

    final uri = UpiUriBuilder.build(
      upiId: upiId,
      receiverName: receiverName,
      amount: amount,
      note: note,
      transactionRefId: transactionRefId,
      merchantCode: merchantCode,
    );

    return await _service.launchPayment(uri: uri, app: app);
  }
}
