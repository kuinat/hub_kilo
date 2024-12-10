
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../controller/signal_incident_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import '../../global_widgets/text_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignalIncidentForm extends GetView<SignalIncidentController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 0,
          title:  Text(
            'Signal Incident'.tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        bottomSheet: SizedBox(
          height: 80,
            child: Center(
                child: InkWell(
                    onTap: () async{

                      if(controller.ticketTypeId.value == 1000000){
                        Get.showSnackbar(Ui.warningSnackBar(message: "Please select a ticket type".tr));
                      }
                      else if (controller.subject.value == ''){
                        Get.showSnackbar(Ui.warningSnackBar(message: "Please enter a subject".tr));
                      }
                      else{
                        controller.buttonPressed.value = true;
                        await controller.createTicket();
                      }



                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),

                        width: Get.width/2,
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Center(
                            child: Obx(() =>  !controller.buttonPressed.value ?
                            Text('Create Ticket'.tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.white)))
                                : SizedBox(height: 20,
                                child: SpinKitThreeBounce(color: Colors.white, size: 20))
                            )
                        )
                    )
                )
            ).paddingSymmetric(horizontal: 20, )
        ),
        body: Obx(() => Theme(
          data: ThemeData(
            //canvasColor: Colors.yellow,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Get.theme.colorScheme.secondary,
                background: Colors.red,
                secondary: validateColor,
              )
          ),
          child: Container(
            decoration: BoxDecoration(color: backgroundColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)), ),
            child: Scrollbar(
              child: ListView(

                children: [
                  Obx(() => Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                        border: Border.all(color: controller.errorTicket.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Select ticket type',
                            style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 10),
                          Row(
                              children: [
                                Icon(Icons.contact_emergency_rounded),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: TextFormField(
                                    controller: controller.ticketType,
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
                                    style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                    onChanged: (value)=>{
                                      if(value.isNotEmpty){
                                        controller.errorTicket.value = false
                                      },
                                      if(value.length > 2){
                                        controller.predict1.value = true,
                                        controller.filterSearchTicketTypes(value)
                                      }else{
                                        controller.predict1.value = false,
                                      }
                                    },
                                    cursorColor: Get.theme.focusColor,
                                  ),
                                ),
                                SizedBox(width: Get.width/6,),
                                Align(
                                  //alignment: Alignment,
                                  child: GestureDetector(
                                      onTap: (){
                                        controller.predict1.value = !controller.predict1.value;
                                      },
                                      child: Icon(Icons.arrow_drop_down_sharp)),
                                ),

                              ]
                          )
                        ]
                    ),
                  )),
                  if(controller.predict1.value)
                    Obx(() => Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        color: Get.theme.primaryColor,
                        height: 120,
                        child: ListView(
                            children: [
                              for(var i =0; i < controller.ticketTypeList.length; i++)...[
                                TextButton(
                                    onPressed: (){
                                      controller.ticketType.text = controller.ticketTypeList[i]['display_name'];
                                      controller.predict1.value = false;
                                      controller.ticketTypeId.value = controller.ticketTypeList[i]['id'];
                                    },
                                    child: Text(controller.ticketTypeList[i]['display_name'], style: TextStyle(color: appColor))
                                )
                              ]
                            ]
                        )
                    )),

                  TextFieldWidget(
                    isLast: false,
                    readOnly: false,
                    onChanged: (input) => controller.subject.value = input,
                    onSaved: (input) => controller.subject.value = input,
                    validator: (input) => input.length < 3 ? AppLocalizations.of(context).validatorError.tr : null,
                    hintText: "Incident Title".tr,
                    labelText: 'Subject'.tr,
                    iconData: Icons.short_text,
                  ),

                  TextFieldWidget(
                    isLast: false,
                    readOnly: true,
                    initialValue: controller.currentUser.value.name,
                    validator: (input) => input.length < 3 ? AppLocalizations.of(context).validatorError.tr : null,
                    labelText: 'Customer'.tr,
                    iconData: Icons.person,
                  ),
                  TextFieldWidget(
                    isLast: false,
                    readOnly: true,
                    initialValue: controller.currentUser.value.email,
                    validator: (input) => input.length < 3 ? AppLocalizations.of(context).validatorError.tr : null,
                    hintText: "Notifications not received".tr,
                    labelText: 'Email'.tr,
                    iconData: Icons.mail,
                  ),

                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Priority', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),),
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(3, (index) {
                                return InkWell(
                                  onTap: () {
                                    controller.priority.value = (index + 1).toInt();
                                  },
                                  child: index < controller.priority.value
                                      ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                                      : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D)),
                                );
                              }),
                            );
                          }),
                        ],
                      ),
                    ),
                  ). marginOnly(bottom: 5, top: 20),

                  Column(
                      children: <Widget>[
                        Card(
                          elevation: 0,
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 100,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                    cursorColor: Colors.black,
                                    textInputAction:TextInputAction.done ,
                                    maxLines: 5,
                                    minLines: 2,
                                    onChanged: (input) => controller.description.value = input,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      label: Text(AppLocalizations.of(context).description),
                                      fillColor: Palette.background,
                                      enabledBorder: InputBorder.none,
                                      //filled: true,
                                      prefixIcon: Icon(Icons.description),
                                      hintText: 'Small description of your problem', ),

                                  ),
                                )
                            )
                        )
                      ]
                  ).marginOnly(top: 20, bottom: 5),

                  Obx(() => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Align(
                          child: Text('Input Images related to your incident'.tr, style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
                          alignment: Alignment.topLeft,
                        ),
                        SizedBox(height: 10),
                        controller.ticketFiles.length <= 0 ? GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: Get.context,
                                  builder: (_){
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      content: Container(
                                          height: 140,
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: ()async{
                                                    await controller.pickImage(ImageSource.camera);
                                                    Navigator.pop(Get.context);
                                                  },
                                                  leading: Icon(FontAwesomeIcons.camera),
                                                  title: Text(AppLocalizations.of(context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                ),
                                                ListTile(
                                                  onTap: ()async{
                                                    await controller.pickImage(ImageSource.gallery);
                                                    Navigator.pop(Get.context);
                                                  },
                                                  leading: Icon(FontAwesomeIcons.image),
                                                  title: Text(AppLocalizations.of(context).uploadImage, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                )
                                              ]
                                          )
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: ()=> Navigator.pop(context),
                                            child: Text(AppLocalizations.of(context).cancel, style: Get.textTheme.headline4.merge(TextStyle(color: inactive)),))
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              padding: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                            )
                        )
                            : Column(
                          children: [
                            SizedBox(
                              height:Get.width/2,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.all(12),
                                  itemBuilder: (context, index){
                                    return Stack(
                                      //mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              child: Image.file(
                                                controller.ticketFiles[index],
                                                fit: BoxFit.cover,
                                                width: Get.width/2,
                                                height:Get.width/2,
                                              ),
                                            )
                                        ),
                                        Positioned(
                                          top:0,
                                          right:0,
                                          child: Align(
                                            //alignment: Alignment.centerRight,
                                            child: IconButton(
                                                onPressed: (){

                                                  controller.ticketFiles.removeAt(index);

                                                },
                                                icon: Icon(Icons.delete, color: inactive, size: 25, )
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index){
                                    return SizedBox(width: 8);
                                  },
                                  itemCount: controller.ticketFiles.length),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                  child: InkWell(
                                    onTap: (){
                                      showDialog(
                                          context: Get.context,
                                          builder: (_){
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                              ),
                                              content: Container(
                                                  height: 140,
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        onTap: ()async{
                                                          await controller.pickImage(ImageSource.camera);
                                                          Navigator.pop(Get.context);
                                                        },
                                                        leading: Icon(FontAwesomeIcons.camera),
                                                        title: Text(AppLocalizations.of(context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                      ),
                                                      ListTile(
                                                        onTap: ()async{
                                                          await controller.pickImage(ImageSource.gallery);
                                                          Navigator.pop(Get.context);
                                                        },
                                                        leading: Icon(FontAwesomeIcons.image),
                                                        title: Text(AppLocalizations.of(context).uploadImage, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                      )
                                                    ],
                                                  )
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: ()=> Navigator.pop(context),
                                                    child: Text(AppLocalizations.of(context).cancel, style: Get.textTheme.headline4.merge(TextStyle(color: inactive)),))
                                              ],
                                            );
                                          });
                                    },
                                    child: Icon(FontAwesomeIcons.circlePlus),
                                  )
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),).marginOnly(top: 10, bottom: 100),


                ],
              ),
            ),
          ),
        ))
    );
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
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
