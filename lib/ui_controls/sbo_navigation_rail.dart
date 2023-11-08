import 'package:flutter/material.dart';

import '../utility/constants/colors/color_constants.dart';

class SBONavigationRail extends StatelessWidget {
  const SBONavigationRail(
      {Key? key,
      required this.destinations,
      required this.onDestinationChange,
      required this.selectedIndex})
      : super(key: key);
  final List<String> destinations;
  final Function(int) onDestinationChange;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: Colors.white,
      useIndicator: false,
      selectedLabelTextStyle: TextStyle(
        color: ColorConstants.primaryRedColor,
        fontWeight: FontWeight.bold,
      ),
      labelType: NavigationRailLabelType.all,
      destinations: destinations
          .map((e) => NavigationRailDestination(
                padding: const EdgeInsets.all(4),
                icon: const SizedBox.shrink(),
                label: Text(e),
              ))
          .toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) => onDestinationChange(index),
    );
  }
}
