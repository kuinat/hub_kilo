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
    @required this.recName,
    @required this.recEmail,
    @required this.recAddress,
    @required this.recPhone,
    @required this.qty,
    @required this.edit,
    @required this.confirm,
    @required this.price,
    @required this.text,
    @required this.onPressed}) : super(key: key);

  final Color color;
  final String user;
  final String text;
  final String recName;
  final String recEmail;
  final String recAddress;
  final String recPhone;
  final String depTown;
  final String arrTown;
  final String depDate;
  final String arrDate;
  final int qty;
  final double price;
  final String imageUrl;
  final VoidCallback onPressed;
  final Function edit;
  final Function confirm;

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
                      child: Text(depTown, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                    ),
                    FaIcon(FontAwesomeIcons.arrowRight),
                    Container(
                        alignment: Alignment.topCenter,
                        width: 100,
                        child: Text(arrTown, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18)))
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesomeIcons.planeCircleCheck, size: 20),
                    SizedBox(width: 20),
                    Text("From: $text", style: Get.textTheme.headline1.
                    merge(TextStyle(color: appColor, fontSize: 17)))
                  ],
                ),
                SizedBox(height: 10),
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
                    Text(depDate, style: Get.textTheme.headline1.
                    merge(TextStyle(color: appColor, fontSize: 16)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          Text(qty.toString(), style: Get.textTheme.headline1.
                          merge(TextStyle(color: appColor, fontSize: 16)))
                        ],
                      ),
                    ),
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
                          Text(price.toString(), style: Get.textTheme.headline6.
                          merge(TextStyle(color: specialColor, fontSize: 16)))
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(FontAwesomeIcons.userCheck, size: 20),
                  title: Text("Receiver Info".tr, style: Get.textTheme.bodyText1.
                  merge(TextStyle(color: appColor, fontSize: 17))),
                  children: [
                    AccountWidget(
                      icon: FontAwesomeIcons.person,
                      text: Text('Full Name'),
                      value: recName,
                    ),
                    AccountWidget(
                      icon: Icons.alternate_email,
                      text: Text('Email'),
                      value: recEmail,
                    ),
                    AccountWidget(
                      icon: FontAwesomeIcons.addressCard,
                      text: Text('Address'),
                      value: recAddress,
                    ),
                    AccountWidget(
                      icon: FontAwesomeIcons.phone,
                      text: Text('Phone'),
                      value: recPhone,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: edit,
                          child: Card(
                              elevation: 10,
                              color: inactive,
                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  child: Text(" Edit ".tr, style: TextStyle(color: Colors.white),),)
                          )
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: confirm,
                          child: Card(
                              elevation: 10,
                              color: specialColor,
                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  child: Text("Delete".tr, style: TextStyle(color: Colors.white)))
                          )
                        ),
                      ],
                    )
                  ],
                  initiallyExpanded: false,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}