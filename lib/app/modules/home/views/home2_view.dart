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
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 300,
                elevation: 0.5,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: Text(
                  Domain.AppName,
                  style: Get.textTheme.headline6,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.sort, color: Colors.black87),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                actions: [NotificationsButtonWidget()],
                bottom: ButtonAllTravelsWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: controller.slider.isEmpty
                          ? AlignmentDirectional.center
                          : AlignmentDirectional.bottomStart,
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: controller.slider.length > 1 ? true : false,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 360,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((element) {
                            return Stack(
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(Directionality.of(context) == TextDirection.rtl ? math.pi : 0),
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    height: 310,
                                    fit: BoxFit.contain,
                                    imageUrl: "${Domain.serverPort}/web/image/m2st_hk_airshipping.publicity/5/image",
                                    placeholder: (context, url) => Image.asset(
                                      'assets/img/loading.gif',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomLeft,
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                                    child: SizedBox(
                                      width: Get.width / 2.5,
                                      child: Column(
                                        children: [
                                            Text(element['text'],
                                              style: Get.textTheme.bodyText2.merge(TextStyle(color: interfaceColor)),
                                              overflow: TextOverflow.fade,
                                              maxLines: 3,
                                            ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                    )),
                              ],
                            );
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((slide) {
                              return Container(
                                width: 20.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value == controller.slider.indexOf(slide) ? interfaceColor : interfaceColor.withOpacity(0.2)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ).marginOnly(bottom: 42),
              ),
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
