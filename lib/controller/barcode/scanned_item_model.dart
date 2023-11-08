import '../../model/transfers/control_number_model.dart';

class ScanOrEnteredItemModel {
  ScanOrEnteredItemModel(
      {this.divisionId,
      this.deptId,
      this.classOrCategoryId,
      this.priceInDecimal = 0.0,
      this.styleOrULine,
      this.price,
      this.week,
      this.isKeyed});

  String? divisionId;
  String? deptId;
  String? classOrCategoryId;
  double priceInDecimal;
  String? styleOrULine;
  String? price;
  int? week;
  bool? isKeyed;
}


/// Fields containing controlNumber, receiving storeNumber(to store) and itemCount
/// isKeyed = to identify if the fields are entered manually or by scanning which later can be used in api call
/// interpretedControlNumber = stores the data of division code, receiving store num and control number
class ScanOrEnteredTransferReceivingItem {
  String controlNumber;
  String receivingStoreNumber;
  String itemCount;
  bool isKeyed = true;
  ControlNumberModel? interpretedControlNumber;
  int? receivedItemCount;

  ScanOrEnteredTransferReceivingItem(
      {required this.controlNumber,
      required this.receivingStoreNumber,
      required this.itemCount});

  static ScanOrEnteredTransferReceivingItem empty() {
    return ScanOrEnteredTransferReceivingItem(
      controlNumber: '',
      receivingStoreNumber: '',
      itemCount: ''
    );
  }
}
