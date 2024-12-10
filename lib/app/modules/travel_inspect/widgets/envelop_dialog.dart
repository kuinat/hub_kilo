import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/envelop_model.dart';
import '../../../models/kilos_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/travel_inspect_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnvelopDialog extends GetView<TravelInspectController> {
  var editing = false;

  var luggage;

  EnvelopDialog({Key key,this.editing, this.luggage}) ;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TravelInspectController());
    return Card(
      //height: Get.height*0.9,
      margin: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: (){
              controller.enveloppeChecked.value = !controller.enveloppeChecked.value;
              Navigator.of(context).pop();
            }, icon: Icon(FontAwesomeIcons.remove), color: Colors.red,),
          ),
          Obx(() => !controller.isEnvelopLuggageModelLoaded.value?Text('Envelope Formats Loading...', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black))): Text('Select an Envelope Format...', style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)))),
          Obx(() => SizedBox(
            height: 155,
            child: !controller.isEnvelopLuggageModelLoaded.value? SpinKitThreeBounce(color: interfaceColor, size: 20,)
                :ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                primary: false,
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemCount: controller.envelopLuggageModel.length,
                itemBuilder: (_, index) {
                  if((luggage['id'] != null && luggage['id'] == controller.envelopLuggageModel[index]['id'])){
                    controller.envelopeSelectedIndex.value = index;

                  }

                  return GestureDetector(
                    onTap: (){
                      controller.envelopeSelectedIndex.value = index;
                      //controller.envelopeItemSelected.value = !controller.envelopeItemSelected.value;
                      controller.envelopLength.value = controller.envelopLuggageModel[index]['average_length'];
                      controller.envelopWidth.value = controller.envelopLuggageModel[index]['average_width'];
                      controller.envelopHeight.value = controller.envelopLuggageModel[index]['average_height'];
                      controller.envelopFormat.value = controller.envelopLuggageModel[index]['envelop_formate'];
                    },
                    child:Obx(() => Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          Container(

                              padding: EdgeInsets.all(20),
                              margin:EdgeInsets.all(10) ,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: controller.envelopeSelectedIndex.value == index ?interfaceColor:inactive, width: controller.kilosChecked.value?4:1, )),
                              child:Column(
                                  children: [
                                    Icon(Icons.mail, size: 60,),
                                    Text(controller.envelopLuggageModel[index]['envelop_formate'],
                                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                                    ),

                                  ])),
                          Visibility(
                              visible: controller.envelopeSelectedIndex.value == index,
                              child: Positioned(
                                top: 5,
                                right: 8,
                                child: Icon(FontAwesomeIcons.check, color: Colors.green,fill: 1.0,grade: 20, size: 30, weight: 10, opticalSize: 5,),
                              ))

                        ]))  ,
                  );

                }),
          )),

          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                ],
                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
            child: Obx(() => ListTile(
              title: Text('Weight of your luggage',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
              //leading: FaIcon( FontAwesomeIcons.moneyBills, size: 20),
              subtitle: Text((controller.envelopWeight.value).toString(),style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ),
            )),
          ),

          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                ],
                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
            child: Obx(() => ListTile(
              title: Text('Width of your luggage',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
              //leading: FaIcon( FontAwesomeIcons.moneyBills, size: 20),
              subtitle: Text((controller.envelopWidth.value).toString(),style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ),
            )),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                ],
                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
            child: Obx(() => ListTile(
              title: Text('Height of your luggage',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
              //leading: FaIcon( FontAwesomeIcons.moneyBills, size: 20),
              subtitle: Text((controller.envelopHeight.value).toString(),style: Get.textTheme.bodyText1.merge(TextStyle(color:Colors.grey.shade700, fontSize: 12)),
              ),
            )),
          ),

          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                ],
                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
            child: Obx(() => ListTile(
              title: Text('Length of your luggage',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
              //leading: FaIcon( FontAwesomeIcons.moneyBills, size: 20),
              subtitle: Text((controller.envelopLength.value).toString(),style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ),
            )),
          ),

          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                ],
                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
            child: Obx(() => ListTile(
              title: Text('Size of your luggage',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
              //leading: FaIcon( FontAwesomeIcons.moneyBills, size: 20),
              subtitle: Text((controller.envelopHeight.value * controller.envelopWidth.value * controller.envelopLength.value).toString(),style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ),
            )),
          ),

          Column(
              children: <Widget>[
                Card(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: controller.envelopDescription.value,
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                          cursorColor: Colors.black,
                          textInputAction:TextInputAction.done ,
                          maxLines: 5,
                          minLines: 2,
                          onChanged: (input) => controller.envelopDescription.value = input,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context).description),
                            fillColor: Palette.background,
                            filled: true,
                            prefixIcon: Icon(Icons.description),
                            hintText: 'Small description of envelop content', ),

                        )
                    )
                )
              ]
          ),


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
                    child: Text('Input 6 Internal Image Files'.tr, style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(height: 10),
                  controller.internalImageFiles.length <= 0 ? GestureDetector(
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
                                          controller.internalImageFiles[index],
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

                                            controller.internalImageFiles.removeAt(index);
                                            controller.imageFiles.removeAt(index);
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
                            itemCount: controller.internalImageFiles.length),
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
            ),),
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
                    child: Text('Input 6 External Images'.tr, style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(height: 10),
                  controller.externalImageFiles.length <= 0 ? GestureDetector(
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
                                          controller.externalImageFiles[index],
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
                                            controller.externalImageFiles.removeAt(index);
                                            controller.imageFiles.removeAt(index+6);
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
                            itemCount: controller.externalImageFiles.length),
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
            ),),
          !editing?BlockButtonWidget(
            onPressed: ()=>{

                if (controller.envelopFormat.value !='') {
                  if(controller.envelopWeight.value<=luggage['quantity']){
                    if(controller.imageFiles.length==12){
                      controller.envelopModel = EnvelopModel(
                          luggageType: 'ENVELOP',
                          envelopDescription: controller.envelopDescription.value,
                          envelopHeight: controller.envelopHeight.value,
                          envelopWeight: controller.envelopWeight.value,
                          envelopQuantity: controller.envelopQuantity.value,
                          envelopFormat: controller.envelopFormat,
                          envelopWidth: controller.envelopWidth.value,
                          envelopLength: controller.envelopLength.value,
                          imageFiles: controller.imageFiles,
                          luggageId: luggage['id'],
                          envelopPrice: controller.envelopPrice,
                          luggageModelId: luggage['luggage_type_id'][0]
                      ),
                      controller.selectedPackages.add(controller.envelopModel),
                      //controller.enveloppeChecked.value = !controller.enveloppeChecked.value,
                      controller.showAvailableLuggage.value = false,
                      Navigator.of(context).pop(),


                    }
                    else{
                      Get.showSnackbar(Ui.warningSnackBar(
                          message: 'Please you should input exactly 12 luggage Images'
                              .tr)),
                    }
                  }
                  else{
                    Get.showSnackbar(Ui.warningSnackBar(
                        message: 'Please input an average weight lower than ${luggage['quantity']} kg'
                            .tr)),
                  }


                }
                else {
                  Get.showSnackbar(Ui.warningSnackBar(
                      message: 'Please input all details related to your envelope(s)'
                          .tr)),
                }


            },
            color: Get.theme.colorScheme.secondary,
            text: true? SizedBox(
              //width: Get.width/1.5,
                child: Text(
                  'Add now'.tr,
                  style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                )
            ) : SizedBox(height: 20,
                child: SpinKitThreeBounce(color: Colors.white, size: 20)),
          ).paddingSymmetric(vertical: 10, horizontal: 20):
          BlockButtonWidget(
            onPressed: ()=>{

                print('nattttttttttttttttt'),
                if ( controller.envelopDescription.value.isNotEmpty) {
                  if(controller.imageFiles.length==12){
                    controller.envelopModel = EnvelopModel(
                        luggageType: 'ENVELOP',
                        envelopDescription: controller.envelopDescription.value,
                        envelopHeight: controller.envelopHeight.value,
                        envelopWeight: controller.envelopWeight.value,
                        envelopQuantity: controller.envelopQuantity.value,
                        envelopWidth: controller.envelopWidth.value,
                        envelopLength: controller.envelopLength.value,
                        envelopFormat: controller.envelopFormat.value,
                        imageFiles: controller.imageFiles,
                        luggageId: luggage['id'],
                        envelopPrice: controller.envelopPrice,
                        luggageModelId: controller.luggageModelId.value
                    ),
                    controller.airShippingLuggageToEdit.add(controller.envelopModel),
                    //controller.enveloppeChecked.value = !controller.enveloppeChecked.value,
                    controller.showAvailableLuggage.value = false,
                    //editing = false,
                    Navigator.of(context).pop(),




                  }
                  else{
                    Get.showSnackbar(Ui.warningSnackBar(
                        message: 'Please you should input exactly 12 luggage Images'
                            .tr)),
                  }


                }
                else {
                  Get.showSnackbar(Ui.warningSnackBar(
                      message: 'Please input all details related to your envelope(s)'
                          .tr)),
                }








            },
            color: Get.theme.colorScheme.secondary,
            text: true? SizedBox(
              //width: Get.width/1.5,
                child: Text(
                  'Update now'.tr,
                  style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                )
            ) : SizedBox(height: 20,
                child: SpinKitThreeBounce(color: Colors.white, size: 20)),
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ],),
    );

  }
}