/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';

import '../../../../common/ui.dart';

class EServiceTilWidget extends StatelessWidget {
  final Widget title;
  final Widget title2;
  final Widget content;
  final List<Widget> actions;
  final double horizontalPadding;

  const EServiceTilWidget({Key key, this.title2, this.title, this.content, this.actions, this.horizontalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: title),
              title2
            ],
          ),
          Divider(
            height: 26,
            thickness: 1.2,
          ),
          content,
        ],
      ),
    );
  }
}
