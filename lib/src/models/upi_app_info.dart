import 'dart:typed_data';
import '../enums/upi_app.dart';

/// Information about an installed UPI application.
class UpiAppInfo {
  /// The display name of the app.
  final String name;

  /// The Android package name of the app.
  final String packageName;

  /// The raw bytes of the app icon (usually PNG).
  final Uint8List? icon;

  /// The mapped [UpiApp] enum for this application.
  final UpiApp app;

  /// Creates a new [UpiAppInfo] instance.
  UpiAppInfo({
    required this.name,
    required this.packageName,
    this.icon,
    required this.app,
  });

  @override
  String toString() => 'UpiAppInfo(name: $name, packageName: $packageName, app: $app)';
}
