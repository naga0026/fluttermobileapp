
class GetDepartmentOrClassDataRequest {
  String divisionCode;
  String? secondDivisionCode;

  GetDepartmentOrClassDataRequest(
      {required this.divisionCode,
        this.secondDivisionCode,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["DivisionCode"] = divisionCode;
    if(secondDivisionCode != null) data["SecondDivisionCode"] = secondDivisionCode;
    return data;
  }
}