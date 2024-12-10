import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../common/ui.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../controller/validation_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParcelView extends GetView<ValidationController> {

  List bookings = [];
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: backgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0)), ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() => Expanded(
                  child: controller.isLoading.value ?
                  Container(
                      child: LoadingCardWidget()) :
                  controller.shipping.isNotEmpty ?
                  ListView.builder(
                      itemCount: controller.shipping.length,
                      itemBuilder: (context, index){

                        String departureCity =controller.shipping[index]['travelbooking_id'] != false ?controller.shipping[index]['travel_departure_city_name'].split('(').first:controller.shipping[index]['shipping_departure_city_id'][1].split('(').first;
                        String a = controller.shipping[index]['travelbooking_id'] != false ?controller.shipping[index]['travel_departure_city_name'].split('(').last:controller.shipping[index]['shipping_departure_city_id'][1].split('(').last;
                        String departureCountry = a.split(')').first;

                        String arrivalCity = controller.shipping[index]['travelbooking_id'] != false ?controller.shipping[index]['travel_arrival_city_name'].split('(').first:controller.shipping[index]['shipping_arrival_city_id'][1].split('(').first;

                        String b = controller.shipping[index]['travelbooking_id'] != false ? controller.shipping[index]['travel_arrival_city_name'].split('(').last:controller.shipping[index]['shipping_arrival_city_id'][1].split('(').last;
                        String arrivalCountry = b.split(')').first;

                        // String departureCity = controller.shipping[index]['travel_departure_city_name'].split('(').first;
                        // String a = controller.shipping[index]['travel_departure_city_name'].split('(').last;
                        // String departureCountry = a.split(')').first;
                        //
                        // String arrivalCity = controller.shipping[index]['travel_arrival_city_name'].split('(').first;
                        // String b = controller.shipping[index]['travel_arrival_city_name'].split('(').last;
                        // String arrivalCountry = b.split(')').first;

                        Future.delayed(Duration.zero, (){
                          controller.shipping.sort((a, b) => a['shipping_date'].compareTo(b['shipping_date']));
                        });
                        var bookingState = controller.shipping[index]['state'];
                        return bookingState != "pending"
                            ? InkWell(
                            onTap: ()=>{
                              Get.bottomSheet(
                                buildBookingSheet(context, controller.shipping[index]['travel_code'], controller.shipping[index]),
                                isScrollControlled: true,
                              )
                            },
                            child: ClipRRect(
                                child: Card(
                                    margin: index == controller.shipping.length - 1 ? EdgeInsets.only(bottom: 250) : EdgeInsets.only(bottom: 10),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      //side: BorderSide(color: interfaceColor.withOpacity(0.4), width: 2),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Banner(
                                        message: bookingState == "received" ? AppLocalizations.of(context).delivered : bookingState == "confirm" ? AppLocalizations.of(context).received : bookingState,
                                        location: BannerLocation.topEnd,
                                        color: bookingState == 'accepted' ? pendingStatus : bookingState == 'rejected' ? specialColor :
                                        bookingState == 'received' ? doneStatus : bookingState == "paid" ? validateColor : bookingState == "confirm" ? interfaceColor : inactive,
                                        child: Column(
                                          //alignment: AlignmentDirectional.topStart,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                      children: [
                                                        Text(AppLocalizations.of(context).reference, style: Get.textTheme.headline2.
                                                        merge(TextStyle(color: buttonColor, fontSize: 16))),
                                                        Container(
                                                          margin: EdgeInsets.symmetric(horizontal: 12),
                                                          width: 1,
                                                          height: 24,
                                                          color: Get.theme.focusColor.withOpacity(0.3),
                                                        ),
                                                        Text(controller.shipping[index]['name'], style: Get.textTheme.headline1.
                                                        merge(TextStyle(color: buttonColor, fontSize: 16)),
                                                        )
                                                      ]
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      if(controller.shipping[index]['booking_type'] == "By Air")
                                                        Icon(FontAwesomeIcons.planeCircleCheck, size: 30, color: background),
                                                      if(controller.shipping[index]['booking_type'] == "By Road")
                                                        Icon(FontAwesomeIcons.bus, size: 30, color: background),
                                                      if(controller.shipping[index]['booking_type'] == "By Sea")
                                                        Icon(FontAwesomeIcons.ship, size: 30, color: background) ,
                                                      Container(
                                                          alignment: Alignment.topCenter,
                                                          width: Get.width/3,
                                                          child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(text: departureCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                                                    TextSpan(text: "\n$departureCountry", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                                                                  ]
                                                              ))
                                                      ),
                                                      FaIcon(FontAwesomeIcons.arrowRight),
                                                      Container(
                                                          alignment: Alignment.topCenter,
                                                          width: Get.width/3,
                                                          child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(text: arrivalCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                                                    TextSpan(text: "\n$arrivalCountry", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                                                                  ]
                                                              ))
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed: ()=> {
                                                      Get.bottomSheet(
                                                        buildBookingSheet(context, controller.shipping[index]['travel_code'], controller.shipping[index]),
                                                        isScrollControlled: true,
                                                      )
                                                    },
                                                    child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                )
                            )
                        ) : SizedBox();
                      }) : Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height /4),
                        FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                        Text(AppLocalizations.of(context).noShippingFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                      ]
                  )
              ))
            ]
        )
    );
  }

  Widget buildBookingSheet(BuildContext context, var travelCode, var shipping){

    return Container(
        height: Get.height/1.2,
        decoration: BoxDecoration(
          color: background,
          //Get.theme.primaryColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
          ],
        ),
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 30,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: (Get.width / 2) - 30),
                  decoration: BoxDecoration(
                    color: Get.theme.focusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.focusColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    //child: SizedBox(height: 1,),
                  ),
                ),
                SizedBox(height: 20),
                Text(AppLocalizations.of(context).shippingValidation, style: Get.textTheme.headline4.merge(TextStyle(fontSize: 20))),
                SizedBox(height: 20),
                DelayedAnimation(
                    delay: 100,
                    child: Container(
                        padding: EdgeInsets.only(top: 00,bottom: 20, left: 60, right: 60),
                        child: QrImageView(
                          data: "$travelCode-${shipping['shipping_id']}",
                          version: QrVersions.auto,
                          size: 200,
                          gapless: false,
                        )
                    )
                ),
                SizedBox(height: 20),
                Text('------ ${AppLocalizations.of(context).orUpperCase} ------'.tr, style: TextStyle(fontSize: 20)),

                SizedBox(height: 20),
                DelayedAnimation(delay: 200,
                    child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                            ],
                            border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text( AppLocalizations.of(context).validationCode.tr,
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                            Obx(() => TextFormField(
                              initialValue: "$travelCode-${shipping['shipping_id']}",
                              //controller: codeController,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: ()=> {

                                        controller.copyPressed.value = true,
                                        Clipboard.setData(ClipboardData(text: "$travelCode-${shipping['shipping_id']}"))

                                      },
                                      icon: Icon(Icons.file_copy, color:controller.copyPressed.value ? validateColor : null)
                                  )
                              ),
                              style: Get.textTheme.bodyText2,
                              readOnly: true,
                              obscureText: false,
                              textAlign: TextAlign.start,
                            )),
                            //IconButton(onPressed: ()=>{}, icon: Icon(Icons.file_copy))
                          ],
                        )
                    )),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: ()async{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context).loadingData),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height - 100,
                            left: 10,
                            right: 10),
                        duration: Duration(seconds: 3),
                      ));
                      await controller.getLuggageInfo(shipping['luggage_ids'][0][0]);
                      print(shipping['luggage_ids'][0][0]);

                      showDialog(
                          context: context,
                          builder: (_){
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  )),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height/1.5,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Text(AppLocalizations.of(context).luggageInfo.tr, style: Get.textTheme.bodyText1.
                                      merge(TextStyle(color: appColor, fontSize: 17))),
                                      SizedBox(height: 15),
                                      for(var a=0; a<controller.shippingLuggage.length; a++)...[
                                        SizedBox(
                                            width: double.infinity,
                                            height: 170,
                                            child:  Column(
                                              children: [
                                                Expanded(
                                                  child:ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: 3,
                                                      itemBuilder: (context, index){
                                                        return InkWell(
                                                            onTap: (){
                                                              showDialog(context: context, builder: (_){
                                                                return Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Material(
                                                                        child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                                                    ),
                                                                    ClipRRect(
                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                      child: FadeInImage(
                                                                        width: Get.width,
                                                                        height: Get.height/2,
                                                                        image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${controller.shippingLuggage[a]['id']}/luggage_image${index+1}?unique=true&file_response=true',
                                                                            headers: Domain.getTokenHeaders()),
                                                                        placeholder: AssetImage(
                                                                            "assets/img/loading.gif"),
                                                                        imageErrorBuilder:
                                                                            (context, error, stackTrace) {
                                                                          return Center(
                                                                              child: Container(
                                                                                  width: Get.width/1.5,
                                                                                  height: Get.height/3,
                                                                                  color: Colors.white,
                                                                                  child: Center(
                                                                                      child: Icon(Icons.photo, size: 150)
                                                                                  )
                                                                              )
                                                                          );
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                            },
                                                            child: Card(
                                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                                child: ClipRRect(
                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    child: FadeInImage(
                                                                      width: 120,
                                                                      height: 100,
                                                                      image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${controller.shippingLuggage[a]['id']}/luggage_image${index+1}?unique=true&file_response=true',
                                                                          headers: Domain.getTokenHeaders()),
                                                                      placeholder: AssetImage(
                                                                          "assets/img/loading.gif"),
                                                                      imageErrorBuilder:
                                                                          (context, error, stackTrace) {
                                                                        return Image.asset(
                                                                            'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                                                            width: 50,
                                                                            height: 50,
                                                                            fit: BoxFit.fitWidth);
                                                                      },
                                                                    )
                                                                )
                                                            )
                                                        );
                                                      }),
                                                )
                                              ],
                                            )
                                        ),
                                        SizedBox(height: 15),
                                        AccountWidget(
                                          icon: FontAwesomeIcons.rulerHorizontal,
                                          text: AppLocalizations.of(context).dimensions,
                                          value: "${controller.shippingLuggage[a]['average_width']} x ${controller.shippingLuggage[a]['average_height']}",
                                        ),
                                        AccountWidget(
                                          icon: FontAwesomeIcons.weightScale,
                                          text: AppLocalizations.of(context).weight,
                                          value: controller.shippingLuggage[a]['average_weight'].toString() + " Kg",
                                        ),
                                        AccountWidget(
                                          icon: Icons.description,
                                          text: AppLocalizations.of(context).description,
                                          value: controller.shippingLuggage[a]['name'],
                                        ),
                                        Spacer(),
                                        Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                                child: Text(AppLocalizations.of(context).back))
                                        )
                                      ],
                                    ],
                                  )
                              ),
                            );
                          }
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(AppLocalizations.of(context).viewLuggageInfo),
                    )
                )
              ],
            )
        )
    );
  }
}
