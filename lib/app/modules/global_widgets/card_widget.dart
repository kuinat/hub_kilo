import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key key,
    @required this.user,
    @required this.depTown,
    @required this.color,
    @required this.arrTown,
    @required this.imageUrl,
    @required this.arrDate,
    @required this.depDate,
    @required this.qty,
    @required this.price,
    @required this.text,
    @required this.onPressed}) : super(key: key);

  final Color color;
  final String user;
  final Widget text;
  final Widget depTown;
  final Widget arrTown;
  final Widget depDate;
  final Widget arrDate;
  final int qty;
  final double price;
  final String imageUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: EdgeInsetsDirectional.only(end: 20, start: 20, top: 20, bottom: 10),
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        //alignment: AlignmentDirectional.topStart,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              height: 130,
              color: Colors.white,
              child: Center(
                child: FaIcon(FontAwesomeIcons.planeDeparture, size: 40)
              )
            )
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(user,
                  maxLines: 1,
                  style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      "Start from".tr,
                      style: Get.textTheme.caption,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        depDate,
                        arrDate
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}