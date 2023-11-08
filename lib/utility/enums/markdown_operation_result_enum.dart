enum MarkdownOperationResultEnum {
  noMarkdown(0),
  weekGotClosed(1),
  initialMarkdownTaken(2),
  subsMarkdownTaken(3),
  noVoidAvailable(4),
  markdownVoided(5),
  reprintUpdated(6),
  noMarkdownLog(7),
  missedMarkdown(8);

  final int rawValue;
  const MarkdownOperationResultEnum(this.rawValue);
}