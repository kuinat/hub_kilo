import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';
import '../widgets/delete_account_widget.dart';
import '../widgets/update_password_widget.dart';


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
          child: Obx(() => Expanded(
            child: MaterialButton(
              onPressed: () {
                if(!controller.birthDateSet.value){
                  controller.user.value?.birthday = DateFormat('yy/MM/dd').format(DateTime.parse(controller.user.value.birthday)).toString();
                  //controller.birthDateSet.value = true;
                }
                if(controller.birthDate.value.toString().contains('/')){
                  controller.user.value.birthday = controller.birthDate.value;
                }
                controller.saveProfileForm();
                controller.buttonPressed.value = !controller.buttonPressed.value;
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.colorScheme.secondary,
              child: !controller.buttonPressed.value ? Text("Update".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)))
                  : SizedBox(height: 10,
                  child: SpinKitThreeBounce(color: Colors.white, size: 20)),
              elevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
            ),
          )).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.profileForm,
          child: ListView(
            primary: true,
            children: [
              Obx((){
                return Column(
                  children: [
                    Text("Change the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                    TextFieldWidget(
                      onChanged: (input) => controller.user.value.name = input,
                      onSaved: (input) => controller.user.value.name = input,
                      validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                      hintText: "John Doe".tr,
                      labelText: "Full Name".tr,
                      iconData: Icons.person_outline,
                      initialValue: controller.user.value.name,
                    ),
                    TextFieldWidget(
                        validator: (input) => !input.contains('@') ? "Should be a valid email" : null,
                        hintText: "johndoe@gmail.com",
                        onChanged: (input) => controller.user.value.email = input,
                        onSaved: (input) => controller.user.value.email = input,
                        labelText: "Email".tr,
                        iconData: Icons.alternate_email,
                        initialValue: controller.user.value.email
                    ),

                    //Obx(() {

                    controller.editNumber.value==false?
                    InkWell(
                        onTap: ()=>{controller.editNumber.value == true},
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
                              //Text(controller.currentUser.value.phone,style: Get.textTheme.bodyText1,),
                              Obx(() =>
                                  ListTile(
                                      leading: FaIcon(FontAwesomeIcons.phone, size: 20),
                                      title: Text(controller.user.value.phone,style: Get.textTheme.bodyText1,

                                      )
                                  )
                              ),

                              // Text('Edit...',style: Get.textTheme.bodyText1,),
                              TextButton(
                                onPressed: ((){
                                  controller.editNumber.value = true;
                                }),
                                child: Text('Edit...',style: Get.textTheme.bodyText1,),)
                            ],
                          ),
                        )
                    ):

                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PhoneFieldWidget(
                          labelText: "Phone Number".tr,
                          hintText: "223 665 7896".tr,
                          //initialValue: controller.currentUser.value.phone,
                          onSaved: (phone) {
                            return controller.user.value?.phone = phone.completeNumber;
                          },
                          onChanged: (input) => controller.user.value?.phone = input.toString(),
                        ),
                        TextButton(
                          onPressed: ((){
                            controller.editNumber.value = false;

                          }),
                          child: Text('Cancel...',style: Get.textTheme.bodyText1,),)

                      ],),

                    InkWell(
                        onTap: (){
                          controller.chooseBirthDate();
                          //controller.user.value.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value);
                          controller.birthDateSet.value = true;
                        },
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
                              Obx(() {
                                return ListTile(
                                    leading: FaIcon(
                                        FontAwesomeIcons.birthdayCake, size: 20),
                                    title: Text(controller.birthDate.value.toString(),
                                      style: Get.textTheme.bodyText1,
                                    ));
                              })
                            ],
                          ),
                        )
                    ),
                    // }
                    //
                    // ),
                    TextFieldWidget(
                      onChanged: (input) => controller.user.value.birthplace = input,
                      onSaved: (input) => controller.user.value.birthplace = input,
                      validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                      hintText: "123 Street, City 136, State, Country".tr,
                      labelText: "Place of birth".tr,
                      iconData: Icons.location_on_rounded,
                      initialValue: controller.user.value.birthplace,
                    ),

                    TextFieldWidget(
                      onChanged: (input) => controller.user.value.street = input,
                      onSaved: (input) => controller.user.value.street = input,
                      validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                      hintText: "123 Street, City 136, State, Country".tr,
                      labelText: "Address".tr,
                      iconData: Icons.location_on_rounded,
                      initialValue: controller.user.value.street,
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
                            onSaved: (input) => controller.selectedGender.value == "Male"?controller.user?.value?.sex = "M":controller.user?.value?.sex = "F",
                            isExpanded: true,
                            alignment: Alignment.bottomCenter,

                            style: Get.textTheme.bodyText1,
                            value: controller.user.value.sex=="M"?controller.selectedGender.value=controller.genderList[0]:controller.selectedGender.value=controller.genderList[1],
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: controller.genderList.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String newValue) {
                              controller.selectedGender.value = newValue;
                              if(controller.selectedGender.value == "Male"){
                                controller.user?.value?.sex = "M";
                              }
                              else{
                                controller.user?.value?.sex = "F";
                              }


                            },).marginOnly(left: 20, right: 20, top: 10, bottom: 10).paddingOnly( top: 20, bottom: 14),
                        )
                    ).paddingOnly(left: 20, right: 20, top: 20, bottom: 14,
                    ),
                  ],
                );

              }),


              //
              // Text("Change password".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              // Text("Fill your old password and type new password and confirm it".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
              // Obx(() {
              //   return TextFieldWidget(
              //     labelText: "Old Password".tr,
              //     hintText: "••••••••••••".tr,
              //     onSaved: (input) => controller.oldPassword.value = input,
              //     onChanged: (input) => controller.oldPassword.value = input,
              //     validator: (input) => input.length > 0 && input.length < 3 ? "Should be more than 3 letters".tr : null,
              //     //initialValue: controller.oldPassword.value,
              //     obscureText: controller.hidePassword.value,
              //     iconData: Icons.lock_outline,
              //     keyboardType: TextInputType.visiblePassword,
              //     suffixIcon: IconButton(
              //       onPressed: () {
              //         controller.hidePassword.value = !controller.hidePassword.value;
              //       },
              //       color: Theme.of(context).focusColor,
              //       icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              //     ),
              //     isFirst: true,
              //     isLast: false,
              //   );
              // }),
              // Obx(() {
              //   return TextFieldWidget(
              //     labelText: "New Password".tr,
              //     hintText: "••••••••••••".tr,
              //     onSaved: (input) => controller.user.value.password = input,
              //     onChanged: (input) => controller.newPassword.value = input,
              //     // validator: (input) {
              //     //   if (input.length > 0 && input.length < 3) {
              //     //     return "Should be more than 3 letters".tr;
              //     //   } else if (input != controller.confirmPassword.value) {
              //     //     return "Passwords do not match".tr;
              //     //   } else {
              //     //     return null;
              //     //   }
              //     // },
              //     //initialValue: controller.newPassword.value,
              //     obscureText: controller.hidePassword.value,
              //     iconData: Icons.lock_outline,
              //     keyboardType: TextInputType.visiblePassword,
              //     isFirst: false,
              //     isLast: false,
              //   );
              // }),
              // Obx(() {
              //   return TextFieldWidget(
              //     labelText: "Confirm New Password".tr,
              //     hintText: "••••••••••••".tr,
              //     //editable: controller.editPassword.value,
              //     onSaved: (input) => controller.confirmPassword.value = input,
              //     onChanged: (input) => controller.confirmPassword.value = input,
              //     validator: (input) {
              //       if (input.length > 0 && input.length < 3) {
              //         return "Should be more than 3 letters".tr;
              //       } else if (input != controller.newPassword.value) {
              //         return "Passwords do not match".tr;
              //       } else {
              //         return null;
              //       }
              //     },
              //     //initialValue: controller.confirmPassword.value,
              //     obscureText: controller.hidePassword.value,
              //     iconData: Icons.lock_outline,
              //     keyboardType: TextInputType.visiblePassword,
              //     isFirst: false,
              //     isLast: true,
              //   );
              // }),
              UpdatePasswordWidget(),
              DeleteAccountWidget(),
            ],
          ),
        ));
  }
}
