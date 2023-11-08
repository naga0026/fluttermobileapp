import 'package:base_project/controller/barcode/scanned_item_model.dart';
import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/model/sbo_field_model.dart';
import 'package:base_project/model/transfers/control_number_model.dart';
import 'package:base_project/services/navigation/navigation_service.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/constants/app/app_constants.dart';
import 'package:base_project/utility/enums/division_enum.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:get/get.dart';

class BarcodeInterpretController extends BaseViewController {
  final storeConfigController = Get.find<StoreConfigController>();

  ScanOrEnteredItemModel? interpretBarcode(String barcode) {
    DivisionEnum currentDiv =
        storeConfigController.selectedStoreDetails.value!.divisionEnum;
    int barcodeLength = barcode.length;
    if (currentDiv.validBarcodeLength.contains(barcodeLength)) {
      switch (barcodeLength) {
        case 20:
          // Marshalls US (10) Store generated, TJMaxx & HomeGoods/Homesense (08, 28)
          // First two digits are 12 for marshalls always
          var firstTwo = barcode.substring(0, 2);
          if (firstTwo == '12' && currentDiv == DivisionEnum.marshallsUsa) {
            return interpretMarshallsUS(barcode);
          } else {
            return interpretTJMaxxOrHomeGoodsOrHomeSense(barcode);
          }
        case 18:
          var dept = barcode.substring(0, 4);
          var uline = barcode.substring(4, 13);
          var price = barcode.substring(13, 18).addLeadingZeroLengthFive;
          return ScanOrEnteredItemModel(
              price: price,
              divisionId: "10",
              deptId: dept,
              priceInDecimal: price.formattedPrice,
              styleOrULine: uline);
        case 14:
          // Canada (04, 24) HangTag, Sticker and Shoe label/sign -Pre printed barcode
          return interpret14Digits(barcode);
        case 16:
          // Canada (04, 24) Markdown and PriceAdjust(Store generated interpretation), Europe (05, 55 both store generated, pre printed)
          return interpret16Digits(barcode);
        default:
          break;
      }
    } else {
      NavigationService.showToast(TranslationKey.invalidScanDivision.tr);
    }
    return null;
  }

  ScanOrEnteredItemModel interpretMarshallsUS(String barcode) {
    var dept = barcode.substring(2, 4);
    var uline = barcode.substring(4, 13);
    var price = barcode.substring(13, 18).addLeadingZeroLengthFive;
    var week = barcode.substring(18, 20);
    return ScanOrEnteredItemModel(
        price: price,
        divisionId: "10",
        deptId: dept,
        priceInDecimal: price.formattedPrice,
        styleOrULine: uline,
        week: int.parse(week));
  }

  ScanOrEnteredItemModel? interpretTJMaxxOrHomeGoodsOrHomeSense(
      String barcode) {
    String currentDiv =
        storeConfigController.selectedStoreDetails.value!.storeDivision;
    var division = barcode.substring(0, 2);
    if (currentDiv != division) {
      NavigationService.showToast(TranslationKey.invalidScanDivision.tr);
      return null;
    }
    if (division == "08" || division == "28") {
      var department = barcode.substring(2, 4);
      var category = barcode.substring(4, 6);
      var styleOrULine = barcode.substring(6, 12);
      var price = barcode.substring(12, 18);
      var week = barcode.substring(18, 20);
      return ScanOrEnteredItemModel(
          price: price,
          classOrCategoryId: category,
          divisionId: division,
          deptId: department,
          priceInDecimal: price.formattedPrice,
          styleOrULine: styleOrULine,
          week: int.parse(week));
    } else {
      NavigationService.showToast("Invalid Barcode.");
      return null;
    }
  }

  ScanOrEnteredItemModel interpret14Digits(String barcode) {
    var department = barcode.substring(0, 2);
    var styleOrULine = barcode.substring(2, 8);
    var price = barcode.substring(8, 14);
    return ScanOrEnteredItemModel(
        price: price,
        deptId: department,
        priceInDecimal: price.formattedPrice,
        styleOrULine: styleOrULine);
  }

  ScanOrEnteredItemModel interpret16Digits(String barcode) {
    var department = barcode.substring(0, 2);
    var category = barcode.substring(2, 4);
    var styleOrULine = barcode.substring(4, 10);
    var price = barcode.substring(10, 16);
    return ScanOrEnteredItemModel(
        price: price,
        classOrCategoryId: category,
        deptId: department,
        priceInDecimal: price.formattedPrice,
        styleOrULine: styleOrULine);
  }

  //region Add scanned barcode to the field's text editing controller

  // After interpretation length maybe correct but there is a possibility
  // of price does not match with the feature's requirement, for example if
  // we are scanning the barcode from markdowns then price should end with 99
  // and for subs 00. These requirement does not match show the invalid barcode toast message
  bool fillScannedBarcodeData(String barcode, List<SBOFieldModel> fields,
      {RegExp? regExpToValidatePrice}) {
    bool isBarcodeValid = true;
    if (barcode.isNotEmpty) {
      var detail = interpretBarcode(barcode.removeAllWhitespace);
      if (regExpToValidatePrice != null) {
        if (!regExpToValidatePrice.hasMatch(
            detail?.price?.formattedPriceInStringToFixedTwoDecimal ?? '0.00')) {
          NavigationService.showToast(TranslationKey.invalidBarcode.tr);
          isBarcodeValid = false;
          return isBarcodeValid;
        }
      }
      for (var element in fields) {
        switch (element.sboField) {
          case SBOField.department:
            element.textEditingController.text =
                detail?.deptId.toString() ?? '';
            break;
          case SBOField.style:
          case SBOField.uline:
            element.textEditingController.text =
                detail?.styleOrULine.toString() ?? '';
            break;
          case SBOField.price:
          case SBOField.currentPrice:
            element.textEditingController.text =
                detail?.priceInDecimal.toStringAsFixed(2) ?? '';
          default:
            break;
        }
      }
    }
    return isBarcodeValid;
  }

  ScanOrEnteredTransferReceivingItem? interpretTransfersReceivingBarcode(
      String barcode, List<SBOFieldModel> fields) {
    if (barcode.length == AppConstants.transfersBarcodeLength) {
      // First 12 control number, 4 store number, 4 item count
      var controlNumber = barcode.substring(0, 12);
      var storeNumber = barcode.substring(12, 16);
      var itemCount = barcode.substring(16, 20);
      for (var element in fields) {
        switch (element.sboField) {
          case SBOField.controlNumber:
            element.textEditingController.text = controlNumber;
            break;
          case SBOField.storeNumber:
            element.textEditingController.text = storeNumber;
            break;
          case SBOField.itemCount:
            element.textEditingController.text = int.parse(itemCount).toString();
            break;
          default:
            break;
        }
      }
      return ScanOrEnteredTransferReceivingItem(
          controlNumber: controlNumber,
          receivingStoreNumber: storeNumber,
          itemCount: itemCount);
    } else {
      NavigationService.showToast(TranslationKey.invalidBarcode.tr);
      return null;
    }
  }

  ControlNumberModel? interpretControlNumberBarcode(String barcode) {
    // divisionLength = 2; shippingStoreLength = 4; boxSequenceNumberLength = 6;
    if (barcode.length == AppConstants.transfersControlNumberLength) {
      int division = int.tryParse(barcode.substring(0, 2)) ?? 0;
      int shippingStoreNumber = int.tryParse(barcode.substring(2, 6)) ?? 0;
      int boxSequenceNumber = int.tryParse(barcode.substring(6)) ?? 0;
      return ControlNumberModel(
          receivingDivision: division,
          shippingStoreNumber: shippingStoreNumber,
          boxSequenceNumber: boxSequenceNumber);
    } else {
      NavigationService.showToast(TranslationKey.invalidControlNumber.tr);
      return null;
    }
  }
}
