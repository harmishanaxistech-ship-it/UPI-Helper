import '../core/upi_service.dart';
import '../models/upi_app_info.dart';

/// Utility class to detect installed UPI applications.
class UpiAppDetector {
  final UpiService _service = UpiService();

  /// Returns a list of [UpiAppInfo] for all installed UPI apps.
  Future<List<UpiAppInfo>> detectInstalledApps() async {
    return await _service.getInstalledApps();
  }
}
