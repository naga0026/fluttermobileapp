import 'package:base_project/controller/home/home_view_controller.dart';
import 'package:base_project/controller/login/login_view_controller.dart';
import  'package:base_project/controller/tab/main_tab_controller.dart';
import 'package:base_project/ui_controls/tab_item.dart';
import 'package:base_project/utility/enums/app_tabs_enum.dart';
import 'package:base_project/view/account/account_screen.dart';
import 'package:base_project/view/base/widgets/app_bar.dart';
import 'package:base_project/view/home/home_screen.dart';
import 'package:base_project/view/printer/printer_screen.dart';
import 'package:base_project/view/scan/scan_print_screen.dart';
import 'package:base_project/view/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/navigation/navigation_service.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  State<MainTabScreen> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabScreen> {
  final tabController = Get.find<MainTabController>();
  final loginViewController = Get.find<LoginViewController>();
  final homeViewController = Get.find<HomeViewController>();

  @override
  void initState() {
    super.initState();
    homeViewController.checkAccessToApp();
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = NavigationService.showDialog(
            title: "Confirm Logout",
            subtitle: "Do you want to logout ?",
            buttonCallBack: () => loginViewController.onLogOut(),
            isAddCancelButton: true,
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
              size: 50,
            ));
        return true;
      },
      child: Scaffold(
        appBar: SBOAppBar(
          onBack: null,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 2))),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            currentIndex: tabController.currentIndex.value,
            onTap: (index) => tabController.onIndexChange(index),
            items: const [
              BottomTabItem(appTab: AppTab.home),
              BottomTabItem(appTab: AppTab.printer),
              BottomTabItem(appTab: AppTab.scanAndPrint),
              BottomTabItem(appTab: AppTab.profile),
              BottomTabItem(appTab: AppTab.settings),
            ],
          ),
        ),
        body: Obx(() => _buildPage()),
      ),
    );
  }

  Widget _buildPage() {
    switch (tabController.currentIndex.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return const PrinterListScreen();
      case 2:
        return const ScanAndPrintScreen();
      case 3:
        return const AccountScreen();
      case 4:
        return const SettingScreen();
      default:
        return const HomeScreen();
    }
  }
}
