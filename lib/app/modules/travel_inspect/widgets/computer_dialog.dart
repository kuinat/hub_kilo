import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/computer_model.dart';
import '../../../models/envelop_model.dart';
import '../../../models/kilos_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/travel_inspect_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComputerDialog extends GetView<TravelInspectController> {
  var editing = false;
  var luggage;
  ComputerDialog({Key key,this.editing, this.luggage}) ;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TravelInspectController());

    return Card(
      margin: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: (){
              controller.computerChecked.value = !controller.computerChecked.value;
              Navigator.of(context).pop();
            }, icon: Icon(FontAwesomeIcons.remove), color: Colors.red,),
          ),
          TextFieldWidget(
            isLast: false,
            readOnly: false,
            initialValue: controller.computerWeight.value.toString(),
            onChanged: (input) => controller.computerWeight.value = double.parse(input),
            hintText: "0.05 kg".tr,
            labelText: 'Weight of Computers you want to ship'.tr,
            iconData: Icons.production_quantity_limits,
          ),

          TextFieldWidget(
            isLast: false,
            readOnly: false,
            initialValue: controller.computerWidth.value.toString(),
            onChanged: (input) => controller.computerWidth.value = double.parse(input),
            hintText: "10 \$".tr,
            labelText: 'Width of your Computer'.tr,
            iconData: Icons.production_quantity_limits,
          ),

          TextFieldWidget(
            isLast: false,
            readOnly: false,
            initialValue: controller.computerHeight.value.toString(),
            onChanged: (input) => controller.computerHeight.value = double.parse(input),
            hintText: "10 \$".tr,
            labelText: 'Height of your Computer'.tr,
            iconData: Icons.production_quantity_limits,
          ),

          TextFieldWidget(
            isLast: false,
            readOnly: false,
            initialValue: controller.computerLength.value.toString(),
            onChanged: (input) => controller.computerLength.value = double.parse(input),
            hintText: "10 cm".tr,
            labelText: 'Length of your luggage'.tr,
            iconData: Icons.production_quantity_limits,
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
              title: Text('Size of your luggage',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black))),
              //leading: FaIcon( FontAwesomeIcons.moneyBills, size: 20),
              subtitle: Text((controller.computerHeight.value * controller.computerWidth.value * controller.computerLength.value).toString(),style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
              ),
            )),
          ),

          Column(
              children: <Widget>[
                Card(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: controller.computerDescription.value,
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          textInputAction:TextInputAction.done ,
                          maxLines: 5,
                          minLines: 2,
                          onChanged: (input) => controller.computerDescription.value = input,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context).description),
                            fillColor: Palette.background,
                            filled: true,
                            prefixIcon: Icon(Icons.description),
                            hintText: 'Small description of your computers', ),

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
                    child: Text('Input 6 Internal Image Files'.tr, style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
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
                    child: Text('Input 6 External Images'.tr, style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
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
              //if(controller.computerChecked.value){
                if (controller.computerWeight.value != 0.0 && controller.computerWidth.value != 0.0 &&
                    controller.computerHeight.value != 0.0 && controller.computerDescription.value.isNotEmpty) {
                  //if(controller.computerWeight.value<= luggage['quantity']){
                    if(controller.imageFiles.length==12){
                      controller.computerModel = ComputerModel(
                          luggageType: 'COMPUTER',
                          computerDescription: controller.computerDescription.value,
                          computerHeight: controller.computerHeight.value,
                          computerWeight: controller.computerWeight.value,
                          computerQuantity: controller.computerQuantity.value,
                          computerWidth: controller.computerWidth.value,
                          computerLength: controller.computerLength.value,
                          imageFiles: controller.imageFiles,
                          luggageId: controller.computerLuggageId.value,
                          computerPrice: controller.computerPrice,
                          luggageModelId: controller.luggageModelId.value
                      ),
                      controller.selectedPackages.add(controller.computerModel),
                      //controller.computerChecked.value = !controller.computerChecked.value,
                      controller.showAvailableLuggage.value = false,
                      Navigator.of(context).pop(),


                    }
                    else{
                      Get.showSnackbar(Ui.warningSnackBar(
                          message: 'Please you should input exactly 12 luggage Images'
                              .tr)),
                    }
                  // }
                  // else{
                  //   Get.showSnackbar(Ui.warningSnackBar(
                  //       message: 'Please input an average weight lower than ${luggage['quantity']} kg'
                  //           .tr)),
                  // }


                }
                else {
                  Get.showSnackbar(Ui.warningSnackBar(
                      message: 'Please input all details related to your computer(s)'
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
          ).paddingSymmetric(vertical: 10, horizontal: 20)
          :BlockButtonWidget(
    onPressed: ()=>{
    if (controller.computerWeight.value != 0.0 && controller.computerWidth.value != 0.0 &&
    controller.computerHeight.value != 0.0 && controller.computerDescription.value.isNotEmpty) {
    if(controller.imageFiles.length==12){
    controller.computerModel = ComputerModel(
    luggageType: 'COMPUTER',
    computerDescription: controller.computerDescription.value,
    computerHeight: controller.computerHeight.value,
    computerWeight: controller.computerWeight.value,
    computerQuantity: controller.computerQuantity.value,
    computerWidth: controller.computerWidth.value,
        computerLength: controller.computerLength.value,
    imageFiles: controller.imageFiles,
    luggageId: luggage['id'],
      computerPrice: controller.computerPrice,
        luggageModelId: luggage['luggage_type_id'][0]
    ),
    controller.airShippingLuggageToEdit.add(controller.computerModel),
    //controller.computerChecked.value = !controller.computerChecked.value,
    controller.showAvailableLuggage.value = false,
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
    message: 'Please input all details related to your computer(s)'
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