import '../department_item.dart';

class GetDepartmentDataResponse {
  int status;
  List<GetDepartmentData>? data;
  String? error;

  GetDepartmentDataResponse({required this.status, this.data, this.error});
}