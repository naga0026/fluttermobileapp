import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:flutter/material.dart';

typedef OnDropDownChange = Function(String);

class DropDown extends StatelessWidget {
  const DropDown(
      {Key? key,
      required this.value,
      required this.items,
      required this.onChange})
      : super(key: key);
  final String? value;
  final List<String> items;
  final OnDropDownChange onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.lightGreyColor,
      child: DropdownButton<String>(
          dropdownColor: ColorConstants.lightGreyColor,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
            size: 25,
          ),
          underline: const SizedBox(),
          value: value,
          hint: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '-- Select --',
              style: TextStyle(color: Colors.black),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e),
                    ),
                  ))
              .toList(),
          onChanged: (item) => onChange(item ?? '')),
    );
  }
}
