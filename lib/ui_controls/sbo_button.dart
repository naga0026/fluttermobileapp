import 'package:flutter/material.dart';

import '../utility/constants/colors/color_constants.dart';

class SBOButton extends StatelessWidget {
  const SBOButton(
      {Key? key, required this.title, required this.onPressed, this.iconName})
      : super(key: key);
  final String title;
  final VoidCallback onPressed;
  final IconData? iconName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: ColorConstants.redTabColor),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconName != null
                ? Icon(
                    iconName,
                    color: Colors.white,
                  )
                : const SizedBox(),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class SBOButtonCustom extends StatelessWidget {
  const SBOButtonCustom(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.isEnabled,
      this.width_ = 130,
      this.isAppbar = true,
      this.isLoading = false})
      : super(key: key);
  final String title;
  final VoidCallback onPressed;
  final bool isEnabled;
  final double width_;
  final bool isAppbar;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width:isLoading?width_-10:width_,
      duration: const Duration(seconds: 1),
      child: ElevatedButton(

          style: ElevatedButton.styleFrom(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor:
                  isEnabled ? Colors.white : ColorConstants.redTabColor),
          onPressed: isLoading?null:onPressed,
          child: isAppbar
              ? Text(
                  title,
                  style: TextStyle(
                      color: isEnabled
                          ? ColorConstants.primaryRedColor
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          isAppbar ? FontStyle.italic : FontStyle.normal),
                )
              : isLoading
                  ?   LinearProgressIndicator(
                    color: ColorConstants.primaryRedColor,
                  )
                  : Text(
                      title,
                      style: TextStyle(
                          color: isEnabled
                              ? ColorConstants.primaryRedColor
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              isAppbar ? FontStyle.italic : FontStyle.normal),
                    )),
    );
  }
}
