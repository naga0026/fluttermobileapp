import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:flutter/material.dart';

extension SizeBox on int {
  Widget get heightBox {
    return SizedBox(height: toDouble());
  }

  Widget get widthBox {
    return SizedBox(width: toDouble());
  }

  bool get boolValue {
    return this == 1 ? true : false;
  }

  String get formattedPriceInStringToFixedTwoDecimal {
    return toString().formattedPriceInStringToFixedTwoDecimal;
  }

  String get priceInInt {
    return toString().priceInInt;
  }

  /// Prices are stored as integer value in database and we are taking last 2 digits as decimal points
  /// First, format the price as double and then round it to integer once done again make it as double with 2 fraction points
  /// Example, if the price is 935 that means the price is 9.35 but in our app price will either
  /// ends with 00 or 99 so rounding it will make a price as 9 but printing will required price to be in fraction points so again convert it to double will make it 9.00
  String get calculatedReKeyPrice {
    var priceInDoubleAndThenRound = double.parse(formattedPriceInStringToFixedTwoDecimal).round();
    return priceInDoubleAndThenRound.toDouble().toStringAsFixed(2).priceWithoutDot;
  }

  String toStringWithPadLeft(int leadingZeros){
    return toString().padLeft(leadingZeros, '0');
  }


}