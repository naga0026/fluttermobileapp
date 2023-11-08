import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/store_config/store_config_controller.dart';
import '../constants/app/date_format.dart';
import '../constants/app/regular_expressions.dart';

extension StringExtension on String {

  // If the length is not six add leading zeros
  String get addLeadingZero {
    return padLeft(6, "0");
  }

  String get makeFourDigitStoreNumber {
    return padLeft(4,"0");
  }

  String get addLeadingZeroLengthFive {
    return padLeft(5, "0");
  }

  /* Maximum length of the price is 6 digits throughout the project
  First four digits are dollars and last two are cents
  we are formatting the price with this logic and converting it to a double value
   */

  String get priceWithoutDot {
    String priceInString = this;
    if(contains('.')){
      priceInString = replaceAll('.', '');
    }
    return priceInString;
  }

  double get formattedPrice {
    // final storeConfigController = Get.find<StoreConfigController>();
    // if(storeConfigController.isMarshallsUSA()){
    //   return length < 6 ? formatPriceFiveDigit : formatPriceSixDigit;
    // } else {
    //   return formatPriceSixDigit;
    // }
    var priceWithoutLeadingZero = priceWithoutDot;
    priceWithoutLeadingZero = int.parse(priceWithoutLeadingZero).toString();
    var decimalStartPoint = (priceWithoutLeadingZero.length) - 2;
    if(decimalStartPoint.isNegative){
      return 0.00;
    }
    var endPoint = priceWithoutLeadingZero.length;
    var decimalPoints = priceWithoutLeadingZero.substring(decimalStartPoint,endPoint);
    var value = priceWithoutLeadingZero.substring(0, decimalStartPoint);
    var newPrice = '$value.$decimalPoints';
    var price = double.parse(newPrice);
    return price.toPrecision(2);
  }

  String get formattedPriceInStringToFixedTwoDecimal {
    return formattedPrice.toStringAsFixed(2);
  }

  String get formattedPriceInStringWithCurrency {
    final storeConfigController = Get.find<StoreConfigController>();
    return storeConfigController.getCurrencySymbol() + formattedPrice.toStringAsFixed(2);
  }

  String get priceInInt {
    final storeConfigController = Get.find<StoreConfigController>();
    if(storeConfigController.isMarshallsUSA()){
      return length < 6 ? addLeadingZeroLengthFive : addLeadingZero ;
    } else {
      return addLeadingZero;
    }
  }

  String get decimalPoints {
    return split('.').toList().last;
  }

  /// Last three digits of the local IP address of device for passing to printer assign
  String get stationID {
    return split('.').last;
  }

  // Removes leading zero from ip address, for api call to add printer it is necessary
  // to remove leading zeros else it will throw the error
  String get printerIPWithoutLeadingZero {
    String resultIp = '';
    List<String> ipDigits = split('.');
    for (String s in ipDigits) {
      var replaced = s.replaceAll(RegularExpressions.leadingZeroRegExp, '');
      resultIp = resultIp.isNotEmpty ? '$resultIp.$replaced' : replaced;
    }
    return resultIp;
  }

  List<String> get ipAddressThreeDigits {
    var ipSeparatedList = List<String>.filled(4, '');
    ipSeparatedList = split('.');
    var newList = ipSeparatedList.map((e) => e.leadingZeroForIP).toList();
    return newList;
  }

  String get leadingZeroForIP {
    return padLeft(3, "0");
  }

  DateTime get date {
    return DateFormat(DateFormatConstants.printerResponseDateFormat)
        .parse(this);
  }

  String addCommaIfNotEmpty() {
    if(isNotEmpty){
      return "$this, ";
    }
    return '';
  }

}

extension StringEncoderBase64 on String {
  String get toBase64 {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(this);
    return encoded;
  }
}