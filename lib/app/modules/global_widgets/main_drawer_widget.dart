/*
 * Copyright (c) 2020 .
 */

import 'package:app/app/modules/global_widgets/pop_up_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:home_services/app/modules/global_widgets/pop_up_widget.dart';

import '../../../color_constants.dart';
import '../../../main.dart';
import '../../providers/odoo_provider.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/my_auth_service.dart';
import '../../services/settings_service.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../root/controllers/root_controller.dart' show RootController;
import '../validate_transaction/controller/validation_controller.dart';
import 'drawer_link_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
class MainDrawerWidget extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut(()=>ValidationController());
    var _currentUser = Get.find<MyAuthService>().myUser;
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
                      Text(AppLocalizations.of(context).welcome.tr, style: Get.textTheme.headline5.merge(TextStyle(color: appColor))),
                      SizedBox(height: 5),
                      Text(AppLocalizations.of(context).logRegister.tr, style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black))),
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
                                  AppLocalizations.of(context).login.tr,
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
                                  AppLocalizations.of(context).register.tr,
                                  style: Get.textTheme.subtitle1.merge(TextStyle(color: Colors.black)),
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
                    style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: interfaceColor, fontSize: 15)),
                  ),
                  accountEmail: Text(""
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipOval(
                            child: FadeInImage(
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                              image: Domain.googleUser?NetworkImage(Domain.googleImage):NetworkImage('${Domain.serverPort}/image/res.partner/${_currentUser.value.id}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                              placeholder: AssetImage(
                                  "assets/img/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/img/téléchargement (3).png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fitWidth);
                              },
                            )
                        )
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
          /*DrawerLinkWidget(
            special: false,
            drawer: false,
            icon: Icons.home_outlined,
            text: "Home",
            onTap: (e) async {
              //Get.back();
              await Get.toNamed(Routes.ROOT);
            },
          ),*/
          DrawerLinkWidget(
              special: false,
              drawer: false,
              icon: Icons.airplanemode_active_sharp,
              text: AppLocalizations.of(context).availableTravels,
              onTap: (e) {
                Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);
              }
          ),

          if(Get.find<MyAuthService>().myUser.value.email != null)...[
            DrawerLinkWidget(
                special: false,
                icon: Icons.dashboard,
                text: AppLocalizations.of(context).dashboard,
                drawer: true,
                onTap: (e) async {
                  Get.back();
                  await Get.find<RootController>().changePage(1);
                }
            ),
            DrawerLinkWidget(
              special: false,
              drawer: false,
              icon: Icons.delivery_dining,
              text: AppLocalizations.of(context).confirmDelivery,
              onTap: (e) async{
                Get.back();
                await Get.find<RootController>().changePage(2);
              }
            ),
            DrawerLinkWidget(
              drawer: false,
              special: false,
              icon: Icons.notifications_none_outlined,
              text: AppLocalizations.of(context).notifications,
              onTap: (e) {
                Get.toNamed(Routes.NOTIFICATIONS);
              },
            ),
          ],
          /*ListTile(
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
          DrawerLinkWidget(
            icon: Icons.account_balance_wallet_outlined,
            text: "Wallets",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.WALLETS);
            },
          ),*/
          if(Get.find<MyAuthService>().myUser.value.email != null)
          DrawerLinkWidget(
            special: false,
            drawer: false,
            icon: Icons.person_outline,
            text: AppLocalizations.of(context).account,
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(3);
            },
          ),
          /*DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS);
            },
          ),*/
          ListTile(
            dense: true,
            title: Text(
              AppLocalizations.of(context).helpPrivacy,
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            special: false,
            drawer: false,
            icon: Icons.help_outline,
            text: AppLocalizations.of(context).signalIssue,
            onTap: (e) async {
              Get.toNamed(Routes.INCIDENTS_VIEW);
              // final Uri url = Uri.parse('https://preprod.hubkilo.com/my/tickets');
              // if (!await launchUrl(url)) {
              //   throw Exception('Could not launch $url');
              // }
              //await Get.offAndToNamed(Routes.HELP);
            },
          ),
          DrawerLinkWidget(
            special: false,
            drawer: false,
            icon: FontAwesomeIcons.circleInfo,
            text: 'Infos',
            onTap: (e) async {
              showDialog(
                  context: context,
                  builder: (_)=>  AlertDialog(
                    title: Text("Application Details", style: TextStyle(color: Colors.black),),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child:Text(AppLocalizations.of(context).cancel))
                    ],
                    content: SizedBox(
                      height: Get.width/5,
                      child: Column(
                        children: [
                          Row(children: [
                            Text('Version: ', style: TextStyle(color: Colors.black),),
                           Text(Get.find<RootController>().packageInfo.version, style: TextStyle(color: Colors.black)),
                          ]),
                          Row(children: [
                            Text('Build Number: ', style: TextStyle(color: Colors.black)),
                            Text(Get.find<RootController>().packageInfo.buildNumber, style: TextStyle(color: Colors.black)),
                          ]),


                        ],
                      ),
                    ),
                    icon: Icon(Icons.settings, size: 40,color: inactive),
                  ));
            },
          ),
          CustomPageDrawerLinkWidget(),
          Obx(() {
            if (Get.find<MyAuthService>().myUser.value.email != null) {
              return DrawerLinkWidget(
                special: true,
                drawer: false,
                icon: Icons.logout,
                text: AppLocalizations.of(context).logOut,
                onTap: (e) async {
                  showDialog(
                      context: context,
                      builder: (_)=>  PopUpWidget(
                        title: "Do you really want to quit?",
                        cancel: AppLocalizations.of(context).cancel,
                        confirm: AppLocalizations.of(context).logOut,
                        onTap: ()async{

                          Domain.googleUser = false;
                          await Get.find<MyAuthService>().removeCurrentUser();
                          Scaffold.of(context).closeDrawer();

                          Get.toNamed(Routes.LOGIN);

                        }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: inactive),
                      ));
                },
              );
            } else {
              return SizedBox();
            }
          }),
          /*
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
            )*/
        ],
      ),
    );
  }
}
