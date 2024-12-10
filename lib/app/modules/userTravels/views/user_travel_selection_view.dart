import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controllers/user_travel_selection_controller.dart';


class UserTravelSelectionView extends GetView<UserTravelSelectionController> {

  List bookings = [];
  var selectedIndex = [];

  @override
  Widget build(BuildContext context) {

    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );
     Get.put(UserTravelSelectionController());


    return  Scaffold(
      //Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: background,
          title:Text( 'My Travels',
            style: Get.textTheme.headline6.merge(TextStyle(color: appColor)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: appColor),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        bottomSheet: Obx(() =>

            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 90,
                child: Center(
                    child: BlockButtonWidget(
                      onPressed: ()=>{
                        controller.buttonPressed.value = true,
                        //controller.editShipping(controller.shipping)
                        for(var shipping in controller.publishedUserTravels){
                          controller.joinShippingTravel(shipping),
                        }
                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ? SizedBox(
                        //width: Get.width/1.5,
                          child: Text(
                            'Join Travel(s)'.tr,
                            style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                          )
                      ) : SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                )
            )
        ),

        body: Container(
            height: Get.height,
            padding: EdgeInsets.all(10),
            decoration: Ui.getBoxDecoration(color: background),
            child: Obx(() =>
                Column(children: [
                  controller.publishedUserTravels.isNotEmpty ?
                  ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.publishedUserTravels.length+1 ,
                      shrinkWrap: true,
                      primary: false,

                      itemBuilder: (context, index) {

                        if (index == controller.publishedUserTravels.length) {
                          return SizedBox(height: 120);
                        } else {

                          Future.delayed(Duration.zero, (){
                            controller.publishedUserTravels.sort((a, b) => b["create_date"].compareTo(a["create_date"]));
                          });
                          return InkWell(
                              onLongPress: (){
                                controller.shippingSelected.value = true;
                                controller.expeditionOffersSelected.add(controller.publishedUserTravels[index]);
                                print('added lenght is: '+controller.expeditionOffersSelected.length.toString());



                              },
                              onTap: ()async=>{
                                controller.shippingSelected.value = false,
                                if(controller.expeditionOffersSelected.contains(controller.publishedUserTravels[index])){
                                  controller.expeditionOffersSelected.remove(controller.publishedUserTravels[index]),
                                  print('reduced lenght is: '+controller.expeditionOffersSelected.length.toString()),
                                },


                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //   content: Text(AppLocalizations.of(context).loadingData),
                                //   duration: Duration(seconds: 2),
                                // )),
                                // //await controller.getTravelInfo(controller.itemsShippingOffer[index]['travelbooking_id'][0]),
                                // controller.owner.value = true,
                                // controller.shippingDetails.value = controller.itemsShippingOffer[index],
                                // if(controller.shippingDetails != null){
                                //   if(controller.travelDetails.isNotEmpty){
                                //     if(controller.travelDetails['booking_type'].toLowerCase() == "air"){
                                //       controller.imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60"
                                //       //"assets/img/istockphoto-1421193265-612x612.jpg";
                                //     }else if(controller.travelDetails['booking_type'].toLowerCase() == "sea"){
                                //       controller.imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8="
                                //       //"assets/img/pexels-julius-silver-753331.jpg";
                                //     }else{
                                //       controller.imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc="
                                //       //"assets/img/istockphoto-859916128-612x612.jpg";
                                //     },
                                //   }
                                //   else{
                                //
                                //   },
                                //
                                //
                                //
                                //   Get.toNamed(Routes.SHIPPING_DETAILS)
                                // },
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: controller.expeditionOffersSelected.contains(controller.publishedUserTravels[index]) ? Border.all(color: interfaceColor,width: 2) : null,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: TravelCardWidget(
                                  isUser: true,
                                  travelState: controller.publishedUserTravels[index]['state'],
                                  depDate: DateFormat("dd MMM yyyy", 'fr_CA').format(DateTime.parse(controller.publishedUserTravels[index]['departure_date'])).toString(),
                                  arrTown: controller.publishedUserTravels[index]['arrival_city_id'][1],
                                  depTown: controller.publishedUserTravels[index]['departure_city_id'][1],
                                  qty: controller.publishedUserTravels[index]['total_weight'],
                                  price: controller.publishedUserTravels[index]['booking_price'],
                                  color: background,
                                  text: Text(""),
                                  imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                  homePage: false,

                                  action: ()=> {

                                    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
                                      content: Text(AppLocalizations.of(context).loadingData),
                                      duration: Duration(seconds: 2),
                                    )),

                                    //controller.publishTravel(controller.publishedUserTravels[index]['id'])
                                  },
                                  travelBy: controller.publishedUserTravels[index]['booking_type'],

                                ),
                              )
                          );}
                      }) :controller.expeditionsOffersLoading.value?
                  Expanded(child: LoadingCardWidget()):
                  Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height /4),
                        FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                        Text(AppLocalizations.of(context).noShippingFound, style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                      ]
                  ),

                ],)


            )


        )
    );
  }


}
