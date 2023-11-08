import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utility/constants/colors/color_constants.dart';
import '../utility/enums/transfers_enum.dart';

typedef OnTransferSegmentChange = Function(TransfersDirection);

class TransferSegmentControl extends StatefulWidget {
  const TransferSegmentControl(
      {Key? key, required this.onSegmentChange, required this.selectedTransfersDirection})
      : super(key: key);
  final OnTransferSegmentChange onSegmentChange;
  final TransfersDirection selectedTransfersDirection;

  @override
  State<TransferSegmentControl> createState() => _TransferSegmentControlState();
}

class _TransferSegmentControlState extends State<TransferSegmentControl> {


  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<TransfersDirection>(
        children: children,
        thumbColor: ColorConstants.primaryRedColor,
        backgroundColor: ColorConstants.primaryRedColor.withOpacity(0.6),
        groupValue: widget.selectedTransfersDirection,
        onValueChanged: _onValueChange);
  }

  Map<TransfersDirection, Widget> children = <TransfersDirection, Widget>{
    TransfersDirection.shipping: Text(
      TransfersDirection.shipping.title,
      style: const TextStyle(color: Colors.white),
    ),
    TransfersDirection.receiving: Text(TransfersDirection.receiving.title,
        style: const TextStyle(color: Colors.white)),
  };

  void _onValueChange(TransfersDirection? option) {
    if (option != null) {
      widget.onSegmentChange(option);
    }
  }
}
