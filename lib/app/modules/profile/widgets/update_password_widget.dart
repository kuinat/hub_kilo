import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/profile_controller.dart';

class UpdatePasswordWidget extends GetView<ProfileController> {
  UpdatePasswordWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>ProfileController());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Change password!", style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.redAccent))),
                Text("Fill your old password and type new password and confirm it", style: Get.textTheme.caption.merge(TextStyle(color: Colors.redAccent))),
              ],
            ),
          ),
          SizedBox(width: 10),
          Obx(() {
            if (Get.find<LaravelApiClient>().isLoading(task: 'deleteUser')) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                  ),
                ),
              );
            }
            return MaterialButton(
              onPressed: () {
                return Get.bottomSheet(
                  buildEditingSheet(context),
                  isScrollControlled: true,);
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.colorScheme.secondary,
              child: Text("Change".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
              elevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
            );
          }),
        ],
      ),
    );
  }


  Widget buildEditingSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: Get.height/1.8,
      decoration: BoxDecoration(
        color: background,
        //Get.theme.primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(children: [
          Align(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              onPressed: () {
                return Get.bottomSheet(
                  buildEditingSheet(context),
                  isScrollControlled: true,);
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.colorScheme.secondary,
              child: Text("Confirm".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
              elevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
            ),
          ),

          Obx(() {
            return TextFieldWidget(
              labelText: "Old Password".tr,
              hintText: "••••••••••••".tr,
              onSaved: (input) => controller.oldPassword.value = input,
              onChanged: (input) => controller.oldPassword.value = input,
              validator: (input) => input.length > 0 && input.length < 3 ? "Should be more than 3 letters".tr : null,
              //initialValue: controller.oldPassword.value,
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
              isFirst: true,
              isLast: false,
            );
          }).marginOnly(bottom: 10),
          Obx(() {
            return TextFieldWidget(
              labelText: "New Password".tr,
              hintText: "••••••••••••".tr,
              onSaved: (input) => controller.user.value.password = input,
              onChanged: (input) => controller.newPassword.value = input,
              // validator: (input) {
              //   if (input.length > 0 && input.length < 3) {
              //     return "Should be more than 3 letters".tr;
              //   } else if (input != controller.confirmPassword.value) {
              //     return "Passwords do not match".tr;
              //   } else {
              //     return null;
              //   }
              // },
              //initialValue: controller.newPassword.value,
              obscureText: controller.hidePassword.value,
              iconData: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              isFirst: false,
              isLast: false,
            );
          }).marginOnly(bottom: 10),
          Obx(() {
            return TextFieldWidget(
              labelText: "Confirm New Password".tr,
              hintText: "••••••••••••".tr,
              //editable: controller.editPassword.value,
              onSaved: (input) => controller.confirmPassword.value = input,
              onChanged: (input) => controller.confirmPassword.value = input,
              validator: (input) {
                if (input.length > 0 && input.length < 3) {
                  return "Should be more than 3 letters".tr;
                } else if (input != controller.newPassword.value) {
                  return "Passwords do not match".tr;
                } else {
                  return null;
                }
              },
              //initialValue: controller.confirmPassword.value,
              obscureText: controller.hidePassword.value,
              iconData: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              isFirst: false,
              isLast: true,
            );
          }).marginOnly(bottom: 10),
        ],),
      ),
    );
  }

  // void _showDeleteDialog(BuildContext context) {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           "Delete your account!".tr,
  //           style: TextStyle(color: Colors.redAccent),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: <Widget>[
  //               Text("Once you delete this account, there is no going back. Please be certain.".tr, style: Get.textTheme.bodyText1),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
  //             onPressed: () {
  //               Get.back();
  //             },
  //           ),
  //           TextButton(
  //             child: Text(
  //               "Confirm".tr,
  //               style: TextStyle(color: Colors.redAccent),
  //             ),
  //             onPressed: () async {
  //               Get.back();
  //               await controller.deleteUser();
  //               await Get.find<RootController>().changePage(0);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
