import '../../utility/enums/division_enum.dart';

class StoreDetails {
  String storeNumber;
  String storeName;
  String storeDivision;
  DivisionEnum divisionEnum;

  StoreDetails(
      {required this.storeNumber,
      required this.storeName,
      required this.storeDivision,
      required this.divisionEnum});
}

class MultipleStoreDetails {
  StoreDetails firstStoreDetails;
  StoreDetails secondStoreDetails;

  MultipleStoreDetails(
      {required this.firstStoreDetails, required this.secondStoreDetails});
}
