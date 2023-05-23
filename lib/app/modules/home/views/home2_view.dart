import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import 'dart:math' as math;
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/Button_All_Travels_widget.dart';
import '../widgets/featured_categories_widget.dart';

class Home2View extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
             icon: Icon(Icons.sort, color: Colors.black87),
             onPressed: () => {Scaffold.of(context).openDrawer()},
           ),
        title: Text(
               Domain.AppName,
               style: Get.textTheme.headline6.merge(TextStyle(color: interfaceColor)),
             ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [NotificationsButtonWidget()],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            controller.onInit();
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    AddressWidget(),
                    /*Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(child: Text("Categories".tr, style: Get.textTheme.headline5)),
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.CATEGORIES);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                    CategoriesCarouselWidget(),
                    Container(
                      color: Get.theme.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(child: Text("Recommended for you".tr, style: Get.textTheme.headline5)),
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.CATEGORIES);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                    RecommendedCarouselWidget(),*/
                    FeaturedCategoriesWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
