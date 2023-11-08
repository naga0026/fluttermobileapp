import 'package:base_project/model/store_config/store_config_model.dart';
import 'package:base_project/services/network/api_repository.dart';
import 'package:base_project/utility/enums/division_enum.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../model/store_config/store_details.dart';
import '../../utility/enums/mega_store_type_enum.dart';
import '../../utility/enums/store_type.dart';
import '../../utility/enums/style_type_enum.dart';
import '../../utility/logger/logger_config.dart';

class StoreConfigController extends GetxController {
  Logger logger = LoggerConfig.initLog();

  final repository = APIRepository();
  RxBool isCountryPoland = false.obs;
  Rx<StoreType> storeType = Rx<StoreType>(StoreType.standalone);
  StoreDetails? firstMegaStoreDetails;
  StoreDetails? secondMegaStoreDetails;
  RxBool isEurope = false.obs;

  /// Holds selected store's division, name and number
  Rxn<StoreDetails> selectedStoreDetails = Rxn<StoreDetails>();

  /// To manage the style range data
  MegaStoreTypeEnum? megaStoreType;

  @override
  onInit() {
    // resetStoreConfigData();
    getStoreConfigData();
    super.onInit();
  }

  Rx<StyleTypeEnum> styleTypeForStore = StyleTypeEnum.style.obs;

  switchDivision(StoreDetails storeDetails) {
    selectedStoreDetails.value = storeDetails;
  }

  StyleTypeEnum checkForStyleOrULine() {
    // Check if store is mega store or not and check for  US marshalls division
    // If division is US marshalls add uline to the field else style

    styleTypeForStore.value =
        isMarshallsUSA() ? StyleTypeEnum.uline : StyleTypeEnum.style;

    return styleTypeForStore.value;
  }

  bool isMarshallsUSA() {
    return selectedStoreDetails.value?.storeDivision == DivisionEnum.marshallsUsa.rawValue;
  }

  Future<void> getStoreConfigData() async {
    try {
      resetStoreConfigData();
      StoreConfigData? storeConfig = await repository.getStoreConfigData(false, null);
      if (storeConfig != null) {
        storeConfig.country == "PL"
            ? isCountryPoland.value = true
            : isCountryPoland.value = false;

        switch (storeConfig.storeType) {
          case 0:
            storeType.value = StoreType.standalone;
            break;
          case 1:
            storeType.value = StoreType.mega;
            break;
          case 2:
            storeType.value = StoreType.combo;
            break;
          default:
            storeType.value = StoreType.standalone;
            break;
        }
        validateAccessIfMegaStore(storeConfig);
      }
    } catch (e) {
      logger.e("Error while fetching storeConfig info.$e");
    }
    return;
  }

  getCurrencySymbol(){
    return isEurope.value?"€":"\$";
  }

  validateAccessIfMegaStore(StoreConfigData? storeConfig) {
    if (storeConfig != null) {
      if (storeType.value == StoreType.mega) {
        firstMegaStoreDetails = StoreDetails(
            storeNumber: storeConfig.divisions.divid[0].number,
            storeName: storeConfig.divisions.divid[0].name,
            storeDivision: storeConfig.divisions.divid[0].division,
            divisionEnum: storeConfig.divisions.divid[0].division.getDivisionName);
        secondMegaStoreDetails = StoreDetails(
            storeNumber: storeConfig.divisions.divid[1].number,
            storeName: storeConfig.divisions.divid[1].name,
            storeDivision: storeConfig.divisions.divid[1].division,
            divisionEnum: storeConfig.divisions.divid[1].division.getDivisionName);
        logger.d("Is mega store: ${StoreType.mega.name}");
        selectedStoreDetails.value = firstMegaStoreDetails;
        logger.d(
            "First division and store number & name: ${firstMegaStoreDetails?.storeDivision}, ${firstMegaStoreDetails?.storeNumber}, ${firstMegaStoreDetails?.storeName}");
        logger.d(
            "Second division and store number & name:  ${secondMegaStoreDetails?.storeDivision}, ${secondMegaStoreDetails?.storeNumber}, ${secondMegaStoreDetails?.storeName}");
      } else {
        StoreDetails selectedStore = StoreDetails(
            storeNumber: storeConfig.divisions.divid[0].number,
            storeName: storeConfig.divisions.divid[0].name,
            storeDivision: storeConfig.divisions.divid[0].division,
            divisionEnum: storeConfig.divisions.divid[0].division.getDivisionName);
        selectedStoreDetails.value = selectedStore;
        logger.d(
            "Division and store number & name: ${selectedStore.storeDivision}, ${selectedStore.storeNumber}, ${selectedStore.storeName}");
      }
      if (storeConfig.divisions.divid.first.division ==
              DivisionEnum.tkMaxxEuropeUk.rawValue.toString() ||
          storeConfig.divisions.divid.first.division ==
              DivisionEnum.tkMaxxEuropeOther.toString()) {
        isEurope.value = true;
      }
     megaStoreType = updateMegaStoreType(storeConfig.divisions);
    }
  }

  void resetStoreConfigData() {
    firstMegaStoreDetails = null;
    secondMegaStoreDetails = null;
    selectedStoreDetails.value = null;
    storeType.value = StoreType.standalone;
    isCountryPoland.value = false;
    isEurope.value = false;
  }


  MegaStoreTypeEnum? updateMegaStoreType(Divisions? divisions) {
    if (divisions?.divid.length != 2) return null;

    var divisionCodes = divisions!.divid.map((e) => e.division).toList();

    if (divisionCodes.contains(DivisionEnum.tjMaxxUsa.rawValue) &&
        divisionCodes
            .contains(DivisionEnum.homeGoodsUsaOrHomeSenseUsa.rawValue)) {
      return MegaStoreTypeEnum.tjMaxxWithHomeGoods;
    }
    return null;
  }

  //region Getters
  String get selectedDivision {
    return selectedStoreDetails.value?.storeDivision ?? '';
  }

  String get selectedStoreNumber {
    return selectedStoreDetails.value?.storeNumber ?? '';
  }

  bool get isMega {
    return storeType.value == StoreType.mega;
  }

  String get firstDivisionCode {
    return firstMegaStoreDetails?.storeDivision ?? '';
  }

  String get secondDivisionCode {
    return secondMegaStoreDetails?.storeDivision ?? '';
  }

  bool isCurrentDivision(int division){
    if(selectedStoreDetails.value == null){
      return false;
    }
    return selectedStoreDetails.value!.storeDivision == division.toString();
  }
//endregion
}
