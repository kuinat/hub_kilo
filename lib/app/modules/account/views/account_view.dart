import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../validate_transaction/controller/validation_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountView extends GetView<AccountController> {

  @override
  Widget build(BuildContext context) {
    //var _currentUser = Get.find<MyAuthService>().myUser;
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor:Get.theme.colorScheme.secondary ,
          appBar: AppBar(
            leading: null,
            title: Text(
              AppLocalizations.of(context).account.tr,
              style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
            ),
            centerTitle: true,
            backgroundColor: Get.theme.colorScheme.secondary,
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: ()async{
              controller.onRefresh();

            },
            child: Container(

              decoration: BoxDecoration(color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)), ),
              child: ListView(
                primary: true,

                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                          onTap: ()=> showDialog(
                              context: context, builder: (_){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                    child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: FadeInImage(
                                    width: Get.width,
                                    height: Get.height/2,
                                    fit: BoxFit.cover,
                                    image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.currentUser.value.id}/image_1920?unique=true&file_response=true',
                                        headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/téléchargement (3).png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fitWidth);
                                    },
                                  ),
                                )
                              ],
                            );
                          }),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Obx(() => CircleAvatar(
                                backgroundColor: background,
                                radius: 50,
                                backgroundImage: Domain.googleUser && controller.currentUser.value.image == 'false' ? NetworkImage(Domain.googleImage)
                                    : controller.currentUser.value.image != 'false' ?
                                NetworkImage('${Domain.serverPort}/image/res.partner/${controller.currentUser.value.id}/image_1920?unique=true&file_response=true',
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
                            )),
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(Get.find<MyAuthService>().myUser.value.name!=null?Get.find<MyAuthService>().myUser.value.name:'', style: Get.textTheme.headline6.merge(TextStyle(fontSize: 18, color: appColor))),
                                  SizedBox(width: 10),
                                  controller.isConform.value ?
                                  Image.asset("assets/img/verified.png", width: 20, height: 20,) : Image.asset('assets/img/warning-comic-sign.png', height: 20, width: 20)
                                ]
                              ),
                              RatingBarIndicator(
                                rating: controller.userRatings.value,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ]
                        ))
                      )
                    ]
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: buildSettings(context),
                  )
                ]
              ),
            )
          )
      ),
    );
  }

  Widget buildSettings(BuildContext context){

    Get.lazyPut(()=>ValidationController());

    return Column(
      children: [

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: Ui.getBoxDecoration(),
          child: Obx(() => Column(
            children: [
              AccountLinkWidget(
                  icon: Icon(Icons.person, color: buttonColor),
                  text: Text(AppLocalizations.of(context).profile.tr, style: TextStyle(color: buttonColor)),
                  onTap: (e) {
                    Get.bottomSheet(
                      buildProfile(context),
                      isScrollControlled: true,
                    );
                  }
              ),
              AccountLinkWidget(
                  icon: Icon(Icons.delivery_dining, color: buttonColor),
                  text: Text(AppLocalizations.of(context).confirmDelivery.tr, style: TextStyle(color: buttonColor)),
                  onTap: (e) {
                    Get.find<ValidationController>().initValues();
                    Get.toNamed(Routes.VALIDATE_TRANSACTION);
                    //Get.find<RootController>().changePage(2);
                  }
              ),
              AccountLinkWidget(
                  icon: Icon(FontAwesomeIcons.fileUpload, color: buttonColor),
                  text: Text(AppLocalizations.of(context).attachmentFiles.tr, style: TextStyle(color: buttonColor)),
                  onTap: (e) async{
                    Get.toNamed(Routes.IDENTITY_FILES);
                    //Get.find<RootController>().changePage(2);
                  }
              ),
              if(controller.userRatings.value != 0.0)
                AccountLinkWidget(
                  icon: Icon(FontAwesomeIcons.thumbsUp, color: buttonColor),
                  text: Text(AppLocalizations.of(context).viewRatings.tr, style: TextStyle(color: buttonColor)),
                  onTap: (e) async{
                    Get.toNamed(Routes.RATING_LIST);
                    //Get.find<RootController>().changePage(2);
                  },
                )
            ],
          )
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            children: [
              AccountLinkWidget(
                icon: Icon(Icons.translate_outlined, color: buttonColor),
                text: Text(AppLocalizations.of(context).language.tr, style: TextStyle(color: buttonColor)),
                onTap: (e) {
                  Get.toNamed(Routes.SETTINGS_LANGUAGE);
                  //Get.showSnackbar(Ui.notificationSnackBar(message: "Languages are momentarily unavailable!"));
                }
              ),
              AccountLinkWidget(
                icon: Icon(Icons.brightness_6_outlined, color: buttonColor),
                text: Text(AppLocalizations.of(context).themeMode.tr, style: TextStyle(color: buttonColor)),
                onTap: (e) {
                  Get.toNamed(Routes.SETTINGS_THEME_MODE);
                },
              ),
              Obx(() => SwitchListTile( //switch at right side of label
                  value: controller.enableNotification.value,
                  onChanged: (bool value){

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context).loadingData),
                      duration: Duration(seconds: 3),
                    ));

                    print(Domain.deviceToken);
                    if(controller.enableNotification.value){
                      controller.getDeviceTokens();
                    }else{
                      controller.enableNotify();
                    }

                  },//luggageSelected
                  title: Text(AppLocalizations.of(context).enableNotifications, style: TextStyle(color: buttonColor))
              )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            children: [
              /*AccountLinkWidget(
                icon: Icon(Icons.support_outlined, color: buttonColor),
                text: Text(AppLocalizations.of(context).helpFaq.tr, style: TextStyle(color: buttonColor)),
                onTap: (e) {
                  Get.toNamed(Routes.HELP);
                }
              ),*/
              AccountLinkWidget(
                icon: Icon(Icons.help_outline, color: buttonColor),
                text: Text(AppLocalizations.of(context).signalIssue.tr, style: TextStyle(color: buttonColor)),
                onTap: (e) async {
                  Get.toNamed(Routes.INCIDENTS_VIEW);
                },
              ),
              AccountLinkWidget(
                icon: Icon(Icons.logout,color: specialColor,),
                text: Text(AppLocalizations.of(context).logOut, style: TextStyle(color: specialColor)),
                onTap: (e) async {
                  showDialog(
                      context: context,
                      builder: (_)=>  PopUpWidget(
                        title: "Do you really want to quit?",
                        cancel: AppLocalizations.of(context).cancel,
                        confirm: AppLocalizations.of(context).logOut,
                        onTap: ()async{

                          Domain.googleUser = false;
                          await Get.find<MyAuthService>().removeCurrentUser();
                          //Scaffold.of(context).closeDrawer();
                          Navigator.of(context).pop();

                          Get.toNamed(Routes.LOGIN);

                        }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: inactive),
                      ));
                },
              ),
              AccountLinkWidget(
                icon: Icon(FontAwesomeIcons.trashCan, color: specialColor,),
                text: Text(AppLocalizations.of(context).deleteAccount, style: TextStyle(color: specialColor)),
                onTap: (e) async {
                  showDialog(
                      context: context,
                      builder: (_)=>  PopUpWidget(
                        title: AppLocalizations.of(context).wantToDeleteAccount,
                        cancel: AppLocalizations.of(context).cancel,
                        confirm: AppLocalizations.of(context).delete,
                        onTap: ()async{

                          Domain.googleUser = false;
                          await controller.deleteUserAccount(controller.currentUser.value.id, controller.currentUser.value.userId);
                          //Scaffold.of(context).closeDrawer();
                          Navigator.of(context).pop();

                          Get.offNamed(Routes.LOGIN);

                        }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: inactive),
                      ));
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProfile(BuildContext context){
    return Container(
      padding: EdgeInsets.all(20),
      height: Get.height/1.2,
      decoration: BoxDecoration(
          color: background,
          //Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
          ]
      ),
      child: Form(
        key: controller.profileForm,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx((){
                return Column(
                  children: [
                    Text(AppLocalizations.of(context).updateProfileInstruction.tr, style: Get.textTheme.headline2.merge(TextStyle(color: appColor, fontSize: 15))).paddingSymmetric(horizontal: 22, vertical: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if(controller.edit.value){
                              controller.editing.value = true;
                              if(controller.birthDate.value.toString().contains('-')){
                                controller.user.value.birthday = controller.birthDate.value;

                              }
                              controller.updateProfile();
                              //controller.saveProfileForm();
                              controller.buttonPressed.value = !controller.buttonPressed.value;
                            }else{
                              controller.edit.value = true;
                            }
                            //_showDeleteDialog(context);
                          },
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: controller.edit.value ? validateColor : Colors.black,
                          child: controller.editing.value ?
                          SizedBox(height: 20,
                              child: SpinKitThreeBounce(color: Colors.white, size: 20)) :
                          Text(controller.edit.value ? AppLocalizations.of(context).saveChanges.tr : AppLocalizations.of(context).editProfile.tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
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
                            child: Text(AppLocalizations.of(context).cancel.tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
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
                      validator: (input) => input.length < 3 ? AppLocalizations.of(context).validatorError.tr : null,
                      hintText: "John Doe".tr,
                      labelText: AppLocalizations.of(context).fullName.tr,
                      iconData: Icons.person_outline,
                      initialValue: controller.user.value.name,
                    ),
                    TextFieldWidget(
                        isLast: false,
                        isFirst: false,
                        readOnly: !controller.edit.value,
                        validator: (input) => !input.contains('@') ? AppLocalizations.of(context).validEmailError : null,
                        hintText: "johndoe@gmail.com",
                        onChanged: (input) => controller.user.value.email = input,
                        onSaved: (input) => controller.user.value.email = input,
                        labelText: AppLocalizations.of(context).emailAddress.tr,
                        iconData: Icons.alternate_email,
                        initialValue: controller.user.value.email
                    ),

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
                                title: Text(controller.user.value.phone == null?'':controller.user.value.phone,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                                ),
                                trailing: controller.edit.value ?TextButton(
                                    onPressed: ((){
                                      controller.editNumber.value = true;
                                    }),
                                    child: Text(AppLocalizations.of(context).edit,style: Get.textTheme.bodyText1)) : null,
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
                              labelText: AppLocalizations.of(context).phoneNumber,
                              suffixIcon: Icon(Icons.phone_android_outlined),
                            ),
                            initialCountryCode: 'BE',
                            onSaved: (phone) {
                              return controller.user.value.phone = phone.completeNumber;
                            },
                            onChanged: (phone) {
                              String phoneNumber = phone.completeNumber;
                              controller.user.value.phone = phoneNumber;
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: ()=> controller.editNumber.value = false,
                            child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: specialColor)))
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
                              Text(AppLocalizations.of(context).placeBirth.tr,
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
                                  Text(AppLocalizations.of(context).cityBirth,
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
                                child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: specialColor))),
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
                                  title: Text(AppLocalizations.of(context).placeBirth,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black))),
                                  leading: FaIcon(FontAwesomeIcons.locationPin, size: 20),
                                  subtitle: Text(controller.user.value.birthplace==null?'':controller.user.value.birthplace,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                                  ),
                                  trailing: TextButton(
                                    onPressed: ((){
                                      controller.editPlaceOfBirth.value = true;
                                    }),
                                    child: Text(AppLocalizations.of(context).edit, style: Get.textTheme.bodyText1,),),
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
                                Text(AppLocalizations.of(context).residentialAddress,
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
                                              Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).residentialAddressNotSelectedError.tr));
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
                              child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: specialColor))),
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
                                title: Text(AppLocalizations.of(context).residentialAddress,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black))),
                                leading: FaIcon(FontAwesomeIcons.locationPin, size: 20),
                                subtitle: Text(controller.user.value.street==null?'':controller.user.value.street,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                                ),
                                trailing: TextButton(
                                  onPressed: ((){
                                    controller.editResidentialAddress.value = true;
                                  }),
                                  child: Text(AppLocalizations.of(context).edit,style: Get.textTheme.bodyText1,),),
                              )
                          ),
                        )

                    ),
                    if(controller.predict2.value)
                      Obx(() => Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 5, right: 5),
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
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                            onSaved: (input) => (controller.selectedGender.value == "Male"||controller.selectedGender.value == "Homme")?controller.user?.value?.sex = "male":controller.user?.value?.sex = "female",
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
                              if(controller.selectedGender.value == "Male"||controller.selectedGender.value == "Homme"){
                                controller.user.value.sex = "male";
                              }
                              else{
                                controller.user.value.sex = "female";
                              }

                            },).marginOnly(left: 20, right: 20).paddingOnly( top: 20, bottom: 14),
                        )
                    ).paddingOnly(bottom: 14,
                    ).paddingOnly(bottom: 14,
                    ),
                  ],
                );
              }),

              SizedBox(height: 20),
              /*Container(
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
                        showDialog(context: context,
                            builder: (_){
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: buildPassword(context)
                              );
                            });
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
              ),*/

            ],
          )
        ),
      ),
    );
  }

  Widget buildPassword(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: Get.height/2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [

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

            Align(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: () async{
                  var value = await controller.verifyOldPassword(controller.user.value.email, controller.newPassword.value);
                  if(value){
                    controller.updateUserPassword(controller.newPassword.value);
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary,
                child: Text(AppLocalizations.of(context).confirm.tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                elevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
              ),
            )
        ],),
      ),
    );
  }

  Widget buildLoader() {
    return Container(
        width: Get.width,
        height: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }
}


