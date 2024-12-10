import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../controllers/available_travels_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AvailableTravelsView extends GetView<AvailableTravelsController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        /*appBar: AppBar(
          title: Text(
            "Available Travels".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Palette.background),
            onPressed: () => {
            Get.find<BookingsController>().transferBooking.value = false,
              Get.offNamed(Routes.ROOT)
            },
          ),
          actions: [NotificationsButtonWidget()],
        ),*/
        body: RefreshIndicator(
            onRefresh: () async {
              controller.initValues();
            },
            child: CustomScrollView(
              controller: controller.scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: false,
              slivers: [
                SliverAppBar(
                    backgroundColor: interfaceColor,
                    expandedHeight: 140,
                    elevation: 0.5,
                    primary: true,
                    pinned: true,
                    floating: false,
                    iconTheme: IconThemeData(color: Get.theme.primaryColor),
                    title: Container(
                      padding: EdgeInsets.all(5),
                      //alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).availableTravels, style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white))),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                              child: Text(controller.items.length.toString(),
                                  style: Get.textTheme.headline5.merge(TextStyle(color: interfaceColor))),
                            )),
                          )
                      )
                    ],
                    bottom: PreferredSize(
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                                width: Get.width/1.2,
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
                                        hintStyle: Get.textTheme.caption,
                                        contentPadding: EdgeInsets.all(10)
                                    )
                                )
                            ),
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
                                          image: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"), fit: BoxFit.cover)
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
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() => controller.isLoading.value ?
                        LoadingCardWidget()
                            :
                        controller.items.isNotEmpty ?
                        SizedBox(
                          height: Get.height,
                          child: Column(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.items.length+1,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        Future.delayed(Duration.zero, (){
                                          controller.items.sort((a, b) => a["departure_date"].compareTo(b["departure_date"]));
                                        });
                                        if (index == controller.items.length) {
                                          return SizedBox(height: Get.height/3);
                                        }else {
                                          return GestureDetector(
                                            onTap: () {
                                              Get.toNamed(Routes.TRAVEL_INSPECT,
                                                  arguments: {
                                                    'travelCard': controller
                                                        .items[index],
                                                    'heroTag': 'services_carousel'
                                                  });
                                              //Get.find<BookingsController>().offerExpedition.value = false;
                                            },

                                            child: TravelCardWidget(
                                                otherLuggageTypes:controller.items[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                                element['flight_announcement_id'][0].compareTo(controller.items[index]['id']) == 0).where((element) =>
                                                element['luggage_type_id'][1].toString().compareTo('ENVELOP') != 0 && element['luggage_type_id'][1].toString().compareTo('KILO') != 0
                                                    && element['luggage_type_id'][1].toString().compareTo('COMPUTER') != 0):[] ,
                                                hasEnvelope: controller.items[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                                element['flight_announcement_id'][0].compareTo(controller.items[index]['id']) == 0).where((element) =>
                                                element['luggage_type_id'][1].toString().compareTo('ENVELOP') == 0).isNotEmpty ?true:false:false,

                                                hasKilos:controller.items[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                                element['flight_announcement_id'][0].compareTo(controller.items[index]['id']) == 0).where((element) =>
                                                element['luggage_type_id'][1].toString().compareTo('KILO') == 0).isNotEmpty ?true:false:false,

                                                hasComputers: controller.items[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                                                element['flight_announcement_id'][0].compareTo(controller.items[index]['id']) == 0).where((element) =>
                                                element['luggage_type_id'][1].toString().compareTo('COMPUTER') == 0).isNotEmpty ?true:false:false,
                                                isUser: false,
                                                homePage: true,
                                                //homePage: false,
                                                travelBy: controller
                                                    .items[index]['booking_type'],
                                                depDate: DateFormat(
                                                    "dd MMM yyyy", 'fr_CA')
                                                    .format(DateTime.parse(controller
                                                    .items[index]['departure_date']))
                                                    .toString().toUpperCase(),
                                                arrTown: controller
                                                    .items[index]['arrival_city_id'][1],
                                                depTown: controller
                                                    .items[index]['departure_city_id'][1],
                                                qty: controller
                                                    .items[index]['kilo_qty'],
                                                price: controller
                                                    .items[index]['price_per_kilo'],
                                                color: background,
                                                text: Text(""),
                                                user: controller
                                                    .items[index]['partner_id'][1],
                                                rating: controller.items[index]['booking_type'] == 'road'?controller.items[index]['average_rating'].toStringAsFixed(1):controller.items[index]['air_average_rating'].toStringAsFixed(1),
                                                imageUrl: '${Domain
                                                    .serverPort}/image/res.partner/${controller
                                                    .items[index]['partner_id'][0]}/image_1920?unique=true&file_response=true'
                                              //: "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png"

                                            ),
                                          );
                                        }
                                      })
                              )
                            ],
                          )
                        ) : Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height /4),
                              FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                              Text(AppLocalizations.of(context).travelNotFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                            ]
                        )
                        )
                      )
                    ],
                  ),
                )
              ],
            )
        ));
  }

  List transportMeans = [
    "Water",
    "Land",
    "Air"
  ];
}
