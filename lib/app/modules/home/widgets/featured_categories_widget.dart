import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../controllers/home_controller.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text("Road".tr.toUpperCase(), style: Get.textTheme.headline5.merge(TextStyle(fontSize: 18)))),
                    MaterialButton(
                      onPressed: () {
                        if(controller.landTravelList.isNotEmpty){
                          Get.toNamed(Routes.CATEGORY, arguments: {'travels': controller.landTravelList, "travelType": "road"});
                        }
                      },
                      shape: StadiumBorder(),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                      child: Text("View All".tr, style: Get.textTheme.subtitle1),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              Obx(() => controller.isLoading.value ?
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
                height: 280,
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    primary: false,
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.landTravelList.length > 5 ? 5 : controller.landTravelList.length,
                    itemBuilder: (_, index) {

                      return GestureDetector(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: TravelCardWidget(
                                  isUser: false,
                                  homePage: false,
                                  code: controller.landTravelList[index]['code'],
                                  travelBy: controller.landTravelList[index]['booking_type'],
                                  travelType: controller.landTravelList[index]['booking_type'] != "road" ? true : false,
                                  depDate: controller.landTravelList[index]['departure_date'],
                                  arrTown: controller.landTravelList[index]['arrival_city_id'][1],
                                  depTown: controller.landTravelList[index]['departure_city_id'][1],
                                  arrDate: controller.landTravelList[index]['arrival_date'],
                                  qty: controller.landTravelList[index]['kilo_qty'],
                                  price: controller.landTravelList[index]['price_per_kilo'],
                                  color: background,
                                  text: Text(""),
                                  user: Text(controller.landTravelList[index]['partner_id'][1], style: TextStyle(fontSize: 17, color: appColor)),
                                  imageUrl: '${Domain.serverPort}/image/res.partner/${controller.landTravelList[index]['partner_id'][0]}/image_1920?unique=true&file_response=true',
                                //: "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png"

                              ),
                          ),
                          onTap: ()=>{
                            Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.landTravelList[index], 'heroTag': 'services_carousel'}),
                          }
                        //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                      );
                    }),
              ) : Container(
                  height: 220,
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
                    Expanded(child: Text("Air".tr.toUpperCase(), style: Get.textTheme.headline5.merge(TextStyle(fontSize: 18)))),
                    MaterialButton(
                      onPressed: () {
                        if(controller.airTravelList.isNotEmpty){
                          Get.toNamed(Routes.CATEGORY, arguments: {'travels': controller.airTravelList, "travelType": "air"});
                        }
                      },
                      shape: StadiumBorder(),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                      child: Text("View All".tr, style: Get.textTheme.subtitle1),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              Obx(() =>
              controller.isLoading.value?
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
                height: 270,
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    primary: false,
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.airTravelList.length > 5 ? 5 : controller.airTravelList.length,
                    itemBuilder: (_, index) {

                      return GestureDetector(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: TravelCardWidget(
                                code: controller.airTravelList[index]['code'],
                                isUser: false,
                                homePage: true,
                                travelBy: controller.airTravelList[index]['travel_type'],
                                travelType: controller.airTravelList[index]['travel_type'] != "road" ? true : false,
                                depDate: controller.airTravelList[index]['departure_date'],
                                arrTown: controller.airTravelList[index]['arrival_town'],
                                depTown: controller.airTravelList[index]['departure_town'],
                                arrDate: controller.airTravelList[index]['arrival_date'],
                                qty: controller.airTravelList[index]['kilo_qty'],
                                price: controller.airTravelList[index]['price_per_kilo'],
                                color: Colors.white,
                                text: Text(""),
                                user: Text(controller.airTravelList[index]['sender']['sender_name'], style: TextStyle(fontSize: 17)),
                                imageUrl: controller.airTravelList[index]['sender']['sender_id'].toString() != 'false' ? '${Domain.serverPort}/web/image/res.partner/${controller.airTravelList[index]['sender']['sender_id']}/image_1920'
                                    : "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png",

                              )
                          ),
                          onTap: ()=>{
                            Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.airTravelList[index], 'heroTag': 'services_carousel'}),
                          }
                        //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                      );
                    }
                ),
              ) : Container(
                  height: 220,
                  child: Center(
                    child: FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 120),
                  ))
              ),
            ],
          )
        ]
    );
  }
}
