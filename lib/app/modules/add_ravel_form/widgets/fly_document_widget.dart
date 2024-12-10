/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';

class FlyDocumentWidget extends StatelessWidget {
  final Icon icon;
  final Icon suffixIcon;
  final Widget text;
  final ValueChanged<void> onTap;

  const FlyDocumentWidget({
    Key key,
    this.icon,
    this.text,
    this.onTap,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap('');
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            icon,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Colors.white,
            ),
            Expanded(
              child: text,
            ),
            suffixIcon,
          ],
        ),
      ),
    );
  }
}

class DocumentWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String value;

  const DocumentWidget({
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
            child: Icon( icon,color: buttonColor, size: 18),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            width: 1,
            height: 24,
            color: Get.theme.focusColor.withOpacity(0.3),
          ),
          Expanded(
              child: Text(text, style: TextStyle(color: buttonColor))
          ),
          SizedBox(
            width: 130,
            child: Text(
              value, style: Get.textTheme.headline1.
            merge(TextStyle(color: buttonColor, fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }
}

