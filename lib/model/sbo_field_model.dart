import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utility/price_formatter/price_formatter.dart';

enum SBOField {
  department,
  category,
  sgmCategory,
  style,
  currentPrice,
  newPrice,
  quantity,
  uline,
  ticketPrice,
  price,
  compareAt,
  line1,
  line2,
  ourPrice,
  returnPrice,
  origPrice,
  classSubs,
  storeNumber,
  controlNumber,
  itemCount
}

extension Values on SBOField {
  String get title {
    switch (this) {
      case SBOField.category:
        return "Category";
      case SBOField.sgmCategory:
        return "Category";
      case SBOField.department:
        return "Department";
      case SBOField.style:
        return "Style";
      case SBOField.currentPrice:
        return "Current Price";
      case SBOField.newPrice:
        return "New Price";
      case SBOField.quantity:
        return "Quantity";
      case SBOField.uline:
        return "Uline";
      case SBOField.ticketPrice:
        return 'TKT Price';
      case SBOField.price:
        return 'Price';
      case SBOField.compareAt:
        return 'CompareAt';
      case SBOField.line1:
        return 'Line 1';
      case SBOField.line2:
        return 'Line 2';
      case SBOField.ourPrice:
        return 'Our Price';
        case SBOField.returnPrice:
        return "Return Price";
       case SBOField.origPrice:
        return "Orig Price";
      case SBOField.classSubs:
        return "Class";
      case SBOField.storeNumber:
        return 'Store Number';
      case SBOField.controlNumber:
        return 'Control Number';
      case SBOField.itemCount:
        return 'Item Count';
    }
  }

  String get hint {
    switch (this) {
      case SBOField.category:
        return "Enter category id.";
      case SBOField.sgmCategory:
        return "Enter category id.";
      case SBOField.department:
        return "Enter department id.";
      case SBOField.style:
        return "Enter style id.";
      case SBOField.currentPrice:
        return "Enter current price.";
      case SBOField.newPrice:
        return "Enter new price.";
      case SBOField.quantity:
        return "1";
      case SBOField.uline:
        return "Enter Uline.";
      case SBOField.ticketPrice:
        return 'Enter ticket price.';
      case SBOField.price:
        return 'Enter price.';
      case SBOField.compareAt:
        return 'Enter compareAt';
      case SBOField.line1:
        return 'Enter Line 1';
      case SBOField.line2:
        return 'Enter Line 2';
      case SBOField.ourPrice:
        return 'Enter Our Price';
      case SBOField.returnPrice:
        return 'Enter return price.';
      case SBOField.origPrice:
        return 'Enter orig price.';
      case SBOField.classSubs:
        return "Enter Class";
      case SBOField.storeNumber:
        return 'Enter Store Number';
      case SBOField.controlNumber:
        return 'Enter Control Number';
      case SBOField.itemCount:
        return 'Enter counts';
    }
  }

  int get maxLength {
    var storeConfigController = Get.find<StoreConfigController>();
    switch (this) {
      case SBOField.category:
        return 4;
      case SBOField.sgmCategory:
        return 4;
      case SBOField.department:
        return storeConfigController.isMarshallsUSA() ? 4 : 2;
      case SBOField.style:
        return 6;
      case SBOField.currentPrice:
        return 7;
      case SBOField.newPrice:
        return 7;
      case SBOField.quantity:
        return 2;
      case SBOField.uline:
        return 9;
      case SBOField.ticketPrice:
        return 7;
      case SBOField.price:
        return 7;
      case SBOField.compareAt:
        return 7;
      case SBOField.line1:
        return 25;
      case SBOField.line2:
        return 25;
      case SBOField.ourPrice:
        return 7;
      case SBOField.returnPrice:
        return 7;
      case SBOField.origPrice:
        return 7;
      case SBOField.classSubs:
        return 2;
      case SBOField.storeNumber:
        return 4;
      case SBOField.controlNumber:
        return 12;
      case SBOField.itemCount:
        return 3;
      default:
        return 0;
    }
  }

  TextInputType get keyBoardType {
    switch (this) {
      case SBOField.line1:
      case SBOField.line2:
        return TextInputType.text;
      default:
        return TextInputType.number;
    }
  }

  List<TextInputFormatter>? get formatters {
    switch (this) {
      case SBOField.department:
      case SBOField.category:
      case SBOField.sgmCategory:
      case SBOField.style:
      case SBOField.uline:
      case SBOField.classSubs:
      case SBOField.storeNumber:
      case SBOField.controlNumber:
        return [FilteringTextInputFormatter.digitsOnly];
      case SBOField.currentPrice:
      case SBOField.ticketPrice:
      case SBOField.ourPrice:
      case SBOField.newPrice:
      case SBOField.compareAt:
      case SBOField.price:
        return [PriceFieldFormatter()];
      default:
        null;
    }
    return null;
  }

  String get errorMessage {
    var storeConfigController = Get.find<StoreConfigController>();
    switch (this) {
      case SBOField.department:
        return 'Department id should be of ${storeConfigController.isMarshallsUSA() ? "2 or 4" : "2"} digits.';
      case SBOField.category:
        return 'Category id should be of 2 or 4 digits.';
      case SBOField.sgmCategory:
        return 'Category id should be 4 digits.';
      case SBOField.style:
        return 'Please enter valid Style.';
      case SBOField.uline:
        return 'Please enter valid Uline.';
      case SBOField.line1:
        return 'Please enter valid Line 1.';
      case SBOField.line2:
        return 'Please enter valid Line 2.';
      case SBOField.currentPrice:
      case SBOField.newPrice:
      case SBOField.ticketPrice:
      case SBOField.compareAt:
      case SBOField.price:
      case SBOField.ourPrice:
      case SBOField.returnPrice:
      case SBOField.origPrice:
        return 'Please enter valid price.';
      case SBOField.quantity:
        return 'Quantity should be less than or equal to 20.';
      case SBOField.classSubs:
        return 'Please enter valid class. ';
      case SBOField.controlNumber:
        return 'Please Enter Valid Control Number';
      case SBOField.storeNumber:
        return 'Store Number Should be of 2 or 4 digit';
      case SBOField.itemCount:
        return 'Please enter valid count';
    }
  }
}

class SBOFieldModel {
  SBOField sboField;
  TextEditingController textEditingController;
  FocusNode? focusNode;

  SBOFieldModel(
      {required this.sboField,
      required this.textEditingController,
      this.focusNode});
}
