class IsInitialCachingRequiredRequest {
  String divisionCode;
  String storeNumber;
  String? secondDivisionCode;
  String? secondStoreNumber;
  String lastUpdated;

  IsInitialCachingRequiredRequest(
      {required this.divisionCode,
      required this.storeNumber,
      this.secondDivisionCode,
      this.secondStoreNumber,
      required this.lastUpdated});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["DivisionCode"] = divisionCode;
    data["StoreNumber"] = storeNumber;
    if(secondDivisionCode != null) data["SecondDivisionCode"] = secondDivisionCode;
    if(secondStoreNumber != null) data["SecondStoreNumber"] = secondStoreNumber;
    data["LastUpdated"] = lastUpdated;
    return data;
  }
}
