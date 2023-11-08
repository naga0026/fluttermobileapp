import 'package:base_project/utility/generic/mapping_model.dart';
import 'package:base_project/view/base/base_scanner_widget.dart';
import 'package:base_project/view/base/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseScreen extends BaseScannerScreen {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState<T extends BaseScreen>
    extends BaseScannerScreenState<BaseScreen> {
  bool showAppBar = true;
  bool showBackButton = false;

  bool showCustomAppBar = false;

  void setAppBar() {}

  void onInitState() {
    if (isScanningEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          zebraScanService.enableDataWedge();
          logger.d('Scanner initialized : ${typeOf<T>()}');
        });
      });
    }
  }

  void onDispose() {
    if(isScanningEnabled){
      zebraScanService.disableDataWedge();
      logger.d('Scanner disposed : ${typeOf<T>()}');
    }
  }

  void onClickBackButton() {
    Get.back();
  }

  Widget body() {
    return Container();
  }

  AppBar customAppBar() => AppBar();

  @override
  void initState() {
    super.initState();
    setAppBar();
    onInitState();
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: showAppBar
            ? SBOAppBar(
                onBack: () {
                  onClickBackButton();
                },
              )
            : showCustomAppBar
                ? customAppBar()
                : null,
        body: body());
  }
}
