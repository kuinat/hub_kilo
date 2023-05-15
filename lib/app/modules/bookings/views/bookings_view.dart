import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/bookings_controller.dart';

class BookingsView extends GetView<BookingsController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.secondary,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Bookings".tr,
          style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                            onChanged: (value){

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
                decoration: Ui.getBoxDecoration(color: backgroundColor),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: 5,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 5);
                            },
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return CardWidget(
                                depDate: Text(DateFormat("dd, MMM\nyyyy", "fr_FR").format(DateTime.now()).toString()),
                                arrTown: Text('Yaounde'),
                                depTown: Text('Paris'),
                                arrDate: Text(DateFormat("dd, MMM\nyyyy", "fr_FR").format(DateTime.now().add(Duration(days: 1))).toString()),
                                qty: 13,
                                price: 150,
                                color: background,
                                text: Text(""),
                                onPressed: () =>{  },
                                user: "Test User",
                                imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',

                              );
                            })
                    )
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
