import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../root/controllers/root_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../controllers/user_travels_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTravelsView extends GetView<UserTravelsController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {

    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );
    Get.lazyPut(()=>AddTravelController());
    return Container(
        height: Get.height,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: backgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0)), ),
        child: Obx(() => Column(

            children: [
              controller.isLoading.value ?
              Expanded(child: LoadingCardWidget()) :
              controller.items.isNotEmpty ?
              Expanded(
                  child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.items.length +1,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        if (index == controller.items.length) {
                          return SizedBox(height: 80);
                        } else {
                          Future.delayed(Duration.zero, (){
                            controller.items.sort((a, b) => b["__last_update"].compareTo(a["__last_update"]));
                          });
                          return GestureDetector(
                            child: TravelCardWidget(
                          //     hasEnvelope: controller.items[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                          // element['flight_announcement_id'][0].compareTo(controller.items[index]['id']) == 0).where((element) =>
                          //     element['luggage_type_id'][1].toString().compareTo('ENVELOP') == 0).isNotEmpty ?true:false:false,
                          //
                          //     hasKilos:controller.items[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                          //     element['flight_announcement_id'][0].compareTo(controller.items[index]['id']) == 0).where((element) =>
                          //     element['luggage_type_id'][1].toString().compareTo('KILO') == 0).isNotEmpty ?true:false:false,
                          //
                          //     hasComputers: controller.items[index]['booking_type']=='air'?controller.listOfAllAirTravelsLuggages.where((element) =>
                          //     element['flight_announcement_id'][0].compareTo(controller.items[index]['id']) == 0).where((element) =>
                          //     element['luggage_type_id'][1].toString().compareTo('COMPUTER') == 0).isNotEmpty ?true:false:false,
                              isUser: true,
                              travelState: controller.items[index]['state'],
                              depDate: DateFormat("dd MMM yyyy", 'fr_CA').format(DateTime.parse(controller.items[index]['departure_date'])).toString(),
                              arrTown: controller.items[index]['arrival_city_id'][1],
                              depTown: controller.items[index]['departure_city_id'][1],
                              qty: controller.items[index]['total_weight'],
                              price: controller.items[index]['booking_price'],
                              color: background,
                              text: Text(""),
                              imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                              homePage: false,

                              action: ()=> {

                                ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context).loadingData),
                                  duration: Duration(seconds: 2),
                                )),

                                controller.publishTravel(controller.items[index]['id'])
                              },
                              travelBy: controller.items[index]['booking_type'],

                            ),
                            onTap: (){
                              //Get.find<BookingsController>().offerExpedition.value = false;
                              Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.items[index], 'heroTag': 'services_carousel'});

                            }

                          );}
                      }).marginOnly(bottom: 200)
              ): SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/1.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                    Text(AppLocalizations.of(context).travelNotFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                  ],
                ),
              )
            ]
        )
        )
    );
  }

  Widget buildInvoice(BuildContext context, List data) {
    return Column(

    );
  }
}
