import 'package:base_project/model/label_definition/transfer_label_data.dart';
import 'package:base_project/utility/helpers/barcode_creating_helper.dart';
import '../../model/label_definition/label_data.dart';

class TransferBarcodeCreatingHelper extends BarcodeCreatingHelper {
  @override
  String generateBarcode(LabelData labelData) {
    TransfersLabelData labelD = labelData as TransfersLabelData;
    return labelD.controlNumber;
  }
}
