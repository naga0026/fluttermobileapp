import 'package:base_project/controller/validation/style_range_validation_controller.dart';
import 'package:base_project/model/printer_price_validator_model.dart';
import 'package:base_project/services/caching/caching_service.dart';
import 'package:base_project/utility/constants/app/app_constants.dart';
import 'package:base_project/utility/enums/pricetype_enums.dart';
import 'package:base_project/utility/enums/style_type_enum.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';

import '../../model/sbo_field_model.dart';
import '../../services/database/database_service.dart';
import '../../services/navigation/navigation_service.dart';
import '../../utility/constants/app/table_names.dart';
import '../../utility/enums/app_name_enum.dart';
import '../../utility/enums/departmentStatus_enum.dart';
import '../base/base_view_controller.dart';
import '../read_configuration/read_config_files__controller.dart';
import '../store_config/store_config_controller.dart';

class ValidationController extends BaseViewController {
  final cachingService = Get.find<CachingService>();
  final databaseService = Get.find<DatabaseService>();
  final readConfigFileController = Get.find<ReadConfigFileController>();
  final storeConfigController = Get.find<StoreConfigController>();
  final styleRangeValidationController =
      Get.put<StyleRangeValidationController>(StyleRangeValidationController());
  final logger = LoggerConfig.initLog();

  List<List<int>> checkDigitMap = [
    [6, 7],
    [6, 8],
    [7, 6],
    [4, 8],
    [3, 9],
    [9, 0],
    [1, 7],
    [2, 6],
    [0, 3],
    [4, 2],
  ];

  Future<(bool, DeptValidEnum)> validateDepartment(String dept) async {
    try {
      if (dept.length == 4 && dept.substring(0, 2) == "12" ||
          dept.length == 2) {
        String code = dept.length == 4 ? dept.substring(2) : dept;

        final data = await databaseService.selectQuery(
            tableName: TableNames.departmentItemTable,
            queryParams: {
              "code": "\'$code\'",
              "division": "\'${storeConfigController.selectedDivision}\'",
              "requestingDivision":
                  "\'${storeConfigController.selectedDivision}\'",
            });

        if (data != null) {
          return (true, DeptValidEnum.found);
        }
      }
      return (false, DeptValidEnum.deptInvalid);
    } catch (e) {
      return (false, DeptValidEnum.notFound);
    }
  }

  PriceTypeEnum getPriceType(String value) {
    if (validatePrice(value, PriceTypeEnum.initial)) {
      return PriceTypeEnum.initial;
    }
    if (validatePrice(value, PriceTypeEnum.subs)) {
      return PriceTypeEnum.subs;
    }
    return PriceTypeEnum.invalid;
  }

  bool validateStyle(String style) {
    const int numOfExtraCheckDigits = 2;
    bool isValid = false;
    if (style.trim().isNotEmpty == true &&
        RegExp(r'^[0-9]+$').hasMatch(style) &&
        int.tryParse(style) != null &&
        int.parse(style) != 0) {
      var checkDigit = int.parse(style.substring(style.length - 1));
      var styleDigits = style.split('').map(int.parse).toList();
      var index = 0;
      var digitFactor = styleDigits[index++] * 9;
      digitFactor += styleDigits[index++] * 1;
      digitFactor += styleDigits[index++] * 3;
      digitFactor += styleDigits[index++] * 5;
      digitFactor += styleDigits[index] * 7;
      digitFactor = 11 - digitFactor % 11;
      if (digitFactor != 10) {
        var checkDigitArray = List<int>.filled(numOfExtraCheckDigits + 1, 0);
        digitFactor = digitFactor % 11;
        checkDigitArray[0] = digitFactor;
        for (int i = 0; i < numOfExtraCheckDigits; ++i) {
          checkDigitArray[i + 1] = checkDigitMap[digitFactor][i];
        }
        isValid = checkDigitArray.any((digit) => digit == checkDigit);
      }
    }
    return isValid;
  }

  bool validateUline(String uline) {
    bool isValid = false;

    if (uline.isNotEmpty == true &&
        uline.length == 9 &&
        uline != AppConstants.invalidUline &&
        uline.split('').every((c) => c.isNum)) {
      var multiplier = [7, 9, 1, 3, 7, 9, 1, 3];
      var sum = 0;

      for (int i = 0; i < uline.length - 1; i++) {
        sum += multiplier[i] * int.parse(uline.substring(i, i + 1));
      }

      sum = 10 - (sum % 10);

      if (sum == 10) {
        sum = 0;
      }

      isValid = sum == int.parse(uline.substring(uline.length - 1));
    }

    return isValid;
  }

  validateCategory(String text) {
    return true;
  }

  bool validatePrice(String price, PriceTypeEnum priceType) {
    final priceValidatorData =
        readConfigFileController.priceValidationParameters;
    Iterable<ValidPrice> priceObject = priceValidatorData!.validPrices.where(
        (element) =>
            element.divisionCode == storeConfigController.selectedDivision);
    final initial = priceObject.first.initial.length > 1
        ? price.endsWith(priceObject.first.initial.first) ||
            price.endsWith(priceObject.first.initial[1])
        : price.endsWith(priceObject.first.initial.first);
    final subs = priceObject.first.sub.length > 1
        ? price.endsWith(priceObject.first.sub.first) ||
            price.endsWith(priceObject.first.sub[1])
        : price.endsWith(priceObject.first.sub.first);

    return priceType == PriceTypeEnum.subs
        ? subs
        : priceType == PriceTypeEnum.initial
            ? initial
            : initial || subs;
  }

  bool validateStyleULine(String styleOrULine) {
    return storeConfigController.styleTypeForStore.value == StyleTypeEnum.uline
        ? validateUline(styleOrULine)
        : validateStyle(styleOrULine);
  }

  /// This function takes array of the fields while are of type SBOFieldModel
  /// Depending on the screen requirements pass the array of your fields
  /// it will iterate through the fields and checks for validation
  /// Use this instead of manually adding the same code in controllers
  Future<bool> validateGivenFields(List<SBOFieldModel> arrayOfFields,
      {PriceTypeEnum priceTypeEnum = PriceTypeEnum.initial,
      AppNameEnum? appName}) async {
    Map<SBOField, bool> validationStatus = {};
    bool isStyleRangeValidationField =
        appName == AppNameEnum.markdowns || appName == AppNameEnum.sgm;
    var departmentEntered = '';
    for (var markdownField in arrayOfFields) {
      bool isProceedFurther = false;
      // For department proceed without length validation
      if (markdownField.textEditingController.text.isNotEmpty &&
          (markdownField.sboField == SBOField.department)) {
        isProceedFurther = true;
      } else if (markdownField.sboField == SBOField.price ||
          markdownField.sboField == SBOField.newPrice ||
          markdownField.sboField == SBOField.ticketPrice ||
          markdownField.sboField == SBOField.ourPrice) {
        isProceedFurther = markdownField.textEditingController.text.length <=
            markdownField.sboField.maxLength;
      } else {
        isProceedFurther = markdownField.textEditingController.text.length ==
            markdownField.sboField.maxLength;
      }

      if (isProceedFurther) {
        var textEnteredInGivenField = markdownField.textEditingController.text;
        switch (markdownField.sboField) {
          case SBOField.department:
            departmentEntered = textEnteredInGivenField;
            var (status, deptValidation) = await validateDepartment(
                markdownField.textEditingController.text);
            if (deptValidation == DeptValidEnum.deptInvalid ||
                deptValidation == DeptValidEnum.notFound && !status) {
              validationStatus[markdownField.sboField] = false;
            }
          case SBOField.style:
            bool isValidStyle = isStyleRangeValidationField
                ? await validateWithStyleRanges(
                    textEnteredInGivenField, departmentEntered)
                : validateStyleULine(textEnteredInGivenField);
            validationStatus[markdownField.sboField] = textEnteredInGivenField
                        .length !=
                    markdownField.sboField.maxLength
                ? false
                : isValidStyle; //validateStyle(markdownField.textEditingController.text);
          case SBOField.uline:
            validationStatus[markdownField.sboField] =
                textEnteredInGivenField.length !=
                        markdownField.sboField.maxLength
                    ? false
                    : validateUline(textEnteredInGivenField);
          case SBOField.price:
            validationStatus[markdownField.sboField] =
                validatePrice(textEnteredInGivenField, priceTypeEnum);
          case SBOField.controlNumber:
          case SBOField.storeNumber:
            validationStatus[markdownField.sboField] =
                textEnteredInGivenField.length ==
                    markdownField.sboField.maxLength;
          case SBOField.itemCount:
            validationStatus[markdownField.sboField] =
                int.parse(textEnteredInGivenField) <=
                    (readConfigFileController
                        .appSettings?.transfers.maxNumberOfItemsInBox ?? 999);
          default:
            break;
        }
      }
    }
    List failedValidation = [];
    validationStatus.forEach((key, value) {
      logger.i(validationStatus.toString());
      if (!value) {
        failedValidation.add(key.name);
      }
    });
    logger.i("calling");
    if (failedValidation.isNotEmpty) {
      NavigationService.showToast(
          "The Following Inputs are Invalid, ${failedValidation.toString().replaceAll("[", "").replaceAll("]", "")}");
      return false;
    }
    return true;
  }

  Future<bool> validateWithStyleRanges(
      String styleUline, String departmentCode) async {
    var isStyleValidated = validateStyleULine(styleUline);
    if (!isStyleValidated) {
      logger.d("Validate style range false");
      return false;
    }

    var isStyleRangeSupported =
        styleRangeValidationController.isStyleRangeSupported();
    if (!isStyleRangeSupported) {
      logger.d("Validate style range: true");
      return true;
    }

    var isStyleRangeValidated = await styleRangeValidationController
        .validateStyleRangeStyle(style: styleUline, department: departmentCode);

    logger.d("Validate style range result: $isStyleRangeValidated");
    return isStyleRangeValidated;
  }
}
