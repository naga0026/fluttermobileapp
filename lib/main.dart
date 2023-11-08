import 'package:base_project/controller/login/login_view_controller.dart';
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/services/physical_response/physical_response_service.dart';
import 'package:base_project/services/database/database_service.dart';
import 'package:base_project/services/navigation/navigation_service.dart';
import 'package:base_project/services/navigation/routes/get_routes.dart';
import 'package:base_project/services/navigation/routes/route_names.dart';
import 'package:base_project/services/printing/stock_type_service.dart';
import 'package:base_project/services/scanning/zebra_scan_service.dart';
import 'package:base_project/services/shared_preference/shared_preference_service.dart';
import 'package:base_project/translations/messages.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:base_project/utility/themes/app_dark_theme.dart';
import 'package:base_project/utility/themes/app_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_error_widget.dart';
import 'controller/initial_view_controller.dart';
import 'controller/validation/fiscal_week.dart';
import 'services/config/config_service.dart';
import 'services/network/network_service.dart';
import 'services/printing/zebra_print_service.dart';


Future<void> main() async {
  bool isDev = false; // Set this to true during development for debugging
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return AppErrorWidget(
      errorDetails: errorDetails,
      isDev: isDev,
      key: UniqueKey(),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initServices();
  runApp(const BaseApp());
}

Future<void> initServices() async {
  LoggerConfig.logger.i('starting services ...');
  await Get.putAsync(() => SharedPreferenceService().initialize());
  Get.put(InitialController());
  await Get.putAsync(() => ConfigService().init());
  Get.put(ReadConfigFileController(), permanent: true);
  await Get.putAsync(() => DatabaseService().init());
  await Get.putAsync(() => NetworkService().init());
  Get.put(StoreConfigController(), permanent: true);
  Get.put(NavigationService());
  Get.put(ZebraPrintService());
  Get.put(ZebraScanService());
  Get.put(StockTypeService());
  Get.put(FiscalWeekCalculationService());
  LoggerConfig.logger.i('All services started...');

  // When need to use the service : final nwService = Get.find<NetworkService>();
}

class BaseApp extends StatefulWidget  {
  const BaseApp({Key? key}) : super(key: key);

  @override
  State<BaseApp> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      super.didChangeAppLifecycleState(state);
      if(state == AppLifecycleState.detached){
        // print("====== detached =====");
        var loginController = Get.find<LoginViewController>();
        loginController.onLogOut();
      }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      fallbackLocale: const Locale('en'),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      navigatorKey: NavigationService.kNavigatorKey,
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      smartManagement: SmartManagement.full,
      initialRoute: RouteNames.loginPage,
      getPages: [
        GetPages.loginPage,
        GetPages.mainTabPage,
        GetPages.homePage,
        GetPages.printerPage,
        GetPages.addPrinterPage,
        GetPages.signScreen,
        GetPages.shoesFrontScreen,
        GetPages.shoesFinalScreen,
        GetPages.networkConfigurationScreen,
      ],
    );
  }
}

