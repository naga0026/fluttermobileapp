import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/sbo_field_model.dart';
import '../utility/constants/colors/color_constants.dart';

class SBOTextField extends FormField<String> {
  SBOTextField(
      {super.key,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      bool autoValidate = false,
      String? hint,
      String? label,
      TextEditingController? controller,
      int? maxLength,
      List<TextInputFormatter>? formatters,
      TextInputType? keyboardType,
      bool? enableInteractiveSelection,
      FocusNode? focusNode,
      TextInputAction? inputAction,
      bool isSecure = false,
      bool autoFocusNextOnMaxLength = true,
      Function(String?)? onChanged,
      Widget? prefixIcon,
      Widget? suffixIcon,
      bool isEnabled = true,
      String? errorText})
      : super(
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<String> state) {
              return TextFormField(
                enabled: isEnabled,
                obscureText: isSecure,
                textInputAction: inputAction,
                focusNode: focusNode,
                enableInteractiveSelection: enableInteractiveSelection,
                controller: controller,
                maxLength: maxLength,
                inputFormatters: formatters,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    contentPadding: const EdgeInsets.only(left: 8, right: 8),
                    counter: const SizedBox(),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: hint,
                    labelText: label,
                    errorText: errorText,
                    hintStyle: const TextStyle(color: Colors.grey)),
                onChanged: onChanged,
              );
            });
}

class SBOInputField extends StatefulWidget {
  const SBOInputField(
      {Key? key,
      required this.sboFieldModel,
      this.enabled = true,
      this.onChange,
      this.nextFocusNode, this.suffixIconWidget})
      : super(key: key);
  final SBOFieldModel sboFieldModel;
  final bool enabled;
  final Function(String?)? onChange;
  final FocusNode? nextFocusNode;
  final Widget? suffixIconWidget;

  @override
  State<SBOInputField> createState() => _SBOInputFieldState();
}

class _SBOInputFieldState extends State<SBOInputField> {
  var list = List<int>.generate(20, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      focusNode: widget.sboFieldModel.focusNode,
      onChanged: (updatedText){
        if(widget.onChange != null){
          widget.onChange!(updatedText);
        }
        if(widget.sboFieldModel.sboField.maxLength == updatedText.length){
          // When the text field is filled with the maximum input length move to next focus
          _focusNextField();
        }
      },
      enabled: widget.enabled,
      showCursor: widget.sboFieldModel.sboField != SBOField.quantity,
      onTap: widget.sboFieldModel.sboField == SBOField.quantity
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showDialog();
            }
          : null,
      inputFormatters: widget.sboFieldModel.sboField.formatters,
      keyboardType: widget.sboFieldModel.sboField.keyBoardType,
      enableInteractiveSelection:
          widget.sboFieldModel.sboField == SBOField.quantity ? false : true,
      maxLength: widget.sboFieldModel.sboField.maxLength,
      controller: widget.sboFieldModel.textEditingController,
      validator: widget.enabled
          ? (val) {
              if (widget.sboFieldModel.sboField == SBOField.price ||
                  widget.sboFieldModel.sboField == SBOField.newPrice ||
                  widget.sboFieldModel.sboField == SBOField.compareAt ||
                  widget.sboFieldModel.sboField == SBOField.ourPrice ||
                  widget.sboFieldModel.sboField == SBOField.ticketPrice ||
                  widget.sboFieldModel.sboField == SBOField.currentPrice) {
                if (val!.isEmpty || val == "0.00") {
                  return widget.sboFieldModel.sboField.errorMessage;
                }
              } else if (widget.sboFieldModel.sboField == SBOField.category ||widget.sboFieldModel.sboField == SBOField.controlNumber ||
                  widget.sboFieldModel.sboField == SBOField.department) {
                if (val!.isEmpty || ![2, 4].contains(val.length)) {
                  return widget.sboFieldModel.sboField.errorMessage;
                }
              } else if (widget.sboFieldModel.sboField == SBOField.quantity) {
                if (val!.isEmpty || val == "0") {
                  return widget.sboFieldModel.sboField.errorMessage;
                }
              } else {
                if (val!.isEmpty || val.length != widget.sboFieldModel.sboField.maxLength) {
                  return widget.sboFieldModel.sboField.errorMessage;
                }
              }
              return null;
            }
          : null,
      onFieldSubmitted: (_)=> _focusNextField(),
      textInputAction: widget.nextFocusNode != null
          ? TextInputAction.next
          : TextInputAction.done,
      decoration: InputDecoration(
          // errorStyle: const TextStyle(height: -0.12),
        suffixIcon: widget.suffixIconWidget,
          errorMaxLines: 3,
          contentPadding: const EdgeInsets.only(left: 8, right: 8),
          counter: const SizedBox(),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          hintText: widget.sboFieldModel.sboField.hint,
          labelText: widget.sboFieldModel.sboField.title,
          hintStyle: const TextStyle(color: Colors.grey)),
    ).paddingOnly(bottom: 10);
  }

  void _showDialog() {
    int selectedValue = 1;
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Container(
                      color: ColorConstants.lightGreyColor,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              )),
                          TextButton(
                              onPressed: () {
                                widget.sboFieldModel.textEditingController.text =
                                    selectedValue.toString();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                    color: ColorConstants.primaryRedColor,
                                    fontSize: 16),
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int value) {
                          selectedValue = list[value];
                        },
                        children: List.generate(
                            list.length,
                            (index) => Center(
                                  child: Text(list[index].toString()),
                                )),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  void _focusNextField() {
    if (widget.nextFocusNode != null) {
      FocusScope.of(context).requestFocus(widget.nextFocusNode);
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
