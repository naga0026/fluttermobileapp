import 'package:base_project/utility/helpers/barcode_creating_helper.dart';

import '../../model/label_definition/label_data.dart';
import '../../model/label_definition/ticketmaker_label_data.dart';
import '../../model/store_config/tjx_divisions.dart';

class TicketMakerBarcodeCreatingHelper extends BarcodeCreatingHelper {
  @override
  String generateBarcode(LabelData labelData) {
    TicketMakerLabelData _ = labelData as TicketMakerLabelData;

    String barcode = '';
    switch (storeConfigController.selectedDivision) {
      case TJXDivisions.marshallsUsa: // 20 digits
        final dept = getDepartmentForMarshallsUsa(labelData.dept);
        barcode =
            '$dept${labelData.uline}${labelData.price}${labelData.weekNumber}';
        break;
      case TJXDivisions.tjMaxxUsa:
      case TJXDivisions.homeGoodsUsaOrHomeSenseUsa: // 20 digits
        barcode =
            '${labelData.division}${labelData.dept}${getClassCode(labelData.classCode!)}${labelData.style}${labelData.price}${labelData.weekNumber}';
        break;
      case TJXDivisions.winnersCanadaOrMarshallsCanada: // 16 digits
      case TJXDivisions
            .homeSenseCanada: // Canada (24) Markdown and PriceAdjust :- 16 digits
      case TJXDivisions.tkMaxxEuropeUk:
      case TJXDivisions.tkMaxxEuropeOther: // Europe (05, 55):- 16 digits
        barcode =
            '${labelData.dept}${getClassCodeForCanada() ? "" : labelData.classCode}${labelData.style}${labelData.price}';
        break;
    }
    return barcode;
  }
}
