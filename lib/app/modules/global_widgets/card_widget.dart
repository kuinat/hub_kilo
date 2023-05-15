import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../account/widgets/account_link_widget.dart';

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
      margin: EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              color: Get.theme.primaryColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 100,
                      child: Center(child: FaIcon(FontAwesomeIcons.planeDeparture)),
                    ),
                    Container(width: 100,
                      child: Center(child: FaIcon(FontAwesomeIcons.planeArrival)),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      width: 100,
                      child: Text("Yaounde", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                    ),
                    FaIcon(FontAwesomeIcons.arrowRight),
                    Container(
                        alignment: Alignment.topCenter,
                        width: 100,
                        child: Text("Douala", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18)))
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, interfaceColor.withOpacity(0.2)]
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(FontAwesomeIcons.ship),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Icon( FontAwesomeIcons.calendarDay,color: interfaceColor, size: 18),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Get.theme.focusColor.withOpacity(0.3),
                    ),
                    Expanded(
                      child: Text('Date de Départ'),
                    ),
                    Text(
                      '12/06/2020', style: Get.textTheme.headline1.
                    merge(TextStyle(color: Get.theme.focusColor, fontSize: 16)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Icon( FontAwesomeIcons.moneyCheck,color: interfaceColor, size: 18),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            width: 1,
                            height: 24,
                            color: Get.theme.focusColor.withOpacity(0.3),
                          ),
                          Text('250 EUR')
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text('Quantity /Kg'),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            width: 1,
                            height: 24,
                            color: Get.theme.focusColor.withOpacity(0.3),
                          ),
                          Text('18')
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}