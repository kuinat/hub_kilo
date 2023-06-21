import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
    this.reject,
    this.packetImageUrl,

    @required this.negotiation,
    @required this.depTown,
    @required this.arrTown,
    @required this.imageUrl,
    @required this.arrDate,
    @required this.depDate,
    @required this.recName,
    @required this.recEmail,
    @required this.recAddress,
    @required this.recPhone,
    @required this.qty,
    @required this.typeOfLuggage,
    this.edit,
    this.confirm,
    @required this.price,
    @required this.travelType,
    @required this.text,
    @required this.bookingState}) : super(key: key);

  final Widget negotiation;
  final String text;
  final String recName;
  final bool transferable;
  final bool editable;
  final String recEmail;
  final String recAddress;
  final String recPhone;
  final String depTown;
  final String arrTown;
  final String typeOfLuggage;
  final String depDate;
  final String arrDate;
  final String bookingState;
  final String travelType;
  final int qty;
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
    var selected = Get.find<BookingsController>().currentState.value ;
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: interfaceColor.withOpacity(0.4), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        child: Column(
          //alignment: AlignmentDirectional.topStart,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  travelType.toLowerCase()=='air'?
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
                  ):travelType.toLowerCase()=='road'?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 100,
                        child: Center(child: FaIcon(FontAwesomeIcons.car)),
                      ),
                      Container(width: 100,
                        child: Center(child: FaIcon(FontAwesomeIcons.car)),
                      )
                    ],
                  ):
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
                        Expanded(child: Text("From: $text", style: Get.textTheme.headline1.
                        merge(TextStyle(color: appColor, fontSize: 17)))),
                        SizedBox(width: 40),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          alignment: Alignment.center,
                          child: Text(bookingState, style: Get.textTheme.headline2.merge(TextStyle(color: bookingState == 'accepted' ? interfaceColor : Colors.black54, fontSize: 12))),
                          decoration: BoxDecoration(
                              color: bookingState == 'accepted' ? interfaceColor.withOpacity(0.3) : inactive.withOpacity(0.3),
                              border: Border.all(
                                color: bookingState == 'accepted' ? interfaceColor.withOpacity(0.2) : inactive.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                        )
                      ]
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Icon( FontAwesomeIcons.calendarDay, size: 18),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        width: 1,
                        height: 24,
                        color: Get.theme.focusColor.withOpacity(0.3),
                      ),
                      Expanded(
                        child: Text('Date de Départ', style: Get.textTheme.headline1.
                        merge(TextStyle(color: appColor, fontSize: 16))),
                      ),
                      Text(depDate, style: Get.textTheme.headline1.
                      merge(TextStyle(color: interfaceColor, fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Icon( FontAwesomeIcons.envelopeOpenText, size: 18),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        width: 1,
                        height: 24,
                        color: Get.theme.focusColor.withOpacity(0.3),
                      ),
                      Expanded(
                        child: Text('Description', style: Get.textTheme.headline1.
                        merge(TextStyle(color: appColor, fontSize: 16))),
                      ),
                      Text(typeOfLuggage, style: Get.textTheme.headline1.
                      merge(TextStyle(color: Colors.black, fontSize: 16)),
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
                            SizedBox(
                              width: 30,
                              child: Icon( Icons.attach_money_outlined, size: 18),
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
                      SizedBox(
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.shoppingBag, size: 18),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              width: 1,
                              height: 24,
                              color: Get.theme.focusColor.withOpacity(0.3),
                            ),
                            Text(qty.toString() + " Kg", style: Get.textTheme.headline1.
                            merge(TextStyle(color: appColor, fontSize: 16)))
                          ],
                        ),
                      ),

                    ],
                  ),
                ExpansionTile(
                  leading: Icon(FontAwesomeIcons.boxesPacking, size: 20),
                    title: Text("Packet Images".tr, style: Get.textTheme.bodyText1.
                    merge(TextStyle(color: appColor, fontSize: 17))),
                  children: [
                    SizedBox(
                      height:100,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(12),
                          itemBuilder: (context, index){
                            return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        //'${Domain.serverPort}/web/image/m2st_hk_airshipping.travel_booking/16/luggage_image1'
                                      '${packetImageUrl}${index+1}',
                                    ),
                                    fit: BoxFit.fill
                                ),
                                border: Border.all(width: 2, color: Get.theme.primaryColor),
                              ),
                            );
                          },
                          separatorBuilder: (context, index){
                            return SizedBox(width: 8);
                          },
                          itemCount: 3),
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
                    )
                ],
                  initiallyExpanded: false,
              ),
                  negotiation,
                  Row(
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
                              color: editable?Colors.blue:inactive,
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
                          onTap: editable? confirm:(){
                          showDialog(
                              context: context,
                              builder: (_)=>
                                  PopUpWidget(
                                    title: "You cannot delete a booking accepted or confirmed",
                                    cancel: 'Cancel',
                                    confirm: 'Ok',
                                    onTap: ()=>{
                                      Navigator.of(Get.context).pop(),
                                    }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                                  )
                          );},
                          child: Card(
                              elevation: 10,
                              color: editable?specialColor:inactive,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Text("Delete".tr, style: TextStyle(color: Colors.white)))
                          )
                      ),


                    ],
                  )
            ])),
          ],
        ),
      )
    );
  }
}