import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/global_widgets/pop_up_widget.dart';

import '../../../color_constants.dart';
import '../../models/booking_model.dart';
import '../account/widgets/account_link_widget.dart';
import '../bookings/controllers/bookings_controller.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key key,
    @required this.editable,
    @required this.transferable,
    @required this.accept,
    @required this.transfer,
    @required this.reject,
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
    @required this.bookingState,
    @required this.onPressed}) : super(key: key);

  final Color color;
  final String user;
  final String text;
  final String recName;
  final bool transferable;
  final bool editable;
  final String recEmail;
  final String recAddress;
  final String recPhone;
  final String depTown;
  final String arrTown;
  final String depDate;
  final String arrDate;
  final String bookingState;
  final int qty;
  final double price;
  final String imageUrl;
  final VoidCallback onPressed;
  final Function edit;
  final Function confirm;
  final Function accept;
  final Function reject;
  final Function transfer;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    var selected = Get.find<BookingsController>().currentState.value ;
    return Container(
      margin: EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: interfaceColor),
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
              color: Colors.white,
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
                    merge(TextStyle(color: appColor, fontSize: 17))),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(bookingState, style: Get.textTheme.headline1.merge(TextStyle(color: bookingState == 'accepted' ? interfaceColor : Colors.black54, fontSize: 12))),
                      decoration: BoxDecoration(
                          color: bookingState == 'accepted' ? interfaceColor.withOpacity(0.3) : inactive.withOpacity(0.3),
                          border: Border.all(
                            color: bookingState == 'accepted' ? interfaceColor.withOpacity(0.2) : inactive.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    )

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
                    selected == 0?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: editable?edit:
                              (){
                            showDialog(
                                context: context,
                                builder: (_)=>
                                    PopUpWidget(
                                      title: "You cannot edit a booking accepted or confirmed",
                                      cancel: 'Cancel',
                                      confirm: 'Ok',
                                      onTap: ()=>{
                                        Navigator.of(Get.context).pop(),
                                      }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                                    )
                            );
                          },
                          child: Card(
                              elevation: 10,
                              color: inactive,
                              margin: EdgeInsets.symmetric( vertical: 15),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal:30, vertical: 10),
                                  child: Text(" Edit ".tr, style: TextStyle(color: Colors.white),),)
                          )
                        ),
                        GestureDetector(
                            onTap: transferable?transfer:
                                (){
                                  showDialog(
                                      context: context,
                                      builder: (_)=>
                                          PopUpWidget(
                                            title: "You can transfer your booking only if it was rejected or is pending validation",
                                            cancel: 'Cancel',
                                            confirm: 'Ok',
                                            onTap: ()=>{
                                              Navigator.of(Get.context).pop(),
                                            }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                                          )
                                  );
                                },
                            child: Card(
                                elevation: 10,
                                color: transferable? validateColor:inactive,
                                margin: EdgeInsets.symmetric( vertical: 15),
                                child: Padding(
                                    padding: EdgeInsets.symmetric( horizontal:20, vertical: 10),
                                    child: Text("Transfer".tr, style: TextStyle(color: Colors.white)))
                            )
                        ),
                        GestureDetector(
                          onTap: confirm,
                          child: Card(
                              elevation: 10,
                              color: specialColor,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Text("Delete".tr, style: TextStyle(color: Colors.white)))
                          )
                        ),

                      ],
                    ):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: accept,
                            child: Card(
                                elevation: 10,
                                color: inactive,
                                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  child: Text(" Accept ".tr, style: TextStyle(color: Colors.white),),)
                            )
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                            onTap: reject,
                            child: Card(
                                elevation: 10,
                                color: specialColor,
                                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    child: Text("Refuse".tr, style: TextStyle(color: Colors.white)))
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