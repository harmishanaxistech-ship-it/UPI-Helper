import 'dart:typed_data';
import '../enums/upi_app.dart';

class UpiAppInfo {
  final String name;
  final String packageName;
  final Uint8List? icon;
  final UpiApp app;

  UpiAppInfo({
    required this.name,
    required this.packageName,
    this.icon,
    required this.app,
  });

  @override
  String toString() => 'UpiAppInfo(name: $name, packageName: $packageName, app: $app)';
}
