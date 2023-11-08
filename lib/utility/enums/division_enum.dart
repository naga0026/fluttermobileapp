enum DivisionEnum {
  winnersCanadaOrMarshallsCanada("04"),
  tkMaxxEuropeUk("05"),
  tjMaxxUsa("08"),
  marshallsUsa("10"),
  homeSenseCanada("24"),
  homeGoodsUsaOrHomeSenseUsa("28"),
  tkMaxxEuropeOther("55");

  final String rawValue;
  const DivisionEnum(this.rawValue);
}

extension ValidBarcodeLength on DivisionEnum {
  List<int> get validBarcodeLength {
    switch(this){
      case DivisionEnum.winnersCanadaOrMarshallsCanada:
        return [14, 16];
      case DivisionEnum.tkMaxxEuropeUk:
        return [16];
      case DivisionEnum.tjMaxxUsa:
        return [14,20];
      case DivisionEnum.marshallsUsa:
        return [18, 20];
      case DivisionEnum.homeSenseCanada:
        return [14,16];
      case DivisionEnum.homeGoodsUsaOrHomeSenseUsa:
        return [14,20];
      case DivisionEnum.tkMaxxEuropeOther:
        return [16];
    }
  }
}

extension DivisionaName on String {
  DivisionEnum get getDivisionName{
    return switch (this) {
      "04" => DivisionEnum.winnersCanadaOrMarshallsCanada,
      "05" => DivisionEnum.tkMaxxEuropeUk,
      "08" => DivisionEnum.tjMaxxUsa,
      "10" => DivisionEnum.marshallsUsa,
      "24" => DivisionEnum.homeSenseCanada,
      "28" => DivisionEnum.homeGoodsUsaOrHomeSenseUsa,
      "55" => DivisionEnum.tkMaxxEuropeOther,
      _ => DivisionEnum.homeGoodsUsaOrHomeSenseUsa
    };
  }

}