# flutter_upi_helper

A production-ready Flutter package for handling UPI payments in India. Easily launch major UPI apps and handle payment responses with a clean and simple API.

## Features

- 🚀 **Launch UPI Apps**: Directly open specific UPI apps or show a chooser.
- 📱 **Supported Apps**: Google Pay, PhonePe, Paytm, BHIM, Amazon Pay, and generic UPI apps.
- 🔍 **App Detection**: Detect installed UPI apps on the device with their names and icons.
- 📝 **Payment Response**: Get detailed transaction responses (Transaction ID, Status, Ref No).
- 🎨 **Ready-to-use UI**: Includes a beautiful bottom-sheet app picker.
- 🛡️ **Error Handling**: Custom exceptions for app not installed, invalid parameters, etc.

## Installation

Add `flutter_upi_helper` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_upi_helper: ^1.0.0
```

## Android Setup

Add the following to your `AndroidManifest.xml` inside the `<manifest>` tag to support package visibility on Android 11+:

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.VIEW"/>
        <data android:scheme="upi"/>
    </intent>
</queries>
```

## Usage

### Simple Payment

```dart
import 'package:flutter_upi_helper/flutter_upi_helper.dart';

final response = await UpiHelper.pay(
  upiId: "merchant@upi",
  receiverName: "John Doe",
  amount: 100.0,
  note: "Payment for order",
);

if (response.status == PaymentStatus.success) {
  print("Payment Successful: ${response.transactionId}");
}
```

### Advanced API

```dart
final response = await UpiHelper.pay(
  upiId: "merchant@upi",
  receiverName: "John Doe",
  amount: 100.0,
  note: "Order Payment",
  app: UpiApp.googlePay,
  transactionRefId: "TXN12345",
);
```

### Detect Installed Apps

```dart
final List<UpiAppInfo> apps = await UpiHelper.getInstalledApps();
```

### Using App Picker UI

```dart
UpiAppPicker.show(
  context: context,
  apps: installedApps,
  onAppSelected: (appInfo) {
    // Initiate payment with selected app
  },
);
```

## Supported Apps

| App | Enum |
|-----|------|
| Google Pay | `UpiApp.googlePay` |
| PhonePe | `UpiApp.phonePe` |
| Paytm | `UpiApp.paytm` |
| BHIM | `UpiApp.bhim` |
| Amazon Pay | `UpiApp.amazonPay` |
| Generic | `UpiApp.generic` |

## Payment Status

- `success`: Payment completed successfully.
- `failed`: Payment failed.
- `cancelled`: User cancelled the payment.
- `submitted`: Payment submitted but pending confirmation.
- `unknown`: Status could not be determined.

## License

MIT
