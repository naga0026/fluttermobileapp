import 'package:base_project/utility/enums/app_tabs_enum.dart';
import 'package:flutter/material.dart';


class BottomTabItem implements BottomNavigationBarItem {

  final AppTab appTab;
  final Color bgColor = Colors.white;

  const BottomTabItem({required this.appTab});

  @override
  Widget get activeIcon => Image.asset(appTab.activeIcon, height: 25, width: 25,);

  @override
  Color? get backgroundColor => bgColor;

  @override
  Widget get icon => Image.asset(appTab.icon, height: 25, width: 25,);

  @override
  String? get label => '';

  @override
  String? get tooltip => '';

}

