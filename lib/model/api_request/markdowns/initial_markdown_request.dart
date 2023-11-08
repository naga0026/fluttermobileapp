class InitialMarkdownRequest {
  String divisionCode;
  String storeNumber;
  String? secondDivisionCode;
  String? secondStoreNumber;
  int pageNumber;
  int pageSize;

  InitialMarkdownRequest(
      {required this.divisionCode,
      required this.storeNumber,
      this.secondStoreNumber,
      this.secondDivisionCode,
      required this.pageNumber,
      required this.pageSize});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["DivisionCode"] = divisionCode;
    data["StoreNumber"] = storeNumber;
    data["PageNumber"] = pageNumber;
    data["PageSize"] = pageSize;
    if(secondDivisionCode != null) data["SecondDivisionCode"] = secondDivisionCode;
    if(secondStoreNumber != null) data["SecondStoreNumber"] = secondStoreNumber;
    return data;
  }
}
