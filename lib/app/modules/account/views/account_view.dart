import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';

class AccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    var _currentUser = Get.find<MyAuthService>().myUser;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Account".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: ListView(
          primary: true,
          children: [
            /*Obx(() {
              return ;
            }),*/
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  height: 150,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 80),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text( _currentUser.value.name ?? '',
                          style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                        SizedBox(height: 10),
                        Text(_currentUser.value.email ?? '', style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),

                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: Ui.getBoxDecoration(
                    radius: 14,
                    border: Border.all(width: 5, color: Get.theme.primaryColor),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                        imageUrl: "https://images.unsplash.com/photo-1571086291540-b137111fa1c7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                  ),
                ),
              ],
            ),
            Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shadowColor: inactive,
                child: ExpansionTile(
                  leading: Icon(FontAwesomeIcons.userCheck, size: 20),
                  title: Text("View Profile".tr, style: Get.textTheme.bodyText2),
                  children: [
                    AccountWidget(
                      icon: FontAwesomeIcons.birthdayCake,
                      text: Text('Date of date'),
                      value: '12/12/2000',
                    ),
                    AccountWidget(
                      icon: FontAwesomeIcons.locationDot,
                      text: Text('Place of birth'),
                      value: "Bangangte",
                    ),
                    AccountWidget(
                      icon: FontAwesomeIcons.male,
                      text: Text('Sexe'),
                      value: "MALE",
                    ),
                    AccountWidget(
                      icon: FontAwesomeIcons.planeDeparture,
                      text: Text('Number of travels'),
                      value: "12",
                    ),
                    AccountWidget(
                      icon: FontAwesomeIcons.book,
                      text: Text('Number of Bookings'),
                      value: "3",
                    ),
                    Card(
                      elevation: 10,
                        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: AccountLinkWidget(
                            icon: Icon(FontAwesomeIcons.userEdit, color: Get.theme.colorScheme.secondary),
                            text: Text("Profile".tr),
                            onTap: (e) {
                              Get.toNamed(Routes.PROFILE);
                            },
                          ))
                    ),
                  ],
                  initiallyExpanded: false,
                )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  /*
                  AccountLinkWidget(
                    icon: Icon(Icons.assignment_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("My Bookings".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(1);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.airplanemode_active_sharp, color: Get.theme.colorScheme.secondary),
                    text: Text("My Travels".tr),
                    onTap: (e) {
                      //Get.toNamed(Routes.NOTIFICATIONS);
                    },
                  ),*/
                  AccountLinkWidget(
                    icon: Icon(Icons.chat_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Messages".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(2);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.qr_code, color: Get.theme.colorScheme.secondary),
                    text: Text("Validate Transaction".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.VALIDATE_TRANSACTION);
                      //Get.find<RootController>().changePage(2);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.translate_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Languages".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_LANGUAGE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.brightness_6_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Theme Mode".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_THEME_MODE);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.support_outlined, color: Get.theme.colorScheme.secondary),
                    text: Text("Help & FAQ".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.HELP);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.logout, color: Get.theme.colorScheme.secondary),
                    text: Text("Logout".tr),
                    onTap: (e) async {
                      await Get.find<AuthService>().removeCurrentUser();
                      Get.find<RootController>().changePage(0);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
