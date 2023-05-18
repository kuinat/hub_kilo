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
                    controller.saveProfileForm();
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
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Profile details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, left: 22),
                      Text("Change the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                      // Obx(() {
                      //   return

                      //}),
                    ],
                  ),

                  // Obx(() {
                  //   return

                  //}),


            // InkWell(
            //     onTap: () {
            //       imagePicker();
            //     },
            //     child: profileImage != ""
            //         ? image == null
            //         ? CircleAvatar(
            //       radius: 70,
            //       backgroundColor: Colors.indigoAccent,
            //       child: Icon(Icons.photo_camera,
            //           size: 50, color: Palette.background),
            //     )
            //         : Image.file(File(image!.path),
            //         fit: BoxFit.contain, width: 150, height: 150)
            //         : Container(
            //       height: 150,
            //       width: 150,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         //borderRadius: BorderRadius.all(Radius.circular(10)),
            //         image: profileImageList != null &&
            //             profileImageList['image_1920'].toString() !=
            //                 'false'
            //             ? DecorationImage(
            //             image: NetworkImage(
            //                 Domain.serverPort +
            //                     '/v1/image/res.partner/' +
            //                     json
            //                         .decode(userDto!)['data'][0]
            //                     ['partner_id'][0]['id']
            //                         .toString() +
            //                     '/image_1920?unique=true&file_response=true',
            //                 headers: Domain.getTokenHeaders()),
            //             fit: BoxFit.cover)
            //             : DecorationImage(
            //             image: AssetImage(
            //                 'assets/images/photo_2022-11-25_01-12-07.jpg')),
            //       ),
            //     ))),




                  // Container(
                  //     width: 100,
                  //     height: 100,
                  //     margin: EdgeInsets.only(right: 10),
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         image: DecorationImage(
                  //             image: NetworkImage("https://images.unsplash.com/photo-1571086291540-b137111fa1c7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80"),
                  //             fit: BoxFit.cover
                  //         )
                  //     )
                  // )


                ],
              ),

              //Obx(() {
                // return
                ImageFieldWidget(
                  label: "Image".tr,
                  field: 'avatar',
                  tag: controller.profileForm.hashCode.toString(),
                  initialImage: "http:127.0.0.1//web/image/res.partner/"+controller.currentUser.value.id.toString()+"/image_1920"
                  // uploadCompleted: (uuid) {
                  //   controller.avatar.value = new Media(id: uuid);
                  // },
                  // reset: (uuid) {
                  //   controller.avatar.value = new Media(thumb: controller.user.value.avatar.thumb);
                  // },
                ),
              //}),
              Obx((){
                return Column(
                  children: [
                    TextFieldWidget(
                      onChanged: (input) => controller.userName.value = input,
                      onSaved: (input) => controller.user.value.name = input,
                      validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                      hintText: "John Doe".tr,
                      labelText: "Full Name".tr,
                      iconData: Icons.person_outline,
                      initialValue: controller.currentUser.value.name,
                    ),
                    TextFieldWidget(
                        validator: (input) => !input.contains('@') ? "Should be a valid email" : null,
                        hintText: "johndoe@gmail.com",
                        onChanged: (input) => controller.email.value = input,
                        onSaved: (input) => controller.user.value.email = input,
                        labelText: "Email".tr,
                        iconData: Icons.alternate_email,
                        initialValue: controller.currentUser.value.email
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PhoneFieldWidget(
                          labelText: "Phone Number".tr,
                          hintText: "223 665 7896".tr,
                          //initialValue: controller.currentUser.value.phone,
                          onSaved: (phone) {
                            return controller.user.value?.phone = phone.completeNumber;
                          },
                          onChanged: (input) => controller.phone.value = input.toString(),
                        ),
                        TextButton(
                          onPressed: ((){
                            controller.editNumber.value = false;

                          }),
                          child: Text('Cancel...',style: Get.textTheme.bodyText1,),)

                      ],),



                    //}),






                    // Obx((){
                    //   return
                    InkWell(
                        onTap: (){
                          controller.chooseBirthDate();
                          //controller.user.value.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value);
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
                      onChanged: (input) => controller.birthPlace.value = input,
                      onSaved: (input) => controller.birthPlace.value = input,
                      validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                      hintText: "123 Street, City 136, State, Country".tr,
                      labelText: "Place of birth".tr,
                      iconData: Icons.location_on_rounded,
                      initialValue: controller.currentUser.value.birthplace,
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
                            value: controller.currentUser.value.sex=="M"?controller.selectedGender.value=controller.genderList[1]:controller.selectedGender.value=controller.genderList[0],
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
                                controller.currentUser?.value?.sex = "M";
                              }
                              else{
                                controller.currentUser?.value?.sex = "F";
                              }


                            },).marginOnly(left: 20, right: 20, top: 10, bottom: 10).paddingOnly( top: 20, bottom: 14),
                        )
                    ).paddingOnly(left: 20, right: 20, top: 20, bottom: 14,
                    ),
                  ],
                );

              }),



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
              }),
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
              }),
              DeleteAccountWidget(),
            ],
          ),
        ));
  }
}
