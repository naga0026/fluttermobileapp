import 'package:base_project/model/api_response/markdowns/get_initial_markdown_response.dart';

class MarkdownCandidateResponse {
  List<MarkdownData>? markdownData;
  int statusCode;
  String? error;

  MarkdownCandidateResponse({required this.statusCode, this.markdownData, this.error});

}
