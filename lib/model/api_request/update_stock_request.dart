class UpdateStockRequest {
  String printerId;
  String stockType;
  int labelLength;
  int separatorType;

  UpdateStockRequest(
      {required this.separatorType,
      required this.stockType,
      required this.labelLength,
      required this.printerId});

  Map<String, dynamic> toJson() => {
        "stockType": stockType,
        "labelLength": labelLength,
        "separatorType": separatorType
      };
}
