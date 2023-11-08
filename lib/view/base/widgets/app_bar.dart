import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/base/app_bar_controller.dart';
import '../../../controller/home/ticket_maker/ticket_maker_controller.dart';
import '../../../controller/store_config/store_config_controller.dart';
import '../../../services/printing/stock_type_service.dart';
import '../../../ui_controls/sbo_button.dart';
import '../../../utility/constants/colors/color_constants.dart';
import '../../../utility/enums/store_type.dart';


final storeDivision = Get.find<StoreConfigController>();
final ticketMaker = Get.find<TicketMakerController>();
final stockTypeService = Get.find<StockTypeService>();
final appBarController = Get.find<AppBarController>();


class SBOAppBar extends AppBar {
  SBOAppBar({super.key, VoidCallback? onBack, bool showBackBtn = false})
      : super(
            title: Obx(
              () => storeDivision.isMega
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SBOButtonCustom(
                          title: "${storeDivision.firstMegaStoreDetails?.storeName}",
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            appBarController.onChangeDivision(storeDivision.firstMegaStoreDetails!);
                          },
                          isEnabled:
                              storeDivision.selectedStoreDetails.value ==
                                  storeDivision.firstMegaStoreDetails,
                        ),
                        5.widthBox,
                        SBOButtonCustom(
                          title: "${storeDivision.secondMegaStoreDetails?.storeName}",
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            appBarController.onChangeDivision(storeDivision.secondMegaStoreDetails!);
                          },
                          isEnabled:
                          storeDivision.selectedStoreDetails.value ==
                              storeDivision.secondMegaStoreDetails,
                        ),
                      ],
                    )
                  : Text(
                      storeDivision.selectedStoreDetails.value?.storeName ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            centerTitle: storeDivision.storeType.value == StoreType.standalone ? true : false,
            elevation: 0,
            backgroundColor: ColorConstants.primaryRedColor,
            leading: showBackBtn
                ? IconButton(
                    onPressed: () => onBack != null ? onBack() : null,
                    icon: const Icon(Icons.arrow_back))
                : null);
}

AppBar customizedAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
  );
}
