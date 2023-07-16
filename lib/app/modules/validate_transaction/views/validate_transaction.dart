import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../../common/ui.dart';
import '../../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../controller/validation_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../main.dart';

class ValidationView extends GetView<ValidationController> {

  List bookings = [];
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Validate Transaction".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {Navigator.pop(context)},
          ),

        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          decoration: Ui.getBoxDecoration(color: backgroundColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: ()=>{
                          controller.currentState.value = 0
                        },
                        child: Obx(()=> Card(
                            color: controller.currentState.value == 0 ? interfaceColor : inactive,
                            elevation: controller.currentState.value == 0 ? 10 : null,
                            shadowColor:  inactive,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Validate Delivery'.tr, style: TextStyle(color: Get.theme.primaryColor))
                            )
                        ))
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                        onTap: ()=>{
                          controller.currentState.value = 1
                        },
                        child: Obx(() => Card(
                            color: controller.currentState.value == 1 ? interfaceColor : inactive,
                            elevation: controller.currentState.value == 1 ? 10 : null,
                            shadowColor: inactive,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Delivery Code'.tr, style: TextStyle(color: Get.theme.primaryColor))
                            )
                        )
                        )
                    )
                  ],
                ),
                SizedBox(height: 20),
                Obx(() => controller.currentState.value == 0 ? confirmDelivery(context) : buildBookingList(context)
                //myDeliveryCode(context)
                )
              ],
            )
          ),
        )
    );
  }

  Widget confirmDelivery(BuildContext context){
    return Column(
      children: [
        if(controller.validationType.value == 0 || controller.validationType.value == 1)...[
          DelayedAnimation(
              delay: 100,
              child: GestureDetector(
                  onTap: ()=>{
                    controller.validationType.value = 1,
                    controller.scan()
                  },
                  child: Card(
                    color: interfaceColor,
                    elevation: 10,
                    shadowColor: inactive,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Icon(Icons.qr_code_scanner, size: 80, color: Colors.white),
                            SizedBox(height: 10),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Text('Scan Code'.tr, style: TextStyle(color: Get.theme.primaryColor)
                                )
                            )
                          ],
                        )
                    ),
                  )
              )
          ),
          SizedBox(height:60),
        ],
        if(controller.validationType.value == 0)
        Text('---------- OR ----------'.tr, style: TextStyle(fontSize: 20)),
        //Divider(color: inactive),
        SizedBox(height: 30),
        if(controller.validationType.value == 0 || controller.validationType.value == 2)
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
                Text( "Validation code".tr,
                  style: Get.textTheme.bodyText1,
                  textAlign: TextAlign.start,
                ),
                TextFormField(
                  maxLines: 1,
                  controller: controller.codeController,
                  onTap: ()=>{
                    controller.validationType.value = 2
                  },
                  //validator: validator,
                  style: Get.textTheme.bodyText2,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  decoration: Ui.getInputDecoration(
                    hintText: 'xxxx xxxx xxxx',
                    iconData: Icons.lock,
                  ),
                ),
              ],
            )
        )),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(controller.validationType.value != 0)
            DelayedAnimation(delay: 250,
                child: GestureDetector(
                    onTap: ()=>{
                      controller.validationType.value = 0
                    },
                    child: Obx(()=> Card(
                        color: controller.validationType.value != 0 ? specialColor : null,
                        elevation: controller.validationType.value != 0 ? 10 : null,
                        shadowColor:  controller.validationType.value != 0 ? specialColor :  null,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Cancel'.tr, style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)))
                        )
                    ))
                ),
            ),
            DelayedAnimation(delay: 250,
                child: BlockButtonWidget(
                  onPressed: () {
                    controller.verifyCode(controller.codeController.text.split('-').first, controller.codeController.text.split('-').last);
                    Timer(Duration(milliseconds: 100), () {
                      controller.codeController.clear();
                    });
                  },
                  color: Get.theme.colorScheme.secondary,
                  text: Text(
                    "Validate Transaction".tr,
                    style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                ).paddingSymmetric(vertical: 10, horizontal: 20)
            )
          ],
        )
      ],
    );
  }

  Widget buildBookingList(BuildContext context){

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                border: Border.all(
                  color: Get.theme.focusColor.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () {
                //Get.toNamed(Routes.SEARCH, arguments: controller.heroTag.value);
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 0),
                    child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
                  ),
                  Expanded(
                    child: Material(
                      color: Get.theme.primaryColor,
                      child: TextField(
                        //controller: controller.textEditingController,
                        style: Get.textTheme.bodyText2,
                        onChanged: (value)=> controller.filterSearchResults(value),
                        autofocus: false,
                        cursorColor: Get.theme.focusColor,
                        decoration: Ui.getInputDecoration(hintText: "Destination town...".tr),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => Expanded(
              child: controller.isLoading.value ?
              LoadingCardWidget() :
              controller.shipping.isNotEmpty ?
              ListView.builder(
                  itemCount: controller.shipping.length,
                  itemBuilder: (context, index){

                    String departureCity = controller.shipping[index]['travel_departure_city_name'].split('(').first;
                    String a = controller.shipping[index]['travel_departure_city_name'].split('(').last;
                    String departureCountry = a.split(')').first;

                    String arrivalCity = controller.shipping[index]['travel_arrival_city_name'].split('(').first;
                    String b = controller.shipping[index]['travel_arrival_city_name'].split('(').last;
                    String arrivalCountry = b.split(')').first;

                    Future.delayed(Duration.zero, (){
                      controller.shipping.sort((a, b) => a['create_date'].compareTo(b['create_date']));
                    });
                    return InkWell(
                        onTap: ()=>{
                          Get.bottomSheet(
                            buildBookingSheet(context, controller.shipping[index]['travel_code'], controller.shipping[index]['id']),
                            isScrollControlled: true,
                          )
                        },
                        child: ClipRRect(
                          child: Card(
                              elevation: 10,
                              margin: index == controller.shipping.length - 1 ? EdgeInsets.only(bottom: 50) : null,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                //side: BorderSide(color: interfaceColor.withOpacity(0.4), width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Banner(
                                  message: controller.shipping[index]['is_paid'] ? 'Paid' : "Pending",
                                  location: BannerLocation.topEnd,
                                  color: controller.shipping[index]['is_paid'] ? validateColor : inactive,
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
                                                    width: 100,
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
                                                Text("${controller.travelInfo['departure_date']} \n- ${controller.travelInfo['arrival_date']}", style: Get.textTheme.headline1.
                                                merge(TextStyle(color: interfaceColor, fontSize: 16)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                                onPressed: ()async{
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text("Loading data..."),
                                                    duration: Duration(seconds: 4),
                                                  ));
                                                  List luggageIds = [];
                                                  for(var a in controller.shipping[index]['luggage_ids']){
                                                    if(!luggageIds.contains(a['id'])){
                                                      luggageIds.add(a['id']);
                                                    }
                                                  }
                                                  await controller.getLuggageInfo(luggageIds);
                                                  print(luggageIds);

                                                  await controller.getLuggageInfo(luggageIds);

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
                                                                  Text("Luggage Info".tr, style: Get.textTheme.bodyText1.
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
                                                                                    return Card(
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
                                                                                    );
                                                                                  }),
                                                                            )
                                                                          ],
                                                                        )
                                                                    ),
                                                                    AccountWidget(
                                                                      icon: FontAwesomeIcons.shoppingBag,
                                                                      text: Text('Name'),
                                                                      value: controller.shippingLuggage[a]['name'],
                                                                    ),
                                                                    AccountWidget(
                                                                      icon: FontAwesomeIcons.rulerHorizontal,
                                                                      text: Text('Dimensions'),
                                                                      value: "${controller.shippingLuggage[a]['average_width']} x ${controller.shippingLuggage[a]['average_height']}",
                                                                    ),
                                                                    AccountWidget(
                                                                      icon: FontAwesomeIcons.weightScale,
                                                                      text: Text('Average weight'),
                                                                      value: controller.shippingLuggage[a]['average_weight'].toString() + " Kg",
                                                                    ),
                                                                    Spacer(),
                                                                    Align(
                                                                        alignment: Alignment.bottomRight,
                                                                        child: TextButton(onPressed: (){
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                            child: Text('Back'))
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
                                                  child: Text('View luggage info'),
                                                )
                                            ),
                                            if(controller.shipping[index]['is_paid'])
                                              ElevatedButton(
                                                  onPressed: ()async{
                                                    showDialog(
                                                        context: context,
                                                        builder: (_){
                                                          return PopUpWidget(
                                                            cancel: 'Cancel',
                                                            confirm: 'Confirm',
                                                            onTap: ()=>{

                                                            },
                                                            icon: Icon(Icons.warning_amber_rounded, size: 40, color: inactive),
                                                            title: 'Do you really want to confirm reception of your luggage?',
                                                          );
                                                        });
                                                  },
                                                  style: ElevatedButton.styleFrom(backgroundColor: validateColor),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: Text('Mark as received'),
                                                  )
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              )
                          )
                        )
                    );
                  }) : Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height /4),
                    FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                    Text('No shipping found', style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                  ]
              )
          ))
        ]
      )
    );
  }

  Widget buildBookingSheet(BuildContext context, var bookingCode, int travelId){

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
            Text('Shipping Validation', style: Get.textTheme.headline4.merge(TextStyle(fontSize: 20))),
            SizedBox(height: 20),
            DelayedAnimation(
                delay: 100,
                child: Container(
                  padding: EdgeInsets.only(top: 00,bottom: 20, left: 60, right: 60),
                  child: QrImageView(
                    data: "$bookingCode>$travelId",
                    version: QrVersions.auto,
                    size: 200,
                    gapless: false,
                  )
                )
            ),
            SizedBox(height: 20),
            Text('---------- OR ----------'.tr, style: TextStyle(fontSize: 20)),

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
                        Text( "Validation code".tr,
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        Obx(() => TextFormField(
                          initialValue: "$bookingCode-$travelId",
                          //controller: codeController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: ()=> {

                                    controller.copyPressed.value = true,
                                    Clipboard.setData(ClipboardData(text: "$bookingCode-$travelId"))

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
          ],
        )
      )
    );
  }
}
