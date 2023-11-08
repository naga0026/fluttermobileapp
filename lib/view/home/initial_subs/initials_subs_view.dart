import 'package:base_project/controller/barcode/scanned_item_model.dart';
import 'package:base_project/model/sbo_field_model.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/ui_controls/sbo_navigation_rail.dart';
import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:base_project/utility/enums/markdowns_operation_enum.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/utility/extensions/list_extension.dart';
import 'package:base_project/view/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home/init_subs/init_subs_view_controller.dart';
import '../../../ui_controls/custom_text.dart';
import '../../../ui_controls/sbo_button.dart';
import '../../../ui_controls/sbo_text_field.dart';
import '../../../ui_controls/sbo_vertical_divider.dart';

class InitialSubsView extends BaseScreen {
  const InitialSubsView({Key? key}) : super(key: key);

  @override
  InitialSubsViewState createState() => InitialSubsViewState();
}

class InitialSubsViewState extends BaseScreenState<InitialSubsView> {
  final _initSubsViewController = Get.find<InitSubsViewController>();
  final GlobalKey<FormState> _initialsFormKey = GlobalKey<FormState>();

  @override
  bool get isScanningEnabled => true;

  @override
  bool get showAppBar => false;

  @override
  void onInitState() {
    super.onInitState();
    _initSubsViewController.initialize();
    _initSubsViewController.initialSetUp();
    _initSubsViewController.onClickClear();
   // _initSubsViewController.runCheckStockBeforeMovingInInitial();
  }

  @override
  void onDispose() {
    _initSubsViewController.arrayInitialMarkdownFields
        .map((element) => element.textEditingController.dispose());
    _initSubsViewController.subscription.cancel();
    _initSubsViewController.onScreenClose();
    super.onDispose();
  }

  @override
  Widget body() {
    return Obx(() {
      return Row(
        children: [
          SBONavigationRail(
            destinations: _initSubsViewController.initialsOperations
                .map((e) => e.rawValue)
                .toList(),
            onDestinationChange: (int destinationIndex) =>
                _initSubsViewController.onDestinationChange(destinationIndex),
            selectedIndex: _initSubsViewController.selectedIndex.value,
          ).paddingSymmetric(vertical: 10),
          const SBOVerticalDivider(),
          Expanded(
              child: _initSubsFieldView(
                  _initSubsViewController.selectedIndex.value)),
        ],
      );
    });
  }

  Widget _initSubsFieldView(int ind) {
    return Obx(() {
      logger.d(MarkdownOperationEnum.subs.rawValue);
      var selectedOperation = _initSubsViewController.initialsOperations[ind];
      if (selectedOperation == MarkdownOperationEnum.subs) {
        if (_initSubsViewController.subsCachingProgress.value < 100) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Caching in progress..."),
                LinearProgressIndicator(
                  value: _initSubsViewController.subsCachingProgress.value/100,
                  backgroundColor: ColorConstants.greyC9C9C9,
                  color: ColorConstants.primaryRedColor,
                ).paddingAll(10)
              ],
            ),
          );
        } else {
          return _subsFieldView();
        }
      } else if (selectedOperation == MarkdownOperationEnum.initials ||
          selectedOperation == MarkdownOperationEnum.mlu) {
        return _initialsAndMLUView();
      } else {
        return _noMarkdownWeekOpen();
      }
    });
  }

  Widget _subsFieldView() {
    if (_initSubsViewController.selectedOperation.value ==
            MarkdownOperationEnum.subs &&
        !_initSubsViewController.isMarkdownWeekOpen.value) {
      return _noMarkdownWeekOpen();
    } else {
      bool isInputEnable = _initSubsViewController.isKeyed.value;
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            scanOrEnter(),
            15.heightBox,
            Form(
              key: _initialsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _initSubsViewController.arraySubsMarkdownFields
                    .mapWithNextField<Widget, SBOFieldModel>(
                        (field, nextField) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SBOInputField(
                      enabled: isInputEnable,
                      sboFieldModel: field,
                      nextFocusNode: nextField?.focusNode,
                    ),
                  );
                }).toList(),
              ),
            ),
            _saveOrClearSubs()
          ],
        ).paddingSymmetric(horizontal: 10),
      );
    }
  }

  Widget _saveOrClear() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SBOButton(
            onPressed: () {
              if (_initialsFormKey.currentState!.validate()) {
                _initSubsViewController.initialMarkdownFields =
                    ScanOrEnteredItemModel();
                _initSubsViewController.initialMarkdownFields.isKeyed = true;
                _initSubsViewController.onClickPrint();
              }
            },
            title: TranslationKey.enterLabel.tr,
          ),
          SBOButton(
            onPressed: () {
              _initSubsViewController.onClickClear();
            },
            title: TranslationKey.clear.tr,
          ),
        ],
      ),
    );
  }

  Widget _saveOrClearSubs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SBOButton(
            onPressed: () {
              if (_initialsFormKey.currentState!.validate()) {
                _initSubsViewController.initialMarkdownFields =
                    ScanOrEnteredItemModel();
                _initSubsViewController.initialMarkdownFields.isKeyed = true;
                _initSubsViewController.onClickPrint();
              }
            },
            title: TranslationKey.enterLabel.tr,
          ),
          SBOButton(
            onPressed: () {
              _initSubsViewController.onClickClearSubs();
            },
            title: TranslationKey.clear.tr,
          ),
        ],
      ),
    );
  }

  Widget _noMarkdownWeekOpen() {
    return Center(
      child: Text(TranslationKey.noMarkdownWeek.tr),
    );
  }

  Widget _initialsAndMLUView() {
    if (_initSubsViewController.selectedOperation.value ==
            MarkdownOperationEnum.initials &&
        !_initSubsViewController.isMarkdownWeekOpen.value) {
      return _noMarkdownWeekOpen();
    } else {
      bool isInputEnable = _initSubsViewController.isKeyed.value;
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            scanOrEnter(),
            15.heightBox,
            Form(
              key: _initialsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _initSubsViewController.arrayInitialMarkdownFields
                    .mapWithNextField<Widget, SBOFieldModel>(
                        (field, nextField) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SBOInputField(
                      enabled: isInputEnable,
                      sboFieldModel: field,
                      nextFocusNode: nextField?.focusNode,
                    ),
                  );
                }).toList(),
              ),
            ),
            _saveOrClear()
          ],
        ).paddingSymmetric(horizontal: 10),
      );
    }
  }
}
