import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_transparent_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.forgotPasswordFormKey = new GlobalKey<FormState>();
    return Scaffold(

        body: Form(
          key: controller.forgotPasswordFormKey,
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken),
                image: AssetImage("assets/img/photo_2023-12-27_05-59-14.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              primary: true,
              children: [

                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      decoration: Ui.getBoxDecoration(
                        color: Colors.transparent,
                        radius: 14,
                        border: Border.all(width: 5, color: Colors.transparent),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          'assets/img/hubcolis.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ).marginOnly(top: Get.height/10),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).forgotPassword.tr,
                    style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
                  ),
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldTransparentWidget(
                        labelText: AppLocalizations.of(context).emailAddress.tr,
                        readOnly: false,
                        hintText: "johndoe@gmail.com".tr,
                        initialValue: controller.currentUser?.value?.email,
                        onChanged: (value)=> controller.email.value = value,
                        onSaved: (input) => controller.currentUser.value.email = input,
                        validator: (input) => !GetUtils.isEmail(input) ? AppLocalizations.of(context).validEmailError.tr : null,
                        iconData: Icons.alternate_email,
                      ),
                      Obx(() => BlockButtonWidget(
                        onPressed: ()async=> {

                          controller.onClick.value = true,
                          await controller.getUserByEmail(controller.email.value),

                        },
                        color: Get.theme.colorScheme.secondary,
                        text: !controller.onClick.value? Text(
                          AppLocalizations.of(context).resetLink,
                          style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, ),),
                          textAlign: TextAlign.center,
                        ): SizedBox(height: 30,
                            child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                      ).paddingSymmetric(vertical: 35, horizontal: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context).noAccount.tr, style: TextStyle(color: Colors.white60)),
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed(Routes.REGISTER);
                            },
                            child: Text(AppLocalizations.of(context).register.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context).rememberPassword.tr, style: TextStyle(color: Colors.white60)),
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed(Routes.LOGIN);
                            },
                            child: Text(AppLocalizations.of(context).login.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        )
    );
  }
}