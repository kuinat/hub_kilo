/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_services/app/modules/global_widgets/pop_up_widget.dart';

import '../../../color_constants.dart';
import '../../providers/odoo_provider.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/my_auth_service.dart';
import '../../services/settings_service.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    return Drawer(
      child: ListView(
        children: [
          Obx(() {
            if (Get.find<MyAuthService>().myUser.value.email == null) {
              return GestureDetector(
                onTap: () {
                  Get.offNamed(Routes.LOGIN);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome".tr, style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                      SizedBox(height: 5),
                      Text("Login account or create new one for free".tr, style: Get.textTheme.bodyText1),
                      SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Get.offNamed(Routes.LOGIN);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined, color: Get.theme.primaryColor, size: 24),
                                Text(
                                  "Login".tr,
                                  style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                          MaterialButton(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            height: 40,
                            elevation: 0,
                            onPressed: () {
                              Get.offNamed(Routes.REGISTER);
                            },
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.person_add_outlined, color: Get.theme.hintColor, size: 24),
                                Text(
                                  "Register".tr,
                                  style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.hintColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () async {
                  await Get.find<RootController>().changePage(3);
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  accountName: Text(
                    Get.find<MyAuthService>().myUser.value.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  accountEmail: Text(
                    Get.find<MyAuthService>().myUser.value.email,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          child: CachedNetworkImage(
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: "https://images.unsplash.com/photo-1571086291540-b137111fa1c7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
                            //Get.find<AuthService>().user.value.avatar.thumb,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Get.find<AuthService>().user.value.verifiedPhone ?? false ? Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24) : SizedBox(),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
          SizedBox(height: 20),
          DrawerLinkWidget(
            icon: Icons.home_outlined,
            text: "Home",
            onTap: (e) async {
              //Get.back();
              await Get.offNamed(Routes.ROOT);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.airplanemode_active_sharp,
            text: "Available Travels",
            onTap: (e) {
              Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);
            }
          ),

          if(Get.find<MyAuthService>().myUser.value.email != null)...[
            DrawerLinkWidget(
              icon: Icons.assignment_outlined,
              text: "Bookings",
              onTap: (e) async {
                Get.back();
                await Get.find<RootController>().changePage(1);
              }
            ),
            DrawerLinkWidget(
              icon: Icons.qr_code,
              text: "Validate Transaction",
              onTap: (e) {
                Get.offNamed(Routes.VALIDATE_TRANSACTION);
              },
            ),
            DrawerLinkWidget(
              icon: Icons.notifications_none_outlined,
              text: "Notifications",
              onTap: (e) {
                Get.offAndToNamed(Routes.NOTIFICATIONS);
              },
            ),
            DrawerLinkWidget(
              icon: Icons.chat_outlined,
              text: "Messages",
              onTap: (e) async {
                //await Get.find<RootController>().changePage(2);
              },
            )
          ],
          ListTile(
            dense: true,
            title: Text(
              "Application preferences".tr,
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          /*DrawerLinkWidget(
            icon: Icons.account_balance_wallet_outlined,
            text: "Wallets",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.WALLETS);
            },
          ),*/
          if(Get.find<MyAuthService>().myUser.value.email != null)
          DrawerLinkWidget(
            icon: Icons.person_outline,
            text: "Account",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(3);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS);
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              "Help & Privacy",
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.help_outline,
            text: "Help & FAQ",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.HELP);
            },
          ),
          CustomPageDrawerLinkWidget(),
          Obx(() {
            if (Get.find<MyAuthService>().myUser.value.email != null) {
              return DrawerLinkWidget(
                icon: Icons.logout,
                text: "Logout",
                onTap: (e) async {
                  showDialog(
                      context: context,
                      builder: (_)=>  PopUpWidget(
                        title: "Do you really want to quit?",
                        cancel: 'Cancel',
                        confirm: 'Log Out',
                        onTap: ()async{
                          final box = GetStorage();
                          await Get.find<MyAuthService>().removeCurrentUser();
                          Scaffold.of(context).closeDrawer();
                          Navigator.pop(context);
                          box.remove("session_id");
                        }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: inactive),
                      ));
                },
              );
            } else {
              return SizedBox();
            }
          }),
          if (Get.find<SettingsService>().setting.value.enableVersion)
            ListTile(
              dense: true,
              title: Text(
                "Version".tr + " " + Get.find<SettingsService>().setting.value.appVersion,
                style: Get.textTheme.caption,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            )
        ],
      ),
    );
  }
}
