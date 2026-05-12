class UpiConstants {
  static const String upiScheme = 'upi://pay';
  
  // URL parameters for UPI URI
  static const String paramPa = 'pa'; // Payee Address (UPI ID)
  static const String paramPn = 'pn'; // Payee Name
  static const String paramMc = 'mc'; // Merchant Code
  static const String paramTr = 'tr'; // Transaction Reference ID
  static const String paramTn = 'tn'; // Transaction Note
  static const String paramAm = 'am'; // Amount
  static const String paramCu = 'cu'; // Currency
  static const String paramUrl = 'url'; // Transaction URL
}
