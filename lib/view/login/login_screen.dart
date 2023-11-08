import 'dart:io';

import 'package:base_project/controller/initial_view_controller.dart';
import 'package:base_project/controller/login/login_view_controller.dart';
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/services/navigation/routes/route_names.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/ui_controls/sbo_button.dart';
import 'package:base_project/ui_controls/sbo_text_field.dart';
import 'package:base_project/utility/constants/app/size_constants.dart';
import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/view/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../services/navigation/navigation_service.dart';
import '../../ui_controls/loading_overlay.dart';
import '../../utility/constants/images_and_icons/image_constants.dart';

class LoginScreen extends BaseScreen {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends BaseScreenState<LoginScreen> {
  final loginController = Get.find<LoginViewController>();
  final initialController = Get.find<InitialController>();
  final storeConfigController = Get.find<StoreConfigController>();
  final readingConfigController = Get.find<ReadConfigFileController>();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    LoadingOverlay.hide();
  }

  @override
  void setAppBar() {
    super.setAppBar();
    showAppBar = false;
  }

  @override
  Widget body() {
    var height = MediaQuery.of(context).size.height;
    var loginBtnHeight = (height * 40) / SizeConstants.kZebraTC52Height;
    return Obx(() {
        if(loginController.isConnectedToNetwork.value == true){
          return WillPopScope(
            onWillPop: () async {
              final result = NavigationService.showDialog(
                  buttonText: "yes",
                  title: "Do you want to exit ?",
                  subtitle: "",
                  buttonCallBack: () => exit(0),
                  isAddCancelButton: true,
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                    size: 50,
                  ));
              return true;
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    20.heightBox,
                    Image.asset(
                      ImageConstants.tjxLogoImage,
                      height: 75,
                    ).paddingOnly(left: 20, right: 20),
                    40.heightBox,
                    Center(
                      child: Form(
                        child: Column(
                          children: [

                            SBOButton(title: "Network Configuration", onPressed: (){
                              Get.toNamed(RouteNames.networkConfigurationScreen);
                            }),
                            30.heightBox,
                            SBOTextField(
                              onChanged: (value) {
                                loginController.username.value = value ?? '';
                                loginController.validateLogIn();
                                if (value?.length == LoginViewController.credentialLength) {
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                }
                              },
                              maxLength: LoginViewController.credentialLength,
                              controller: loginController.usernameController,
                              hint: 'Username',
                              prefixIcon: const Icon(Icons.person),
                              keyboardType: TextInputType.number,
                              formatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                            20.heightBox,
                            SBOTextField(
                              focusNode: _passwordFocusNode,
                              maxLength: LoginViewController.credentialLength,
                              onChanged: (value) {
                                loginController.password.value = value ?? '';
                                loginController.validateLogIn();
                                if (loginController.passwordController.text.length ==
                                    LoginViewController.credentialLength&&
                                    loginController.usernameController.text.length ==
                                        LoginViewController.credentialLength) {
                                  _passwordFocusNode.unfocus();
                                }
                              },
                              controller: loginController.passwordController,
                              isSecure: true,
                              hint: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              keyboardType: TextInputType.number,
                              formatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                            50.heightBox,
                            Obx(() {
                              bool isEnabled = loginController.isLoginEnabled.value;
                              return Container(
                                height: loginBtnHeight,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: isEnabled
                                        ? ColorConstants.primaryRedColor
                                        : ColorConstants.primaryRedColor
                                        .withOpacity(0.5)),
                                child: TextButton(
                                  onPressed: isEnabled
                                      ? () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    loginController.onClickLogin();
                                  }
                                      : null,
                                  child: Text(
                                    TranslationKey.login.tr,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ).paddingOnly(left: 20, right: 20),
                    ),
                    70.heightBox,
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                      height: 3,
                      thickness: 2,
                      color: Colors.grey,
                    ).paddingOnly(top: 20),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SBO v1.0.0.0",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              loginController.physicalResponseService.errorBeep();
              NavigationService.showDialogWithOk(
                  title: TranslationKey.errorLabel.tr,
                  message: TranslationKey.networkError.tr,
                  onClickOk: () {
                    exit(0);
                  }
              );
            });
          return Container();
        }
      }
    );
  }
}
