import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';
import '../widgets/delete_account_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileView extends GetView<ProfileController> {
  final bool hideAppBar;

  ProfileView({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    controller.profileForm = new GlobalKey<FormState>();
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
          title: Text(
            "Profile".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Obx(() => Expanded(
                child: MaterialButton(
                  onPressed: () {
                    //controller.saveProfileForm();
                    controller.buttonPressed.value = !controller.buttonPressed.value;
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: !controller.buttonPressed.value ? Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)))
                      : SizedBox(height: 10,
                      child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                  elevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                ),
              )),
              SizedBox(width: 10),
              MaterialButton(
                onPressed: () {
                  controller.resetProfileForm();
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.hintColor.withOpacity(0.1),
                child: Text("Reset".tr, style: Get.textTheme.bodyText2),
                elevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.profileForm,
          child: ListView(
            primary: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Profile details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, left: 22),
                      Text("Change the following \ndetails and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                    ],
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage("https://images.unsplash.com/photo-1571086291540-b137111fa1c7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80"),
                            fit: BoxFit.cover
                        )
                    )
                  )
                ],
              ),

              TextFieldWidget(
                onChanged: (input) => controller.userName.value = input,
                validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                hintText: "John Doe".tr,
                labelText: "Full Name".tr,
                iconData: Icons.person_outline,
              ),
              TextFieldWidget(
                validator: (input) => !input.contains('@') ? "Should be a valid email" : null,
                hintText: "johndoe@gmail.com",
                onChanged: (input) => controller.email.value = input,
                labelText: "Email".tr,
                iconData: Icons.alternate_email,
              ),
              PhoneFieldWidget(
                labelText: "Phone Number".tr,
                hintText: "223 665 7896".tr,
                onChanged: (input) => controller.phone.value = input.toString(),
              ),
              InkWell(
                  onTap: ()=>{controller.chooseBirthDate()},
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
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
                        Text("Date of birth".tr,
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        Obx(() =>
                            ListTile(
                                leading: FaIcon(FontAwesomeIcons.birthdayCake, size: 20),
                                title: Text(DateFormat('dd/MM/yyyy').format(controller.birthDate.value).toString(),
                                  style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
                                )
                            )
                        )
                      ],
                    ),
                  )
              ),
              TextFieldWidget(
                onChanged: (input) => controller.birthPlace.value = input,
                validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                hintText: "123 Street, City 136, State, Country".tr,
                labelText: "Place of birth".tr,
                iconData: Icons.location_on_rounded,
              ),
              TextFieldWidget(
                onChanged: (input) => controller.gender.value = input,
                hintText: "MALE".tr,
                labelText: "Gender".tr,
                iconData: FontAwesomeIcons.male,
              ),
              Text("Change password".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              Text("Fill your old password and type new password and confirm it".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
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
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "New Password".tr,
                  hintText: "••••••••••••".tr,
                  onSaved: (input) => controller.newPassword.value = input,
                  onChanged: (input) => controller.newPassword.value = input,
                  validator: (input) {
                    if (input.length > 0 && input.length < 3) {
                      return "Should be more than 3 letters".tr;
                    } else if (input != controller.confirmPassword.value) {
                      return "Passwords do not match".tr;
                    } else {
                      return null;
                    }
                  },
                  //initialValue: controller.newPassword.value,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isFirst: false,
                  isLast: false,
                );
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "Confirm New Password".tr,
                  hintText: "••••••••••••".tr,
                  editable: controller.editPassword.value,
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
              }),
              DeleteAccountWidget(),
            ],
          ),
        ));
  }
}
