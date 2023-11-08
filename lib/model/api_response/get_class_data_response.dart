import '../class_item.dart';

class GetClassDataResponse {
  int status;
  List<GetClassData>? data;
  String? error;

  GetClassDataResponse({required this.status, this.data, this.error});
}

