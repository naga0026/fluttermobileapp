import 'dart:async';
import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:flutter/material.dart';

class TransferChoiceChipControl<T> extends StatefulWidget {
  const TransferChoiceChipControl(
      {Key? key,
      required this.chips,
      required this.onSelect, this.removeSelection = false})
      : super(key: key);
  final List<T> chips;
  final Function(dynamic) onSelect;
  final bool removeSelection;

  @override
  State<TransferChoiceChipControl> createState() =>
      _TransferChoiceChipControlState();
}

class _TransferChoiceChipControlState extends State<TransferChoiceChipControl> {
  StreamController selectedValueController = StreamController();

  Stream get selectedValue => selectedValueController.stream;

  @override
  void dispose() {
    selectedValueController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: selectedValue,
        builder: (context, AsyncSnapshot snapshot) {
          return Wrap(
            spacing: 5.0,
            children: widget.chips.map((e) {
              return ChoiceChip(
                selectedColor: ColorConstants.primaryRedColor,
                labelStyle: const TextStyle(color: Colors.white),
                label: Text(e.rawValue),
                selected: widget.removeSelection ? false : e == snapshot.data,
                onSelected: (bool selected) {
                  selectedValueController.sink.add(e);
                  widget.onSelect(e);
                },
              );
            }).toList(),
          );
        });
  }
}
