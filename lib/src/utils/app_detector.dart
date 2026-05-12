import '../core/upi_service.dart';
import '../models/upi_app_info.dart';

class UpiAppDetector {
  final UpiService _service = UpiService();

  Future<List<UpiAppInfo>> detectInstalledApps() async {
    return await _service.getInstalledApps();
  }
}
