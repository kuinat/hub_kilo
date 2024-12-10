import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../add_ravel_form/Views/add_travel_form.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';
import '../controllers/travel_inspect_controller.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TravelInspectView extends GetView<TravelInspectController> {

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut(()=>AddTravelController());
    Get.lazyPut(()=>AddTravelsView());
    
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
                          child: FaIcon(FontAwesomeIcons.arrowLeft, color: buttonColor)
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
                        child: Text(controller.travelCard['booking_type'].toString().toUpperCase(), style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white))),
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
                    ).marginOnly(bottom: 10),
                  ),
                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if(Get.find<MyAuthService>().myUser.value.id != controller.travelCard['partner_id'][0])...[
                          Obx(() => EServiceTilWidget(
                              title: Text(AppLocalizations.of(context).description.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black, fontSize: 14))),
                              title2: SizedBox(),
                              content: Column(
                                  children: [

                                    if(controller.travelCard['booking_type'] == 'road')...[
                                      ListTile(
                                        title: Text(AppLocalizations.of(context).state, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor))),
                                        trailing:Text(controller.travelCard['state'] == "negotiating" ? AppLocalizations.of(context).statePublished.toUpperCase() : controller.travelCard['state'].toUpperCase(), style: Get.textTheme.headline2.merge(TextStyle(color: controller.travelCard['state'] == 'negotiating' ? validateColor : controller.travelCard['state'] == 'rejected' ? specialColor :
                                        controller.travelCard['state'] == 'received' ? doneStatus : inactive, fontSize: 14))),
                                        //Text(controller.travelCard['state'] == "negotiating" ? "Published" : controller.travelCard['state'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                      ),
                                    ]
                                    else...[
                                      ListTile(
                                        title: Text('Type of Luggages allowed', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold))),
                                      ),
                                      Obx(() =>  controller.specificAirTravelLuggage.isEmpty?
                                      SizedBox(
                                        height: 100,
                                      ):
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          itemCount: controller.specificAirTravelLuggage.length,
                                          itemBuilder: (_, index){
                                            return ExpansionTile(
                                              initiallyExpanded: true,
                                              title: Text(controller.specificAirTravelLuggage[index]['luggage_type_id'][1],style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: appColor, fontWeight: FontWeight.bold)) ),
                                              leading: Icon(controller.specificAirTravelLuggage[index]['luggage_type_id'][1] == 'KILO'?FontAwesomeIcons.luggageCart: controller.specificAirTravelLuggage[index]['luggage_type_id'][1] == 'ENVELOP'? FontAwesomeIcons.envelope:FontAwesomeIcons.computer),
                                              children: [
                                                ListTile(
                                                  title: Text('Available Weight', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: Colors.grey.shade500))),
                                                  trailing: Text(controller.specificAirTravelLuggage[index]['quantity'].toString() , style: Get.textTheme.headline2.merge(TextStyle(fontSize: 12, color: Colors.black))),
                                                ),
                                                ListTile(
                                                  title: Text(AppLocalizations.of(context).priceKg, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: Colors.grey.shade500))),
                                                  trailing: Text(controller.specificAirTravelLuggage[index]['price'].toString() + " "+ controller.travelCard['local_currency_id'][1], style: Get.textTheme.headline2.merge(TextStyle(fontSize: 12, color: Colors.black))),
                                                )

                                              ],
                                            );
                                          },


                                        ),
                                      )),
                                      ListTile(
                                        title: Text('Hand over Address', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w900)),),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Street: ', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold)),
                                          Text(controller.travelCard['street'], style: TextStyle(color: Colors.grey.shade700)),


                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('City: ', style: TextStyle(color: labelColor,)),
                                          Text(controller.travelCard['city'][1], style: TextStyle(color: Colors.grey.shade700)),

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('State: ', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold)),
                                          Text(controller.travelCard['state_id'].toString()!= '[false, false]' ?controller.travelCard['state_id'][1]:'', style: TextStyle(color: Colors.grey.shade700)),

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Country: ', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold),),
                                          Text(controller.travelCard['country_id'][1], style: TextStyle(color: Colors.grey.shade700,)),

                                        ],
                                      ),



                                     ]




                                  ]
                              )
                          )),
                          EServiceTilWidget(
                            title: Text(AppLocalizations.of(context).aboutTraveler.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black, fontSize: 14))),
                            title2: Obx(() =>
                            controller.travelCard['average_rating'] != 0.0 ?
                            TextButton(
                                onPressed: ()=>{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context).loadingData),
                                    duration: Duration(seconds: 3),
                                  )),
                                  controller.getUser(controller.travelCard['partner_id'][0]),

                                },
                                child: Text( !controller.viewRatings.value ? AppLocalizations.of(context).viewRatings : "", style: Get.textTheme.subtitle2.merge(TextStyle(color: interfaceColor)))
                            ) : Text('')),
                            content: buildUserDetailsCard(context),
                            actions: [],
                          ),
                        ]else...[
                          buildShippingsByTravel(context)
                        ]
                      ]
                    )
                  )
                ]
              )
          )
        );
    });
  }

  Widget buildShippingsByTravel(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: Get.height/1.2,
      width: Get.width,
      decoration: BoxDecoration(
          color: background,
          //color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
          ]
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: controller.mixedTravelShipping.length + 1,
                  itemBuilder: (context, index){
                    Future.delayed(Duration.zero, (){
                      controller.mixedTravelShipping.sort((a, b) => a["shipping_departure_date"].compareTo(b["shipping_departure_date"]));
                    });
                    return Column(
                      children: [
                        if(index == 0)
                        EServiceTilWidget(
                            title: Text(AppLocalizations.of(context).description.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black))),
                            title2: Text(''),
                            content: Column(
                                children: [
                                  ListTile(
                                    title: Text(AppLocalizations.of(context).state, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor))),
                                    trailing:Text(controller.travelCard['state'] == "negotiating" ? AppLocalizations.of(context).statePublished.toUpperCase() : controller.travelCard['state'].toUpperCase(), style: Get.textTheme.headline2.merge(TextStyle(color: controller.travelCard['state'] == 'negotiating' ? validateColor : controller.travelCard['state'] == 'rejected' ? specialColor :
                                    controller.travelCard['state'] == 'received' ? doneStatus : inactive, fontSize: 12))),
                                    //Text(controller.travelCard['state'] == "negotiating" ? "Published" : controller.travelCard['state'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                  ),
                                  if (controller.travelCard['booking_type'] == 'road')...[
                                    ListTile(
                                      title: Text(AppLocalizations.of(context).totalShippingPrice, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor))),
                                      trailing: Text(controller.travelCard['booking_price'].toString() + " "+ controller.travelCard['local_currency_id'][1]
                                          , style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: appColor))),
                                    ),
                                  ]
                                  else...[
                                    ListTile(
                                      title: Text('Type of Luggages allowed', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w900))),

                                    ),
                                    for(var item in controller.specificAirTravelLuggage)...[
                                      ExpansionTile(
                                        title: Text(item['luggage_type_id'][1],style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)) ),
                                        leading: Icon(item['luggage_type_id'][1] == 'KILO'?FontAwesomeIcons.luggageCart: item['luggage_type_id'][1] == 'COMPUTER'? FontAwesomeIcons.computer:FontAwesomeIcons.envelope),
                                        children: [
                                          ListTile(
                                            title: Text('Available Weight', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold))),
                                            trailing: Text(item['quantity'].toString() , style: Get.textTheme.headline2.merge(TextStyle(fontSize: 18, color: appColor))),
                                          ),
                                          ListTile(
                                            title: Text(AppLocalizations.of(context).priceKg, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold))),
                                            trailing: Text(item['price'].toString() + " "+ controller.travelCard['local_currency_id'][1], style: Get.textTheme.headline2.merge(TextStyle(fontSize: 18, color: appColor))),
                                          )

                                        ],
                                      )
                                    ],
                                    ListTile(
                                      title: Text('Hand over Address', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w900)),),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Country: ', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold),),
                                        Text(controller.travelCard['country_id'][1], style: TextStyle(color: Colors.grey.shade700,)),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('City: ', style: TextStyle(color: labelColor,)),
                                        Text(controller.travelCard['city'][1], style: TextStyle(color: Colors.grey.shade700)),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('State: ', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold)),
                                        controller.travelCard['state_id'].toString() != 'false'&& controller.travelCard['state_id'].toString() != '[false, false]' ?
                                        Text( controller.travelCard['state_id'][1].toString(), style: TextStyle(color: Colors.grey.shade700))
                                        :Text('', style: TextStyle(color: Colors.grey.shade700)),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Street: ', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold)),
                                        Text(controller.travelCard['street'], style: TextStyle(color: Colors.grey.shade700)),

                                      ],
                                    )



                                  ]

                                ]
                            )
                        ),
                          controller.loadingShipping.value ?
                          LoadingCardWidget() : controller.mixedTravelShipping.isEmpty ?
                          SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 50),
                                    Text(AppLocalizations.of(context).noShippingFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                                  ]
                              )
                          ) : index != controller.mixedTravelShipping.length ?
                          buildShippingCard(context,controller.mixedTravelShipping[index], index)
                              : SizedBox(height: Get.height/2),
                      ]
                    );
                  }
              )
          )
        ],
      )),
    );
  }

  Widget buildShippingCard(BuildContext context,var booking, int index){

    print(booking['receiver_partner_id']);

    return booking['state'] != "rejected" ? CardWidget(
      owner: false,
      homePage: true,
      user: booking['booking_type']=='By Road'? booking['bool_parcel_reception'] ?
      booking['parcel_reception_receiver_partner_id'][1] : booking['partner_id'][1]:booking['partner_id'][1],
      imageUrl: booking['booking_type']=='By Road'?
      booking['bool_parcel_reception'] ?
      '${Domain.serverPort}/image/res.partner/${booking['parcel_reception_receiver_partner_id'][0]}/image_1920?unique=true&file_response=true' :
      '${Domain.serverPort}/image/res.partner/${booking['partner_id'][0]}/image_1920?unique=true&file_response=true' :
      '${Domain.serverPort}/image/res.partner/${booking['partner_id'][0]}/image_1920?unique=true&file_response=true' ,
      markReceived: ()=>{
        print(booking['booking_type']),
        showDialog(
            context: context,
            builder: (_){
              return PopUpWidget(
                cancel: AppLocalizations.of(context).cancel,
                confirm: AppLocalizations.of(context).confirm,
                onTap: ()=>{
                  showDialog(
                      context: context,
                      builder: (_){
                        return SizedBox(height: 30,
                            child: SpinKitThreeBounce(color: Colors.white, size: 30)
                        );
                      }),
                  booking['booking_type']=='By Road' || booking['booking_type']=='road'?
                  controller.markReceivedForRoad(booking['id'])
                      :controller.markReceivedForAir(booking['id'])
                },
                icon: Icon(Icons.warning_amber_rounded, size: 40, color: inactive),
                title: AppLocalizations.of(context).confirmLuggageReceptionDialog,
              );
            })
      },
      travellerDisagree: booking['disagree'] != null? booking['disagree']:false,
      shippingDate: booking['create_date'],
      code: booking['name'],
      travelType: booking['booking_type'],
      editable: booking['state'].toLowerCase()=='pending' ? true:false,
      transferable: false,
      //booking['state'].toLowerCase()=='rejected' || booking['state'].toLowerCase()=='pending' ? true:
      bookingState: booking['state'],
      price: booking['shipping_price'],
      text: "${booking['travel_departure_city_name'].split(" ").first} > ${booking['travel_arrival_city_name'].split(" ").first}",
      negotiation: booking['msg_shipping_accepted'] != null?booking['msg_shipping_accepted'] ?
      GestureDetector(
          onTap: ()=> Get.toNamed(Routes.CHAT, arguments: {'shippingCard': booking}) ,
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
                    ]
                  )
              )
          )
      ) : SizedBox():SizedBox(),
      detailsView: TextButton(
        onPressed: ()async=> {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).loadingData),
            duration: Duration(seconds: 3),
          )),

          booking['booking_type'] == 'By Road'?
          await controller.getRoadTravelInfo(booking['travelbooking_id'][0], booking)
              :await controller.getAirTravelInfo(booking['travelbooking_id'][0], booking)

        },
        child: Text(AppLocalizations.of(context).moreInfo, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: interfaceColor))),
      ),
    ) : SizedBox();
  }

  Widget buildUserDetailsCard(BuildContext context) {
    return Obx(() => SizedBox(
      height: !controller.viewRatings.value ? 80 : Get.height/2,
      width: Get.width,
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: FadeInImage(
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.travelCard['partner_id'][0]}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                      placeholder: AssetImage(
                          "assets/img/loading.gif"),
                      imageErrorBuilder:
                          (context, error, stackTrace) {
                        return Image.asset(
                            'assets/img/téléchargement (3).png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.fitWidth);
                      },
                    )
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(controller.travelCard['partner_id'][1],
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 2,
                        style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)),
                      ),
                    ],
                  ),
                ),

                Text("⭐️ ${controller.travelCard['booking_type']=='road'?controller.travelCard['average_rating'].toStringAsFixed(1):controller.travelCard['air_average_rating'].toStringAsFixed(1)}", style: TextStyle(fontSize: 12, color: appColor))
              ]
          ),
          Expanded(
            child: ListView.builder(
                itemCount: controller.ratings.length+1,
                itemBuilder: (_, index){
                  if(index != controller.ratings.length){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipOval(
                                  child: FadeInImage(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.ratings[index]['rater_id'][0]}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/téléchargement (3).png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fitWidth);
                                    },
                                  )
                              ),
                              Flexible(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                        width: Get.width,
                                        margin: EdgeInsets.only(top: 5.0),
                                        child: Row(
                                            children: [
                                              Expanded(child: Text(controller.ratings[index]['rater_id'][1],
                                                style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 12)),
                                              )),
                                              for(var i=0; i < int.parse(controller.ratings[index]['rating']); i++)...[
                                                Text('⭐️')
                                              ]
                                            ]
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text("\n" + controller.ratings[index]['comment'].toString(),
                                          style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 10)),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                              DateFormat('dd, MMM yyyy').format(DateTime.parse(controller.ratings[index]['rating_date'])),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 12))
                          ),
                        ),
                      ],
                    );
                  }else{
                    return SizedBox(height: Get.height/2);
                  }
                }),
          )
        ],
      ),
    ));
  }

  Container buildCarouselBullets(BuildContext context) {
    double width = MediaQuery.of(context).size.width/1.2;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Container(
            alignment: Alignment.center,
            width: width,
            height: 100,
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
                    Text(AppLocalizations.of(context).departure.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    //FaIcon(FontAwesomeIcons.planeDeparture),
                    SizedBox(height: 10),
                    RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.parse(controller.travelCard['departure_date'])), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                              TextSpan(text: "\n${controller.travelCard['departure_date'].split(" ").last}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                            ]
                        ))
                  ]
                ),
                Spacer(),
                Column(
                  children: [
                    Text(AppLocalizations.of(context).arrival.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    //FaIcon(FontAwesomeIcons.planeArrival),
                    SizedBox(height: 10),
                    RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.parse(controller.travelCard['arrival_date'])), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                              TextSpan(text: "\n${controller.travelCard['arrival_date'].split(" ").last}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                            ]
                        ))
                  ],
                )
              ],
            )
        )
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width/2.8;

    String departureCity = controller.travelCard['departure_city_id'][1].split('(').first;
    String a = controller.travelCard['departure_city_id'][1].split('(').last;
    String departureCountry = a.split(')').first;

    String arrivalCity = controller.travelCard['arrival_city_id'][1].split('(').first;
    String b = controller.travelCard['arrival_city_id'][1].split('(').last;
    String arrivalCountry = b.split(')').first;

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
                child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: departureCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.w900))),
                          TextSpan(text: "\n$departureCountry".toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                        ]
                    ))
              ),
              FaIcon(FontAwesomeIcons.arrowRight),
              Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: arrivalCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.w900))),
                            TextSpan(text: "\n$arrivalCountry".toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                          ]
                      ))
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ]
        ),
        child: controller.travelCard['state'] != 'completed' ?
        Padding(
          padding: EdgeInsets.only(left: 40,right: 40),

          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(Get.find<MyAuthService>().myUser.value.id != controller.travelCard['partner_id'][0])...[
                if(!controller.transferBooking.value)...[
                  BlockButtonWidget(
                      text: Container(
                        height: 24,
                        alignment: Alignment.center,
                        child: Text(
                          "${AppLocalizations.of(context).ship} ${AppLocalizations.of(context).now}".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      color: Get.theme.colorScheme.secondary,
                      onPressed: () async{
                        print(Get.find<MyAuthService>().myUser.value.id);

                        if(Get.find<MyAuthService>().myUser.value.email != null){
                          Get.toNamed(Routes.ADD_SHIPPING_FORM);
                          await Get.find<TravelInspectController>().newShippingFunction();

                        }else{
                          await Get.offNamed(Routes.LOGIN);
                        }
                      })
                ]else...[
                  BlockButtonWidget(
                      text: Container(
                        height: 24,
                        alignment: Alignment.center,
                        child: Text(
                          "${AppLocalizations.of(context).transfer} ${AppLocalizations.of(context).now}".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      color: Get.theme.colorScheme.secondary,
                      onPressed: () async{
                        if(Get.find<MyAuthService>().myUser.value.email != null){
                          controller.travelCard['booking_type'] == 'road'?
                          controller.transferRoadTravelShipping():
                          controller.transferAirTravelShipping();
                        }else{
                          await Get.offNamed(Routes.LOGIN);
                        }
                      })
                ]
              ]else...[
                if(controller.travelCard['state'] == 'negotiating')...[
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20,),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: validateColor,
                          ),
                          onPressed: ()=>{
                            showDialog(
                                context: context,
                                builder: (_)=>
                                    PopUpWidget(
                                      title: AppLocalizations.of(context).closeNegotiationMessage,
                                      cancel: AppLocalizations.of(context).cancel,
                                      confirm: AppLocalizations.of(context).confirm,
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_){
                                              return SizedBox(height: 30,
                                                  child: SpinKitThreeBounce(color: Colors.white, size: 30)
                                              );
                                            });
                                        await controller.travelCard['booking_type']== 'road'?controller.closeRoadTravelNegotiation(controller.travelCard['id']):controller.closeAirTravelNegotiation(controller.travelCard['id']);
                                        print(controller.travelCard['id']);

                                      }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                                    )
                            )
                          } ,
                          child: Text(AppLocalizations.of(context).closeNegotiation))
                  )
                ]else...[
                  if(controller.travelCard['state'] == "pending")...[
                    ElevatedButton(
                        onPressed: ()=>{
                          showDialog(
                              context: context,
                              builder: (_)=>
                                  PopUpWidget(
                                    title:  AppLocalizations.of(context).cancelPost,
                                    cancel: AppLocalizations.of(context).cancel,
                                    confirm: AppLocalizations.of(context).confirm,
                                    onTap: (){
                                      print('id is : ${controller.travelCard['id']}');
                                      controller.travelCard['booking_type'] == 'road'?controller.cancelRoadTravel(controller.travelCard['id']):controller.cancelAirTravel(controller.travelCard['id']);
                                      print(controller.travelCard['id']);
                                    }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                                  )
                          )
                        },
                        child: SizedBox(width: 100,height: 30,
                            child: Center(child: Text(AppLocalizations.of(context).cancel)))
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: inactive,
                        ),
                        onPressed: () async =>{

                          Get.delete<AddTravelController>(),
                         // Get.delete<AddTravelsView>(),
                          //Get.put(AddTravelsView()),

                          Get.put(AddTravelController()),

                          controller.travelCard['booking_type']== 'road'?
                          Get.offNamed(Routes.ADD_TRAVEL_FORM, arguments: {'travelCard': controller.travelCard}):
                          Get.offNamed(Routes.ADD_AIR_TRAVEL_FORM, arguments: {'travelCard': controller.travelCard}),
                         // await Navigator.pushReplacementNamed(context, Routes.ADD_TRAVEL_FORM, arguments: {'travelCard': controller.travelCard}),
                          //Get.toNamed(, arguments: )
                        },
                        child: SizedBox(width: 100,height: 30,
                            child: Center(child: Text(AppLocalizations.of(context).edit)))
                    )
                  ]
                ]
              ]
            ]
          )
        ) : Padding(
          padding: EdgeInsets.only(left: 40,right: 40),
           child: Container(
               margin: EdgeInsets.symmetric(horizontal: 20,),
               child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: inactive,
                   ),
                   onPressed: ()=>{
                    Get.showSnackbar(Ui.notificationSnackBar(message: "${AppLocalizations.of(context).travelCompletedOn} ${controller.travelCard['__last_update']}".tr))
                   },
                   child: Text(AppLocalizations.of(context).travelCompleted))
           )
        )
      );
  }







}
