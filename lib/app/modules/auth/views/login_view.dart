import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Login".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.offNamed(Routes.ROOT)},
          ),
        ),
        body: Form(
          key: controller.loginFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 120,
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
                      child: Text(
                        "Welcome to the best service provider system!".tr,
                        style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor)),
                        textAlign: TextAlign.center,
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
                        'assets/img/logohubkilo.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
               return Container(
                 padding: EdgeInsets.symmetric(horizontal: 10),
                 child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFieldWidget(
                          readOnly: false,
                          labelText: "Email Address".tr,
                          hintText: "johndoe@gmail.com".tr,
                          initialValue: controller.currentUser?.value?.email,
                          onSaved: (input) => controller.currentUser?.value?.email = input,
                          validator: (input) => !input.contains('@') ? "Should be a valid email".tr : null,
                          iconData: Icons.alternate_email,
                        ),
                        Obx(() {
                          return TextFieldWidget(
                            labelText: "Password".tr,
                            hintText: "••••••••••••".tr,
                            readOnly: false,
                            initialValue: controller.currentUser?.value?.password,
                            onSaved: (input) => controller.currentUser?.value?.password = input,
                            validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                            obscureText: controller.hidePassword.value,
                            iconData: Icons.lock_outline,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.hidePassword.value = !controller.hidePassword.value;
                              },
                              color: Theme.of(context).focusColor,
                              icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              child: Text("Forgot Password?".tr),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 30),
                        BlockButtonWidget(
                          onPressed: () {
                            controller.login();
                          },
                          color: Get.theme.colorScheme.secondary,
                          text: !controller.loading.value? Text(
                            "Login".tr,
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                          ): SizedBox(height: 30,
                              child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                        ).paddingSymmetric(vertical: 10, horizontal: 20),

                        Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                height: 30,
                                //color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Text(
                              " Or  ",
                              style: TextStyle(
                                fontSize: 16,
                                //fontFamily:'Roboto',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Expanded(
                              child: Divider(
                                height: 30,
                                //color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            //fixedSize: Size(50, 40)
                          ),
                            onPressed: (){
                            controller.signInWithGoogle();
                            },
                          label: Text('Connect with Google',style: TextStyle(fontWeight: FontWeight.bold)),
                          icon: Icon(FontAwesomeIcons.google),
                        ).paddingSymmetric(vertical: 10, horizontal: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("You don't have an account?".tr),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.REGISTER);
                              },
                              child: Text("Register".tr),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 20),
                      ],
                    ),
               );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
