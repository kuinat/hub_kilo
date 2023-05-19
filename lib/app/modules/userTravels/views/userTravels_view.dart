import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../controllers/myTravels_controller.dart';

class MyTravelsView extends GetView<MyTravelsController> {

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
          child: ListView(
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
                child: GestureDetector(
                  onTap: () {
                    //Get.toNamed(Routes.SEARCH, arguments: controller.heroTag.value);
                  },
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
                            onChanged: (value)=>{
                              controller.filterSearchResults(value)
                            },
                            autofocus: false,
                            cursorColor: Get.theme.focusColor,
                            decoration: Ui.getInputDecoration(hintText: "Search for home service...".tr),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            BottomFilterSheetWidget(context),
                            isScrollControlled: true,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Get.theme.focusColor.withOpacity(0.1),
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            children: [
                              Text("Filter".tr, style: Get.textTheme.bodyText2),
                              Icon(
                                Icons.filter_list,
                                color: Get.theme.hintColor,
                                size: 21,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height/1.2,
                padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 40),
                decoration: Ui.getBoxDecoration(color: backgroundColor),
                child: Column(
                  children: [
                    /*Container(
                      height: 43,
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.transportState.length,
                          itemBuilder: (context, index){
                            return Obx(() => InkWell(
                              onTap: ()=> controller.currentIndex.value == index,
                              child: Card(
                                color: controller.currentIndex.value == index ? interfaceColor : inactive,
                                elevation: controller.currentIndex.value == index ? 10 : null,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(controller.transportState[index], style: TextStyle(color: Colors.white)),
                                ),
                              )
                            ));
                          }),
                    ),*/
                    Expanded(
                        child: Obx(()=>
                            GridView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: controller.items.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent: 300.0,
                                ),
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  var type = controller.items[index]['travel_type'];
                                  return GestureDetector(
                                    child: TravelCardWidget(
                                      isUser: true,
                                      disable: controller.items[index]['disable'],
                                      travelState: controller.items[index]['status'],
                                      depDate: controller.items[index]['departure_date'],
                                      arrTown: controller.items[index]['arrival_town'],
                                      depTown: controller.items[index]['departure_town'],
                                      arrDate: controller.items[index]['arrival_date'],
                                      icon: type == "Air" ? FaIcon(FontAwesomeIcons.planeDeparture)
                                          : type == "Sea" ? FaIcon(FontAwesomeIcons.ship)
                                          : FaIcon(FontAwesomeIcons.bus),
                                      qty: controller.items[index]['kilo_qty'],
                                      price: controller.items[index]['price_per_kilo'],
                                      color: background,
                                      text: Text(""),
                                      user: Text('Me', style: TextStyle(fontSize: 17)),
                                      imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',

                                    ),
                                    onTap: ()=>
                                        Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.items[index], 'heroTag': 'services_carousel'}),
                                  );
                                })
                        )
                    ),
                    SizedBox(height: 50)
                  ]
                )
              )
            ],
          )
    ));
  }

  Widget BottomFilterSheetWidget(BuildContext context){
    return Container(
      height: Get.height/2,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 15, left: 4, right: 4),
              children: [
                ExpansionTile(
                  title: Text("Status".tr, style: Get.textTheme.bodyText2),
                  children: List.generate(controller.transportState.length, (index) {
                    var state = controller.transportState.elementAt(index);
                    return SwitchListTile( //switch at right side of label
                        value: controller.selectedState.contains(state),
                        onChanged: (bool value){
                          controller.toggleTravels(value, state);
                          controller.state.value = state;
                        },
                        title: Text(controller.transportState[index])
                    );
                  }),
                  initiallyExpanded: true,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            child: Row(
              children: [
                Expanded(child: Text("Filter".tr, style: Get.textTheme.headline5)),
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  child: Text("Apply".tr, style: Get.textTheme.subtitle1),
                  elevation: 0,
                ),
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
      ),
    );
  }

}
