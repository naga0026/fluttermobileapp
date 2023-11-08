class RequestPageParam {
  int totalPage;
  int totalRecord;
  int currentPage;
  int perPageRecords = 75000;
  int currentRecords;
  double percentageProgress;

  RequestPageParam(
      {this.totalPage = 0,
      this.totalRecord = 0,
      this.currentPage = 1,
      this.currentRecords = 0,
      this.percentageProgress = 0.0});
}
