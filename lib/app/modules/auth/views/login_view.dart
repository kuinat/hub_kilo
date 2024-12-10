import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_transparent_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        body: Form(
          key: controller.loginFormKey,
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
                        radius: 14,
                        color: Colors.transparent,
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
                    ).marginOnly(top: Get.height/13, bottom: 30),
                    Text(
                      AppLocalizations.of(context).login,
                      style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
                    )
                  ],
                ),
                Obx(() {
                 return Container(
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFieldTransparentWidget(
                            readOnly: false,
                            labelText: AppLocalizations.of(context).emailAddress,
                            hintText: "johndoe@gmail.com",
                            initialValue: controller.email.value,
                            keyboardType: TextInputType.emailAddress,
                            //onSaved: (input) => controller.currentUser.value.email = input,
                            onChanged: (value) => {
                              controller.email.value = value,
                              controller.currentUser.value.email = controller.email.value
                            },
                            validator: (input) => !input.contains('@') ? AppLocalizations.of(context).validEmailError : null,
                            iconData: Icons.alternate_email,
                          ),
                          Obx(() {
                            return TextFieldTransparentWidget(
                              labelText: AppLocalizations.of(context).password,
                              hintText: "••••••••••••",
                              readOnly: false,
                              initialValue: controller.password.value,
                              //onSaved: (input) => controller.currentUser.value.password = input,
                              onChanged: (value) => {
                                controller.password.value = value,
                                controller.currentUser.value.password = controller.password.value
                              },
                              validator: (input) => input.length < 3 ? AppLocalizations.of(context).validatorError : null,
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
                          SizedBox(height: 10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Obx(() => Checkbox(
                          //       value: controller.isChecked.value,
                          //       side: BorderSide(color: Colors.white.withOpacity(0.7)),
                          //       onChanged: (value)async{
                          //         var box = await GetStorage();
                          //         controller.isChecked.value = !controller.isChecked.value;
                          //         if(controller.isChecked.value){
                          //           box.write("userEmail", controller.email.value);
                          //           box.write("password", controller.password.value);
                          //           box.write("checkBox", controller.isChecked.value);
                          //         }else{
                          //           box.remove("userEmail");
                          //           box.remove("password");
                          //           box.remove("checkBox");
                          //           box.write("checkBox", false);
                          //         }
                          //         print(box.read('userEmail'));
                          //         print(box.read('password'));
                          //         print(box.read('checkBox'));
                          //       }
                          //     )),
                          //     Text(AppLocalizations.of(context).rememberMe+'    ',style: TextStyle(fontFamily: "poppins",fontSize: 15, color: Colors.white.withOpacity(0.7))),
                          //     //Spacer(),
                          //
                          //   ],
                          // ).paddingSymmetric(horizontal: 30),

                          SizedBox(height: 20),
                          Obx(() => BlockButtonWidget(
                            onPressed: () => controller.login(),
                            color: Get.theme.colorScheme.secondary,
                            text: !controller.loading.value? Text(
                              AppLocalizations.of(context).login,
                              style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                            ): SizedBox(height: 30,
                                child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                          ).paddingSymmetric(vertical: 10, horizontal: 20),),

                          Row(
                            children:  [
                              Expanded(
                                child: Divider(
                                  height: 30,
                                  //color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).or+" ",
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

                          InkWell(
                            onTap: ()=> controller.signInWithGoogle(),
                            child: Container(
                              width: Get.width,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.transparent.withOpacity(0.7),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                                  ],
                                  border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/img/search.png", width: 20,height: 20),
                                  SizedBox(width: 10),
                                  Text(AppLocalizations.of(context).connectGoogle,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.REGISTER);
                                },
                                child: Text(AppLocalizations.of(context).register,style: TextStyle(fontFamily: "poppins",fontSize: 15, color: Colors.white)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.FORGOT_PASSWORD);
                                },
                                child: Text(AppLocalizations.of(context).forgotPassword+' ?',
                                  style: TextStyle(fontFamily: "poppins",fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
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
      ),
    );
  }
}
