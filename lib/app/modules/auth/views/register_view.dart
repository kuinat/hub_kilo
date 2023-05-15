import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  var selectedGender = "Select your gender".obs;


  var genderList = [
    'Select your gender'.tr,
    'Male'.tr,
    'Female'.tr,
  ];
  var identityPieceList = [
    'Select an identity piece'.tr,
    'CNI'.tr,
    'Passeport'.tr,
  ];

  var birthDay= DateTime.now().obs ;


  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Register".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {
              Navigator.pop(context)
            },
          ),
        ),
        body: Form(
          key: controller.registerFormKey,
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
                      radius: 20,
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
                if (controller.loading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "Full Name".tr,
                        hintText: "John Doe".tr,
                        initialValue: controller.currentUser?.value?.name,
                        onSaved: (input) => controller.currentUser?.value?.name = input,
                        validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "Email Address".tr,
                        hintText: "johndoe@gmail.com".tr,
                        initialValue: controller.currentUser?.value?.email,
                        onSaved: (input) => controller.currentUser?.value?.email = input,
                        validator: (input) => !input.contains('@') ? "Should be a valid email".tr : null,
                        iconData: Icons.alternate_email,
                        isFirst: false,
                        isLast: false,
                      ),

                      InkWell(
                          onTap: (){
                            controller.chooseBirthDate();
                            controller.currentUser?.value?.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value);
                            controller.birthDateSet.value = true;

                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                                ],
                                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Birth Date".tr,
                                  style: Get.textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                                Obx(() =>
                                    ListTile(
                                        leading: Icon(Icons.calendar_today),
                                        title: Text(DateFormat('dd/MM/yy').format(controller.birthDate.value).toString(),
                                          style: Get.textTheme.bodyText2),
                                        )
                                    )
                              ],
                            ),
                          )
                      ),

                      TextFieldWidget(
                        labelText: "Birth Place".tr,
                        hintText: "Nairobi".tr,
                        initialValue: controller.currentUser?.value?.birthplace,
                        onSaved: (input) => controller.currentUser?.value?.birthplace = input,
                        validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                        iconData: Icons.map,
                        isFirst: true,
                        isLast: false,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                            ],
                            border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                        child: DropdownButtonHideUnderline(

                          child: DropdownButtonFormField(
                            decoration: InputDecoration.collapsed(
                              hintText: ''

                            ),
                            validator:(input) => input == "Select your gender" ? "Select a gender".tr : null,
                            onSaved: (input) => controller.currentUser?.value?.sex = input,
                            isExpanded: true,
                            alignment: Alignment.bottomCenter,

                            style: Get.textTheme.bodyText1,
                            value: selectedGender.value,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: genderList.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String newValue) {
                              selectedGender.value = newValue;
                              controller.currentUser?.value?.sex = newValue;

                            },).marginOnly(left: 20, right: 20, top: 10, bottom: 10).paddingOnly( top: 20, bottom: 14),
                        )
                      ).paddingOnly(left: 20, right: 20, top: 20, bottom: 14,
                      ),


                      PhoneFieldWidget(
                        labelText: "Phone Number".tr,
                        hintText: "223 665 7896".tr,
                        initialCountryCode: controller.currentUser?.value?.getPhoneNumber()?.countryISOCode,
                        initialValue: controller.currentUser?.value?.getPhoneNumber()?.number,
                        onSaved: (phone) {
                          return controller.currentUser?.value?.phone = phone.completeNumber;
                        },
                        isLast: false,
                        isFirst: false,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          onChanged: (newValue){
                            controller.password.value = newValue;
                          },
                          labelText: "Password".tr,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.currentUser?.value?.password,
                          onSaved: (input) => controller.currentUser?.value?.password = input,
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
                        return TextFieldWidget(
                          onChanged: (newValue){
                            if(newValue!=controller.password.value){

                              controller.confirmPassword.value = 'password not matching';
                            }
                            else{
                              controller.confirmPassword.value = controller.password.value;
                            }
                          },
                          labelText: "Confirm Password".tr,
                          errorText: controller.confirmPassword.value == 'password not matching'?'password not matching':null,
                          hintText: "••••••••••••".tr,
                          //initialValue: controller.currentUser?.value?.password,
                          //onSaved: (input) => controller.currentUser.value.password = input,
                          //validator: (input) => controller.confirmPassword.value,
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
                  );
                }
              })
            ],
          ),
        ),
        bottomNavigationBar: Row(
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
                      if(!controller.birthDateSet.value){
                        controller.currentUser?.value?.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value).toString();
                      }

                      if(controller.password.value==controller.confirmPassword.value)
                        {
                          controller.register();
                        }

                      controller.buttonPressed.value = !controller.buttonPressed.value;
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: !controller.buttonPressed.value ? Text(
                      "Register".tr,
                      style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                    ) : SizedBox(height: 20,
                        child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  child: Text("You already have an account?".tr),
                ).paddingOnly(bottom: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
