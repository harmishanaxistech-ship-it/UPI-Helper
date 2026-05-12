/// Supported UPI applications for payment.
enum UpiApp {
  /// Google Pay application.
  googlePay,

  /// PhonePe application.
  phonePe,

  /// Paytm application.
  paytm,

  /// BHIM application.
  bhim,

  /// Amazon Pay application.
  amazonPay,

  /// Generic UPI intent handler.
  generic;

  /// Returns the Android package name for the specific UPI app.
  String get packageName {
    switch (this) {
      case UpiApp.googlePay:
        return 'com.google.android.apps.nbu.paisa.user';
      case UpiApp.phonePe:
        return 'com.phonepe.app';
      case UpiApp.paytm:
        return 'net.one97.paytm';
      case UpiApp.bhim:
        return 'in.org.npci.upiapp';
      case UpiApp.amazonPay:
        return 'in.amazon.mShop.android.shopping';
      case UpiApp.generic:
        return '';
    }
  }

  /// Returns the display name of the UPI app.
  String get appName {
    switch (this) {
      case UpiApp.googlePay:
        return 'Google Pay';
      case UpiApp.phonePe:
        return 'PhonePe';
      case UpiApp.paytm:
        return 'Paytm';
      case UpiApp.bhim:
        return 'BHIM';
      case UpiApp.amazonPay:
        return 'Amazon Pay';
      case UpiApp.generic:
        return 'UPI App';
    }
  }
}
