import 'package:base_project/model/store_config/tjx_divisions.dart';
import 'package:get/get.dart';

import '../../controller/read_configuration/read_config_files__controller.dart';
import '../../controller/store_config/store_config_controller.dart';
import '../../utility/enums/separator_type.dart';
import '../../utility/enums/stock_type.dart';
import '../base/base_service.dart';

class StockTypeService extends BaseService {
  final _configFilesController = Get.find<ReadConfigFileController>();
  final _storeConfig = Get.find<StoreConfigController>();

  bool isShoeStore = false;

  static const defaultStocks = [
    StockTypeEnum.markdown,
    StockTypeEnum.hangTag,
    StockTypeEnum.priceAdjust,
    StockTypeEnum.stickers,
    StockTypeEnum.transfers
  ];

  List<StockTypeEnum> selectValidStockTypes() {
    var list = <StockTypeEnum>[];
    list.addAll(defaultStocks);
    if (isShoeStore) {
      if (!list.contains(StockTypeEnum.shoes)) {
        list.add(StockTypeEnum.shoes);
      }
    }
    return list;
  }

  /// Checks for the division and updates the available stocks array
  List<StockTypeEnum> updateStockTypes() {
    List<StockTypeEnum> availableStocks = [];
    String currentDivision = _storeConfig.selectedDivision;
    switch (currentDivision) {
      case TJXDivisions.winnersCanadaOrMarshallsCanada:
        availableStocks = selectValidStockTypes();
        break;
      case TJXDivisions.tjMaxxUsa:
        availableStocks = selectValidStockTypes();
        break;
      case TJXDivisions.marshallsUsa:
        availableStocks.addAll(defaultStocks);
        if (!availableStocks.contains(StockTypeEnum.shoes)) {
          availableStocks.add(StockTypeEnum.shoes);
        }
        break;
      case TJXDivisions.homeSenseCanada:
        availableStocks.addAll(defaultStocks);
        break;
      case TJXDivisions.homeGoodsUsaOrHomeSenseUsa:
        availableStocks.addAll(defaultStocks);
        if (!availableStocks.contains(StockTypeEnum.largeSign)) {
          availableStocks.add(StockTypeEnum.largeSign);
        }
        if (!availableStocks.contains(StockTypeEnum.smallSign)) {
          availableStocks.add(StockTypeEnum.smallSign);
        }
        break;
      case TJXDivisions.tkMaxxEuropeUk:
      case TJXDivisions.tkMaxxEuropeOther:
        availableStocks = [
          StockTypeEnum.markdown,
          StockTypeEnum.stickers,
          StockTypeEnum.transfers
        ];
        break;
    }

    return availableStocks;
  }

  String getLabelLength(StockTypeEnum stockType) {
    var zplSetting = _configFilesController.zplSettings;
    bool isEurope = _storeConfig.isEurope.value;
    switch (stockType) {
      case StockTypeEnum.markdown:
      case StockTypeEnum.priceAdjust:
        return isEurope
            ? (zplSetting?.labelLength.europe.markdown ?? "0")
            : (zplSetting?.labelLength.northAmerica.markdown ?? "0");
      case StockTypeEnum.shoes:
        return zplSetting?.labelLength.common.shoes ?? "0";
      case StockTypeEnum.stickers:
        return isEurope
            ? (zplSetting?.labelLength.europe.sticker ?? "0")
            : (zplSetting?.labelLength.northAmerica.sticker ?? "0");
      case StockTypeEnum.hangTag:
        return zplSetting?.labelLength.common.hangTag ?? "0";
      case StockTypeEnum.transfers:
        return isEurope
            ? (zplSetting?.labelLength.europe.transfers ?? "0")
            : (zplSetting?.labelLength.northAmerica.transfers ?? "0");
      case StockTypeEnum.smallSign:
        return zplSetting?.labelLength.common.sign.small ?? "0";
      case StockTypeEnum.largeSign:
        return zplSetting?.labelLength.common.sign.large ?? "0";
    }
  }

  String getSeparatorCommand() {
    var zplSetting = _configFilesController.zplSettings;
    bool isEurope = _storeConfig.isEurope.value;
    return isEurope
        ? (zplSetting?.separatorTypeZpl.gapSense ?? '')
        : (zplSetting?.separatorTypeZpl.barSense ?? '');
  }

  SeparatorTypeEnum getSeparatorType() {
    bool isEurope = _storeConfig.isEurope.value;
    return isEurope ? SeparatorTypeEnum.gap : SeparatorTypeEnum.bar;
  }

  StockTypeEnum getStockTypeFromString(String stock) {
    var printingConfig =
        _configFilesController.appSettings?.printingConfiguration;
    if (stock == printingConfig?.markdownStock) {
      return StockTypeEnum.markdown;
    } else if (stock == printingConfig?.priceAdjustStock) {
      return StockTypeEnum.priceAdjust;
    } else if (stock == printingConfig?.stickerStock) {
      return StockTypeEnum.stickers;
    } else if (stock == printingConfig?.transferStock) {
      return StockTypeEnum.transfers;
    } else if (stock == printingConfig?.hangTagStock) {
      return StockTypeEnum.hangTag;
    } else if (stock == printingConfig?.shoeTagStock) {
      return StockTypeEnum.shoes;
    } else if (stock == printingConfig?.smallSignStock) {
      return StockTypeEnum.smallSign;
    } else if (stock == printingConfig?.largeSignStock) {
      return StockTypeEnum.largeSign;
    } else if (stock == printingConfig?.shoeStickerStock) {
      return StockTypeEnum.shoes;
    } else {
      return StockTypeEnum.markdown;
    }
  }

}
