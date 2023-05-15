import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/home_controller.dart';
import 'services_carousel_widget.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {

  List travelType = [
    "By Land",
    "By Air",
    "By Sea"
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.featured.isEmpty) {
        return CircularLoadingWidget(height: 300);
      }
      return Column(
        children: List.generate(travelType.length, (index) {
          var _category = controller.featured.elementAt(index);
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text("${travelType[index]}".tr, style: Get.textTheme.headline5)),
                    MaterialButton(
                      onPressed: () {
                        Get.toNamed(Routes.CATEGORY, arguments: _category);
                      },
                      shape: StadiumBorder(),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                      child: Text("View All".tr, style: Get.textTheme.subtitle1),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (controller.featured.elementAt(index).eServices.isEmpty) {
                  return Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  );
                }
                return ServicesCarouselWidget(services: controller.featured.elementAt(index).eServices);
              }),
            ],
          );
        }),
      );
    });
  }
}
