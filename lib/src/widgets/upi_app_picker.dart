import 'package:flutter/material.dart';
import '../models/upi_app_info.dart';

/// A beautiful bottom sheet widget that allows users to select from installed UPI apps.
class UpiAppPicker extends StatelessWidget {
  /// List of installed UPI apps to display.
  final List<UpiAppInfo> apps;

  /// Callback function when an app is selected.
  final Function(UpiAppInfo) onAppSelected;

  /// Title of the picker bottom sheet.
  final String title;

  /// Creates a [UpiAppPicker] instance.
  const UpiAppPicker({
    super.key,
    required this.apps,
    required this.onAppSelected,
    this.title = 'Select UPI App',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (apps.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('No UPI apps found')),
            )
          else
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onAppSelected(app);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: app.icon != null
                                ? Image.memory(app.icon!, fit: BoxFit.cover)
                                : const Icon(Icons.account_balance_wallet, size: 30),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          app.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Static helper to show the [UpiAppPicker] as a modal bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required List<UpiAppInfo> apps,
    required Function(UpiAppInfo) onAppSelected,
    String title = 'Pay with UPI',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UpiAppPicker(
        apps: apps,
        onAppSelected: onAppSelected,
        title: title,
      ),
    );
  }
}
