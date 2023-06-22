import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../providers/laravel_provider.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../account/widgets/account_link_widget.dart';

import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/packet_image_field_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/pop_up_photo_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/user_widget.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../../userBookings/widgets/bookings_list_loader_widget.dart';
import '../controllers/travel_inspect_controller.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';

class TravelInspectView extends GetView<TravelInspectController> {

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );

    return Obx(() {

      return Scaffold(
          bottomNavigationBar: buildBottomWidget(context),
          body: RefreshIndicator(
              onRefresh: () async {
                controller.refreshEService();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: FaIcon(FontAwesomeIcons.arrowLeft, color: Get.theme.hintColor)
                        )
                      ),
                      onPressed: () => {
                        Get.find<BookingsController>().transferBooking.value = false,
                        Get.back()
                      },
                    ),
                    actions: [
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: 120,
                        child: Text(controller.travelCard['booking_type'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.white))),
                        decoration: BoxDecoration(
                            color: controller.travelCard['booking_type'] != "air" ? Colors.white.withOpacity(0.4) : interfaceColor.withOpacity(0.4),
                            border: Border.all(
                              color: controller.travelCard['booking_type'] != "air" ? Colors.white.withOpacity(0.2) : interfaceColor.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      )
                    ],
                    bottom: buildEServiceTitleBarWidget(context),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            Container(
                              height: 370,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(controller.imageUrl.value), fit: BoxFit.cover)
                              ),
                            ),
                            buildCarouselBullets(context)
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(() => EServiceTilWidget(
                            title: Text("Description".tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: interfaceColor))),
                            title2: Get.find<MyAuthService>().myUser.value.id  != controller.travelCard['create_uid'][0] ?
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: ((){
                                if(controller.travelCard['shipping_ids'].isNotEmpty){
                                  Get.bottomSheet(
                                    buildBookingByTravel(context),
                                    isScrollControlled: true,
                                  );
                                }else{
                                  Get.showSnackbar(Ui.notificationSnackBar(message: "No booking has been made on this travel yet".tr));
                                }

                                print(controller.currentIndex);
                              }),
                              child: Text("View Bookings".tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.white))),
                            ) : SizedBox(),
                            content: Column(
                              children: [
                                ListTile(
                                  title: Text('Reference', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: appColor))),
                                  trailing: Text(controller.travelCard['code'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                                ),
                                ListTile(
                                  title: Text('Available Quantity (kg):', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, color: appColor))),
                                  trailing: Text(controller.travelCard['total_weight'].toString(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, color: appColor))),
                                ),
                                if(controller.travelCard['booking_type'] != 'road')
                                ListTile(
                                  title: Text('Price /kg', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, color: appColor))),
                                  trailing: Text(controller.travelCard['booking_price'].toString() + " "+ controller.travelCard['local_currency_id'][1], style: Get.textTheme.headline2.merge(TextStyle(fontSize: 18, color: appColor))),
                                ),
                                Divider(
                                  height: 26,
                                  thickness: 1.2,
                                ),
                                ListTile(
                                  title: Text('Article Accepted', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: appColor))),
                                  subtitle: Text(controller.travelCard['luggage_ids'].toString(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                                ),
                              ],
                            )
                        )),
                        if(Get.find<MyAuthService>().myUser.value.id  != controller.travelCard['create_uid'][0])
                          EServiceTilWidget(
                            title: Text("About Traveler".tr, style: Get.textTheme.subtitle2),
                            title2: InkWell(
                              onTap: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Negotiate', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, decoration: TextDecoration.underline))),
                                  SizedBox(width: 10),
                                  FaIcon(FontAwesomeIcons.solidMessage, color: interfaceColor),
                                ],
                              ),
                            ),
                            content: buildUserDetailsCard(context),
                            actions: [],
                          ),
                      ],
                    ),
                  ),
                ],
              )),
        );
    });
  }

  Widget buildBookingByTravel(BuildContext context){

    return controller.areBookingsLoading.value?
        Container(
          padding: EdgeInsets.all(20),
          height: Get.height/1.2,
          decoration: BoxDecoration(
            color: background,
            //Get.theme.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
            ],
          ),
          child:  BookingsListLoaderWidget(),
        ):

    controller.list.isEmpty?
        Container(
            padding: EdgeInsets.all(20),
            height: Get.height/1.2,
            decoration: BoxDecoration(
              color: background,
              //Get.theme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
              ],
            ),

            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                    Text('No Bookings found', style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                  ],
        ),
            ),
          )
        :
      Container(
      padding: EdgeInsets.all(20),
      height: Get.height/1.2,
      decoration: BoxDecoration(
        color: background,
        //Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            width: MediaQuery.of(context).size.width/2.5,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white
            ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: controller.travelBookings.length,
                itemBuilder: (context, index){
                  return buildBookingsView(context, controller.travelBookings[index]
                  );
                },
              )
          )
        ],
      )
    );
  }

  Widget buildBookingsView(BuildContext context, var booking){
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
                child:
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
                              Expanded(child: Text("Booked By: " +booking["create_uid"][1], style: Get.textTheme.headline1.
                              merge(TextStyle(color: appColor, fontSize: 17)))),
                              SizedBox(width: 40),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                alignment: Alignment.center,
                                child: Text(booking["state"], style: Get.textTheme.headline2.merge(TextStyle(color: booking["state"].toLowerCase() == 'accepted' ? interfaceColor : booking["state"].toLowerCase() == 'rejected' ? specialColor : Colors.black54, fontSize: 12))),
                                decoration: BoxDecoration(
                                    color: booking["state"].toLowerCase() == 'accepted' ? interfaceColor.withOpacity(0.3) : booking["state"].toLowerCase() == 'rejected' ? specialColor.withOpacity(0.3)  : inactive.withOpacity(0.3),
                                    border: Border.all(
                                      color: booking["state"].toLowerCase() == 'accepted' ? interfaceColor.withOpacity(0.2) : booking["state"].toLowerCase() == 'rejected' ? specialColor.withOpacity(0.3) : inactive.withOpacity(0.2),
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                              )
                            ]
                        ),
                        SizedBox(height: 10),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Icon( Icons.attach_money_outlined, size: 25),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                    width: 1,
                                    height: 24,
                                    color: Get.theme.focusColor.withOpacity(0.3),
                                  ),

                                //controller.travelCard['booking_type'].toLowerCase() == 'road'?
                                  Text("Shipping price:  "+ booking["shipping_price"].toString() + ' ' +controller.travelCard['local_currency_id'][1],
                                      style: Get.textTheme.headline6.
                                      merge(TextStyle(color: specialColor, fontSize: 16)))
                                      // :SizedBox()
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:30,
                                      child: Icon(FontAwesomeIcons.shoppingBag, size: 18)),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                    width: 1,
                                    height: 24,
                                    color: Get.theme.focusColor.withOpacity(0.3),
                                  ),

                                 // controller.travelCard['booking_type']=='road'?
                                  Text("Kilo Booked: "+ booking["total_weight"].toString()+ " Kg",
                                      style: Get.textTheme.headline1.
                                      merge(TextStyle(color: appColor, fontSize: 16)))
                                      //: SizedBox()

                                ],
                              ),
                            ),

                          ],
                        ),

                        /*ExpansionTile(
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
                                              controller.travelCard['booking_type']=='air'?
                                              '${Domain.serverPort}/web/image/m2st_hk_airshipping.travel_booking/${booking['id'].toString()}/luggage_image${index}':
                                            controller.travelCard['booking_type']=='road'?
                                            '${Domain.serverPort}/web/image/m2st_hk_roadshipping.travel_booking/${booking['id'].toString()}/luggage_image${index}':
                                              '',),

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
                        ),*/

                        ExpansionTile(
                          leading: Icon(FontAwesomeIcons.userCheck, size: 20),
                          title: Text("Receiver Info".tr, style: Get.textTheme.bodyText1.
                          merge(TextStyle(color: appColor, fontSize: 17))),
                          children: [
                            AccountWidget(
                              icon: FontAwesomeIcons.person,
                              text: Text('Full Name'),
                              value: booking['receiver_partner_id'][1],
                            ),
                            AccountWidget(
                              icon: Icons.alternate_email,
                              text: Text('Email'),
                              value: booking['receiver_email'].toString(),
                            ),
                            AccountWidget(
                              icon: FontAwesomeIcons.addressCard,
                              text: Text('Address'),
                              value: booking['receiver_address'],
                            ),
                            AccountWidget(
                              icon: FontAwesomeIcons.phone,
                              text: Text('Phone'),
                              value: booking['receiver_phone'],
                            ),
                          ],
                          initiallyExpanded: false,
                        ),
                        booking["state"].toLowerCase() == 'pending'?
                            Column(
                              children: [
                              InkWell(
                                onTap: ()=>{ Get.toNamed(Routes.CHAT, arguments: {'bookingCard': booking}) },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Negotiate', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, decoration: TextDecoration.underline))),
                                    SizedBox(width: 10),
                                    FaIcon(FontAwesomeIcons.solidMessage, color: interfaceColor),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        showDialog(
                                            context: context,
                                            builder: (_)=>
                                                PopUpWidget(
                                                  title: "Are you sure to accept this booking? your choice can't be changed later",
                                                  cancel: 'Cancel',
                                                  confirm: 'Ok',
                                                  onTap: () async =>{
                                                    controller.acceptRoadBooking(booking['id']),

                                                  }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                                                )
                                        );

                                      },
                                      child: Card(
                                          elevation: 10,
                                          color: inactive,
                                          margin: EdgeInsets.symmetric( vertical: 15),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Text(" Accept ".tr, style: TextStyle(color: Colors.white),),)
                                      )
                                  ),
                                  SizedBox(width: 20,),
                                  GestureDetector(
                                      onTap: (){
                                        showDialog(
                                            context: context,
                                            builder: (_)=>
                                                PopUpWidget(
                                                  title: "Are you sure to reject this booking? your choice can't be changed later",
                                                  cancel: 'Cancel',
                                                  confirm: 'Ok',
                                                  onTap: () async =>{
                                                    await controller.rejectRoadBooking(booking['id']),

                                                  }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                                                )
                                        );
                                      },
                                      child: Card(
                                          elevation: 10,
                                          color: specialColor,
                                          margin: EdgeInsets.symmetric( vertical: 15),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              child: Text("Refuse".tr, style: TextStyle(color: Colors.white)))
                                      )
                                  ),
                                ],
                              )
                            ],)

                            :SizedBox()
                      ])),
            )],
          ),
        )
    );
  }

  Container buildCarouselBullets(BuildContext context) {
    double width = MediaQuery.of(context).size.width/1.2;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Container(
          alignment: Alignment.center,
          width: width,
          height: 80,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  FaIcon(FontAwesomeIcons.planeDeparture),
                  SizedBox(height: 10),
                  Text(controller.travelCard['departure_date'].toString(),
                      style: TextStyle(fontSize: 20, color: appColor)),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  FaIcon(FontAwesomeIcons.planeArrival),
                  SizedBox(height: 10),
                  Text(controller.travelCard['arrival_date'].toString(),
                      style: TextStyle(fontSize: 20, color: appColor))
                ],
              )
            ],
          )
      )
    );
  }

  Widget buildUserDetailsCard(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 20,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.travelCard['partner_id']}/avatar_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                      fit: BoxFit.cover)
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(controller.travelCard['create_uid'][1],
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 2,
                      style: Get.textTheme.bodyText2.merge(TextStyle(fontSize: 18, color: appColor)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
                child: Chip(
                  padding: EdgeInsets.all(0),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("5", style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor))),
                      Icon(
                        Icons.star_border,
                        color: Get.theme.primaryColor,
                        size: 16,
                      ),
                    ],
                  ),
                  backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.9),
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width/2.8;
    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topCenter,
                width: width,
                child: Text(controller.travelCard['departure_city_id'][1], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
              ),
              FaIcon(FontAwesomeIcons.arrowRight),
              Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  child: Text(controller.travelCard['arrival_city_id'][1], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18)))
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 40,right: 40),

          child: Get.find<MyAuthService>().myUser.value.id != controller.travelCard['create_uid'][0] ?
          BlockButtonWidget(
              text: Container(
                height: 24,
                alignment: Alignment.center,
                child: Text(
                  "Book Now".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6.merge(
                    TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () async{
                Get.bottomSheet(
                  buildBookingSheet(context),
                  isScrollControlled: true,
                );
                /*if(Get.find<MyAuthService>().myUser.value.email != null){
                  Get.bottomSheet(
                    buildBookingSheet(context),
                    isScrollControlled: true,
                  );
                }else{
                  await Get.offNamed(Routes.LOGIN);
                }*/
              }) : controller.transferBooking.value && Get.find<MyAuthService>().myUser.value.id == controller.travelCard['create_uid'][0]?
          BlockButtonWidget(
              text: Container(
                height: 24,
                alignment: Alignment.center,
                child: Text(
                  "Transfer Now".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6.merge(
                    TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () async{
                if(Get.find<MyAuthService>().myUser.value.email != null){
                  controller.travelCard['booking_type'] == "air"?
                  await controller.transferAirNow(controller.travelCard['id']):
                  controller.travelCard['booking_type'] == "road"?
                  await controller.transferRoadNow(controller.travelCard['id']):
                  (){};
                }else{
                  await Get.offNamed(Routes.LOGIN);
                }
              }):
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: ()=>{
                  showDialog(
                      context: context,
                        builder: (_)=>
                            PopUpWidget(
                              title: "Do you really want to delete this post?",
                              cancel: 'Cancel',
                              confirm: 'Delete',
                              onTap: (){
                                if(controller.travelCard['booking_type'] == "air"){
                                  controller.deleteAirTravel(controller.travelCard['id']);
                                  print("air delete");
                                }
                                if(controller.travelCard['booking_type'] == "road"){
                                  controller.deleteRoadTravel(controller.travelCard['id']);
                                  print("road delete");
                                }
                                if(controller.travelCard['booking_type'] == "sea"){
                                  //controller.deleteRoadTravel(controller.travelCard['id']);
                                }
                                print(controller.travelCard['id']);
                              }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                            )
                    )
                  },
                  child: SizedBox(width: 100,height: 30,
                      child: Center(child: Text('Delete')))
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: inactive,
                  ),
                  onPressed: ()=>{
                    Navigator.pushReplacementNamed(context, Routes.ADD_TRAVEL_FORM, arguments: {'travelCard': controller.travelCard}),
                    //Get.toNamed(, arguments: )
                  },
                  child: SizedBox(width: 100,height: 30,
                      child: Center(child: Text('Edit')))
              )
            ],
          )
        ),
      );
  }

  Widget buildBookingSheet(BuildContext context){

    return Container(
      height: Get.height/1.8,
      decoration: BoxDecoration(
        color: background,
        //Get.theme.primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: Obx(() => Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            child: Row(
              children: [
                controller.bookingStep.value != 0 ?
                  MaterialButton(
                    onPressed: () =>{
                      controller.bookingStep.value = 0
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                    child: Text("Back".tr, style: Get.textTheme.subtitle1),
                    elevation: controller.elevation.toDouble(),
                  ) : SizedBox(width: 60),
                Spacer(),
                controller.bookingStep.value == 0 ?
                Text('Booking Details', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16))) :
                Text('Receiver Details', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16))),
                Spacer(),
                controller.bookingStep.value == 0 ?
                MaterialButton(
                  onPressed: () =>{
                    if(controller.imageFiles.length!=3){
                      showDialog(
                          context: context,
                          builder: (_)=>
                              PopUpWidget(
                                title: "You cannot continue if you have not uploaded 3 pictures",
                                cancel: 'Cancel',
                                confirm: 'ok',
                                onTap: (){
                                  Navigator.of(context).pop();
                                }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                              )
                      )
                    }
                    else{
                      controller.bookingStep.value++
                    }

                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  child: Text("Next".tr, style: Get.textTheme.subtitle1),
                  elevation: 0,
                ) : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BlockButtonWidget(
                      text: Container(
                        height: 24,
                        alignment: Alignment.center,
                        child: !controller.buttonPressed.value ? Text(
                          "Send".tr,
                          style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                        ) : SizedBox(height: 20,
                            child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                      ),
                      color: Get.theme.colorScheme.secondary,
                      onPressed: ()async{
                        controller.buttonPressed.value = !controller.buttonPressed.value;
                        controller.travelCard['booking_type'].toString().toLowerCase()== 'air'?await controller.bookAirNow(controller.travelCard['id'])
                        :controller.travelCard['booking_type'].toString().toLowerCase()== 'road'?await controller.bookRoadNow(controller.travelCard['id'])
                        :(){};

                      })
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 15, left: 4, right: 4),
              children: [
                controller.bookingStep.value == 0 ?
                build_Book_travel(context, controller.travelCard['booking_type'])
                    : build_Receiver_details(context)
              ],
            ),
          ),
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
        ],
      )
      ),
    );
  }

  Widget build_Book_travel(BuildContext context, String travelType) {
    var visible =  travelType.toString().toLowerCase()=='road';
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFieldWidget(
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              onChanged: (input) => controller.description.value = input,
              labelText: "Description".tr,
              iconData: FontAwesomeIcons.fileLines,
            ),
            TextFieldWidget(
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              onChanged: (input) => controller.quantity.value = int.parse(input),
              labelText: "Quantity".tr,
              iconData: FontAwesomeIcons.shoppingBag,
            ),

                Visibility(
                  visible: visible,
                    child: TextFieldWidget(
                      keyboardType: TextInputType.text,
                      validator: (input) => input.isEmpty ? "field required!".tr : null,
                      onChanged: (input) => controller.luggageWidth.value = int.parse(input),
                      labelText: "Luggage Width".tr,
                      iconData: FontAwesomeIcons.shoppingBag,
                    ),
                ),
            Visibility(
              visible: visible,
              child: TextFieldWidget(
                keyboardType: TextInputType.text,
                validator: (input) => input.isEmpty ? "field required!".tr : null,
                onChanged: (input) => controller.luggageHeight.value = int.parse(input),
                labelText: "Luggage Height".tr,
                iconData: FontAwesomeIcons.shoppingBag,
              ),
            ),

            Obx(() => Container(
              color: Colors.white,
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Align(
                    child: Text('Input 3 packet pictures'.tr),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(height: 20,),
                  controller.imageFiles.length<=0?GestureDetector(
                      onTap: () {
                        showDialog(
                            context: Get.context,
                            builder: (_){
                              return AlertDialog(
                                content: Container(
                                    height: 170,
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: ()async{
                                            await controller.pickImage(ImageSource.camera);
                                            Navigator.pop(Get.context);
                                          },
                                          leading: Icon(FontAwesomeIcons.camera),
                                          title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                        ),
                                        ListTile(
                                          onTap: ()async{
                                            await controller.pickImage(ImageSource.gallery);
                                            Navigator.pop(Get.context);
                                          },
                                          leading: Icon(FontAwesomeIcons.image),
                                          title: Text('Upload an image', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                        )
                                      ],
                                    )
                                ),
                              );
                            });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                      )
                  )
                      :Column(
                    children: [
                      SizedBox(
                        height:100,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(12),
                            itemBuilder: (context, index){
                              return Stack(
                                //mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.file(
                                      controller.imageFiles[index],
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                  Positioned(
                                    top:0,
                                    right:0,
                                    child: Align(
                                      //alignment: Alignment.centerRight,
                                      child: IconButton(
                                          onPressed: (){
                                            controller.imageFiles.removeAt(index);
                                          },
                                          icon: Icon(FontAwesomeIcons.remove, color: Colors.red, size: 25, )
                                      ),
                                    ),
                                  ),


                                      // .marginOnly(top: 10, right: 10),
                                ],

                              );
                            },
                            separatorBuilder: (context, index){
                              return SizedBox(width: 8);
                            },
                            itemCount: controller.imageFiles.length),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Visibility(
                            child: InkWell(
                              onTap: (){
                                showDialog(
                                    context: Get.context,
                                    builder: (_){
                                      return AlertDialog(
                                        content: Container(
                                            height: 170,
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: ()async{
                                                    await controller.pickImage(ImageSource.camera);
                                                    Navigator.pop(Get.context);
                                                  },
                                                  leading: Icon(FontAwesomeIcons.camera),
                                                  title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                ),
                                                ListTile(
                                                  onTap: ()async{
                                                    await controller.pickImage(ImageSource.gallery);
                                                    Navigator.pop(Get.context);
                                                  },
                                                  leading: Icon(FontAwesomeIcons.image),
                                                  title: Text('Upload an image', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                )
                                              ],
                                            )
                                        ),
                                      );
                                    });
                              },
                              child: Icon(FontAwesomeIcons.circlePlus),
                            )
                        ),
                      )
                    ],

                  ),

                ],
              ),
            ),),



          ],
        ),
      ],
    );
  }

  Widget build_Receiver_details(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SwitchListTile( //switch at right side of label
                value: controller.selectUser.value,
                onChanged: (bool value){
                  controller.selectUser.value = value;
                },
                title: Text("Select a user ?", style: Get.textTheme.headline1.merge(TextStyle(color: appColor)))
            ),
            !controller.selectUser.value ?
            Column(
              children: [
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.name.value = input,
                  labelText: "Full Name".tr,
                  iconData: FontAwesomeIcons.person,
                ),
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.email.value = input,
                  labelText: "Email".tr,
                  iconData: Icons.alternate_email,
                ),
                PhoneFieldWidget(
                  labelText: "Phone Number".tr,
                  hintText: "223 665 7896".tr,
                  initialCountryCode: "CM",
                  //initialValue: controller.currentUser?.value?.getPhoneNumber()?.number,
                  onChanged: (phone){
                    controller.phone.value = "${phone.countryCode}${phone.number}";
                  },
                ),
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.address.value = input,
                  labelText: "Address".tr,
                  iconData: FontAwesomeIcons.addressCard,
                ),
              ],
            ) :
            controller.visible.value?TextFieldWidget(
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              //onChanged: (input) => controller.selectUser.value = input,
              labelText: "Select User".tr,
              iconData: FontAwesomeIcons.userGroup,
              onChanged: (value){
                var userFilter = [];
                if(value==''){
                  controller.users.value=controller.resetusers;
                }
                else{
                  for(var item in controller.users){
                    print(item['name'].toString());
                    if(item['name'].toLowerCase().contains(value)){
                      userFilter.add(item);
                      controller.users.value = userFilter;
                    }else{
                      controller.users.value = userFilter;
                    }
                    //controller.users.value = userFilter;
                  }
                }
              },
            ):TextButton(
                onPressed: (){
                  controller.visible.value = true;
                  controller.users.value = controller.resetusers;

            }, child: Text('Select another user')),

            if(controller.selectUser.value)
            controller.users.isNotEmpty ?
            Container(
                margin: EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                  ],
                ),


                child: ListView.separated(
                    //physics: AlwaysScrollableScrollPhysics(),
                    itemCount: controller.users.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 5);
                    },
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          controller.receiverId.value = controller.users[index]['id'];
                          print(controller.receiverId.value.toString());
                          controller.selectedIndex.value = index;
                          controller.selected.value = true;
                          controller.visible.value = false;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: controller.selectedIndex.value == index && controller.selected.value ? Border.all(color: interfaceColor) : null ,
                            color: Get.theme.primaryColor,

                          ),
                          child: UserWidget(
                            user: controller.users[index]['name'],
                            selected: false,
                            imageUrl: controller.users[index]['image_1920'] == true ? '${Domain.serverPort}/web/image/res.partner/${controller.users[index]['id']}/image_1920'
                                : 'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-unknown-social-media-user-photo-default-avatar-profile-icon-vector-unknown-social-media-user-184816085.jpg',
                          ),
                        ),
                      );
                    })
            ) : Container(
                child: Text('No other user than you', style: TextStyle(color: inactive, fontSize: 18))
                    .marginOnly(top:MediaQuery.of(Get.context).size.height*0.2))
          ],
        ),
      ],
    );
  }
}
