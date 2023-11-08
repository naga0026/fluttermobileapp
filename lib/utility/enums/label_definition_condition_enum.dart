enum LabelDefinitionConditionEnum {
  isAnyNorthAmericaDivisionExcept04and24("IsAnyNorthAmericaDivisionExcept_04_and_24"),
  isDivision04Or24("IsDivision_04_or_24"),
  isAnyEuropeDivision("IsAnyEuropeDivision"),
  isDivision04("IsDivision_04"),
  isDivision24("IsDivision_24"),
  isNotDivision04Nor24("IsNotDivision_04_nor_24"),
  isDivision28("IsDivision_28"),
  isDivision05("IsDivision_05"),
  isDivision55("IsDivision_55"),
  isDivision08Or28("IsDivision_08_or_28"),
  isDivision10("IsDivision_10"),
  isAnyNorthAmericaDivision("IsAnyNorthAmericaDivision"),
  isDivision_08("IsDivision_08"),
  isDivision04Or10("IsDivision_04_or_10"),
  isEuropeUkIreGerAt("IsEuropeUkIreGerAt"),
  isEuropeNetherlands("IsEuropeNetherlands"),
  isEuropePoland("IsEuropePoland"),
  isBoxBarcodeLabelPL("IsBoxBarcodeLabel_PL"),
  isBoxBarcodeLabelEU("IsBoxBarcodeLabel_EU"),
  isBoxBarcodeLabelNA("IsBoxBarcodeLabel_NA"),
  isAddressLabelPL("IsAddressLabel_PL"),
  isAddressLabelEU("IsAddressLabel_EU"),
  isAddressLabelNA("IsAddressLabel_NA"),
  isControlLabelEU("IsControlLabel_EU"),
  isControlLabelNA("IsControlLabel_NA");


  final String rawValue;
  const LabelDefinitionConditionEnum(this.rawValue);

}