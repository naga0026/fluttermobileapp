import 'package:base_project/bindings/home/home_binding.dart';
import 'package:base_project/bindings/login/login_binding.dart';
import 'package:base_project/bindings/printer/add_printer_binding.dart';
import 'package:base_project/bindings/printer/printer_binding.dart';
import 'package:base_project/bindings/tabs/main_tab_binding.dart';
import 'package:base_project/services/navigation/routes/route_names.dart';
import 'package:base_project/view/home/ticket_maker/shoes_screen/shoes_final_screen.dart';
import 'package:base_project/view/home/ticket_maker/shoes_screen/shoes_front_screen.dart';
import 'package:base_project/view/login/login_screen.dart';
import 'package:base_project/view/login/network/network_screen.dart';
import 'package:base_project/view/main_tab/main_tab_view.dart';
import 'package:base_project/view/printer/add_printer_screen.dart';
import 'package:get/get.dart';

import '../../../app_error_widget.dart';
import '../../../view/home/home_screen.dart';
import '../../../view/home/ticket_maker/sign_screen/sign_screen.dart';
import '../../../view/printer/printer_screen.dart';

/*
NOTE: Add a mode in binding if you wish to keep the controller permanent
else it will be disposed once screen is deleted from the navigation stack
 */

class GetPages {
  static GetPage loginPage = GetPage(
      name: RouteNames.loginPage,
      page: () => const LoginScreen(),
      binding: LoginBinding());
  static GetPage errorPage = GetPage(
    name: RouteNames.errorPage,
    page: () => AppErrorWidget(
      key: null,
      errorDetails: null,
    ),
  );

  static GetPage mainTabPage = GetPage(
      name: RouteNames.tabPage,
      page: () => const MainTabScreen(),
      binding: MainTabBinding());

  static GetPage homePage = GetPage(
      name: RouteNames.homePage,
      page: () => const HomeScreen(),
      binding: HomeBinding());

  static GetPage printerPage = GetPage(
      name: RouteNames.printerListPage,
      page: () => const PrinterListScreen(),
      binding: PrinterBinding());

  static GetPage addPrinterPage = GetPage(
      name: RouteNames.printerAddPage,
      page: () => const AddPrinterScreen(),
      binding: AddPrinterBinding());

  static GetPage signScreen = GetPage(
    name: RouteNames.signScreen,
    page: () =>  SignScreen(),
  );

  static GetPage shoesFrontScreen = GetPage(
    name: RouteNames.shoesFrontScreen,
    page: () => const ShoesFrontScreen(),
  );

  static GetPage shoesFinalScreen = GetPage(
    name: RouteNames.shoesFinalScreen,
    page: () => const ShoesFinalScreen(),
  );

  static GetPage networkConfigurationScreen = GetPage(
    name: RouteNames.networkConfigurationScreen,
    page: () => const NetworkConfigurationScreen(),
  );
}
