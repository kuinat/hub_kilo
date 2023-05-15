import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        drawer: MainDrawerWidget(),
        body: controller.currentPage,
        bottomNavigationBar: CustomBottomNavigationBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          itemColor: context.theme.colorScheme.secondary,
          currentIndex: controller.currentIndex.value,
          onChange: (index) {
            controller.changePage(index);
          },
          children: [
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.home,
              label: "Home".tr,
            ),
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.book,
              label: "Bookings".tr,
            ),
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.planeCircleCheck,
              label: "My Travels".tr,
            ),
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.userEdit,
              label: "Account".tr,
            ),
          ],
        ),
      );
    });
  }
}
