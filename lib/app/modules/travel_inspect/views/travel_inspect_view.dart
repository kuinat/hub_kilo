import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/travel_inspect_controller.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';

class TravelInspectView extends GetView<TravelInspectController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var travel = controller.travelCard;
      if (!travel.isNotEmpty) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        var type = controller.travelCard['travel_type'].toString();
        return Scaffold(
          bottomNavigationBar: buildBottomWidget(context),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEService(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
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
                      onPressed: () => {Get.back()},
                    ),
                    actions: [
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: 120,
                        child: Text(controller.travelCard['travel_type'].toString(), style: Get.textTheme.headline1.merge(TextStyle(color: Colors.white))),
                        decoration: BoxDecoration(
                            color: type != "by_air" ? Colors.white.withOpacity(0.4) : interfaceColor.withOpacity(0.4),
                            border: Border.all(
                              color: type != "by_air" ? Colors.white.withOpacity(0.2) : interfaceColor.withOpacity(0.2),
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
                            CachedNetworkImage(
                              height: 370,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: controller.imageUrl.value,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                height: 65,
                                width: 65,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error_outline),
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
                        EServiceTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              ListTile(
                                title: Text('Available Quantity (kg):', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                trailing: Text(controller.travelCard['kilo_qty'].toString(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                              ),
                              ListTile(
                                title: Text('Price /kg', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                trailing: Text(controller.travelCard['price_per_kilo'].toString(), style: Get.textTheme.headline2.merge(TextStyle(fontSize: 18))),
                              ),
                              Divider(
                                height: 26,
                                thickness: 1.2,
                              ),
                              ListTile(
                                title: Text('Article Accepted', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                subtitle: Text(controller.travelCard['type_of_luggage_accepted'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16))),
                              ),
                            ],
                          )
                        ),
                        EServiceTilWidget(
                          title: Text("About Traveler".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              Text(controller.travelCard['user']['user_name'], style: Get.textTheme.headline1),
                              Text(controller.travelCard['user']['user_email'], style: Get.textTheme.headline2.merge(TextStyle(fontSize: 18))),
                              Divider(height: 35, thickness: 1.3),
                              buildUserDetailsCard(context)
                            ],
                          ),
                          actions: [

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
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
                child: CachedNetworkImage(
                  height: 65,
                  width: 65,
                  fit: BoxFit.cover,
                  imageUrl: "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60",
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 65,
                    width: 65,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(controller.travelCard['user']['user_name'].toString(),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 2,
                      style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                    ),
                    Text(controller.travelCard['user']['user_email'].toString(),
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.caption,
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
                child: Text(controller.travelCard['departure_town'].toString(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
              ),
              FaIcon(FontAwesomeIcons.arrowRight),
              Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  child: Text(controller.travelCard['arrival_town'].toString(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18)))
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
          child: 1  /*controller.travelCard['user']['id']*/ != 1 ?
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
              onPressed: () {
                Get.bottomSheet(
                  buildBookingSheet(context),
                  isScrollControlled: true,
                );
              }) : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: specialColor,
                ),
                  onPressed: ()=>{
                  showDialog(context: context,
                      builder: (_)=>
                  showDeleteWidget(context))
                  },
                  child: SizedBox(width: 100,height: 30,
                      child: Center(child: Text('Delete')))
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: inactive,
                  ),
                  onPressed: ()=>{
                    Get.toNamed(Routes.ADD_TRAVEL_FORM)
                  },
                  child: SizedBox(width: 100,height: 30,
                      child: Center(child: Text('Edit')))
              )
            ],
          )
        ),
      );
  }

  Widget showDeleteWidget(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
      content: SizedBox(
        height: MediaQuery.of(context).size.height/9,
        child: Column(
          children: [
            Text('Do you really want to delete this post?', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: ()=>{
                  Navigator.pop(context)
                },
                    child: Text('Cancel', style: TextStyle(color: inactive))),
                SizedBox(width: 10),
                TextButton(onPressed: ()=>{
                  Navigator.pop(context)
                },
                    child: Text('Delete', style: TextStyle(color: specialColor)))
              ],
            )
          ]
        )
      ),
      
    );
  }

  Widget buildBookingSheet(BuildContext context){
    return Container(
      height: Get.height/1.8,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
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
                    controller.bookingStep.value++
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
                      onPressed: (){
                        controller.buttonPressed.value = !controller.buttonPressed.value;
                        Timer(Duration(seconds: 3), () {
                          Navigator.pop(context);
                        });
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
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Text('Booking Details here')

                   ]
                 ) : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Receiver Details here')

                    ]
                )
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

}
