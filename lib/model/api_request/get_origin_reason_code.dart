class GetOriginReasonCodeRequest {
  String divisionCode;
  String languageCode;

  GetOriginReasonCodeRequest({
    required this.divisionCode,
    required this.languageCode,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["DivisionCode"] = divisionCode;
    data["LanguageCode"] = languageCode;
    return data;
  }
}
