import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/animation_controllers/animation.dart';
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
        floatingActionButton: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(controller.buttonPressed.value)...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  DelayedAnimation(
                      delay: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: ()=>{

                                for(var i=0; i < controller.items.length; i++){
                                  if(controller.items[i]['state'].contains("negotiating")){
                                    controller.inNegotiation.value = true
                                  }else{
                                    controller.inNegotiation.value = false
                                  }
                                },
                                if(!controller.inNegotiation.value){
                                  Get.toNamed(Routes.ADD_TRAVEL_FORM)
                                }else{
                                  Get.showSnackbar(Ui.notificationSnackBar(message: "You cannot have simultaneous in the system two travels in negotiation! please update and try again"))
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white
                              ),
                              child: Text("New Travel", style: Get.textTheme.headline4.merge(TextStyle(color: appColor)))
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: interfaceColor.withOpacity(0.7),
                            child: Center(
                              child: Icon(Icons.airplanemode_on, size: 30, color: Colors.white),
                            ),
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 10),
                  DelayedAnimation(
                      delay: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: ()async{
                                List data = await controller.getInvoice();
                                if(data.isNotEmpty) {
                                  Get.bottomSheet(
                                    buildInvoice(context, data),
                                    isScrollControlled: true,
                                  );
                                }else{
                                  Get.showSnackbar(Ui.notificationSnackBar(message: "No shipping has been made on this travel yet".tr));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white
                              ),
                              child: Text("View Invoice", style: Get.textTheme.headline4.merge(TextStyle(color: appColor)))
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: interfaceColor.withOpacity(0.7),
                            child: Center(
                              child: Icon(Icons.file_open_rounded, size: 30, color: Colors.white),
                            ),
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                      heroTag: null,
                      backgroundColor: pink,
                      onPressed: (){
                        controller.buttonPressed.value = !controller.buttonPressed.value;
                      },
                      child: Icon(Icons.close, color: Palette.background)
                  )
                ],
              )
            ]else...[
              FloatingActionButton.extended(
                  heroTag: null,
                  //backgroundColor: interfaceColor,
                  onPressed: (){
                    controller.buttonPressed.value = !controller.buttonPressed.value;
                  },
                  label: Text('More'),
                  icon: Icon(Icons.add, color: Palette.background)
              )
            ]
          ],
        )),
        /*FloatingActionButton(
          //backgroundColor: pink,
            onPressed: ()=>{

              for(var i=0; i < controller.items.length; i++){
                if(controller.items[i]['state'].contains("negotiating")){
                  controller.inNegotiation.value = true
                }else{
                  controller.inNegotiation.value = false
                }
              },
              if(!controller.inNegotiation.value){
                Get.toNamed(Routes.ADD_TRAVEL_FORM)
              }else{
                Get.showSnackbar(Ui.notificationSnackBar(message: "You cannot have simultaneous in the system two travels in negotiation! please update and try again"))
              }

            },
            child: Center(
              child: Icon(Icons.airplanemode_on_sharp, size: 25),
            )
        )*/
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
                            Expanded(child: LoadingCardWidget()) :
                            controller.items.isNotEmpty ?
                            Expanded(
                                child: GridView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.items.length +1,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 220.0,
                                    ),
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
                                          isUser: true,
                                          travelState: controller.items[index]['state'],
                                          depDate: DateFormat("dd MMMM yyyy", 'fr_CA').format(DateTime.parse(controller.items[index]['departure_date'])).toString(),
                                          arrTown: controller.items[index]['arrival_city_id'][1],
                                          depTown: controller.items[index]['departure_city_id'][1],
                                          qty: controller.items[index]['total_weight'],
                                          price: controller.items[index]['booking_price'],
                                          color: background,
                                          text: Text(""),
                                          imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                          homePage: false,

                                          action: ()=> controller.getAttachmentFiles(controller.items[index]['id']),

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

  Widget buildInvoice(BuildContext context, List data) {
    return Column(

    );
  }
}
