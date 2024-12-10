import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/my_user_model.dart';
import '../../../models/setting_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class VerificationView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
    UserRepository _userRepository;

    _userRepository = UserRepository();
    Get.put(currentUser);

    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Double Verification".tr,
              style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
            ),
            centerTitle: true,
            backgroundColor: Get.theme.colorScheme.secondary,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
              onPressed: () async{
              await Get.find<MyAuthService>().removeCurrentUser();

              Get.toNamed(Routes.LOGIN);
              },
            ),
          ),
          body: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 140,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text("",
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to the best service provider system!".tr,
                            style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),
                          // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
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
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),),
                ],
              ),
              Obx(() {
                if (controller.loading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      RichText(
                        text: TextSpan(
                          text: "Please enter the code sent to ",
                          children: [
                            TextSpan(
                              text: controller.email.value,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(horizontal: 20, vertical: 20),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFieldWidget(
                          labelText: "Verification Code".tr,
                          hintText: "- - - - - -".tr,
                          style: Get.textTheme.headline4.merge(TextStyle(letterSpacing: 8)),
                          textAlign: TextAlign.center,
                          readOnly: false,
                          keyboardType: TextInputType.number,
                          onChanged: (input) => controller.smsSent.value = input,
                          // iconData: Icons.add_to_home_screen_outlined,
                        ),
                      ),

                      BlockButtonWidget(
                        onPressed: () async {
                          //await controller.verifyPhone();

                          if(controller.smsSent.value.isNotEmpty){
                            controller.verifyClicked.value = true;

                            Get.find<MyAuthService>().myUser.value = await _userRepository.get(controller.authUserId.value);
                            if(Get.find<MyAuthService>().myUser.value.id != null){
                              var foundDeviceToken= false;

                              if(Get.find<MyAuthService>().myUser.value.deviceTokenIds.isNotEmpty)
                              {
                                for(int i = 0; i<Get.find<MyAuthService>().myUser.value.deviceTokenIds.length;i++){
                                  if(Domain.deviceToken==Get.find<MyAuthService>().myUser.value.deviceTokenIds[i]){
                                    foundDeviceToken = true;
                                  }
                                }

                              }
                              else{
                                await controller.saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
                              }

                              if(!foundDeviceToken){
                                await controller.saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
                              }
                              controller.loading.value = false;
                              Get.showSnackbar(Ui.SuccessSnackBar(message: "You logged in successfully " ));

                              controller.verifyClicked.value = false;

                              await Get.toNamed(Routes.ROOT);
                            }
                            else{
                              controller.loading.value = false;
                            }
                          }
                        },
                        color: controller.smsSent.value.isNotEmpty ? Get.theme.colorScheme.secondary : inactive,
                        text: !controller.verifyClicked.value ? Text(
                          "Verify".tr,
                          style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                        ): SizedBox(height: 30,
                            child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                      ).paddingSymmetric(vertical: 30, horizontal: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              //controller.resendOTPCode();
                            },
                            child: Text("Resend the OTP Code Again".tr, style: TextStyle(
                              color: interfaceColor,
                              fontSize: 12,
                            ),),
                          ),
                        ],
                      )
                    ],
                  );
                }
              })
            ],
          )),
    );
  }
}