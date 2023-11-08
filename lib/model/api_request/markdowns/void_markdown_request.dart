class VoidOrReprintMarkdownRequest {
  int logId;
  int? reprintCount;

  VoidOrReprintMarkdownRequest({required this.logId, this.reprintCount});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["logId"] = logId;
    if(reprintCount != null && reprintCount != 0){
      data["reprintCount"] = reprintCount;
    }
    return data;
  }
}
