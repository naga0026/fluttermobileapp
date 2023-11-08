import 'package:base_project/controller/initial_view_controller.dart';
import 'package:base_project/controller/login/login_view_controller.dart';
import 'package:base_project/controller/login/network/networkView_controller.dart';
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/view/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../translations/translation_keys.dart';
import '../../../ui_controls/sbo_text_field.dart';
import '../../../utility/constants/colors/color_constants.dart';

class NetworkConfigurationScreen extends BaseScreen {
  const NetworkConfigurationScreen({super.key});

  @override
  NetworkViewState createState() => NetworkViewState();
}

class NetworkViewState extends BaseScreenState<NetworkConfigurationScreen> {
  final initialController = Get.find<InitialController>();
  final loginController = Get.find<LoginViewController>();
  final readingConfigController = Get.find<ReadConfigFileController>();
  final nwtViewController = Get.put(NetworkViewController());

  @override
  bool get showAppBar => false;

  @override
  bool get showCustomAppBar => true;

  @override
  AppBar customAppBar() => AppBar(
        title: Text(
          TranslationKey.nwtConfiguration.tr,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );

  @override
  body() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(children: [
          Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      initialController.isRemoteEnabled.value
                          ? TranslationKey.isRemoteEnabled.tr
                          : TranslationKey.isRemoteDisabled.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: initialController.isRemoteEnabled.value,
                      onChanged: (bool value) =>
                          loginController.remoteSwitchController(),
                    ),
                  ],
                ),
                initialController.isRemoteEnabled.value?
                InkWell(
                    onTap: (){
                      showModalBottomSheet(context: context, builder: (context)=>ListView.builder(
                        itemCount: nwtViewController.labUrls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(

                            contentPadding: const EdgeInsets.all(5),
                            enableFeedback: true,
                            style: ListTileStyle.drawer,
                            selectedTileColor: ColorConstants.primaryRedColor,
                            leading: const Icon(Icons.personal_video_rounded,color: Colors.grey,),
                            onTap: (){

                              nwtViewController.changeRemoteIpAddress(nwtViewController.labUrls.entries.toList()[index]);
                            },
                            title: Text(nwtViewController.labUrls.keys.toList()[index]),
                          );
                        },));
                    },
                    child:SBOTextField(
                    isEnabled: initialController.isRemoteEnabled.value?false:true,
                    controller: initialController.isRemoteEnabled.value
                        ? loginController.remoteConnectionAddController
                        : loginController.ipConnectionAddController,
                    hint: initialController.isRemoteEnabled.value
                        ? nwtViewController.selectedLab.value
                        : loginController.ipBaseUrl.value == ''
                        ? 'Connection IP Address'
                        : loginController.ipBaseUrl.value,
                    prefixIcon: initialController.isRemoteEnabled.value
                        ? const Icon(Icons.wifi)
                        : const Icon(Icons.cell_wifi_sharp),)
                ):SBOTextField(
                  isEnabled: initialController.isRemoteEnabled.value?false:true,
                  controller: initialController.isRemoteEnabled.value
                      ? loginController.remoteConnectionAddController
                      : loginController.ipConnectionAddController,
                  hint: initialController.isRemoteEnabled.value
                      ? readingConfigController.appBaseURL?.apiBaseUrl
                      : loginController.ipBaseUrl.value == ''
                          ? 'Connection IP Address'
                          : loginController.ipBaseUrl.value,
                  prefixIcon: initialController.isRemoteEnabled.value
                      ? const Icon(Icons.wifi)
                      : const Icon(Icons.cell_wifi_sharp),
                ),
                20.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor:
                            ColorConstants.primaryRedColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          await loginController.onSwitchConnection();
                        },
                        icon: const Icon(
                          Icons.cached_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          initialController.isRemoteEnabled.value
                              ? TranslationKey.syncButtonRemote.tr
                              :TranslationKey.syncButtonIp.tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
