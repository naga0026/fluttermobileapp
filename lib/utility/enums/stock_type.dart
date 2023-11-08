// Add raw value for each enum that way it will be easier
// to get the title while displaying it in UI
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:get/get.dart';

import '../../translations/translation_keys.dart';

enum StockTypeEnum {
  markdown("Markdown"),
  hangTag("HangTag"),
  priceAdjust("PriceAdjust"),
  stickers("Sticker"),
  transfers("Transfers"),
  shoes("Shoes"),
  smallSign("SmallSign"),
  largeSign("LargeSign");

  final String rawValue;

  const StockTypeEnum(this.rawValue);
}


extension GetStockTypeAPIParam on StockTypeEnum {
  String get parameterKey {
    final ReadConfigFileController setting =
    Get.find<ReadConfigFileController>();
    switch (this) {
      case StockTypeEnum.markdown:
        return setting.appSettings?.printingConfiguration.markdownStock ?? '';
      case StockTypeEnum.hangTag:
        return setting.appSettings?.printingConfiguration.hangTagStock ?? '';
      case StockTypeEnum.priceAdjust:
        return setting.appSettings?.printingConfiguration.priceAdjustStock ??
            '';
      case StockTypeEnum.stickers:
        return setting.appSettings?.printingConfiguration.stickerStock ?? '';
      case StockTypeEnum.transfers:
        return setting.appSettings?.printingConfiguration.transferStock ?? '';
      case StockTypeEnum.shoes:
        return setting.appSettings?.printingConfiguration.shoeTagStock ?? '';
      case StockTypeEnum.smallSign:
        return setting.appSettings?.printingConfiguration.smallSignStock ?? '';
      case StockTypeEnum.largeSign:
        return setting.appSettings?.printingConfiguration.largeSignStock ?? '';
    }
  }
}

extension GetTickerMakerName on StockTypeEnum {
  String get ticketMakerName {
    switch (this) {
      case StockTypeEnum.markdown:
        return TranslationKey.tmMdLabel.tr;//
      case StockTypeEnum.hangTag:
        return TranslationKey.tmHangTag.tr;
      case StockTypeEnum.priceAdjust:
        return TranslationKey.tmPaLabel.tr;
      case StockTypeEnum.stickers:
        return TranslationKey.tmLabel.tr;
      case StockTypeEnum.shoes:
        return TranslationKey.tmShoe.tr;
      case StockTypeEnum.smallSign:
        return TranslationKey.tmSign.tr;
      case StockTypeEnum.largeSign:
        return TranslationKey.tmSign.tr;
      case StockTypeEnum.transfers:
        return "";
    }
  }
}

extension StockTypeStringToEnum on String {
  StockTypeEnum get stock {
    switch (this) {
      case "Markdown (red label)":
        return StockTypeEnum.markdown;
      case "Sticker":
        return StockTypeEnum.stickers;
      case "Price Adjust (yellow label)":
        return StockTypeEnum.priceAdjust;
      case "Hang tag":
        return StockTypeEnum.hangTag;
      case "Transfer":
        return StockTypeEnum.transfers;
      case "Shoe tag":
        return StockTypeEnum.shoes;
      case "Shoe sticker":
        return StockTypeEnum.shoes;
      case "Large sign":
        return StockTypeEnum.largeSign;
      case "Small sign":
        return StockTypeEnum.smallSign;
      default:
        return StockTypeEnum.markdown;
    }
  }

  StockTypeEnum get getPrinterStockTypeFromString {
    switch (this) {
      case "Markdown (red label)":
        return StockTypeEnum.markdown;
      case "Hang tag":
        return StockTypeEnum.hangTag;
      case "Price Adjust (yellow label)":
        return StockTypeEnum.priceAdjust;
      case "Sticker":
        return StockTypeEnum.stickers;
      case "Shoe tag":
        return StockTypeEnum.shoes;
      case "Small sign":
        return StockTypeEnum.smallSign;
      case "Large sign":
        return StockTypeEnum
            .largeSign; // You might want to choose either smallSign or largeSign here
      case "Transfer":
        return StockTypeEnum.transfers;
      default:
        return StockTypeEnum.markdown;
    }
  }
}