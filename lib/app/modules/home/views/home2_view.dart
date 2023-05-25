import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../main.dart';
//import 'dart:math' as math;
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
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
            await controller.refreshHome(showMessage: true);
            controller.onInit();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    AddressWidget(),
                    FeaturedCategoriesWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
