enum WeekStatus { WEEK_OPEN, WEEK_APPROVED }

final weekStatusValues = EnumValues({
  "WeekOpen": WeekStatus.WEEK_OPEN,
  "WeekApproved": WeekStatus.WEEK_APPROVED
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
