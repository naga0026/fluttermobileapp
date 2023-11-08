import '../style_range_data.dart';

class GetStyleRangeDataResponse {
  int status;
  List<GetStyleRangeData>? data;
  String? error;

  GetStyleRangeDataResponse({required this.status, this.data, this.error});
}