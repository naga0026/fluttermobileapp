import 'package:base_project/controller/home/home_view_controller.dart';
import 'package:base_project/controller/login/login_view_controller.dart';
import 'package:base_project/controller/login/user_management.dart';
import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:base_project/utility/enums/app_name_enum.dart';
import 'package:base_project/view/home/SGM/sgm.dart';
import 'package:base_project/view/home/ticket_maker/ticket_maker.dart';
import 'package:base_project/view/home/transfers/transfers_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/navigation/navigation_service.dart';
import '../../utility/constants/images_and_icons/icon_constants.dart';
import 'initial_subs/initials_subs_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int tabCount = 5;
  final homeController = Get.find<HomeViewController>();
  final userManagementController = Get.find<UserManagementController>();
  final loginViewController = Get.find<LoginViewController>();

  @override
  void initState() {
    tabCount =
        homeController.appNames.isEmpty ? 1 : homeController.appNames.length;
    _tabController = TabController(length: tabCount, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            icon: IconConstants.exitAppIcon);
        return true;
      },
      child: Obx(() {
        _tabController = TabController(length: tabCount, vsync: this);
        return homeController.appNames.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    color: ColorConstants.redTabColor,
                    child: Center(
                      child: TabBar(
                          onTap: (index) {
                            // TODO: Handle tab change
                            homeController.onTabChange();
                            homeController.currentTabIndex.value = index;
                          },
                          controller: _tabController,
                          indicatorColor: Colors.grey,
                          isScrollable: true,
                          tabs: homeController.appNames.isEmpty ||
                                  homeController.appNames == []
                              ? [const Tab(text: "Access Denied")]
                              : homeController.appNames
                                  .map((AppNameEnum element) => Tab(
                                        text: element.rawValue,
                                      ))
                                  .toList()),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: homeController.appNames.map((app) {
                      return getScreen(app);
                    }).toList(),
                  ))
                ],
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "YOUR NOT AUTHORIZED TO ACCESS.",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
      }),
    );
  }

  Widget getScreen(AppNameEnum feature) {
    switch (feature) {
      case AppNameEnum.markdowns:
        return const InitialSubsView();
      case AppNameEnum.sgm:
        return const SGMScreen();
      case AppNameEnum.ticketMaker:
        return const TicketMaker();
      case AppNameEnum.transfers:
        return const TransfersScreen();
      case AppNameEnum.returnItemLookup:
        return Container();
      case AppNameEnum.recallTracking:
        return Container();
      default:
        return accessDenied();
    }
  }

  Widget accessDenied() {
    return Center(
      child: Text(
        "Access Denied",
        style: TextStyle(
            color: ColorConstants.lightGreyColor,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
