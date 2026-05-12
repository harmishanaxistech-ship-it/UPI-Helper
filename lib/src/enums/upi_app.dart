enum UpiApp {
  googlePay,
  phonePe,
  paytm,
  bhim,
  amazonPay,
  generic;

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
