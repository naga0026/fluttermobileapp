class SubsMarkdownsRequest {
String divisionCode;
String storeNumber;
String? secondDivisionCode;
String? secondStoreNumber;
int pageNumber;
int pageSize;

SubsMarkdownsRequest({required this.divisionCode, required this.storeNumber, required this.pageNumber, required this.pageSize});

Map<String, dynamic> toJson() => {
  "divisionCode": divisionCode,
  "storeNumber": storeNumber,
  "secondDivisionCode": secondDivisionCode,
  "secondStoreNumber": secondStoreNumber,
  "pageNumber" : pageNumber,
  "pageSize" : pageSize
};
}