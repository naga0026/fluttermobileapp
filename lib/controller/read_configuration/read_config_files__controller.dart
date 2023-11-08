import 'dart:io';
import 'package:base_project/model/app_base_url/app_base_url.dart';
import 'package:base_project/model/app_setting/app_setting.dart';
import 'package:base_project/model/app_setting/zpl_setting.dart';
import 'package:get/get.dart';
import '../../model/fiscal_week_model.dart';
import '../../model/label_definition/label_definitions.dart';
import '../../model/label_definition/printer_label_definition.dart';
import '../../model/price_threshold_model.dart';
import '../../model/printer_price_validator_model.dart';
import '../../model/transfers/damged_jewelry_json_model.dart';
import '../../services/config/config_service.dart';
import '../../utility/constants/app/config_file_constants.dart';
import '../initial_view_controller.dart';

class ReadConfigFileController extends GetxController {
  @override
  void onInit() async {
    await ConfigService().getConfigFolderPath();
    setDataToModels();
    super.onInit();
  }

  final initialController = Get.find<InitialController>();

  AppSettings? appSettings;
  AppBaseURL? appBaseURL;
  ZplSettings? zplSettings;
  List<DamagedJeweleryModel>? damagedJeweleryModel;
  PriceValidationParameters? priceValidationParameters;
  List<FiscalWeekDefinition>? fiscalWeekDefinition;
  List<PriceThresholdParameters>? priceThresholdParameters;
  LabelDefinitions labelDefinitions = LabelDefinitions();

  String? getBaseurl() {
    if (initialController.isRemoteEnabled.value && appBaseURL != null) {
      return appBaseURL!.apiBaseUrl;
    } else {
      if (appBaseURL != null && appBaseURL!.ipAddress != null) {
        return appBaseURL!.ipAddress;
      }
    }
    return null;
  }

  readFile(String fileName) {
    String? path = ConfigService.universalFolderName;
    String filePath = path! + fileName;
    if (checkFileExist(filePath)) {
      var data = File(filePath).readAsStringSync();
      return data.replaceAll('\\', '');
    }
  }

  checkFileExist(String filePath) {
    if (File(filePath).existsSync()) {
      return true;
    }
    return false;
  }

  readAllFileData(String fileName) async {
    String? path = ConfigService.universalFolderName;
    if (path != null) {
      final readData = await readFile(fileName);
      return (readData, true);
    }
    return (null, false);
  }

  readSingleFileWithName(String fileName) async {
    var (data, status) = await readAllFileData(fileName);
    if (status) {
      switch (fileName) {
        case ConfigurationFileNames.appSettingsFile:
          appSettings = appSettingsFromJson(data);
          break;
        case ConfigurationFileNames.apiBaseUrlParameterFile:
          appBaseURL = appBaseURLFromJson(data);
        case ConfigurationFileNames.zplSettingsFile:
          zplSettings = zplSettingsFromJson(data);
        case ConfigurationFileNames.priceValidationParametersFile:
          priceValidationParameters = priceValidationParametersFromJson(data);
        case ConfigurationFileNames.maintenanceZplFile:
          var labels = printerLabelDefinitionsFromJson(data);
          labelDefinitions.maintenance = labels;
        case ConfigurationFileNames.markdownZplFile:
          var labels = printerLabelDefinitionsFromJson(data);
          labelDefinitions.markdown = labels;
        case ConfigurationFileNames.sgmZplFile:
          var labels = printerLabelDefinitionsFromJson(data);
          labelDefinitions.sgm = labels;
        case ConfigurationFileNames.transferZplFile:
          var labels = printerLabelDefinitionsFromJson(data);
          labelDefinitions.transfers = labels;
        case ConfigurationFileNames.ticketMakerZplFile:
          var labels = printerLabelDefinitionsFromJson(data);
          labelDefinitions.ticketMaker = labels;
        case ConfigurationFileNames.fiscalWeekConversionFile:
          fiscalWeekDefinition = fiscalWeekDefinitionFromJson(data);
        case ConfigurationFileNames.recallTrackingZplFile:
          var labels = printerLabelDefinitionsFromJson(data);
          labelDefinitions.recall = labels;
        case ConfigurationFileNames.priceThresholdParametersFile:
          priceThresholdParameters = priceThresholdParametersFromJson(data);
        case ConfigurationFileNames.damagedJewelryJsonModel:
          damagedJeweleryModel = damagedJeweleryModelFromJson(data);
      }
    }
  }

  Future<void> setDataToModels() async {
    final fileNameList = [
      ConfigurationFileNames.appSettingsFile,
      ConfigurationFileNames.apiBaseUrlParameterFile,
      ConfigurationFileNames.zplSettingsFile,
      ConfigurationFileNames.priceValidationParametersFile,
      ConfigurationFileNames.maintenanceZplFile,
      ConfigurationFileNames.markdownZplFile,
      ConfigurationFileNames.sgmZplFile,
      ConfigurationFileNames.transferZplFile,
      ConfigurationFileNames.ticketMakerZplFile,
      ConfigurationFileNames.recallTrackingZplFile,
      ConfigurationFileNames.priceThresholdParametersFile,
      ConfigurationFileNames.fiscalWeekConversionFile,
      ConfigurationFileNames.damagedJewelryJsonModel,
    ];
    for (String fileName in fileNameList) {
      var (data, status) = await readAllFileData(fileName);
      if (status) {
        switch (fileName) {
          case ConfigurationFileNames.appSettingsFile:
            appSettings = appSettingsFromJson(data);
            break;
          case ConfigurationFileNames.apiBaseUrlParameterFile:
            appBaseURL = appBaseURLFromJson(data);
          case ConfigurationFileNames.zplSettingsFile:
            zplSettings = zplSettingsFromJson(data);
          case ConfigurationFileNames.priceValidationParametersFile:
            priceValidationParameters = priceValidationParametersFromJson(data);
          case ConfigurationFileNames.maintenanceZplFile:
            var labels = printerLabelDefinitionsFromJson(data);
            labelDefinitions.maintenance = labels;
          case ConfigurationFileNames.markdownZplFile:
            var labels = printerLabelDefinitionsFromJson(data);
            labelDefinitions.markdown = labels;
          case ConfigurationFileNames.sgmZplFile:
            var labels = printerLabelDefinitionsFromJson(data);
            labelDefinitions.sgm = labels;
          case ConfigurationFileNames.transferZplFile:
            var labels = printerLabelDefinitionsFromJson(data);
            labelDefinitions.transfers = labels;
          case ConfigurationFileNames.ticketMakerZplFile:
            var labels = printerLabelDefinitionsFromJson(data);
            labelDefinitions.ticketMaker = labels;
          case ConfigurationFileNames.fiscalWeekConversionFile:
            fiscalWeekDefinition = fiscalWeekDefinitionFromJson(data);
          case ConfigurationFileNames.recallTrackingZplFile:
            var labels = printerLabelDefinitionsFromJson(data);
            labelDefinitions.recall = labels;
          case ConfigurationFileNames.priceThresholdParametersFile:
            priceThresholdParameters = priceThresholdParametersFromJson(data);
          case ConfigurationFileNames.damagedJewelryJsonModel:
            damagedJeweleryModel = damagedJeweleryModelFromJson(data);
        }
      }
    }
  }
}
