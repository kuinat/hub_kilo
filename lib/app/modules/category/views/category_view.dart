import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../controllers/category_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryView extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {

    Get.lazyPut<HomeController>(
          () => HomeController(),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              if(controller.currentPage.value != 1){
                controller.currentPage.value --;
                controller.refreshPage(controller.currentPage.value);
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.arrow_back_ios, color: controller.currentPage.value != 1 ? Colors.black : inactive)
              ),
            ),
          ),
          Card(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text('${controller.currentPage.value} / ${controller.totalPages.value}', textAlign: TextAlign.center, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: appColor)))
              )
          ),
          InkWell(
            onTap: () {
              if(controller.currentPage.value != controller.totalPages.value){
                controller.currentPage.value ++;
                controller.refreshPage(controller.currentPage.value);
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.arrow_forward_ios_sharp, color: controller.currentPage.value != controller.totalPages.value? Colors.black : inactive)
              ),
            ),
          )
        ],
      )),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshPage(1);
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: buttonColor,
                expandedHeight: 140,
                elevation: 0.5,
                primary: true,
                pinned: true,
                floating: false,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                title: Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  width: 120,
                  child: Text(controller.travelType.value.toUpperCase(), style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white))),
                  decoration: BoxDecoration(
                      color: controller.travelType.value != "air" ? Colors.white.withOpacity(0.4) : interfaceColor.withOpacity(0.4),
                      border: Border.all(
                        color: controller.travelType.value != "air" ? Colors.white.withOpacity(0.2) : interfaceColor.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Obx(() => Center(
                          child: Text(controller.widgetType=='roadTravels'?
                          controller.roadTravelList.length.toString():
                          controller.widgetType== 'expeditionsOffers'?
                          controller.expeditionsOffersList.length.toString():
                          controller.widgetType== 'receptionOffers'?
                          controller.receptionOffersList.length.toString():
                          controller.widgetType=='airTravels'?
                          controller.airTravelList.length.toString():'',
                              style: Get.textTheme.headline5.merge(TextStyle(color: interfaceColor))),
                        )),
                      )
                  )
                ],
                bottom: PreferredSize(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10, left: 10),
                        child:
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(!controller.filterPressed.value)...[
                              SizedBox(
                                  width: Get.width/1.8,
                                  child: TextFormField(
                                    //controller: controller.textEditingController,
                                      style: Get.textTheme.bodyText2,
                                      onChanged: (value)=> controller.filterSearchResults(value),
                                      autofocus: false,
                                      cursorColor: Get.theme.focusColor,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1, color: buttonColor),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          hintText: AppLocalizations.of(context).searchHere,
                                          filled: true,
                                          fillColor: Colors.white,
                                          suffixIcon: Icon(Icons.search),
                                          prefixIcon: GestureDetector(
                                              onTap: (){
                                                controller.filterPressed.value = !controller.filterPressed.value;
                                              },
                                              child: Icon(Icons.filter_alt_rounded)),
                                          hintStyle: Get.textTheme.caption,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                                      )
                                  )
                              ),
                            ],

                            if(controller.filterPressed.value)...[

                              SizedBox(
                                width: Get.width/2.5,
                                child: TextFormField(
                                  //controller: controller.textEditingController,
                                    style: Get.textTheme.bodyText2,
                                    onChanged: (value)=> controller.filterSearchDepartureTown(value),
                                    autofocus: false,
                                    cursorColor: Get.theme.focusColor,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: buttonColor),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        hintText: 'Departure Town',
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintStyle: Get.textTheme.caption,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                                    )
                                ),
                              ),

                              SizedBox(
                                width: Get.width/2.5,
                                child: TextFormField(
                                  //controller: controller.textEditingController,
                                    style: Get.textTheme.bodyText2,
                                    onChanged: (value)=> controller.filterSearchArrivalTown(value),
                                    autofocus: false,
                                    cursorColor: Get.theme.focusColor,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: buttonColor),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        hintText: 'Arrival Town',
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintStyle: Get.textTheme.caption,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                                    )
                                ),
                              ),
                            ],

                            controller.filterPressed.value?IconButton(onPressed: (){
                              controller.filterPressed.value = !controller.filterPressed.value;
                            }, icon:Icon( FontAwesomeIcons.remove, color: Colors.white,))
                                :SizedBox(),

                            //Spacer(),
                            if(!controller.filterPressed.value)...[
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),

                                child: MaterialButton(
                                  onPressed: () async {
                                    if(controller.widgetType=='roadTravels'){
                                      if(Get.find<HomeController>().existingPublishedRoadTravel.isTrue){
                                        Get.showSnackbar(Ui.warningSnackBar(message: 'You already have a road travel in Published state, complete it before creating another travel'));
                                      }
                                      else{

                                        //Navigator.of(context).pop(),
                                        Get.offNamed(Routes.ADD_TRAVEL_FORM);
                                      }
                                    }
                                    else if(controller.widgetType == 'expeditionsOffers'){
                                      Get.find<BookingsController>().offerExpedition.value = true;
                                      Get.toNamed(Routes.CREATE_OFFER_EXPEDITION);
                                      await Get.find<TravelInspectController>().newShippingFunction();
                                    }
                                    else if(controller.widgetType=='airTravels'){
                                      if(Get.find<HomeController>().existingPublishedAirTravel.isTrue){
                                        Get.showSnackbar(Ui.warningSnackBar(message: 'You already have an air travel in Published state, complete it before creating another travel'));
                                      }
                                      else{

                                        Get.toNamed(Routes.ADD_AIR_TRAVEL_FORM);
                                      }

                                    }
                                    else if(controller.widgetType == 'receptionOffers'){
                                      Get.find<BookingsController>().offerReception.value = true;
                                      Get.toNamed(Routes.CREATE_RECEPTION_OFFER);
                                      await Get.find<TravelInspectController>().newShippingFunction();
                                    }
                                    else{

                                    }

                                  },
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                  //color: this.color,
                                  disabledElevation: 0,
                                  disabledColor: Get.theme.focusColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: Row(children: [
                                    Icon(Icons.add, color: Colors.white),
                                    Text(AppLocalizations.of(context).create, style: TextStyle(color: Colors.white),)

                                  ],),
                                  elevation: 0,
                                ),
                              ),
                            ],
                            SizedBox(width: 10)

                          ],
                        ))
                    ),
                    preferredSize: Size.fromHeight(50.0)),
                flexibleSpace: Row(
                    children: [
                      Container(
                          width: Get.width,
                          child: FlexibleSpaceBar(
                            background: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(controller.imageUrl.value), fit: BoxFit.cover)
                              ),
                            ),
                          )
                      )
                    ]
                )
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  Obx(() => controller.widgetType =='roadTravels'?
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: controller.loading.value ?
                      LoadingCardWidget() :
                      ListView.builder(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.roadTravelList.length,
                        itemBuilder: ((_, index) {
                          Future.delayed(Duration.zero, (){
                            controller.roadTravelList.sort((a, b) => a["departure_date"].compareTo(b["departure_date"]));
                          });
                          return GestureDetector(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: TravelCardWidget(
                                  isUser: false,
                                  homePage: false,
                                  travelBy: controller.roadTravelList[index]['booking_type'],
                                  depDate: DateFormat("dd MMM yyyy", 'fr_CA').format(DateTime.parse(controller.roadTravelList[index]['departure_date'])).toString().toUpperCase(),
                                  arrTown: controller.roadTravelList[index]['arrival_city_id'][1],
                                  depTown: controller.roadTravelList[index]['departure_city_id'][1],
                                  qty: controller.roadTravelList[index]['kilo_qty'],
                                  price: controller.roadTravelList[index]['price_per_kilo'],
                                  color: background,
                                  text: Text(""),
                                  user: controller.roadTravelList[index]['partner_id'][1],
                                  rating: controller.roadTravelList[index]['average_rating'].toStringAsFixed(1),
                                  imageUrl: '${Domain.serverPort}/image/res.partner/${controller.roadTravelList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true'

                              ),
                            ),
                            onTap: ()=> Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.roadTravelList[index], 'heroTag': 'services_carousel'}),
                            //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                          );
                        }),
                      )):
                  controller.widgetType =='expeditionsOffers'?
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: controller.loading.value ?
                      LoadingCardWidget() :
                      ListView.builder(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.expeditionsOffersList.length,
                        itemBuilder: ((_, index) {
                          Future.delayed(Duration.zero, (){
                            controller.expeditionsOffersList.sort((a, b) => a["shipping_departure_date"].compareTo(b["shipping_departure_date"]));
                          });
                          return GestureDetector(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: CardWidget(
                                  homePage: true,
                                  owner: controller.expeditionsOffersList[index]['partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?true:false,
                                  user: controller.expeditionsOffersList[index]['bool_parcel_reception'] ?
                                  controller.expeditionsOffersList[index]['parcel_reception_receiver_partner_id'][1] : controller.expeditionsOffersList[index]['partner_id'][1],
                                  imageUrl: controller.expeditionsOffersList[index]['bool_parcel_reception'] ?
                                  '${Domain.serverPort}/image/res.partner/${controller.expeditionsOffersList[index]['parcel_reception_receiver_partner_id'][0]}/image_1920?unique=true&file_response=true' :
                                  '${Domain.serverPort}/image/res.partner/${controller.expeditionsOffersList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',
                                  travellerDisagree: controller.expeditionsOffersList[index]['disagree'],
                                  shippingDate: controller.expeditionsOffersList[index]['create_date'],
                                  code: controller.expeditionsOffersList[index]['name'],
                                  travelType: controller.expeditionsOffersList[index]['booking_type'],
                                  transferable: controller.expeditionsOffersList[index]['state'].toLowerCase()=='rejected' || controller.expeditionsOffersList[index]['state'].toLowerCase()=='pending' ? true:false,
                                  bookingState: controller.expeditionsOffersList[index]['state'],
                                  price: controller.expeditionsOffersList[index]['shipping_price'],
                                  text: "${controller.expeditionsOffersList[index]['shipping_departure_city_id'][1].split(" ").first} > ${controller.expeditionsOffersList[index]['shipping_arrival_city_id'][1].split(" ").first}",
                                  detailsView: TextButton(
                                    onPressed: ()async=> {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(AppLocalizations.of(context).loadingData),
                                        duration: Duration(seconds: 3),
                                      )),
                                      Get.find<BookingsController>().shippingDetails.value = controller.expeditionsOffersList[index],
                                      controller.expeditionsOffersList[index]['partner_id'] == Get.find<MyAuthService>().myUser.value.id?
                                      Get.find<BookingsController>().owner.value = false
                                          :Get.find<BookingsController>().owner.value = true,
                                      if(Get.find<BookingsController>().shippingDetails != null){
                                        if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                          if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                            Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60",
                                            //"assets/img/istockphoto-1421193265-612x612.jpg";
                                          }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=",
                                            //"assets/img/pexels-julius-silver-753331.jpg";
                                          }else{
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=",
                                            //"assets/img/istockphoto-859916128-612x612.jpg";
                                          }
                                        }else{
                                          //Get.find<BookingsController>().imageUrl.value = ,

                                        },


                                        Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingOffer'})
                                      }
                                    },
                                    child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                                  ),
                                  negotiation:  SizedBox()

                              ),
                            ),
                            onTap: (){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 3),
                              ));
                              //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                              Get.find<BookingsController>().shippingDetails.value = controller.expeditionsOffersList[index];
                              controller.expeditionsOffersList[index]['partner_id'] == Get.find<MyAuthService>().myUser.value.id?
                              Get.find<BookingsController>().owner.value = false
                                  :Get.find<BookingsController>().owner.value = true;
                              if(Get.find<BookingsController>().shippingDetails != null){
                                if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                  if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                    Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
                                    //"assets/img/istockphoto-1421193265-612x612.jpg";
                                  }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
                                    //"assets/img/pexels-julius-silver-753331.jpg";
                                  }else{
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
                                    //"assets/img/istockphoto-859916128-612x612.jpg";
                                  }
                                }else{

                                }



                                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'shippingOffer'});
                              }
                            },
                            //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                          );
                        }),
                      )):
                  controller.widgetType =='receptionOffers'?
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: controller.loading.value ?
                      LoadingCardWidget() :
                      ListView.builder(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.receptionOffersList.length,
                        itemBuilder: ((_, index) {
                          Future.delayed(Duration.zero, (){
                            controller.receptionOffersList.sort((a, b) => a["shipping_departure_date"].compareTo(b["shipping_departure_date"]));
                          });
                          return GestureDetector(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: CardWidget(
                                  homePage: true,
                                  owner: controller.receptionOffersList[index]['parcel_reception_receiver_partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?true:false,
                                  user: controller.receptionOffersList[index]['bool_parcel_reception'] ?
                                  controller.receptionOffersList[index]['parcel_reception_receiver_partner_id'][1] : controller.receptionOffersList[index]['partner_id'][1],
                                  imageUrl: controller.receptionOffersList[index]['bool_parcel_reception'] ?
                                  '${Domain.serverPort}/image/res.partner/${controller.receptionOffersList[index]['parcel_reception_receiver_partner_id'][0]}/image_1920?unique=true&file_response=true' :
                                  '${Domain.serverPort}/image/res.partner/${controller.receptionOffersList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',
                                  travellerDisagree: controller.receptionOffersList[index]['disagree'],
                                  shippingDate: controller.receptionOffersList[index]['create_date'],
                                  code: controller.receptionOffersList[index]['name'],
                                  travelType: controller.receptionOffersList[index]['booking_type'],
                                  transferable: controller.receptionOffersList[index]['state'].toLowerCase()=='rejected' || controller.receptionOffersList[index]['state'].toLowerCase()=='pending' ? true:false,
                                  bookingState: controller.receptionOffersList[index]['state'],
                                  price: controller.receptionOffersList[index]['shipping_price'],
                                  text: "${controller.receptionOffersList[index]['shipping_departure_city_id'][1].split(" ").first} > ${controller.receptionOffersList[index]['shipping_arrival_city_id'][1].split(" ").first}",
                                  detailsView: TextButton(
                                    onPressed: ()async=> {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(AppLocalizations.of(context).loadingData),
                                        duration: Duration(seconds: 3),
                                      )),
                                      Get.find<BookingsController>().shippingDetails.value = controller.receptionOffersList[index],
                                      controller.receptionOffersList[index]['parcel_reception_receiver_partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?
                                      Get.find<BookingsController>().owner.value = false
                                          :Get.find<BookingsController>().owner.value = true,
                                      if(Get.find<BookingsController>().shippingDetails != null){
                                        if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                          if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                            Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60",
                                            //"assets/img/istockphoto-1421193265-612x612.jpg";
                                          }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=",
                                            //"assets/img/pexels-julius-silver-753331.jpg";
                                          }else{
                                            Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=",
                                            //"assets/img/istockphoto-859916128-612x612.jpg";
                                          }
                                        }else{
                                          //Get.find<BookingsController>().imageUrl.value = ,

                                        },

                                        Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'receptionOffer'})
                                      }
                                    },
                                    child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
                                  ),
                                  negotiation:  SizedBox()

                              ),
                            ),
                            onTap: (){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 3),
                              ));
                              //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                              Get.find<BookingsController>().shippingDetails.value = controller.receptionOffersList[index];
                              controller.receptionOffersList[index]['parcel_reception_receiver_partner_id'][0] == Get.find<MyAuthService>().myUser.value.id?
                              Get.find<BookingsController>().owner.value = false
                                  :Get.find<BookingsController>().owner.value = true;
                              if(Get.find<BookingsController>().shippingDetails != null){
                                if(Get.find<BookingsController>().travelDetails.isNotEmpty){
                                  if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "air"){
                                    Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
                                    //"assets/img/istockphoto-1421193265-612x612.jpg";
                                  }else if(Get.find<BookingsController>().travelDetails['booking_type'].toLowerCase() == "sea"){
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
                                    //"assets/img/pexels-julius-silver-753331.jpg";
                                  }else{
                                    Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
                                    //"assets/img/istockphoto-859916128-612x612.jpg";
                                  }
                                }else{

                                }



                                Get.toNamed(Routes.SHIPPING_DETAILS, arguments: {'shippingType':'receptionOffer'});
                              }
                            },
                            //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                          );
                        }),
                      )):
                  controller.widgetType =='airTravels'?
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: controller.loading.value ?
                      LoadingCardWidget() :
                      ListView.builder(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.airTravelList.length,
                        itemBuilder: ((_, index) {
                          Future.delayed(Duration.zero, (){
                            controller.airTravelList.sort((a, b) => a["departure_date"].compareTo(b["departure_date"]));
                          });
                          return GestureDetector(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: TravelCardWidget(
                                  isUser: false,
                                  homePage: false,
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
                                  travelBy: controller.airTravelList[index]['booking_type'],
                                  depDate: DateFormat("dd MMM yyyy", 'fr_CA').format(DateTime.parse(controller.airTravelList[index]['departure_date'])).toString().toUpperCase(),
                                  arrTown: controller.airTravelList[index]['arrival_city_id'][1],
                                  depTown: controller.airTravelList[index]['departure_city_id'][1],
                                  qty: controller.airTravelList[index]['kilo_qty'],
                                  price: controller.airTravelList[index]['price_per_kilo'],
                                  color: background,
                                  text: Text(""),
                                  user: controller.airTravelList[index]['partner_id'][1],
                                  rating: controller.airTravelList[index]['booking_type'] == 'road'?controller.airTravelList[index]['average_rating'].toStringAsFixed(1):controller.airTravelList[index]['air_average_rating'].toStringAsFixed(1),
                                  imageUrl: '${Domain.serverPort}/image/res.partner/${controller.airTravelList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true'

                              ),
                            ),
                            onTap: ()=> Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.airTravelList[index], 'heroTag': 'services_carousel'}),
                            //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                          );
                        }),
                      )):
                  Padding(padding: EdgeInsets.zero)
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSearchBar(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1.5;
    return Container(
      height: 40,
      width: width,
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        //controller: controller.textEditingController,
        style: Get.textTheme.bodyText2,
        onChanged: (value)=> controller.filterSearchResults(value),
        autofocus: false,
        cursorColor: Get.theme.focusColor,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: buttonColor),
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: AppLocalizations.of(context).create,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.search),
            hintStyle: Get.textTheme.caption,
            contentPadding: EdgeInsets.all(10)
        ),
      ),
    );
  }
}
