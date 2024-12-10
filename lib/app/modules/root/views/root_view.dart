import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.lazyPut(()=>MyAuthService());
      Get.lazyPut<OdooApiClient>(
            () => OdooApiClient(),
      );
      return WillPopScope(
        onWillPop: ()=>
            Fluttertoast.showToast(
              msg: 'Tap again to leave!',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: inactive,
              textColor: Colors.white,
              fontSize: 16.0,
            )
        ,
        child: Scaffold(
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
                label: AppLocalizations.of(context).home.tr,
              ),
              CustomBottomNavigationItem(
                icon: FontAwesomeIcons.shippingFast,
                label: AppLocalizations.of(context).dashboard,
              ),
              CustomBottomNavigationItem(
                icon: FontAwesomeIcons.qrcode,
                label: AppLocalizations.of(context).scanCode,
              ),
              CustomBottomNavigationItem(
                icon: FontAwesomeIcons.user,
                label: AppLocalizations.of(context).account.tr,
              ),
            ],
          ),
        ),
      );
    });
  }
}
