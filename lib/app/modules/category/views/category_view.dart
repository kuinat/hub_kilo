import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              expandedHeight: 150,
              elevation: 0.5,
              primary: true,
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color: Get.theme.primaryColor),
              title: Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                width: 120,
                child: Text(controller.travelType.value, style: Get.textTheme.headline1.merge(TextStyle(color: Colors.white))),
                decoration: BoxDecoration(
                    color: controller.travelType.value != "Air" ? Colors.white.withOpacity(0.4) : interfaceColor.withOpacity(0.4),
                    border: Border.all(
                      color: controller.travelType.value != "Air" ? Colors.white.withOpacity(0.2) : interfaceColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => {Get.back()},
              ),
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
                        buildSearchBar(context)
                      ],
                    );
                  }),).marginOnly(bottom: 10),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  /*Container(
                    height: 60,
                    child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(CategoryFilter.values.length, (index) {
                          var _filter = CategoryFilter.values.elementAt(index);
                          return Obx(() {
                            return Padding(
                              padding: const EdgeInsetsDirectional.only(start: 20),
                              child: RawChip(
                                elevation: 0,
                                label: Text(_filter.toString().tr),
                                labelStyle: controller.isSelected(_filter) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                                selectedColor: controller.category.value.color,
                                selected: controller.isSelected(_filter),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                showCheckmark: true,
                                checkmarkColor: Get.theme.primaryColor,
                                onSelected: (bool value) {
                                  controller.toggleSelected(_filter);
                                  controller.loadEServicesOfCategory(controller.category.value.id, filter: controller.selected.value);
                                },
                              ),
                            );
                          });
                        })),
                  ),*/
                  Obx(() => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.travelList.length,
                        itemBuilder: ((_, index) {
                          var _service = controller.travelList.elementAt(index);
                          return GestureDetector(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1.2,
                                  child: TravelCardWidget(
                                    isUser: false,
                                    homePage: false,
                                    travelBy: controller.travelList[index]['travel_type'],
                                    travelType: controller.travelList[index]['travel_type'] != "road" ? true : false,
                                    depDate: controller.travelList[index]['departure_date'],
                                    arrTown: controller.travelList[index]['arrival_town'],
                                    depTown: controller.travelList[index]['departure_town'],
                                    arrDate: controller.travelList[index]['arrival_date'],
                                    qty: controller.travelList[index]['kilo_qty'],
                                    price: controller.travelList[index]['price_per_kilo'],
                                    color: Colors.white,
                                    text: Text(""),
                                    user: Text(controller.travelList[index]['sender']['sender_name'], style: TextStyle(fontSize: 17)),
                                    imageUrl: controller.travelList[index]['sender']['sender_id'].toString() != 'false' ? '${Domain.serverPort}/web/image/res.partner/${controller.travelList[index]['sender']['sender_id']}/image_1920'
                                        : "https://w7.pngwing.com/pngs/81/570/png-transparent-profile-logo-computer-icons-user-user-blue-heroes-logo-thumbnail.png",

                                  )
                              ),
                              onTap: ()=>{
                                Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': controller.travelList[index], 'heroTag': 'services_carousel'}),
                              }
                            //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                          );
                        }),
                      ))
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSearchBar(BuildContext context) {
    double width = MediaQuery.of(context).size.width/1.2;
    return Container(
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
    );
  }

}
