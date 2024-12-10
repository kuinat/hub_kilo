/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';

class DrawerLinkWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool special;
  final bool drawer;
  final ValueChanged<void> onTap;
  const DrawerLinkWidget({
    Key key,
    this.icon,
    this.text,
    this.onTap,
    this.drawer,
    this.special,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap('');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            drawer ?
            Icon(
              icon,
              color: !special ? buttonColor : specialColor, size: 22,
            ) : Icon(
              icon,
              color: !special ? buttonColor : specialColor,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Get.theme.focusColor.withOpacity(0.2),
            ),
            Expanded(
              child: Text(text.tr, style: Get.textTheme.bodyText2.merge(TextStyle(fontSize: 14, color: !special ? buttonColor : specialColor, fontWeight: FontWeight.normal))),
            ),
          ],
        ),
      ),
    );
  }
}
