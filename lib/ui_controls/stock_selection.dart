import 'package:base_project/utility/enums/stock_type.dart';
import 'package:flutter/material.dart';

import '../utility/constants/colors/color_constants.dart';

class StockSelection extends StatelessWidget {
  const StockSelection(
      {Key? key, required this.stockTypes, required this.onStockTypeUpdate, required this.selectedStock})
      : super(key: key);
  final List<StockTypeEnum> stockTypes;
  final Function(StockTypeEnum) onStockTypeUpdate;
  final StockTypeEnum selectedStock;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: stockTypes
            .map((StockTypeEnum stock) => ListTile(
                  onTap: () => onStockTypeUpdate(stock),
                  tileColor:
                      stock == selectedStock ? ColorConstants.primaryRedColor : null,
                  title: Text(
                    stock.rawValue,
                    style: TextStyle(
                        color: stock == selectedStock ? Colors.white : Colors.black),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
