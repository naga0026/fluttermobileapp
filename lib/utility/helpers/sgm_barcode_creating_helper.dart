import 'package:base_project/model/label_definition/sgm_label_data.dart';
import 'package:base_project/utility/helpers/barcode_creating_helper.dart';

import '../../model/label_definition/label_data.dart';
import '../../model/store_config/tjx_divisions.dart';

class SGMBarcodeCreatingHelper extends BarcodeCreatingHelper {
  @override
  String generateBarcode(LabelData labelData) {
    SGMLabelData _ = labelData as SGMLabelData;
    String barcode = '';

    switch (storeConfigController.selectedDivision) {
      case TJXDivisions.marshallsUsa: // 20 digits
        final dept = getDepartmentForMarshallsUsa(labelData.departmentCode);
        barcode =
            '$dept${labelData.uline}${labelData.toPrice}${labelData.weekNumber}';
        break;
      case TJXDivisions.tjMaxxUsa:
      case TJXDivisions.homeGoodsUsaOrHomeSenseUsa: // 20 digits
        barcode =
            '${labelData.division}${labelData.departmentCode}${getClassCode(labelData.classCode)}${labelData.style}${labelData.toPrice}${labelData.weekNumber}';
        break;
      case TJXDivisions.winnersCanadaOrMarshallsCanada: // 16 digits
      case TJXDivisions
            .homeSenseCanada: // Canada (24) Markdown and PriceAdjust :- 16 digits
      case TJXDivisions.tkMaxxEuropeUk:
      case TJXDivisions.tkMaxxEuropeOther: // Europe (05, 55):- 16 digits
        barcode =
            '${labelData.departmentCode}${getClassCodeForCanada() ? "" : labelData.classCode}${labelData.style}${labelData.toPrice}';
        break;
    }
    return barcode;
  }
}
