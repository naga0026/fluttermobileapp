import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/home/ticket_maker/ticket_maker_controller.dart';
import 'package:get/get.dart';

class MainTabController extends BaseViewController {

  var currentIndex = 0.obs;
  final ticketMakerController = Get.find<TicketMakerController>();

  onIndexChange(int index){
    ticketMakerController.onClickClear();
    currentIndex.value = index;
  }

}