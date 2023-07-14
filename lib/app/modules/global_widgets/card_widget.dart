
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:app/app/modules/global_widgets/pop_up_widget.dart';

import '../../../color_constants.dart';
import '../../../main.dart';
import '../account/widgets/account_link_widget.dart';
import '../userBookings/controllers/bookings_controller.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key key,

    this.editable,
    this.transferable,
    this.accept,
    this.transfer,
    this.departureTown,
    this.arrivalTown,
    this.reject,
    this.packetImageUrl,
    this.negotiation,
    @required this.owner,
    @required this.luggageView,
    @required this.shippingDate,
    @required this.code,
    @required this.imageUrl,
    @required this.recName,
    @required this.recEmail,
    @required this.recAddress,
    @required this.recPhone,
    this.edit,
    this.confirm,
    @required this.button,
    @required this.price,
    @required this.travelType,
    @required this.text,
    @required this.bookingState
  }) : super(key: key);

  final Widget negotiation;
  final String text;
  final bool owner;
  final String departureTown;
  final String arrivalTown;
  final String code;
  final String recName;
  final Widget luggageView;
  final String shippingDate;
  final bool transferable;
  final bool editable;
  final String recEmail;
  final String recAddress;
  final String recPhone;
  final String bookingState;
  final String travelType;
  final Widget button;
  final double price;
  final String imageUrl;
  final String packetImageUrl;
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
    //var selected = Get.find<BookingsController>().currentState.value ;
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: interfaceColor.withOpacity(0.4), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          //alignment: AlignmentDirectional.topStart,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: shippingDate.split("T").first, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                          TextSpan(text: "\n${shippingDate.split("T").last.split(".").first}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                        ]
                    )
                ),
                Spacer(),
                Text(code, style: TextStyle(color: appColor, fontSize: 15)),
              ],
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
                        SizedBox(
                          width: 30,
                          child: Icon(FontAwesomeIcons.planeCircleCheck, size: 20),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          width: 1,
                          height: 24,
                          color: Get.theme.focusColor.withOpacity(0.3),
                        ),
                        Expanded(child: Text("From: $text", overflow: TextOverflow.ellipsis,style: Get.textTheme.headline1.
                        merge(TextStyle(color: appColor, fontSize: 17)))),
                        SizedBox(width: 40),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          alignment: Alignment.center,
                          child: Text(bookingState, style: Get.textTheme.headline2.merge(TextStyle(color: bookingState == 'accepted' ? interfaceColor : bookingState == 'rejected' ? specialColor :
                          bookingState == 'received' ? doneStatus : inactive, fontSize: 12))),
                          decoration: BoxDecoration(
                              color: bookingState == 'accepted' ? interfaceColor.withOpacity(0.3) : bookingState == 'rejected' ? specialColor.withOpacity(0.2) :
                              bookingState == 'received' ? doneStatus.withOpacity(0.3) : inactive.withOpacity(0.3),
                              border: Border.all(
                                color: bookingState == 'accepted' ? interfaceColor.withOpacity(0.2) : bookingState == 'rejected' ? specialColor.withOpacity(0.2) :
                                bookingState == 'received' ? doneStatus.withOpacity(0.2) : inactive.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                        )
                      ]
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if(bookingState == 'pending')
                      negotiation,
                      SizedBox(width: 10),
                      SizedBox(width: 200,
                          child: luggageView),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: button,
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
                      )
                    ],
                    initiallyExpanded: false,
                  ),
                  if(owner)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: editable ? edit :
                              (){
                            showDialog(
                                context: context,
                                builder: (_)=>
                                    PopUpWidget(
                                      title: "You cannot edit a shipping accepted or confirmed",
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
                              color: editable?Colors.blue:inactive,
                              margin: EdgeInsets.symmetric( vertical: 15),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal:30, vertical: 10),
                                child: Text(" Edit ".tr, style: TextStyle(color: Colors.white),),)
                          )
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: transferable ? transfer:
                              (){
                            showDialog(
                                context: context,
                                builder: (_)=>
                                    PopUpWidget(
                                      title: "You can transfer your shipping only if it was rejected or is pending validation",
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
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: editable ? confirm:(){
                            showDialog(
                                context: context,
                                builder: (_)=>
                                    PopUpWidget(
                                      title: "You cannot delete a Shipping accepted or confirmed",
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
                              color: editable?specialColor:inactive,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Text("Cancel".tr, style: TextStyle(color: Colors.white)))
                          )
                      ),
                    ],
                  )
            ])
            ),
          ],
        ),
      )
    );
  }
}