import '../origin_reason_model.dart';

class GetOriginAndReasonDataResponse {
  int status;
  List<OriginReasonModel>? data;
  String? error;

  GetOriginAndReasonDataResponse({required this.status, this.data, this.error});
}
