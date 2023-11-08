import 'package:base_project/controller/home/home_view_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {

  @override
  void dependencies() {
    Get.put<HomeViewController>(HomeViewController());
  }

}