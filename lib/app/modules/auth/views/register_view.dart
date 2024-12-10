import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_transparent_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;
  String dropdownvalueGender = AppLocalizations.of(Get.context).gender;

  var selectedGender = AppLocalizations.of(Get.context).gender.obs;


  var genderList = [
    AppLocalizations.of(Get.context).gender.tr,
    AppLocalizations.of(Get.context).male.tr,
    AppLocalizations.of(Get.context).female.tr,
  ];

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    return Scaffold(
        body: Form(
          key: controller.registerFormKey,
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
                      AppLocalizations.of(context).register,
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
                          labelText: AppLocalizations.of(context).fullName,
                          hintText: "John Doe".tr,
                          readOnly: false,
                          initialValue: controller.currentUser?.value?.name,
                          onSaved: (input) => controller.currentUser?.value?.name = input,
                          validator: (input) => input.length < 3 ? AppLocalizations.of(context).validatorError.tr : null,
                          iconData: Icons.person_outline,
                        ),
                        TextFieldTransparentWidget(
                          labelText: AppLocalizations.of(context).emailAddress,
                          hintText: "johndoe@gmail.com".tr,
                          readOnly: false,
                          initialValue: controller.currentUser?.value?.email,
                          onChanged: (value) => controller.email.value = value,
                          onSaved: (input) => controller.currentUser?.value?.email = input,
                          validator: (input) => !input.contains('@') ? AppLocalizations.of(context).validEmailError.tr : null,
                          iconData: Icons.alternate_email,
                        ),

                        Container(
                            decoration: BoxDecoration(
                                color:  Colors.transparent.withOpacity(0.4),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                                ],
                                border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.transparent.withOpacity(0.1),
                                decoration: InputDecoration.collapsed(
                                    hintText: '',

                                ),
                                validator:(input) => input == AppLocalizations.of(context).emailAddress ? AppLocalizations.of(context).emailAddress : null,
                                onSaved: (input) => (selectedGender.value == "Male"||selectedGender.value == "Homme")?controller.currentUser?.value?.sex = "male":controller.currentUser?.value?.sex = "female",
                                isExpanded: true,
                                alignment: Alignment.bottomCenter,

                                style: TextStyle(color: labelColor),
                                value: selectedGender.value,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),

                                // Array list of items
                                items: genderList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items, style: TextStyle(color: Colors.white),),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String newValue) {
                                  selectedGender.value = newValue;
                                  if(selectedGender.value == "Male"||selectedGender.value == "Homme"){
                                    controller.currentUser?.value?.sex = "male";
                                  }
                                  else{
                                    controller.currentUser?.value?.sex = "female";
                                  }


                                },).marginOnly(left: 20, right: 20, top: 10, bottom: 10).paddingOnly( top: 20, bottom: 14),
                            )
                        ).paddingOnly(left: 5, right: 5, top: 20, bottom: 14,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                          margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.transparent.withOpacity(0.4),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                              border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: '032655333333',

                              labelText: AppLocalizations.of(context).phoneNumber,
                              suffixIcon: Icon(Icons.phone_android_outlined, color: Colors.white,),
                            ),
                            initialCountryCode: 'BE',
                            style: TextStyle( color: Colors.white),
                            onSaved: (phone) {
                              return controller.currentUser?.value?.phone = phone.completeNumber;
                            },
                          ),
                        ),

                        Obx(() {
                          return TextFieldTransparentWidget(
                            onChanged: (newValue){
                              controller.password.value = newValue;
                            },
                            labelText: AppLocalizations.of(context).password,
                            hintText: "••••••••••••".tr,
                            readOnly: false,
                            initialValue: controller.currentUser?.value?.password,
                            onSaved: (input) => controller.currentUser?.value?.password = input,
                            validator: (input) => input.length < 3 ? AppLocalizations.of(context).validatorError.tr : null,
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

                        Obx(() {
                          return TextFieldTransparentWidget(
                            onChanged: (newValue){
                              if(newValue!=controller.password.value){

                                controller.confirmPassword.value = AppLocalizations.of(context).passwordNotMatchingError;
                              }
                              else{
                                controller.confirmPassword.value = controller.password.value;
                              }
                            },
                            labelText: AppLocalizations.of(context).confirmPassword,
                            errorText: (controller.confirmPassword.value == 'password not matching'||controller.confirmPassword.value == 'mot de passe non correspondant')?AppLocalizations.of(context).passwordNotMatchingError:null,
                            hintText: "••••••••••••".tr,
                            readOnly: false,
                            obscureText: controller.hidePassword.value,
                            iconData: Icons.lock_outline,
                            keyboardType: TextInputType.visiblePassword,
                            isLast: true,
                            isFirst: false,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.hidePassword.value = !controller.hidePassword.value;
                              },
                              color: Theme.of(context).focusColor,
                              icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }
                )
              ],
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        bottomNavigationBar: SizedBox(
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  SizedBox(
                    width: Get.width,
                    child: BlockButtonWidget(
                      onPressed: () {

                        if(controller.password.value==controller.confirmPassword.value)
                        {
                          controller.register();
                        }

                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.loading.value?Text(
                        AppLocalizations.of(context).register,
                        style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                      ): SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).noAccount.tr, style: TextStyle(color: Colors.black),),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        child: Text(AppLocalizations.of(context).login, style: TextStyle(color: interfaceColor, fontWeight: FontWeight.bold)),
                      ),

                    ],).paddingOnly(bottom: 10)


                ],
              ),
            ],
          ),),
        )
    );
  }
}
