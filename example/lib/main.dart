import 'package:flutter/material.dart';
import 'package:flutter_upi_helper/flutter_upi_helper.dart';

void main() {
  runApp(const MyApp());
}

/// Main application widget for the demo.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPI Helper Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UpiDemoPage(),
    );
  }
}

/// Home page for the UPI Helper demo.
class UpiDemoPage extends StatefulWidget {
  /// Creates a [UpiDemoPage] instance.
  const UpiDemoPage({super.key});

  @override
  State<UpiDemoPage> createState() => _UpiDemoPageState();
}

class _UpiDemoPageState extends State<UpiDemoPage> {
  final TextEditingController _upiIdController =
      TextEditingController(text: "googlepay-8@okaxis");
  final TextEditingController _nameController =
      TextEditingController(text: "Google");
  final TextEditingController _amountController =
      TextEditingController(text: "1.00");
  final TextEditingController _noteController =
      TextEditingController(text: "Test Payment");

  List<UpiAppInfo> _installedApps = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
  }

  Future<void> _loadInstalledApps() async {
    setState(() => _isLoading = true);
    try {
      final apps = await UpiHelper.getInstalledApps();
      setState(() {
        _installedApps = apps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading apps: $e')),
        );
      }
    }
  }

  Future<void> _initiatePayment(UpiAppInfo appInfo) async {
    try {
      final response = await UpiHelper.pay(
        upiId: _upiIdController.text,
        receiverName: _nameController.text,
        amount: double.tryParse(_amountController.text) ?? 0,
        note: _noteController.text,
        app: appInfo.app,
      );

      _showResultDialog(response);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showResultDialog(UpiPaymentResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          response.status == PaymentStatus.success ? 'Success' : 'Transaction Result',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${response.status.name.toUpperCase()}'),
            if (response.transactionId != null)
              Text('Txn ID: ${response.transactionId}'),
            if (response.approvalRefNo != null)
              Text('Ref No: ${response.approvalRefNo}'),
            const SizedBox(height: 10),
            const Text('Raw Response:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(response.rawResponse, style: const TextStyle(fontSize: 10)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI Helper Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInstalledApps,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _upiIdController,
                      decoration: const InputDecoration(labelText: 'UPI ID'),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Receiver Name'),
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Note'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Installed UPI Apps',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_installedApps.isEmpty)
              const Center(child: Text('No UPI apps found.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _installedApps.length,
                itemBuilder: (context, index) {
                  final app = _installedApps[index];
                  return ListTile(
                    leading: app.icon != null
                        ? Image.memory(app.icon!, width: 40, height: 40)
                        : const Icon(Icons.account_balance_wallet),
                    title: Text(app.name),
                    subtitle: Text(app.packageName),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _initiatePayment(app),
                  );
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                UpiAppPicker.show(
                  context: context,
                  apps: _installedApps,
                  onAppSelected: (app) => _initiatePayment(app),
                );
              },
              icon: const Icon(Icons.apps),
              label: const Text('Show App Picker Bottom Sheet'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
