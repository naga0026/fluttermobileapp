import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/scanning/zebra_scan_service.dart';
import '../../utility/logger/logger_config.dart';


abstract class BaseScannerScreen extends StatefulWidget {
  const BaseScannerScreen({Key? key}) : super(key: key);

  @override
  State<BaseScannerScreen> createState() => BaseScannerScreenState();
}

class BaseScannerScreenState<T extends BaseScannerScreen> extends State<T> {

  final zebraScanService = Get.find<ZebraScanService>();
  final logger = LoggerConfig.initLog();
  bool isScanningEnabled = false;

  // @override
  // void initState() {
  //   super.initState();
  //   if (isScanningEnabled) {
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       Future.delayed(Duration.zero).then((value) {
  //         zebraScanService.enableDataWedge();
  //         logger.d('Scanner initialized');
  //       });
  //     });
  //   }
  // }
  //
  // @override
  // void dispose(){
  //   if(isScanningEnabled){
  //     zebraScanService.disableDataWedge();
  //     logger.d('Base scanner disposed');
  //   }
  //   super.dispose();
  // }



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}