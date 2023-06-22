import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';

class AccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    //var _currentUser = Get.find<MyAuthService>().myUser;
    return Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(
            "Account".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: ()async{
            await controller.onRefresh();

          },
          child: ListView(
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
                          Text( controller.currentUser.value.name ?? '',
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                          SizedBox(height: 10),
                          Text(controller.currentUser.value.email ?? '', style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),

                        ],
                      ),
                    ),
                  ),

                  //Obx(() =>
                      Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      image: DecorationImage(
                          image: NetworkImage(
                              // _currentUser.value.image == true ? '${Domain.serverPort}/web/image/res.partner/${_currentUser.value.id}/image_1920'
                              //     :
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-unknown-social-media-user-photo-default-avatar-profile-icon-vector-unknown-social-media-user-184816085.jpg',

                          ),
                          fit: BoxFit.fill,
                        // onError: (exception, stackTrace) {
                        //   // Handle the error here
                        //   Get.showSnackbar(Ui.ErrorSnackBar(message: "Image failed to load!".tr));
                        //   print('Image failed to load: $exception');
                        // },
                      ),
                      border: Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        color:
                        //controller.currentUser.value.image == 'true' ? Colors.white.withOpacity(0.3) :
                        interfaceColor.withOpacity(0.3),
                        child: Center(
                            child: IconButton(
                                onPressed: ()async{
                                  await controller.selectCameraOrGallery();
                                },
                                icon: Icon(FontAwesomeIcons.camera, size: 30, color: Colors.white)
                            )
                        ),
                      ),
                    ),
                  )
                    //,)

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
                        text: Text('Date of Birth'),
                        value: controller.currentUser.value.birthday.toString(),
                      ),
                      AccountWidget(
                        icon: FontAwesomeIcons.locationDot,
                        text: Text('Place of birth'),
                        value: controller.currentUser.value.birthplace,
                      ),
                      AccountWidget(
                        icon: FontAwesomeIcons.locationDot,
                        text: Text('Address'),
                        value: controller.currentUser.value.street,
                      ),
                      AccountWidget(
                        icon: FontAwesomeIcons.male,
                        text: Text('Sexe'),
                        value: controller.currentUser.value.sex=='M'?"Male":"Female",
                      ),

                      Card(
                          elevation: 10,
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: AccountLinkWidget(
                                icon: Icon(FontAwesomeIcons.userEdit, color: Get.theme.colorScheme.secondary),
                                text: Text("Edit Profile".tr),
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
                        Get.offNamed(Routes.VALIDATE_TRANSACTION);
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
                        showDialog(context: context,
                            builder: (_)=> PopUpWidget(
                              title: "Do you really want to quit?",
                              cancel: 'Cancel',
                              confirm: 'Log Out',
                              onTap: ()async{
                                final box = GetStorage();
                                await Get.find<MyAuthService>().removeCurrentUser();
                                Get.find<RootController>().changePage(0);
                                box.remove("session_id");
                                Navigator.pop(context);
                              }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: inactive),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }


}
