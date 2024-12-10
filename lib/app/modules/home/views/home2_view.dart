import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../main.dart';
//import 'dart:math' as math;
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/featured_categories_widget.dart';

class Home2View extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        //backgroundColor: Get.theme.colorScheme.secondary,
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshHome(showMessage: true);
              controller.onInit();
            },
            child: Container(
              decoration: BoxDecoration(color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),

              ),
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: FaIcon(FontAwesomeIcons.bars, color: Colors.white),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    ),
                    expandedHeight: 200,
                    centerTitle: true,
                    actions: [NotificationsButtonWidget()],
                    backgroundColor: backgroundColor,
                    title: Text(
                      Domain.AppName,
                      style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Container(
                            height: 320,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.darken),
                                image: AssetImage("assets/img/photo_2023-12-27_05-59-14.jpg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: FeaturedCategoriesWidget()
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
