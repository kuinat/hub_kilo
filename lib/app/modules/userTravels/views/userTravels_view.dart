import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../controllers/user_travels_controller.dart';

class MyTravelsView extends GetView<UserTravelsController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          //backgroundColor: pink,
            onPressed: ()=>{
              Get.toNamed(Routes.ADD_TRAVEL_FORM)
            },
            child: Center(
              child: Icon(FontAwesomeIcons.planeDeparture, size: 18),
            )
        ),
        appBar: AppBar(
          title: Text(
            "My Travels".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              controller.initValues();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        border: Border.all(
                          color: Get.theme.focusColor.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 12, left: 0),
                          child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
                        ),
                        Expanded(
                          child: Material(
                            color: Get.theme.primaryColor,
                            child: TextField(
                              //controller: controller.textEditingController,
                              style: Get.textTheme.bodyText2,
                              onChanged: (value)=> controller.filterSearchResults(value),
                              autofocus: false,
                              cursorColor: Get.theme.focusColor,
                              decoration: Ui.getInputDecoration(hintText: "Search for home service...".tr),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      padding: EdgeInsets.all(10),
                      decoration: Ui.getBoxDecoration(color: backgroundColor),
                      child: Obx(() => Column(

                          children: [
                            controller.isLoading.value ?
                            LoadingCardWidget() :
                            controller.items.isNotEmpty ?
                            Expanded(
                                child: GridView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.items.length +1,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 250.0,
                                    ),
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder: (context, index) {
                                      if (index == controller.items.length) {
                                      return SizedBox(height: 80);
                                      } else {
                                        Future.delayed(Duration.zero, (){
                                          controller.items.sort((a, b) => a["departure_date"].compareTo(b["departure_date"]));
                                        });
                                      return GestureDetector(
                                        child: TravelCardWidget(
                                          isUser: true,
                                          travelState: controller.items[index]['state'],
                                          depDate: controller.items[index]['departure_date'],
                                          arrTown: controller.items[index]['arrival_city_id'][1],
                                          depTown: controller.items[index]['departure_city_id'][1],
                                          arrDate: controller.items[index]['arrival_date'],
                                          qty: controller.items[index]['total_weight'],
                                          price: controller.items[index]['booking_price'],
                                          color: background,
                                          text: Text(""),
                                          user: Text('Me', style: TextStyle(fontSize: 17)),
                                          imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                          homePage: false,
                                          travelType: controller.items[index]['booking_type'] != "road" ? true : false,
                                          travelBy: controller.items[index]['booking_type'],

                                        ),
                                        onTap: ()=>
                                            Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.items[index], 'heroTag': 'services_carousel'}),
                                      );}
                                    })
                            ) : SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height/1.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                                  Text('No Travels found', style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                                ],
                              ),
                            )
                          ]
                      )
                      )
                  )
                ],
              )

            )
        )
    );
  }
}
