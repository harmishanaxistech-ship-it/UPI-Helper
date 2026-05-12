import 'package:flutter/services.dart';
import '../enums/payment_status.dart';
import '../enums/upi_app.dart';
import '../models/upi_app_info.dart';
import '../models/upi_payment_response.dart';
import '../utils/response_parser.dart';
import '../exceptions/upi_exception.dart';

/// Internal service class to communicate with platform-specific code.
class UpiService {
  static const MethodChannel _channel = MethodChannel('flutter_upi_helper');

  /// Fetches the list of installed UPI apps from the platform.
  Future<List<UpiAppInfo>> getInstalledApps() async {
    try {
      final List<dynamic>? apps = await _channel.invokeMethod('getInstalledApps');
      if (apps == null) return [];

      return apps.map((app) {
        final map = Map<String, dynamic>.from(app);
        final packageName = map['packageName'] as String;
        
        UpiApp upiApp = UpiApp.generic;
        for (var value in UpiApp.values) {
          if (value.packageName == packageName) {
            upiApp = value;
            break;
          }
        }

        return UpiAppInfo(
          name: map['name'] as String,
          packageName: packageName,
          icon: map['icon'] as Uint8List?,
          app: upiApp,
        );
      }).toList();
    } on PlatformException catch (e) {
      throw UpiException(e.message ?? 'Failed to get installed apps', code: e.code);
    }
  }

  /// Launches the payment intent with the given [uri] and optional [app].
  Future<UpiPaymentResponse> launchPayment({
    required Uri uri,
    UpiApp? app,
  }) async {
    try {
      final String? response = await _channel.invokeMethod('launchPayment', {
        'uri': uri.toString(),
        'packageName': app?.packageName,
      });

      if (response == null) {
        return UpiPaymentResponse(
          status: PaymentStatus.unknown,
          rawResponse: 'No response from UPI app',
        );
      }

      return UpiResponseParser.parse(response);
    } on PlatformException catch (e) {
      if (e.code == 'APP_NOT_INSTALLED') {
        throw UpiAppNotInstalledException(app?.appName ?? 'Requested app');
      }
      throw UpiException(e.message ?? 'Payment failed', code: e.code);
    }
  }
}
