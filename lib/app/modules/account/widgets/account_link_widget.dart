/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';

class AccountLinkWidget extends StatelessWidget {
  final Icon icon;
  final Widget text;
  final ValueChanged<void> onTap;

  const AccountLinkWidget({
    Key key,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap('');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            icon,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
            Expanded(
              child: text,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Get.theme.focusColor,
            ),
          ],
        ),
      ),
    );
  }
}

class AccountWidget extends StatelessWidget {
  final IconData icon;
  final Widget text;
  final String value;

  const AccountWidget({
    Key key,
    this.icon,
    this.text,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Icon( icon,color: interfaceColor, size: 18),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            width: 1,
            height: 24,
            color: Get.theme.focusColor.withOpacity(0.3),
          ),
          Expanded(
            child: text,
          ),
          SizedBox(
            width: 100,
            child: Text(
              value, style: Get.textTheme.headline1.
            merge(TextStyle(color: Get.theme.focusColor, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}

