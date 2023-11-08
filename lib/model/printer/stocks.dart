import '../../utility/enums/stock_type.dart';

class Stocks {
  StockTypeEnum stockType;
  bool isSelected;

  Stocks({required this.stockType, this.isSelected = false});

}