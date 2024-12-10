
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../common/animation_controllers/animatonFadeIn.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../add_ravel_form/Views/add_travel_form.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';
import '../../userTravels/views/userTravels_view.dart';
import '../../validate_transaction/controller/validation_controller.dart';
import '../../validate_transaction/views/parcel_view.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/bookings_list_loader_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingsView extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {

    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );
    Get.lazyPut<UserTravelsController>(
          () => UserTravelsController(),
    );
    Get.lazyPut<ValidationController>(
          () => ValidationController(),
    );
    Get.lazyPut(()=>TravelInspectController());
    Get.put(AddTravelsView());
    Get.put(AddTravelController());


    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
          backgroundColor:Get.theme.colorScheme.secondary,
          resizeToAvoidBottomInset: true,
          floatingActionButton: Obx(() =>
          controller.currentPage.value == 1 ?
          Container(
            height: 44.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
            child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.transparent,
                onPressed: () async =>{
                  ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(Get.context).loadingData),
                    duration: Duration(seconds: 3),
                  )),

                  Get.put(AddTravelController()),
                  await controller.getAttachmentFiles(),
                  Get.bottomSheet(
                    Get.find<AddTravelsView>().airOrRoadTravel(context),
                    isScrollControlled: true,
                  ),

                  // }else{
                  //   Get.showSnackbar(Ui.notificationSnackBar(message: AppLocalizations.of(context).manyTravelsNegotiatingError))
                  // }

                },
                label: Text(AppLocalizations.of(context).transport),
                icon: Icon(Icons.add, color: Palette.background)
            ),
          ):
          controller.currentPage.value == 0 ?
          controller.myExpeditionsPage.value == 2?
          Container(
            height: 44.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
            child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.transparent,
                onPressed: () async =>{
                  Get.delete<TravelInspectController>(),
                  Get.lazyPut<TravelInspectController>(
                        () => TravelInspectController(),),
                  controller.offerExpedition.value =true,
                  //Get.find<TravelInspectController>().onInit(),
                  Get.toNamed(Routes.CREATE_OFFER_EXPEDITION),
                  await Get.find<TravelInspectController>().newShippingFunction(),
                  //Get.toNamed(Routes.ADD_SHIPPING_FORM),

                },

                label: Text(AppLocalizations.of(context).createExpedition),
                icon: Icon(Icons.add, color: Palette.background)
            ),
          )
              :controller.myExpeditionsPage.value == 3?
          Container(
            height: 44.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
            child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.transparent,
                onPressed: () async =>{
                  Get.delete<TravelInspectController>(),
                  Get.lazyPut<TravelInspectController>(
                        () => TravelInspectController(),),
                  controller.offerReception.value =true,
                  //Get.find<TravelInspectController>().onInit(),
                  Get.toNamed(Routes.CREATE_RECEPTION_OFFER),
                  await Get.find<TravelInspectController>().newShippingFunction(),
                  //Get.toNamed(Routes.ADD_SHIPPING_FORM),

                },

                label: Text('Reception Offer'),
                icon: Icon(Icons.add, color: Palette.background)
            ),
          )
          :SizedBox(): SizedBox(),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor:Get.theme.colorScheme.secondary,
            leading: Padding(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  onTap: ()async=> await Get.find<RootController>().changePage(3),
                  child: ClipOval(
                    child: FadeInImage(
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                      image: NetworkImage('${Domain.serverPort}/image/res.partner/${Get.find<MyAuthService>().myUser.value.id}/image_1920?unique=true&file_response=true',
                          headers: Domain.getTokenHeaders()),
                      placeholder: AssetImage(
                          "assets/img/loading.gif"),
                      imageErrorBuilder:
                          (context, error, stackTrace) {
                        return Image.asset("assets/img/téléchargement (3).png", width: 20, height: 20);
                      },
                    ),
                  ),
                )
            ),
            title: Row(
              children: [
                Expanded(
                    child: Obx(() =>
                    controller.currentPage.value == 0 ?
                    Text(
                      "${AppLocalizations.of(context).my} ${AppLocalizations.of(context).shipping}, ${controller.allShippingItem.value.length}",
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.headline5.merge(TextStyle(color: Colors.white)),
                    ) :
                    controller.currentPage.value == 1 ?
                    Text(
                      "${AppLocalizations.of(context).myTravels}, ${Get.find<UserTravelsController>().items.length}",
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.headline5.merge(TextStyle(color: Colors.white)),
                    ) :
                    Text(
                      "${AppLocalizations.of(context).parcels}, ${Get.find<ValidationController>().items.length}",
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.headline5.merge(TextStyle(color: Colors.white)),
                    )
                    )
                ),
                Obx(() =>
                controller.currentPage.value == 1 ?
                Container(
                  key: Key('travelKey'),
                    width: 150,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                        border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: '',

                        ),
                        isExpanded: true,
                        alignment: Alignment.bottomRight,

                        style: TextStyle(color: labelColor),
                        value: Get.find<UserTravelsController>().status[0],
                        // Down Arrow Icon
                        icon: Icon(Icons.filter_list),

                        items: Get.find<UserTravelsController>().status.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == "NEGOTIATING" ? "PUBLISHED" : value,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          List filter = [];
                          controller.items.value = Get.find<UserTravelsController>().origin;
                          if(newValue != 'ALL'){
                            for(var i in controller.items){

                              if(i['state'] == newValue.toLowerCase()){
                                filter.add(i);
                              }
                              Get.find<UserTravelsController>().items.value = filter;
                            }
                          }else{
                            Get.find<UserTravelsController>().items.value = Get.find<UserTravelsController>().origin;
                          }
                        },
                      ),
                    )
                )
                    :Container(
                  key: Key('shippingKey'),
                    width: 150,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                        border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: '',

                        ),
                        isExpanded: true,
                        alignment: Alignment.bottomRight,

                        style: TextStyle(color: labelColor),
                        value: controller.status[0],
                        // Down Arrow Icon
                        icon: Icon(Icons.filter_list),

                        items: controller.status.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value == "RECEIVED" ? AppLocalizations.of(context).delivered.toUpperCase() : value,
                                style: TextStyle(fontSize: 14),
                              )
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          List filter = [];
                          controller.myExpeditionsPage.value == 1?
                          controller.items.value = controller.originShippingRequest.value:
                          controller.myExpeditionsPage.value == 2?
                          controller.items.value = controller.originShippingOffer.value:
                          controller.myExpeditionsPage.value == 3?
                          controller.items.value = controller.originReceptionOffer.value:
                          controller.items.value =[];
                          // controller.allMyShippingList.value = controller.originShippingRequest:
                          // controller.allMyShippingList.value = controller.originShippingOffer;
                          if(newValue != 'ALL'){
                            for(var i in controller.items){

                              if(!i["disagree"]){
                                if(i['state'] == newValue.toLowerCase()){
                                  filter.add(i);
                                }
                              }else{
                                if("cancel" == newValue.toLowerCase()){
                                  filter.add(i);
                                }
                              }

                              controller.items.value = filter;
                            }
                          }else{
                            controller.myExpeditionsPage.value == 1?
                            controller.items.value = controller.originShippingRequest.value:
                            controller.myExpeditionsPage.value == 2?
                            controller.items.value = controller.originShippingOffer.value:
                            controller.myExpeditionsPage.value == 3?
                            controller.items.value = controller.originReceptionOffer.value:
                            controller.items.value =[];
                          }
                        },
                      ),
                    )
                )

                )
              ],
            ),
            centerTitle: true,
            //backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                controller.refreshBookings();
              },
              color: Colors.transparent,
              child: SingleChildScrollView(
                  child: Obx(()=>
                      Column(
                          children: [
                            Column(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: ()=> controller.currentPage.value = 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          width: controller.myExpeditionsPage == 1 ||controller.myExpeditionsPage == 2 ||controller.myExpeditionsPage == 3 ?Get.width/2:Get.width/3.3,
                                          decoration: BoxDecoration(
                                              border: controller.currentPage.value == 0 ? controller.myExpeditionsPage == 1 ||controller.myExpeditionsPage == 2 ||controller.myExpeditionsPage == 3?null :Border(bottom: BorderSide(color: Colors.white, width: 4)) : null
                                          ),
                                          child: controller.myExpeditionsPage == 1 ||controller.myExpeditionsPage == 2 ||controller.myExpeditionsPage == 3 ? Align(
                                            //alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.arrow_back, color: Colors.white),
                                                    onPressed: () => {controller.myExpeditionsPage.value = 0},
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  controller.myExpeditionsPage == 1?Text(AppLocalizations.of(context).request, style: TextStyle(color: Colors.white),)
                                                      :controller.myExpeditionsPage == 2?Text(AppLocalizations.of(context).offer, style: TextStyle(color: Colors.white))
                                                  :Text('Reception Offer', style: TextStyle(color: Colors.white)),
                                                ],
                                              )

                                          )
                                              :Text('${AppLocalizations.of(context).my} ${AppLocalizations.of(context).shipping}',textAlign: TextAlign.center, style: Get.textTheme.headline5.merge(TextStyle(color: controller.currentPage.value == 0 ?Colors.white: Colors.white.withOpacity(0.4)))),
                                        )
                                    ),
                                    if( !(controller.myExpeditionsPage == 1 ||controller.myExpeditionsPage == 2 ||controller.myExpeditionsPage == 3 ) )...[
                                      InkWell(
                                        onTap: ()async {
                                          controller.currentPage.value = 1;
                                          Get.find<UserTravelsController>().refreshMyTravels();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          width: Get.width/3.3,
                                          decoration: BoxDecoration(
                                              border: controller.currentPage.value == 1 ? Border(bottom: BorderSide(color: Colors.white, width: 4)) : null
                                          ),
                                          child: Text(AppLocalizations.of(context).myTravels,textAlign: TextAlign.center, style: Get.textTheme.headline5.merge(TextStyle(color: controller.currentPage.value == 1 ?Colors.white: Colors.white.withOpacity(0.4)))),
                                        ),
                                      ),
                                    ],
                                    if( !(controller.myExpeditionsPage == 1 ||controller.myExpeditionsPage == 2 ||controller.myExpeditionsPage == 3) )...[
                                      InkWell(
                                          onTap: ()=> {
                                            controller.currentPage.value = 2,
                                            Get.find<ValidationController>().refreshPage()
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            width: Get.width/3.3,
                                            decoration: BoxDecoration(
                                                border: controller.currentPage.value == 2 ? Border(bottom: BorderSide(color: Colors.white, width: 4)) : null
                                            ),
                                            child: Text(AppLocalizations.of(context).myParcels,textAlign: TextAlign.center, style: Get.textTheme.headline5.merge(TextStyle(color: controller.currentPage.value == 2 ?Colors.white: Colors.white.withOpacity(0.4)))),
                                          )
                                      ),
                                    ]


                                  ]
                              ),
                              Visibility(child: SizedBox())
                            ],),

                            controller.currentPage.value == 0 ? MyBookings(context) :
                            controller.currentPage.value == 1 ? MyTravelsView() :
                            ParcelView()
                          ]
                      )
                  )
              )

          )
      ),
    );
  }

  Widget MyBookings(BuildContext context){

    return Obx(() => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: backgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0)), ),
        height: Get.height,
        width: Get.width,
        child: controller.myExpeditionsPage == 0 ? DelayedAnimation(delay: 30,child: offersOrRequests()) :
        controller.myExpeditionsPage == 1 ? shippingRequests() :
        controller.myExpeditionsPage == 2?
        shippingsOffers():
            receptionOffers()
    ));
  }

  Widget shippingRequests(){
    return Column(
      children: [

        controller.isLoading.value ?
        Expanded(child: LoadingCardWidget()) :
        Expanded(
            child: controller.items.isNotEmpty ?
            ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: controller.items.length+1 ,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {

                  if (index == controller.items.length) {
                    return SizedBox(height: 120);
                  } else {

                    Future.delayed(Duration.zero, (){
                      controller.items.sort((a, b) => b["create_date"].compareTo(a["create_date"]));
                    });
                    return InkWell(
                        onTap: ()async=>{

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context).loadingData),
                            duration: Duration(seconds: 2),
                          )),

                          controller.items[index]['booking_type'] == 'By Road'?
                          await controller.getRoadTravelInfo(controller.items[index]['travelbooking_id'][0])
                              :await controller.getAirTravelInfo(controller.items[index]['travelbooking_id'][0]),
                          controller.owner.value = true,
                          controller.shippingDetails.value = controller.items[index],
                          if(controller.shippingDetails != null){

                            if(controller.travelDetails['booking_type'].toLowerCase() == "air"){
                              controller.imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                              //"assets/img/istockphoto-1421193265-612x612.jpg";
                            }else if(controller.travelDetails['booking_type'].toLowerCase() == "sea"){
                              controller.imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                              //"assets/img/pexels-julius-silver-753331.jpg";
                            }else{
                              controller.imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                              //"assets/img/istockphoto-859916128-612x612.jpg";
                            },

                            Get.toNamed(Routes.SHIPPING_DETAILS,arguments: {'shippingType':'shippingRequest'}),
                            print(controller.items[index]['average_rating']),
                            print(controller.items[index]['id']),
                          },
                        },
                        child: CardWidget(
                          owner: true,
                          homePage: false,
                          travellerDisagree: controller.items[index]['booking_type']== 'By Road'?controller.items[index]['disagree']:false,
                          shippingDate: controller.items[index]['create_date'],
                          code: controller.items[index]['name'],
                          travelType: controller.items[index]['booking_type']=='By Road'?'road':'air',
                          transferable: controller.items[index]['state'].toLowerCase()=='rejected' || controller.items[index]['state'].toLowerCase()=='pending' ? true:false,
                          bookingState: controller.items[index]['state'],
                          price: controller.items[index]['shipping_price'],
                          text: "${controller.items[index]['travel_departure_city_name'].split(" ").first} > ${controller.items[index]['travel_arrival_city_name'].split(" ").first}",
                          detailsView: TextButton(
                            onPressed: ()async=> {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 3),
                              )),
                              controller.items[index]['booking_type'] == 'By Road'?
                              await controller.getRoadTravelInfo(controller.items[index]['travelbooking_id'][0])
                                  :await controller.getAirTravelInfo(controller.items[index]['travelbooking_id'][0]),
                              controller.shippingDetails.value = controller.items[index],
                              controller.owner.value = true,
                              if(controller.shippingDetails != null){

                                if(controller.travelDetails['booking_type'].toLowerCase() == "air"){
                                  controller.imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                  //"assets/img/istockphoto-1421193265-612x612.jpg";
                                }else if(controller.travelDetails['booking_type'].toLowerCase() == "sea"){
                                  controller.imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                  //"assets/img/pexels-julius-silver-753331.jpg";
                                }else{
                                  controller.imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                  //"assets/img/istockphoto-859916128-612x612.jpg";
                                },

                                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingRequest'})
                              }
                            },
                            child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                          ),
                          negotiation: controller.items[index]['booking_type'].toString() == 'By Road'?!controller.items[index]['disagree']  ? controller.items[index]['msg_shipping_accepted'] ?
                          GestureDetector(
                              onTap: ()=> Get.toNamed(Routes.CHAT, arguments: {'shippingCard': controller.items[index]}) ,
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
                                          controller.transferShipping(controller.items[index]['id']),
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
                          ):SizedBox(),

                        )
                    );}
                }).marginOnly(bottom: 180) :
            Column(
                children: [
                  SizedBox(height: MediaQuery.of(Get.context).size.height /4),
                  FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                  Text(AppLocalizations.of(Get.context).noShippingFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                ]
            )
        )

      ],
    );
  }

  Widget shippingsOffers(){
    return Column(
      children: [
        controller.isLoading.value ?
        Expanded(child: LoadingCardWidget()) :
        Expanded(
            child: controller.items.isNotEmpty ?
            ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: controller.items.length+1 ,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {

                  if (index == controller.items.length) {
                    return SizedBox(height: 120);
                  } else {

                    Future.delayed(Duration.zero, (){
                      controller.items.sort((a, b) => b["create_date"].compareTo(a["create_date"]));
                    });
                    return InkWell(
                        onTap: ()async=>{

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context).loadingData),
                            duration: Duration(seconds: 2),
                          )),
                          //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                          controller.owner.value = true,
                          controller.shippingDetails.value = controller.items[index],
                          if(controller.shippingDetails != null){
                            if(controller.travelDetails.isNotEmpty){
                              if(controller.travelDetails['booking_type'].toLowerCase() == "air"){
                                controller.imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                //"assets/img/istockphoto-1421193265-612x612.jpg";
                              }else if(controller.travelDetails['booking_type'].toLowerCase() == "sea"){
                                controller.imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                //"assets/img/pexels-julius-silver-753331.jpg";
                              }else{
                                controller.imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                //"assets/img/istockphoto-859916128-612x612.jpg";
                              },
                            }
                            else{

                            },
                            print('Travel Details: ${controller.shippingDetails['travelbooking_id']}'),
                            Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingOffer'})
                          },
                        },
                        child: CardWidget(
                          owner: true,
                          homePage: false,
                          travellerDisagree: controller.items[index]['disagree'],
                          shippingDate: controller.items[index]['create_date'],
                          code: controller.items[index]['name'],
                          travelType: controller.items[index]['booking_type'],
                          transferable: controller.items[index]['state'].toLowerCase()=='rejected' || controller.items[index]['state'].toLowerCase()=='pending' ? true:false,
                          bookingState: controller.items[index]['state'],
                          price: controller.items[index]['shipping_price'],
                          text:  "${controller.items[index]['shipping_departure_city_id'][1].split(" ").first} > ${controller.items[index]['shipping_arrival_city_id'][1].split(" ").first}",
                          detailsView: TextButton(
                            onPressed: ()async=> {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 3),
                              )),
                              //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                              controller.shippingDetails.value = controller.items[index],
                              controller.owner.value = true,
                              if(controller.shippingDetails != null){
                                if(controller.travelDetails.isNotEmpty){
                                  if(controller.travelDetails['booking_type'].toLowerCase() == "air"){
                                    controller.imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                    //"assets/img/istockphoto-1421193265-612x612.jpg";
                                  }else if(controller.travelDetails['booking_type'].toLowerCase() == "sea"){
                                    controller.imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                    //"assets/img/pexels-julius-silver-753331.jpg";
                                  }else{
                                    controller.imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                    //"assets/img/istockphoto-859916128-612x612.jpg";
                                  },
                                }else{

                                },



                                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingOffer'})


                              }
                            },
                            child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                          ),
                          negotiation: !controller.items[index]['disagree']  ? controller.items[index]['msg_shipping_accepted'] ?
                          GestureDetector(
                              onTap: ()=> Get.toNamed(Routes.CHAT, arguments: {'shippingCard': controller.items[index]}) ,
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
                                          controller.transferShipping(controller.items[index]['id']),
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
                    );}
                }).marginOnly(bottom: 180) :
            Column(
                children: [
                  SizedBox(height: MediaQuery.of(Get.context).size.height /4),
                  FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                  Text(AppLocalizations.of(Get.context).noShippingFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                ]
            )
        )

      ],);

  }

  Widget receptionOffers(){
    return Column(
      children: [
        controller.isLoading.value ?
        Expanded(child: LoadingCardWidget()) :
        Expanded(
            child: controller.items.isNotEmpty ?
            ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: controller.items.length+1 ,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {

                  if (index == controller.items.length) {
                    return SizedBox(height: 120);
                  } else {

                    Future.delayed(Duration.zero, (){
                      controller.items.sort((a, b) => b["create_date"].compareTo(a["create_date"]));
                    });
                    return InkWell(
                        onTap: ()async=>{

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context).loadingData),
                            duration: Duration(seconds: 2),
                          )),
                          //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                          controller.owner.value = true,
                           controller.items[index]['travelbooking_id'] != false?
                          await controller.getRoadTravelInfo(controller.items[index]['travelbooking_id'][0]):(){},
                          controller.shippingDetails.value = controller.items[index],

                          if(controller.shippingDetails != null){
                            if(controller.travelDetails.isNotEmpty){
                              if(controller.travelDetails['booking_type'].toLowerCase() == "air"){
                                controller.imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                //"assets/img/istockphoto-1421193265-612x612.jpg";
                              }else if(controller.travelDetails['booking_type'].toLowerCase() == "sea"){
                                controller.imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                //"assets/img/pexels-julius-silver-753331.jpg";
                              }else{
                                controller.imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                //"assets/img/istockphoto-859916128-612x612.jpg";
                              },
                            }
                            else{

                            },
                            print('Travel Details: ${controller.shippingDetails['travelbooking_id']}'),
                            Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'receptionOffer'})
                          },
                          print(controller.items[index]['booking_type']),
                        },
                        child: CardWidget(
                          homePage: false,
                          owner: true,
                          travellerDisagree: controller.items[index]['disagree'],
                          shippingDate: controller.items[index]['create_date'],
                          code: controller.items[index]['name'],
                          travelType: controller.items[index]['booking_type'],
                          transferable: controller.items[index]['state'].toLowerCase()=='rejected' || controller.items[index]['state'].toLowerCase()=='pending' ? true:false,
                          bookingState: controller.items[index]['state'],
                          price: controller.items[index]['shipping_price'],
                          text: "${controller.items[index]['shipping_departure_city_id'][1].split(" ").first} > ${controller.items[index]['shipping_arrival_city_id'][1].split(" ").first}",
                          detailsView: TextButton(
                            onPressed: ()async=> {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 3),
                              )),
                              //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                              controller.shippingDetails.value = controller.items[index],
                              controller.items[index]['travelbooking_id'] != false?
                              await controller.getRoadTravelInfo(controller.items[index]['travelbooking_id'][0]):(){},
                              //await controller.getRoadTravelInfo(controller.items[index]['travelbooking_id'][0]),
                              controller.owner.value = true,
                              if(controller.shippingDetails != null){
                                if(controller.travelDetails.isNotEmpty){
                                  if(controller.travelDetails['booking_type'].toLowerCase() == "air"){
                                    controller.imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                    //"assets/img/istockphoto-1421193265-612x612.jpg";
                                  }else if(controller.travelDetails['booking_type'].toLowerCase() == "sea"){
                                    controller.imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                    //"assets/img/pexels-julius-silver-753331.jpg";
                                  }else{
                                    controller.imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                    //"assets/img/istockphoto-859916128-612x612.jpg";
                                  },
                                }else{

                                },



                                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'receptionOffer'})
                              }
                            },
                            child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                          ),
                          negotiation: !controller.items[index]['disagree']  ? controller.items[index]['msg_shipping_accepted'] ?
                          GestureDetector(
                              onTap: ()=> Get.toNamed(Routes.CHAT, arguments: {'shippingCard': controller.items[index]}) ,
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
                                          controller.transferShipping(controller.items[index]['id']),
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
                    );}
                }).marginOnly(bottom: 180):
            Column(
                children: [
                  SizedBox(height: MediaQuery.of(Get.context).size.height /4),
                  FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                  Text(AppLocalizations.of(Get.context).noShippingFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                ]
            )
        )

      ],);

  }

  Widget offersOrRequests(){
    return  Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [

          SizedBox(height: 20,),
          Obx(() => InkWell(
              onTap: (){
                controller.items.value = controller.listShippingRequest;
                controller.myExpeditionsPage.value = 1;
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SizedBox(
                  height: Get.height*0.2,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('${AppLocalizations.of(Get.context).myShippingRequest}(${controller.itemsMyShippingRequest.length})',textAlign: TextAlign.center, style: Get.textTheme.headline5.merge(TextStyle(color: interfaceColor)))),
                ),
              ))),
          SizedBox(height: 20,),
          Obx(() => InkWell(
              onTap: () {
                controller.items.value = controller.listShippingOffer;
                controller.myExpeditionsPage.value = 2;
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SizedBox(
                    height: Get.height*0.2,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('${AppLocalizations.of(Get.context).myShippingOffer} (${controller.itemsMyShippingOffer.length})',textAlign: TextAlign.center, style: Get.textTheme.headline5.merge(TextStyle(color: interfaceColor))))),
              )
          )),
          SizedBox(height: 20,),
          Obx(() => InkWell(
              onTap: () {
                controller.items.value = controller.listReceptionOffer;
                controller.myExpeditionsPage.value = 3;
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SizedBox(
                    height: Get.height*0.2,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Reception Offer (${controller.itemsMyReceptionOffer.length})',textAlign: TextAlign.center, style: Get.textTheme.headline5.merge(TextStyle(color: interfaceColor))))),
              )
          )),

        ]
    );
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }
}
