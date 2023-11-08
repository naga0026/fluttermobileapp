import 'package:flutter/services.dart';

class PriceFieldFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newString = '';
    if (newValue.text.contains('.')) {
      newString = newValue.text.replaceAll('.', '');
    } else {
      newString = newValue.text;
    }
    var newInt = int.parse(newString);
    var newDouble = newInt / 100;
    newString = newDouble.toStringAsFixed(2);
    return TextEditingValue(
        text: newString, selection: TextSelection.collapsed(offset: newString.length));
  }
}