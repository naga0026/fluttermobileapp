import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:flutter/material.dart';

class SBOListTile extends StatelessWidget {
  const SBOListTile(
      {Key? key,
      required this.title,
      this.subTitle,
      this.swipeToLeftTitle,
      this.swipeToRightTitle,
      this.onDismiss})
      : super(key: key);
  final Widget title;
  final Widget? subTitle;
  final String? swipeToLeftTitle;
  final String? swipeToRightTitle;
  final Function(DismissDirection)? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.greyC9C9C9,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Dismissible(
        behavior: HitTestBehavior.deferToChild,
        dismissThresholds: const {
          DismissDirection.endToStart: .07,
          DismissDirection.startToEnd: .07
        },
        confirmDismiss: (direction) =>
            onDismiss != null ? onDismiss!(direction) : null,
        key: UniqueKey(),
        secondaryBackground: swipeToLeftTitle != null
            ? SwipeToLeftWidget(title: swipeToLeftTitle!)
            : const SizedBox(),
        background: swipeToRightTitle != null
            ? SwipeToRightWidget(
                title: swipeToRightTitle!,
              )
            : const SizedBox(),
        child: ListTile(
          title: title,
          subtitle: subTitle,
        ),
      ),
    );
  }
}

class SwipeToLeftWidget extends StatelessWidget {
  const SwipeToLeftWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: ColorConstants.primaryRedColor,
      child: Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class SwipeToRightWidget extends StatelessWidget {
  const SwipeToRightWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: ColorConstants.greyEEEE,
      child: Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
