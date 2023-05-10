import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/expedition_order_controller.dart';

class ExpeditionOrderView extends GetView<ExpeditionOrderController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;



  @override
  Widget build(BuildContext context) {
    controller.expeditionOrderFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Expedition Order".tr,
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
          key: controller.expeditionOrderFormKey,
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
                        "Fill this Form and get your package sent".tr,
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
                        labelText: "What are you sending?".tr,
                        hintText: "Raw African food".tr,
                        initialValue: controller.currentUser?.value?.name,
                        onSaved: (input) => controller.currentUser.value.name = input,
                        validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "Number of kilos".tr,
                        hintText: "5 kg".tr,
                        initialValue: controller.currentUser?.value?.email,
                        onSaved: (input) => controller.currentUser.value.email = input,
                        validator: (input) => !input.contains('@') ? "Should be a valid email".tr : null,
                        iconData: Icons.alternate_email,
                        isFirst: false,
                        isLast: false,
                      ),

                      TextFieldWidget(
                        labelText: "Receiver's name".tr,
                        hintText: "John Doe".tr,
                        initialValue: controller.currentUser?.value?.birthday,
                        onSaved: (input) => controller.currentUser.value.birthday = input,
                        validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                        iconData: Icons.map,
                        isFirst: true,
                        isLast: false,
                      ),


                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: Get.theme.primaryColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       boxShadow: [
                      //         BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      //       ],
                      //       border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                      //   child: DropdownButton(
                      //
                      //     isExpanded: true,
                      //     alignment: Alignment.bottomCenter,
                      //
                      //     style: Get.textTheme.bodyText1,
                      //     value: selectedGender.value,
                      //     // Down Arrow Icon
                      //     icon: const Icon(Icons.keyboard_arrow_down),
                      //
                      //     // Array list of items
                      //     items: genderList.map((String items) {
                      //       return DropdownMenuItem(
                      //         value: items,
                      //         child: Text(items),
                      //       );
                      //     }).toList(),
                      //     // After selecting the desired option,it will
                      //     // change button value to selected value
                      //     onChanged: (String newValue) {
                      //       selectedGender.value = newValue;
                      //       controller.currentUser.value.sex = newValue;
                      //
                      //     },).marginOnly(left: 20, right: 20, top: 10, bottom: 10).paddingOnly( top: 20, bottom: 14),
                      // ).paddingOnly(left: 20, right: 20, top: 20, bottom: 14),


                      PhoneFieldWidget(
                        labelText: "Receiver's Phone Number".tr,
                        hintText: "223 665 7896".tr,
                        initialCountryCode: controller.currentUser?.value?.getPhoneNumber()?.countryISOCode,
                        initialValue: controller.currentUser?.value?.getPhoneNumber()?.number,
                        onSaved: (phone) {
                          return controller.currentUser.value.phone = phone.completeNumber;
                        },
                        isLast: false,
                        isFirst: false,
                      ),

                      

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
                      controller.register();
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      "Validate Expedition".tr,
                      style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                ),




              ],
            ),
          ],
        ),
      ),
    );
  }
}
