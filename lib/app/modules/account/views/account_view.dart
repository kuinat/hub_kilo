import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../profile/widgets/delete_account_widget.dart';
import '../../profile/widgets/update_password_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';

class AccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    //var _currentUser = Get.find<MyAuthService>().myUser;
    return Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(
            "Account".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: ()async{
            await controller.onRefresh();

          },
          child: ListView(
            primary: true,
            children: [
              /*Obx(() {
              return ;
            }),*/
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey.shade200,
                        child: CircleAvatar(
                            radius: 70,
                            backgroundImage: controller.currentUser.value.image != 'false' ? NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${controller.currentUser.value.id}/image_1920?unique=true&file_response=true',
                                headers: Domain.getTokenHeaders()) : AssetImage("assets/img/téléchargement (2).png"),
                            onBackgroundImageError: (Object, StackBack){
                              return Image.asset('assets/img/user.png', width: 70, height: 70);
                            },
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                  onTap: ()=> controller.selectCameraOrGallery(),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.add_a_photo, color: Colors.black),
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            60,
                                          ),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(2, 4),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 3,
                                          ),
                                        ]),
                                  )
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 15),
                  child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: Get.find<MyAuthService>().myUser.value.name, style: Get.textTheme.headline6.merge(TextStyle(fontSize: 18, color: appColor))
                          ),
                          TextSpan(
                              text: "\n${Get.find<MyAuthService>().myUser.value.email}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: appColor))
                          )
                        ]
                      )),
                  )
                ],
              ),

              Obx(() => Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                color: Palette.background,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    InkWell(
                      onTap: (){
                          controller.currentState.value = 0;
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            //color: controller.currentState == 0 ? background : null,
                            border: controller.currentState == 0 ? Border(
                                bottom: BorderSide(width: 4, color: interfaceColor)
                            ): null
                        ),
                        child: Text("Profile", style: context.textTheme.headline4,),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        controller.currentState.value = 1;
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            //color: controller.currentState == 1 ? background : null,
                            border: controller.currentState == 1 ? Border(
                                bottom: BorderSide(width: 4, color: interfaceColor)
                            ): null
                        ),
                        child: Text("Attachment", style: context.textTheme.headline4,),
                      ),
                    ),
                    /*InkWell(
                  onTap: (){
                    //setState(() {currentState = 2;});
                  },
                  child: Container(
                    width: width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: currentState == 2 ? background : null,
                        border: currentState == 2 ? Border(
                            bottom: BorderSide(width: 4, color: validateColor)
                        ): null
                    ),
                    child: Text("Emplacements", style: TextStyle(color: inactive)),
                  ),
                ),*/
                    InkWell(
                      onTap: (){
                        controller.currentState.value = 2;
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            //color: controller.currentState == 2 ? background : null,
                            border: controller.currentState == 2 ? Border(
                                bottom: BorderSide(width: 4, color: interfaceColor)
                            ): null
                        ),
                        child: Text("Settings", style: context.textTheme.headline4,),
                      ),
                    ),
                  ],
                ),
              )),
              /*Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shadowColor: inactive,
                  child: ExpansionTile(
                    leading: Icon(FontAwesomeIcons.userCheck, size: 20),
                    title: Text("View Profile".tr, style: Get.textTheme.bodyText2),
                    children: [
                      AccountWidget(
                        icon: FontAwesomeIcons.birthdayCake,
                        text: Text('Date of Birth'),
                        value: controller.currentUser.value.birthday.toString()=='false'?'--':controller.currentUser.value.birthday.toString()
                      ),
                      AccountWidget(
                        icon: FontAwesomeIcons.locationDot,
                        text: Text('Place of birth'),
                        value: controller.currentUser.value.birthplace.toString() == 'false'?'--':controller.currentUser.value.birthplace,
                      ),
                      AccountWidget(
                        icon: FontAwesomeIcons.locationDot,
                        text: Text('Address'),
                        value: controller.currentUser.value.street == 'false'?'--':controller.currentUser.value.street,
                      ),
                      AccountWidget(
                        icon: FontAwesomeIcons.male,
                        text: Text('Sexe'),
                        value: controller.currentUser.value.sex=='male'?"Male":"Female",
                      ),

                      Card(
                          elevation: 10,
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: AccountLinkWidget(
                                icon: Icon(FontAwesomeIcons.userEdit, color: Get.theme.colorScheme.secondary),
                                text: Text("Edit Profile".tr),
                                onTap: (e) {
                                  Get.toNamed(Routes.PROFILE);
                                },
                              ))
                      ),
                    ],
                    initiallyExpanded: false,
                  )
              ),*/
              SizedBox(height: 10),
              Obx(() => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: controller.currentState.value == 0 ? buildProfile(context) :
                controller.currentState.value == 1 ? buildAttachment(context) :
                buildSettings(context),
              ))
            ],
          ),
        )
    );
  }

  Widget buildProfile(BuildContext context){
    return Form(
      key: controller.profileForm,
      child: Column(
        children: [
          Obx((){
            return Column(
              children: [
                Text("Change the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                TextFieldWidget(
                  isLast: false,
                  onChanged: (input) => controller.user.value.name = input,
                  onSaved: (input) => controller.user.value.name = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  hintText: "John Doe".tr,
                  labelText: "Full Name".tr,
                  iconData: Icons.person_outline,
                  initialValue: controller.user.value.name,
                ),
                TextFieldWidget(
                    isLast: false,
                    isFirst: false,
                    validator: (input) => !input.contains('@') ? "Should be a valid email" : null,
                    hintText: "johndoe@gmail.com",
                    onChanged: (input) => controller.user.value.email = input,
                    onSaved: (input) => controller.user.value.email = input,
                    labelText: "Email".tr,
                    iconData: Icons.alternate_email,
                    initialValue: controller.user.value.email
                ),

                //Obx(() {

                controller.editNumber.value == false ?
                InkWell(
                    onTap: ()=> controller.editNumber.value == true,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      margin: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Obx(() =>
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.phone, size: 20),
                            title: Text(controller.user.value.phone,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                            ),
                            trailing: TextButton(
                              onPressed: ((){
                                controller.editNumber.value = true;
                              }),
                              child: Text('Edit...',style: Get.textTheme.bodyText1,),),
                          )
                      ),
                    )
                ) :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                          margin: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                              border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              hintText: '032655333333',
                              labelText: 'Phone Number',
                              suffixIcon: Icon(Icons.phone_android_outlined),
                            ),
                            initialCountryCode: 'BE',
                            onSaved: (phone) {
                              return controller.user.value?.phone = phone.completeNumber;
                            },
                            onChanged: (phone) {
                              String phoneNumber = phone.completeNumber;
                              controller.user.value?.phone = phoneNumber;
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: ()=> controller.editNumber.value = false,
                            child: Text('Cancel', style: TextStyle(color: specialColor)))
                      ],
                    ),

                InkWell(
                    onTap: (){
                      controller.chooseBirthDate();
                      //controller.user.value.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value);
                      controller.birthDateSet.value = true;
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      margin: EdgeInsets.only(left: 5, right: 5),
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

                TextFieldWidget(
                  isLast: false,
                  isFirst: false,
                  onChanged: (input) => controller.user.value.birthplace = input,
                  onSaved: (input) => controller.user.value.birthplace = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  hintText: "123 Street, City 136, State, Country".tr,
                  labelText: "Place of birth".tr,
                  iconData: Icons.location_on_rounded,
                  initialValue: controller.user.value.birthplace,
                ),

                TextFieldWidget(
                  isLast: false,
                  isFirst: false,
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
                        value: controller.user.value.sex=="male"?controller.selectedGender.value=controller.genderList[0]:controller.selectedGender.value=controller.genderList[1],
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

                        },).marginOnly(left: 20, right: 20).paddingOnly( top: 20, bottom: 14),
                    )
                ).paddingOnly(left: 20, right: 20, top: 20, bottom: 14,
                ),
              ],
            );
          }),

          UpdatePasswordWidget(),
          DeleteAccountWidget(),
        ],
      ),
    );
  }

  Widget buildAttachment(BuildContext context){
    return Column(
      children: [

      ],
    );
  }

  Widget buildSettings(BuildContext context){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: Ui.getBoxDecoration(),
          child: AccountLinkWidget(
            icon: Icon(Icons.qr_code, color: Get.theme.colorScheme.secondary),
            text: Text("Validate Transaction".tr),
            onTap: (e) {
              Get.offNamed(Routes.VALIDATE_TRANSACTION);
              //Get.find<RootController>().changePage(2);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            children: [
              AccountLinkWidget(
                icon: Icon(Icons.translate_outlined, color: Get.theme.colorScheme.secondary),
                text: Text("Languages".tr),
                onTap: (e) {
                  Get.toNamed(Routes.SETTINGS_LANGUAGE);
                },
              ),
              AccountLinkWidget(
                icon: Icon(Icons.brightness_6_outlined, color: Get.theme.colorScheme.secondary),
                text: Text("Theme Mode".tr),
                onTap: (e) {
                  Get.toNamed(Routes.SETTINGS_THEME_MODE);
                },
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            children: [
              AccountLinkWidget(
                icon: Icon(Icons.support_outlined, color: Get.theme.colorScheme.secondary),
                text: Text("Help & FAQ".tr),
                onTap: (e) {
                  Get.toNamed(Routes.HELP);
                },
              ),
              AccountLinkWidget(
                icon: Icon(Icons.logout, color: Get.theme.colorScheme.secondary),
                text: Text("Logout".tr),
                onTap: (e) async {
                  showDialog(context: context,
                      builder: (_)=> PopUpWidget(
                        title: "Do you really want to quit?",
                        cancel: 'Cancel',
                        confirm: 'Log Out',
                        onTap: ()async{
                          final box = GetStorage();
                          await Get.find<MyAuthService>().removeCurrentUser();
                          Get.find<RootController>().changePage(0);
                          box.remove("session_id");
                          Navigator.pop(context);
                        }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: inactive),
                      ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

}
