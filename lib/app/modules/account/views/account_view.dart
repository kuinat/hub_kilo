import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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
              SizedBox(height: 10),
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: background,
                            radius: 50,
                            backgroundImage: controller.currentUser.value.image != 'false' ? NetworkImage('${Domain.serverPort}/image/res.partner/${controller.currentUser.value.id}/image_1920?unique=true&file_response=true',


                                headers: Domain.getTokenHeaders()) : AssetImage("assets/img/téléchargement (2).png"),
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
                                          color: Colors.grey.shade300,
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
              SizedBox(height: 10),
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
                          //color: controller.currentState == 2 ? background : null,
                            border: controller.currentState == 1 ? Border(
                                bottom: BorderSide(width: 4, color: interfaceColor)
                            ): null
                        ),
                        child: Text("Attachment", style: context.textTheme.headline4,),
                      ),
                    ),
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

              SizedBox(height: 10),
              Obx(() => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: controller.currentState.value == 0 ? buildProfile(context) :
                controller.currentState.value == 1 ? buildAttachments(context) :
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        if(controller.edit.value){
                          if(controller.birthDate.value.toString().contains('-')){
                            controller.user.value.birthday = controller.birthDate.value;
                            controller.updateProfile();
                            //controller.updateProfile();
                          }
                          //controller.saveProfileForm();
                          controller.buttonPressed.value = !controller.buttonPressed.value;
                        }else{
                          controller.edit.value = true;
                        }
                        //_showDeleteDialog(context);
                      },
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: controller.edit.value ? validateColor : inactive,
                      child: Text(controller.edit.value ? "Save changes".tr : "Edit profile".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                      elevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                    ),
                    SizedBox(width: 10),
                    if(controller.edit.value)
                      MaterialButton(
                        onPressed: () {
                          controller.edit.value = false;
                          //_showDeleteDialog(context);
                        },
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: specialColor,
                        child: Text("Cancel".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                        elevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                      )
                  ],
                ),
                TextFieldWidget(
                  isLast: false,
                  readOnly: !controller.edit.value,
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
                    readOnly: !controller.edit.value,
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
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
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
                            trailing: controller.edit.value ?TextButton(
                              onPressed: ((){
                                controller.editNumber.value = true;
                              }),
                              child: Text('Edit...',style: Get.textTheme.bodyText1)) : null,
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
                            style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                            textAlign: TextAlign.start,
                          ),
                          Obx(() {
                            return ListTile(
                                leading: FaIcon(
                                    FontAwesomeIcons.birthdayCake, size: 20),
                                title: Text(controller.birthDate.value.toString(),
                                  style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                                ));
                          })
                        ],
                      ),
                    )
                ),
                Obx(() {
                     return controller.editPlaceOfBirth.value?
                         Column(
                           children: [
                             Container(
                               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                               margin: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                               decoration: BoxDecoration(
                                   color: Get.theme.primaryColor,
                                   borderRadius: BorderRadius.all(Radius.circular(10)),
                                   boxShadow: [
                                     BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                                   ],
                                   border: Border.all(color: controller.errorCity1.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                               child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.stretch,
                                   children: [
                                     Text("City of Birth",
                                       style: Get.textTheme.bodyText1,
                                       textAlign: TextAlign.start,
                                     ),
                                     SizedBox(height: 10),
                                     Row(
                                         children: [
                                           Icon(Icons.location_pin),
                                           SizedBox(width: 10),
                                           SizedBox(
                                             width: MediaQuery.of(context).size.width/2,
                                             child: TextFormField(
                                               controller: controller.depTown,
                                               decoration: InputDecoration(
                                                 border: InputBorder.none,
                                                 focusedBorder: InputBorder.none,
                                                 enabledBorder: InputBorder.none,
                                                 errorBorder: InputBorder.none,
                                                 disabledBorder: InputBorder.none,
                                                 contentPadding:
                                                 EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                               ),
                                               //initialValue: controller.travelCard.isEmpty || controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                                               style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
                                               onChanged: (value)=>{
                                                 if(value.isNotEmpty){
                                                   controller.errorCity1.value = false
                                                 },
                                                 if(value.length > 2){
                                                   controller.predict1.value = true,
                                                   controller.filterSearchResults(value)
                                                 }else{
                                                   controller.predict1.value = false,
                                                 }
                                               },
                                               cursorColor: Get.theme.focusColor,
                                             ),
                                           ),
                                         ]
                                     )
                                   ]
                               ),
                             ),

                             Align(
                               alignment: Alignment.centerRight,
                               child: TextButton(
                                   onPressed: ()=> controller.editPlaceOfBirth.value = false,
                                   child: Text('Cancel', style: TextStyle(color: specialColor))),
                             )
                           ],
                         )
                     :
                  InkWell(
                      onTap: ()=> controller.editPlaceOfBirth.value == true,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
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
                              title: Text('Place of birth',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black))),
                              leading: FaIcon(FontAwesomeIcons.locationPin, size: 20),
                              subtitle: Text(controller.user.value.birthplace,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                              ),
                              trailing: TextButton(
                                onPressed: ((){
                                  controller.editPlaceOfBirth.value = true;
                                }),
                                child: Text('Edit...',style: Get.textTheme.bodyText1,),),
                            )
                        ),
                      )
                  )
                  ;}),
                if(controller.predict1.value)
                  Obx(() => Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                      color: Get.theme.primaryColor,
                      height: 200,
                      child: ListView(
                          children: [
                            for(var i =0; i < controller.countries.length; i++)...[
                              TextButton(
                                  onPressed: (){
                                    controller.depTown.text = controller.countries[i]['display_name'];
                                    controller.predict1.value = false;
                                    controller.birthCityId.value = controller.countries[i]['id'];
                                  },
                                  child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                              )
                            ]
                          ]
                      )
                  )),
                controller.editResidentialAddress.value?
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          margin: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
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
                                Text("Residential Address",
                                  style: Get.textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 10),
                                Row(
                                    children: [
                                      Icon(Icons.location_pin),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: TextFormField(
                                          controller: controller.arrTown,
                                          readOnly: controller.birthCityId.value != 0 ? false : true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding:
                                            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                          ),
                                          onTap: (){
                                            if(controller.birthCityId.value == 0){
                                              controller.errorCity1.value = true;
                                              Get.showSnackbar(Ui.warningSnackBar(message: "Please, first select a departure city!!! ".tr));
                                            }
                                          },
                                          //initialValue: controller.travelCard.isEmpty || controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                                          style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
                                          onChanged: (value)=>{
                                            if(value.length > 2){
                                              controller.predict2.value = true,
                                              controller.filterSearchResults(value)
                                            }else{
                                              controller.predict2.value = false,
                                            }
                                          },
                                          cursorColor: Get.theme.focusColor,
                                        ),
                                      ),
                                    ]
                                )
                              ]
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: ()=> controller.editResidentialAddress.value = false,
                              child: Text('Cancel', style: TextStyle(color: specialColor))),
                        )
                      ],
                    )
                :
                InkWell(
                    onTap: ()=> controller.editResidentialAddress.value == true,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
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
                            title: Text('Residential address',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black))),
                            leading: FaIcon(FontAwesomeIcons.locationPin, size: 20),
                            subtitle: Text(controller.user.value.street,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                            ),
                            trailing: TextButton(
                              onPressed: ((){
                                controller.editResidentialAddress.value = true;
                              }),
                              child: Text('Edit...',style: Get.textTheme.bodyText1,),),
                          )
                      ),
                    )

                ),
                if(controller.predict2.value)
                  Obx(() => Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                      color: Get.theme.primaryColor,
                      height: 200,
                      child: ListView(
                          children: [
                            for(var i =0; i < controller.countries.length; i++)...[
                              TextButton(
                                  onPressed: (){
                                    controller.arrTown.text = controller.countries[i]['display_name'];
                                    controller.predict2.value = false;
                                    controller.residentialAddressId.value = controller.countries[i]['id'];
                                  },
                                  child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                              )
                            ]
                          ]
                      )
                  )),

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

          SizedBox(height: 20,),

          Container(
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

                MaterialButton(
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
                  ),

              ],
            ),
          ),

          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   decoration: Ui.getBoxDecoration(),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text("Delete your account!", style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.redAccent))),
          //             Text("Once you delete this account, there is no going back. Please be certain.", style: Get.textTheme.caption.merge(TextStyle(color: Colors.redAccent))),
          //           ],
          //         ),
          //       ),
          //       SizedBox(width: 10),
          //       MaterialButton(
          //           onPressed: () {
          //             _showDeleteDialog(context);
          //           },
          //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //           color: Colors.redAccent,
          //           child: Text("Delete".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
          //           elevation: 0,
          //           highlightElevation: 0,
          //           hoverElevation: 0,
          //           focusElevation: 0,
          //         ),
          //     ],
          //   ),
          // ),

        ],
      ),
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
              readOnly: false,
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
              readOnly: false,
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
              readOnly: false,
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


  Widget buildAttachments(BuildContext context){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            children: [
              AccountLinkWidget(
                icon: Icon(FontAwesomeIcons.fileUpload, color: Get.theme.colorScheme.secondary),
                text: Text("Upload identity files".tr),
                onTap: (e) {
                  Get.toNamed(Routes.IDENTITY_FILES);
                  //Get.offNamed(Routes.IDENTITY_FILES);
                  //Get.find<RootController>().changePage(2);
                },
              ),

              // CircleAvatar(
              //     backgroundColor: background,
              //     radius: 50,
              //     backgroundImage: controller.currentUser.value.image != 'false' ? NetworkImage('${Domain.serverPort}/image/ir.attachment/${controller.currentUser.value.id}/datas?unique=true&file_response=true',
              //
              //         headers: Domain.getTokenHeaders()) : AssetImage("assets/img/téléchargement (2).png"),
              //
              // )

            ],
          ),
        ),

        Container(
            width: MediaQuery.of(context).size.width*0.75,
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
                image: DecorationImage(
                fit: BoxFit.fill,
                onError: (exception, stackTrace) =>AssetImage("assets/img/téléchargement (2).png"),
                image: NetworkImage(
                  '${Domain.serverPort}/image/ir.attachment/${controller.currentUser.value.partnerAttachmentIds[0]}/datas?unique=true&file_response=true',headers: Domain.getTokenHeaders(),
                )
              //image: controller.currentUser.value.image != 'false' ? NetworkImage('${Domain.serverPort}/image/ir.attachment/${controller.currentUser.value.id}/datas?unique=true&file_response=true'): AssetImage("assets/img/téléchargement (2).png"),


            )))


      ],
    );
  }

}


