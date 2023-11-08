import 'package:base_project/controller/home/sgm/sgm_view_controller.dart';
import 'package:base_project/controller/home/ticket_maker/shoe/shoes_Front_controller.dart';
import 'package:base_project/controller/initial_view_controller.dart';
import 'package:get/get.dart';

import '../../controller/base/app_bar_controller.dart';
import '../../controller/home/ticket_maker/shoe/shoes_ Final_controller.dart';
import '../../controller/home/ticket_maker/sign/signs_controller.dart';
import '../../controller/home/ticket_maker/ticket_maker_controller.dart';
import '../../controller/home/transfers/transfers_controller.dart';
import '../../controller/login/login_view_controller.dart';
import '../../controller/validation/validation_controller.dart';

// Add a mode in binding if you wish to keep the controller permanent
// else it will be disposed once screen is deleted from the navigation stack

class LoginBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<LoginViewController>(() => LoginViewController(), fenix: true);
    Get.lazyPut<TicketMakerController>(() => TicketMakerController(), fenix: true);
    Get.lazyPut<ValidationController>(() => ValidationController(), fenix: true);
    Get.lazyPut<SGMViewController>(() => SGMViewController(), fenix: true);
    Get.lazyPut<AppBarController>(() => AppBarController(), fenix: true);
    Get.lazyPut<ShoesFrontScreenController>(() => ShoesFrontScreenController(), fenix: true);
    Get.lazyPut<ShoesFinalScreenController>(() => ShoesFinalScreenController(), fenix: true);
    Get.lazyPut<SignsController>(() => SignsController(), fenix: true);
    Get.lazyPut<InitialController>(() => InitialController(), fenix: true);
    Get.lazyPut<TransfersController>(() => TransfersController(), fenix: true);
  }

}