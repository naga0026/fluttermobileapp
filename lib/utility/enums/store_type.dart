enum StoreType {
  mega(1),
  combo(2),
  standalone(0);

  final int rawValue;
  const StoreType(this.rawValue);
}

extension Name on StoreType {

  String get name {
    switch(this){
      case StoreType.mega:
        return "MEGA-STORE";
      case StoreType.combo:
        return "COMBO-STORE";
      case StoreType.standalone:
        return "STANDALONE-STORE";
    }
  }

}