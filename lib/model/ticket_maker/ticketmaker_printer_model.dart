import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:get/get.dart';

import '../../controller/login/user_management.dart';
import '../../controller/store_config/store_config_controller.dart';

class PerformTicketMaker {
  late String department;
  String? userId;
  late String category;
  late String? style;
  late String? uline;
  late String price;
  String? compareAt;
  String? line1;
  String? line2;
  String? YAline;

  PerformTicketMaker({
    required this.department,
    required this.category,
    this.userId,
    required this.price,
    required this.style,
    required this.uline,
    this.compareAt,
    this.line1,
    this.line2,
    this.YAline,
  });

  factory PerformTicketMaker.fromTicketMakerData(TicketMakerData data) {
    final storeConfigController = Get.find<StoreConfigController>();
    var userManagementController = Get.find<UserManagementController>();
    return PerformTicketMaker(
      userId: userManagementController.userData?.data?.userId ?? '',
      uline: storeConfigController.isMarshallsUSA() ? data.uline : null,
      style: storeConfigController.isMarshallsUSA() ? null : data.style,
      department: data.department,
      category: data.category ?? "00",
      price: data.price,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['department'] = department;
    data['category'] = category;
    data['compareAt'] = compareAt;
    data['price'] = price;
    if ((style ?? '').isNotEmpty) {
      data['style'] = style;
    }
    if ((uline ?? '').isNotEmpty) {
      data['uline'] = uline;
    }
    data['userId'] = userId;
    return data;
  }

  String getCurrency(){
    final storeConfigController = Get.find<StoreConfigController>();
    return storeConfigController.getCurrencySymbol();
  }

  String formattedPriceMarshalls(givenPrice) {
    return getCurrency()+ givenPrice
        .toString()
        .addLeadingZeroLengthFive
        .formattedPrice
        .toStringAsFixed(2);
  }

  String formattedPrice(givenPrice) {
    return getCurrency()+givenPrice
        .toString()
        .addLeadingZero
        .formattedPrice
        .toStringAsFixed(2);
  }

  String formatShoesPrice(givenPrice){
    return givenPrice
        .toString()
        .addLeadingZeroLengthFive
        .formattedPrice
        .toStringAsFixed(2);
  }


  getSixDigitPrice() {
    final storeConfigController = Get.find<StoreConfigController>();
    return "${storeConfigController.getCurrencySymbol()}${price.substring(0, price.length - 2)}.${price.substring(price.length - 2)}";
  }
}

class TicketMakerData {
  late String department;
  late String userId;
  late String category;
  String? style;
  String? uline;
  late String price;
  String? compairAt;
  String? line1;
  String? line2;
  String? YAline;

  TicketMakerData({
    required this.department,
    required this.category,
    required this.userId,
    required this.price,
    this.style,
    this.uline,
    this.compairAt,
    this.line1,
    this.line2,
    this.YAline,
  });
}
