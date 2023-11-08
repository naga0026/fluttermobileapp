class MarkdownWeekOpenRequest {
  String divisionCode;
  String storeNumber;
  int markdownType;

  MarkdownWeekOpenRequest(
      {required this.divisionCode,
      required this.storeNumber,
      required this.markdownType});

  Map<String, dynamic> toJson() {
    return {
      "DivisionCode" : divisionCode,
      "StoreNumber" : storeNumber,
      "MarkdownType" : markdownType
    };
  }
}
