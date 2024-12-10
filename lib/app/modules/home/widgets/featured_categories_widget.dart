import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../add_ravel_form/Views/add_travel_form.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/expedition_offer_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)),
      ),
      child: Column(
          children: [
            Column(
              children: [
                DelayedAnimation(
                  delay: 100,
                  child: GestureDetector(
                    onTap: () async {
                      Get.lazyPut(()=>AddTravelsView());
                      Get.lazyPut(()=>AddTravelController());

                      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(Get.context).loadingData),
                        duration: Duration(seconds: 6),
                      ));

                      

                      await Get.find<BookingsController>().getAttachmentFiles();
                      Get.bottomSheet(
                        Get.find<AddTravelsView>().airOrRoadTravel(context),
                        isScrollControlled: true,

                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 10),
                      height: 120,
                      width: Get.width,
                      child: Row(
                        children: [
                          Container(
                            width: Get.width*0.25,
                            height: 100,
                            padding: EdgeInsets.all(10),
                            //margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              image: DecorationImage(
                                image: AssetImage("assets/img/Na_Dec_31.jpg"), fit: BoxFit.contain,),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                              border:  null,),

                          ),

                          Container(
                            width: Get.width*0.65,
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Transport Parcel', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 16)),
                                Flexible(child: Text("Transport people's parcel around the globe", style: TextStyle(color: Colors.grey.shade700),))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.black26, height: 0.5).marginOnly(left: 20, right: 20),

                DelayedAnimation(
                  delay: 250,
                  child: GestureDetector(
                    onTap: (){
                      Get.bottomSheet(

                        requestOrOfferShipping(context),
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.only(left: 5, right: 5,  bottom: 10),
                      height: 120,
                      width: Get.width,
                      child: Row(
                        children: [
                          Container(
                            width: Get.width*0.25,
                            height: 100,
                            padding: EdgeInsets.all(10),
                            //margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              image: DecorationImage(
                                  image: AssetImage("assets/img/transporter.jpg"), fit: BoxFit.contain),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                              border:  null,),
                          ),

                          Container(
                            width: Get.width*0.65,
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Send Parcel', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 16)),
                                Flexible(child: Text("Have a traveller deliver your parcel around the globe", style: TextStyle(color: Colors.grey.shade700),))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.black26, height: 0.5).marginOnly(left: 20, right: 20),

                DelayedAnimation(
                  delay: 350,
                  child: GestureDetector(
                    onTap: () async {
                      Get.find<BookingsController>().offerReception.value = true;
                      Get.toNamed(Routes.CREATE_RECEPTION_OFFER);
                      await Get.find<TravelInspectController>().newShippingFunction();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.only(left: 5, right: 5,  bottom: 10),
                      height: 120,
                      width: Get.width,
                      child: Row(
                        children: [
                          Container(
                            width: Get.width*0.25,
                            height: 100,
                            padding: EdgeInsets.all(10),
                            //margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              image: DecorationImage(
                                  image: AssetImage("assets/img/Recevoir.jpg"), fit: BoxFit.contain),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                              border:  null,),
                          ),

                          Container(
                            width: Get.width*0.65,
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Receive Parcel', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 16)),
                                Flexible(child: Text("Have a traveller pickup your parcel from accross the globe", style: TextStyle(color: Colors.grey.shade700),))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.black26, height: 0.5).marginOnly(left: 20, right: 20),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text(AppLocalizations.of(context).road.tr.toUpperCase(), style: Get.textTheme.headline5.merge(TextStyle(fontSize: 18, color: appColor)))),
                      MaterialButton(
                        onPressed: () async {
                          if(controller.landTravelList.isNotEmpty){
                            Get.toNamed(Routes.CATEGORY, arguments: {"travelType": 'road','widgetType': 'roadTravels',});

                          }
                        },
                        shape: StadiumBorder(),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                        child: Text(AppLocalizations.of(context).viewAll.tr, style: Get.textTheme.subtitle1.merge(TextStyle(color: interfaceColor))),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
                Obx(() => controller.isRoadTravelLoading.value ?
                Container(
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                ) :
                controller.landTravelList.isNotEmpty ?
                Container(
                  height: 180,
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      primary: false,
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.landTravelList.length > 7 ? 7 : controller.landTravelList.length,
                      itemBuilder: (_, index) {

                        return GestureDetector(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: TravelCardWidget(
                                isUser: false,
                                homePage: true,
                                travelBy: controller.landTravelList[index]['booking_type'],
                                depDate: DateFormat("dd MMM yyyy", 'fr_CA').format(DateTime.parse(controller.landTravelList[index]['departure_date'])).toString().toUpperCase(),
                                arrTown: controller.landTravelList[index]['arrival_city_id'][1],
                                depTown: controller.landTravelList[index]['departure_city_id'][1],
                                qty: controller.landTravelList[index]['kilo_qty'],
                                price: controller.landTravelList[index]['price_per_kilo'],
                                color: background,
                                text: Text(""),
                                user: controller.landTravelList[index]['partner_id'][1],
                                rating: controller.landTravelList[index]['average_rating'].toStringAsFixed(1),
                                imageUrl: '${Domain.serverPort}/image/res.partner/${controller.landTravelList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',

                              ),
                            ),
                            onTap: () async =>{
                            Get.delete<TravelInspectController>(),
                            Get.lazyPut<TravelInspectController>(
                            () => TravelInspectController(),),
                              Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.landTravelList[index], 'heroTag': 'services_carousel'}),


                        //     await Get.find<TravelInspectController>().mixedTravelShipping.clear(),
                        //
                        // controller.landTravelList[index]['booking_type'].toLowerCase() == "air"?
                        //     Get.find<TravelInspectController>().mixedTravelShipping.addAll(await Get.find<TravelInspectController>().getThisAirTravelShipping(controller.landTravelList[index]['shipping_ids']))
                        //     : Get.find<TravelInspectController>().mixedTravelShipping.addAll(await Get.find<TravelInspectController>().getThisRoadTravelShipping(controller.landTravelList[index]['shipping_ids']))


                            }
                          //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                        );
                      }),
                ) : Container(
                    height: 200,
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3), size: 120),
                    ))
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text(AppLocalizations.of(context).air.tr.toUpperCase(), style: Get.textTheme.headline5.merge(TextStyle(fontSize: 18, color: appColor)))),
                      MaterialButton(
                        onPressed: () {
                          if(controller.airTravelList.isNotEmpty){
                            Get.toNamed(Routes.CATEGORY, arguments: {'widgetType': 'airTravels', "travelType": "air"});
                          }
                        },
                        shape: StadiumBorder(),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                        child: Text(AppLocalizations.of(context).viewAll.tr, style: Get.textTheme.subtitle1.merge(TextStyle(color: interfaceColor))),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
                Obx(() =>
                controller.isAirTravelLoading.value?
                Container(
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                ) : controller.airTravelList.isNotEmpty ?
                Container(
                  height: 205,
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      primary: false,
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.airTravelList.length > 5 ? 5 : controller.airTravelList.length,
                      itemBuilder: (_, index) {
                        Future.delayed(Duration.zero, (){
                          controller.airTravelList.sort((a, b) => a["departure_date"].compareTo(b["departure_date"]));
                        });
                        return GestureDetector(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width/1.2,
                                child: TravelCardWidget(
                                  otherLuggageTypes:controller.airTravelList[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                  element['flight_announcement_id'][0].compareTo(controller.airTravelList[index]['id']) == 0).where((element) =>
                                  element['luggage_type_id'][1].toString().compareTo('ENVELOP') != 0 && element['luggage_type_id'][1].toString().compareTo('KILO') != 0
                                  && element['luggage_type_id'][1].toString().compareTo('COMPUTER') != 0):[] ,
                                  hasEnvelope: controller.airTravelList[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                  element['flight_announcement_id'][0].compareTo(controller.airTravelList[index]['id']) == 0).where((element) =>
                                  element['luggage_type_id'][1].toString().compareTo('ENVELOP') == 0).isNotEmpty ?true:false:false,

                                  hasKilos:controller.airTravelList[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                  element['flight_announcement_id'][0].compareTo(controller.airTravelList[index]['id']) == 0).where((element) =>
                                  element['luggage_type_id'][1].toString().compareTo('KILO') == 0).isNotEmpty ?true:false:false,

                                  hasComputers: controller.airTravelList[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                  element['flight_announcement_id'][0].compareTo(controller.airTravelList[index]['id']) == 0).where((element) =>
                                  element['luggage_type_id'][1].toString().compareTo('COMPUTER') == 0).isNotEmpty ?true:false:false,
                                  isUser: false,
                                  homePage: true,
                                  travelBy: controller.airTravelList[index]['travel_type'],
                                  depDate: DateFormat("dd MMMM yyyy", 'fr_CA').format(DateTime.parse(controller.airTravelList[index]['departure_date'])).toString(),
                                  arrTown: controller.airTravelList[index]['arrival_city_id'][1],
                                  depTown: controller.airTravelList[index]['departure_city_id'][1],
                                  qty: controller.airTravelList[index]['kilo_qty'],
                                  price: controller.airTravelList[index]['price_per_kilo'],
                                  color: Colors.white,
                                  text: Text(""),
                                  user: controller.airTravelList[index]['partner_id'][1],
                                  rating: controller.airTravelList[index]['air_average_rating'].toStringAsFixed(1),
                                  imageUrl: '${Domain.serverPort}/image/res.partner/${controller.airTravelList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',

                                )
                            ),
                            onTap: ()=>{
                              Get.delete<TravelInspectController>(),
                              Get.lazyPut<TravelInspectController>(
                                    () => TravelInspectController(),),
                              Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.airTravelList[index], 'heroTag': 'services_carousel'}),
                              print(controller.listOfAllAirTravelsLuggages[index]['luggage_type_id'][1]),
                            }
                          //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                        );
                      }
                  ),
                ) : Container(
                    height: 200,
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 120),
                    ))
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text(AppLocalizations.of(context).expeditionOffer.tr.toUpperCase(), style: Get.textTheme.headline5.merge(TextStyle(fontSize: 18, color: appColor)))),
                      MaterialButton(
                        onPressed: () {
                          if(controller.expeditionOfferList.isNotEmpty){
                            Get.toNamed(Routes.CATEGORY, arguments: {'widgetType': 'expeditionsOffers', "travelType": "road"});
                          }
                        },
                        shape: StadiumBorder(),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                        child: Text(AppLocalizations.of(context).viewAll.tr, style: Get.textTheme.subtitle1.merge(TextStyle(color: interfaceColor))),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
                Obx(() =>
                controller.isExpeditionOfferLoading.value?
                Container(
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                ) : controller.expeditionOfferList.isNotEmpty ?
                Container(
                  height: 180,
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      primary: false,
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.expeditionOfferList.length > 7 ? 7 : controller.expeditionOfferList.length,
                      itemBuilder: (_, index) {

                        return GestureDetector(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width/1.2,
                                child:controller.expeditionOfferList[index]==null?SizedBox()
                                    : CardWidget(
                                  //selected: controller.shippingSelected.value,
                                  homePage: true,
                                  owner: controller.expeditionOfferList[index]['partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?true:false,
                                  user: controller.expeditionOfferList[index]['bool_parcel_reception'] ?
                                  controller.expeditionOfferList[index]['parcel_reception_receiver_partner_id'][1] : controller.expeditionOfferList[index]['partner_id'][1],
                                  imageUrl: controller.expeditionOfferList[index]['bool_parcel_reception'] ?
                                  '${Domain.serverPort}/image/res.partner/${controller.expeditionOfferList[index]['parcel_reception_receiver_partner_id'][0]}/image_1920?unique=true&file_response=true' :
                                  '${Domain.serverPort}/image/res.partner/${controller.expeditionOfferList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',
                                  travellerDisagree: controller.expeditionOfferList[index]['disagree'],
                                  shippingDate: controller.expeditionOfferList[index]['create_date'],
                                  code: controller.expeditionOfferList[index]['name'],
                                  travelType: controller.expeditionOfferList[index]['booking_type'],
                                  transferable: controller.expeditionOfferList[index]['state'].toLowerCase()=='rejected' || controller.expeditionOfferList[index]['state'].toLowerCase()=='pending' ? true:false,
                                  bookingState: controller.expeditionOfferList[index]['state'],
                                  price: controller.expeditionOfferList[index]['shipping_price'],
                                  text: "${controller.expeditionOfferList[index]['shipping_departure_city_id'][1].split(" ").first} > ${controller.expeditionOfferList[index]['shipping_arrival_city_id'][1].split(" ").first}",
                                  detailsView: TextButton(
                                    onPressed: ()async=> {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(AppLocalizations.of(context).loadingData),
                                        duration: Duration(seconds: 3),
                                      )),
                                      //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                                      Get.find<BookingsController>().shippingDetails.value = controller.expeditionOfferList[index],
                                      controller.expeditionOfferList[index]['partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?
                                      Get.find<BookingsController>().owner.value = false
                                      :Get.find<BookingsController>().owner.value = true,
                                      if(Get.find<BookingsController>().shippingDetails != null){
                                        if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                          if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                            Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                            //"assets/img/istockphoto-1421193265-612x612.jpg";
                                          }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                            //"assets/img/pexels-julius-silver-753331.jpg";
                                          }else{
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                            //"assets/img/istockphoto-859916128-612x612.jpg";
                                          },
                                        }else{

                                        },
                                        print(Get.find<BookingsController>().shippingDetails.value['travelbooking_id']),



                                        Get.toNamed(Routes.SHIPPING_DETAILS,arguments: {'shippingType':'shippingOffer'})
                                      }
                                    },
                                    child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                                  ),
                                  negotiation: !controller.expeditionOfferList[index]['disagree']  ? controller.expeditionOfferList[index]['msg_shipping_accepted'] ?
                                  GestureDetector(
                                      onTap: ()=> Get.toNamed(Routes.CHAT, arguments: {'shippingCard': controller.expeditionOfferList[index]}) ,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              border: Border.all(color: buttonColor.withOpacity(0.4))
                                          ),
                                          margin: EdgeInsets.symmetric( vertical: 10),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(AppLocalizations.of(context).chat, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 13,color: buttonColor))),
                                                  SizedBox(width: 10),
                                                  FaIcon(FontAwesomeIcons.solidMessage, color: buttonColor, size: 15),
                                                ],
                                              )
                                          )
                                      )
                                  ) : SizedBox() : GestureDetector(
                                      onTap: ()=> showDialog(
                                          context: context,
                                          builder: (_)=>
                                              PopUpWidget(
                                                title: "Do you really want to transfer your shipping?",
                                                cancel: AppLocalizations.of(context).cancel,
                                                confirm: AppLocalizations.of(context).transfer,
                                                onTap: () async => {
                                                  Navigator.of(Get.context).pop(),
                                                  //controller.transferShipping(controller.allShippingOffers[index]['id']),
                                                }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                                              )
                                      ),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              border: Border.all(color: buttonColor.withOpacity(0.4))
                                          ),
                                          margin: EdgeInsets.symmetric( vertical: 10),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(AppLocalizations.of(context).transfer, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 13,color: buttonColor))),
                                                  SizedBox(width: 10),
                                                  FaIcon(FontAwesomeIcons.forward, color: buttonColor, size: 15),
                                                ],
                                              )
                                          )
                                      )
                                  ),

                                )
                            ),
                            onTap: ()=>{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 3),
                              )),
                              //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                              Get.find<BookingsController>().shippingDetails.value = controller.expeditionOfferList[index],
                              controller.expeditionOfferList[index]['partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?
                              Get.find<BookingsController>().owner.value = false
                                  :Get.find<BookingsController>().owner.value = true,
                              if(Get.find<BookingsController>().shippingDetails != null){
                                if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                  if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                    Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                    //"assets/img/istockphoto-1421193265-612x612.jpg";
                                  }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                    //"assets/img/pexels-julius-silver-753331.jpg";
                                  }else{
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                    //"assets/img/istockphoto-859916128-612x612.jpg";
                                  },
                                }else{

                                },



                                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingOffer'})
                              }
                            }
                          //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                        );
                      }
                  ),
                ) : Container(
                    height: 200,
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 120),
                    ))
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text('Reception Offers'.tr.toUpperCase(), style: Get.textTheme.headline5.merge(TextStyle(fontSize: 18, color: appColor)))),
                      MaterialButton(
                        onPressed: () {
                          if(controller.receptionOfferList.isNotEmpty){
                            Get.toNamed(Routes.CATEGORY, arguments: {'widgetType': 'receptionOffers', "travelType": "road"});
                          }
                        },
                        shape: StadiumBorder(),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                        child: Text(AppLocalizations.of(context).viewAll.tr, style: Get.textTheme.subtitle1.merge(TextStyle(color: interfaceColor))),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
                Obx(() =>
                controller.isReceptionOfferLoading.value?
                Container(
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                ) : controller.receptionOfferList.isNotEmpty ?
                Container(
                  height: 180,
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      primary: false,
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.receptionOfferList.length > 7 ? 7 : controller.receptionOfferList.length,
                      itemBuilder: (_, index) {

                        return GestureDetector(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width/1.2,
                                child:controller.receptionOfferList[index]==null?SizedBox()
                                    : CardWidget(
                                  //selected: controller.shippingSelected.value,
                                  homePage: true,
                                  owner: controller.receptionOfferList[index]['parcel_reception_receiver_partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?true:false,
                                  user: controller.receptionOfferList[index]['bool_parcel_reception'] ?
                                  controller.receptionOfferList[index]['parcel_reception_receiver_partner_id'][1] : controller.receptionOfferList[index]['partner_id'][1],
                                  imageUrl: controller.receptionOfferList[index]['bool_parcel_reception'] ?
                                  '${Domain.serverPort}/image/res.partner/${controller.receptionOfferList[index]['parcel_reception_receiver_partner_id'][0]}/image_1920?unique=true&file_response=true' :
                                  '${Domain.serverPort}/image/res.partner/${controller.receptionOfferList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',
                                  travellerDisagree: controller.receptionOfferList[index]['disagree'],
                                  shippingDate: controller.receptionOfferList[index]['create_date'],
                                  code: controller.receptionOfferList[index]['name'],
                                  travelType: controller.receptionOfferList[index]['booking_type'],
                                  transferable: controller.receptionOfferList[index]['state'].toLowerCase()=='rejected' || controller.receptionOfferList[index]['state'].toLowerCase()=='pending' ? true:false,
                                  bookingState: controller.receptionOfferList[index]['state'],
                                  price: controller.receptionOfferList[index]['shipping_price'],
                                  text: "${controller.receptionOfferList[index]['shipping_departure_city_id'][1].split(" ").first} > ${controller.receptionOfferList[index]['shipping_arrival_city_id'][1].split(" ").first}",
                                  detailsView: TextButton(
                                    onPressed: ()async=> {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(AppLocalizations.of(context).loadingData),
                                        duration: Duration(seconds: 3),
                                      )),
                                      //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                                      Get.find<BookingsController>().shippingDetails.value = controller.receptionOfferList[index],
                                      controller.receptionOfferList[index]['parcel_reception_receiver_partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?
                                      Get.find<BookingsController>().owner.value = true
                                          :Get.find<BookingsController>().owner.value = false,
                                      if(Get.find<BookingsController>().shippingDetails != null){
                                        if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                          if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                            Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                            //"assets/img/istockphoto-1421193265-612x612.jpg";
                                          }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                            //"assets/img/pexels-julius-silver-753331.jpg";
                                          }else{
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                            //"assets/img/istockphoto-859916128-612x612.jpg";
                                          },
                                        }else{

                                        },
                                        print(Get.find<BookingsController>().shippingDetails.value['parcel_reception_receiver_partner_id']),

                                        Get.delete<TravelInspectController>(),
                                        Get.lazyPut<TravelInspectController>(
                                              () => TravelInspectController(),),

                                        Get.toNamed(Routes.SHIPPING_DETAILS,arguments: {'shippingType':'receptionOffer'})
                                      }
                                    },
                                    child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                                  ),
                                  negotiation: !controller.receptionOfferList[index]['disagree']  ? controller.receptionOfferList[index]['msg_shipping_accepted'] ?
                                  GestureDetector(
                                      onTap: ()=> Get.toNamed(Routes.CHAT, arguments: {'shippingCard': controller.receptionOfferList[index]}) ,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              border: Border.all(color: buttonColor.withOpacity(0.4))
                                          ),
                                          margin: EdgeInsets.symmetric( vertical: 10),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(AppLocalizations.of(context).chat, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 13,color: buttonColor))),
                                                  SizedBox(width: 10),
                                                  FaIcon(FontAwesomeIcons.solidMessage, color: buttonColor, size: 15),
                                                ],
                                              )
                                          )
                                      )
                                  ) : SizedBox() : GestureDetector(
                                      onTap: ()=> showDialog(
                                          context: context,
                                          builder: (_)=>
                                              PopUpWidget(
                                                title: "Do you really want to transfer your shipping?",
                                                cancel: AppLocalizations.of(context).cancel,
                                                confirm: AppLocalizations.of(context).transfer,
                                                onTap: () async => {
                                                  Navigator.of(Get.context).pop(),
                                                  //controller.transferShipping(controller.allShippingOffers[index]['id']),
                                                }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                                              )
                                      ),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              border: Border.all(color: buttonColor.withOpacity(0.4))
                                          ),
                                          margin: EdgeInsets.symmetric( vertical: 10),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(AppLocalizations.of(context).transfer, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 13,color: buttonColor))),
                                                  SizedBox(width: 10),
                                                  FaIcon(FontAwesomeIcons.forward, color: buttonColor, size: 15),
                                                ],
                                              )
                                          )
                                      )
                                  ),

                                )
                            ),
                            onTap: ()=>{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 3),
                              )),
                              //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                              Get.find<BookingsController>().shippingDetails.value = controller.receptionOfferList[index],
                              controller.receptionOfferList[index]['parcel_reception_receiver_partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?
                              Get.find<BookingsController>().owner.value = false
                                  :Get.find<BookingsController>().owner.value = true,
                              if(Get.find<BookingsController>().shippingDetails != null){
                                if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                  if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                    Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                    //"assets/img/istockphoto-1421193265-612x612.jpg";
                                  }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                    //"assets/img/pexels-julius-silver-753331.jpg";
                                  }else{
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                    //"assets/img/istockphoto-859916128-612x612.jpg";
                                  },
                                }else{

                                },



                                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'receptionOffer'})
                              }
                            }
                          //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                        );
                      }
                  ),
                ) : Container(
                    height: 200,
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 120),
                    ))
                ),
              ],
            ),
          ]
      ),
    );
  }

  Widget requestOrOfferShipping(BuildContext context) {
    return Container(
        height: Get.height*0.7,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: EdgeInsets.all(20),
        child: Obx(() => ListView(
          primary: true,
          //padding: EdgeInsets.all(10),
          children: [

            Text('Which kind of shipping are you up to?'.tr,
              style: Get.textTheme.headline6.merge(TextStyle(color: buttonColor)),
              textAlign: TextAlign.center,
            ),


            SizedBox(height: 15),
            if(!controller.shippingRequestSelected.value)...[
              InkWell(
                  onTap: ()=>{
                    controller.shippingRequestSelected.value = !controller.shippingRequestSelected.value,
                  },
                  child: Container(
                      height: 130,
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                          border: Border.all(color: inactive)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Shipping Request',style: TextStyle(fontSize: 20)),
                              SizedBox(height: 10,),
                              Text('A shipping request is a shipping from an existing travel'.tr,
                                style: Get.textTheme.headline6.merge(TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                textAlign: TextAlign.center,
                              ),

                            ],)
                      )
                  )
              ),
              InkWell(
                onTap: () async =>{

                  Get.find<BookingsController>().offerExpedition.value = true,
                  Navigator.of(context).pop(),
                  Get.toNamed(Routes.CREATE_OFFER_EXPEDITION),
                  await Get.find<TravelInspectController>().newShippingFunction(),



                },
                child: Container(
                  height: 130,
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: inactive)),
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text('Shipping Offer',style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10,),
                          Text('A shipping offer is a shipping from no travel'.tr,
                            style: Get.textTheme.headline6.merge(TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            textAlign: TextAlign.center,
                          ),

                        ],)),


                ),
              ),

            ] else...[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: (){
                  controller.shippingRequestSelected.value = !controller.shippingRequestSelected.value;
                }, icon: Icon(Icons.arrow_back_ios, color: interfaceColor,)),
              ),
              InkWell(
                  onTap: ()=>{
                    if(controller.landTravelList.isNotEmpty){
                      Navigator.of(context).pop(),
                      Get.toNamed(Routes.CATEGORY, arguments: {"travelType": 'road','widgetType': 'roadTravels',}),
                    }
                    else{
                      Get.showSnackbar(Ui.warningSnackBar(message: "There are no road travels to make a shipping request ".tr)),
                    }
                  },
                  child: Container(
                      height: 130,
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                          border: Border.all(color: inactive)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text('Road Shipping Request',style: TextStyle(fontSize: 20)))
                  )
              ),
              InkWell(
                onTap: () async =>{

                  if(controller.airTravelList.isNotEmpty){
                    Navigator.of(context).pop(),
                    Get.toNamed(Routes.CATEGORY, arguments: {'widgetType': 'airTravels', "travelType": "air"}),
                  }
                  else{
                    Get.showSnackbar(Ui.warningSnackBar(message: "There are no air travels to make a shipping request ".tr)),
                  }



                },
                child: Container(
                    height: 130,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                        border: Border.all(color: inactive)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Air Shipping Request',style: TextStyle(fontSize: 20)))
                ),
              ),

            ]

          ],
        ))
    );
  }

}
