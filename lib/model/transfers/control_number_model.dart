/// Control number contains Division code of receiving division,
/// shipping store number(fromStore) and control number sequence
class ControlNumberModel {
  int receivingDivision;
  int shippingStoreNumber;
  int boxSequenceNumber;

  ControlNumberModel(
      {required this.receivingDivision,
      required this.shippingStoreNumber,
      required this.boxSequenceNumber});
}
