import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/available_travels_controller.dart';

class AvailableTravelsView extends GetView<AvailableTravelsController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
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
            onPressed: () => {Get.offNamed(Routes.ROOT)},
          ),
          actions: [NotificationsButtonWidget()],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              /*if (!Get.find<LaravelApiClient>().isLoading(task: 'getBookings')) {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshBookings(showMessage: true, statusId: controller.currentStatus.value);
              Get.find<LaravelApiClient>().unForceRefresh();
            }*/
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
                                //controller.filterSearchResults(value)
                              },
                              autofocus: controller.heroTag.value == "search" ? true : false,
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
                    padding: EdgeInsets.all(10),
                    decoration: Ui.getBoxDecoration(color: backgroundColor),
                    child: Column(
                      children: [
                        Expanded(
                            child: controller.isServer.value ?
                            CircularLoadingWidget(height: 300) :
                            Obx(()=>
                                GridView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.items.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                      mainAxisExtent: 330.0,
                                    ),
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder: (context, index) {
                                      var type = controller.items[index]['travel_type'];
                                      return GestureDetector(
                                        onTap: ()=>
                                            Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.items[index], 'heroTag': 'services_carousel'}),
                                        child: TravelCardWidget(
                                          disable: false,
                                          isUser: false,
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
                                          user: Text(controller.items[index]['user']['user_name'], style: TextStyle(fontSize: 17)),
                                          imageUrl: controller.items[index]['user']['user_id'].toString() != 'false' ? '${Domain.serverPort}/web/image/res.partner/${controller.items[index]['user']['user_id']}/image_1920'
                                          : "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png",

                                        ),
                                      );
                                    })
                            )
                        ),
                        SizedBox(height: 50)
                      ],
                    )
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
                  title: Text("Travels".tr, style: Get.textTheme.bodyText2),
                  children: List.generate(transportMeans.length, (index) {
                    var _category = transportMeans.elementAt(index);
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: false,
                      onChanged: (value) {
                        //controller.toggleCategory(value, _category);
                      },
                      title: Text(
                        _category,
                        style: Get.textTheme.bodyText1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                      ),
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
