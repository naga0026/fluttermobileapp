import 'dart:convert';

class MarkdownWeekResponse {
  int status;
  MarkdownWeek? markdownWeek;
  String? error;

  MarkdownWeekResponse({required this.status, this.markdownWeek, this.error});
}


MarkdownWeek markdownWeekFromJson(String str) => MarkdownWeek.fromJson(json.decode(str));

String markdownWeekToJson(MarkdownWeek data) => json.encode(data.toJson());

class MarkdownWeek {
  final String weekId;
  final bool finalClearance;

  MarkdownWeek({
    required this.weekId,
    required this.finalClearance,
  });

  factory MarkdownWeek.fromJson(Map<String, dynamic> json) => MarkdownWeek(
    weekId:json["weekId"]??"",
    finalClearance: json["finalClearance"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "weekId": weekId,
    "finalClearance": finalClearance,
  };
}
