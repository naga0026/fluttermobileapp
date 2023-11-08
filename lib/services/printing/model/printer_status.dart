enum PrinterStatus {
  isHeadOpen('isHeadOpen'),
  isPaused('isPaused'),
  isPaperOut('isPaperOut'),
  isNotConnected('isNotConnected'),
  isPartialFormatInProgress('isPartialFormatInProgress'),
  isHeadCold('isHeadCold'),
  isHeadTooHot('isHeadTooHot'),
  isRibbonOut('isRibbonOut'),
  isReceiveBufferFull('isReceiveBufferFull');

  final String rawValue;
  const PrinterStatus(this.rawValue); // Generative enum constructor

}
