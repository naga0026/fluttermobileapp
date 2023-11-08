import 'dart:core';

class SgmInputScreenDataModel {

  SgmInputScreenDataModel({
    this.styleOrULine,
    this.currentPriceInBarcodeFormat,
    this.newPriceInBarcodeFormat,
    this.quantity,
    this.deptId,
    this.classOrCategoryId,
    this.isKeyed,
    this.newPriceInDisplayFormat
  });

  String? styleOrULine;
  String? currentPriceInBarcodeFormat;
  String? newPriceInBarcodeFormat;
  String? quantity;
  String? deptId;
  String? classOrCategoryId;
  bool? isKeyed;
  String? newPriceInDisplayFormat;
  String? currentPriceInDisplay;

}
