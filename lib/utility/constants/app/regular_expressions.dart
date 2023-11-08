
class RegularExpressions {

  static final RegExp initialPriceEnding99 = RegExp(r'^[0-9]+\.(99)$');
  static final RegExp ipAddressPattern = RegExp(r'^http:\/\/(([01]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.){3}([01]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$');
  static final RegExp leadingZeroRegExp = RegExp(r'^0+(?=.)');
  static final RegExp printerIpRexExp = RegExp(r'^((?:[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])[.]){3}(?:[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$');
}