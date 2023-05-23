/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../../../common/ui.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key key,
    this.initialValue,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.errorText,
    this.iconData,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.isFirst,
    this.editable,
    this.isLast,
    this.style,
    this.textAlign,
    this.suffix,
    this.onTap,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final Function() onTap;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final String hintText;
  final String errorText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final bool editable;
  final IconData iconData;
  final String initialValue;
  final bool obscureText;
  final bool isFirst;
  final bool isLast;
  final Widget suffixIcon;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      margin: EdgeInsets.only(left: 5, right: 5, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1.merge(TextStyle(color: labelColor)),
            textAlign: textAlign ?? TextAlign.start,
          ),
          TextFormField(
            initialValue: initialValue,
            maxLines: keyboardType == TextInputType.multiline ? null : 1,
            key: key,
            keyboardType: keyboardType ?? TextInputType.text,
            onSaved: onSaved,
            onTap: onTap,
            onChanged: onChanged,
            validator: validator,
            enabled: editable,
            style: style ?? Get.textTheme.bodyText2.merge(TextStyle(color: labelColor)),
            obscureText: obscureText ?? false,
            textAlign: textAlign ?? TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: hintText ?? '',
              iconData: iconData,
              suffixIcon: suffixIcon,
              suffix: suffix,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst && isLast != null && !isLast) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
