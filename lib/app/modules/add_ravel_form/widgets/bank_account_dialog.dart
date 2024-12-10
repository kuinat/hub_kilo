import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/kilos_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controller/add_travel_controller.dart';

class BankAccountDialog extends GetView<AddTravelController> {
  var editing = false;
  var luggage;
  BankAccountDialog({Key key,this.editing, this.luggage}) ;
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AddTravelController());

    return Card(
      margin: EdgeInsets.fromLTRB(20, 20,20,Get.height*0.05),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Obx(() => ListView(
          padding: EdgeInsets.fromLTRB(20, 20,20,20),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(FontAwesomeIcons.remove)
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: controller.errorBank.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Select a bank by bank identifier code or bank name',
                          style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 10),
                        Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/2,
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  controller: controller.bankIdentifierCode,
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
                                      controller.errorBank.value = false
                                    },
                                    if(value.length > 2){
                                      controller.predictBank.value = true,
                                      controller.filterSearchBank(value)
                                    }else{
                                      controller.predictBank.value = false,
                                      controller.enableBankFields.value = false,
                                    controller.bankBic.value = '',
                                    print(controller.bankBic.value),
                                    controller.bankName.value = '',
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
              ],
            ),
            if(controller.predictBank.value )...[
              Obx(() => Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  color: Get.theme.primaryColor,
                  height:  200,
                  child: ListView(
                      children: [
                        for(var i =0; i < controller.allBanks.length; i++)...[
                          Column(
                            children:[
                              TextButton(
                                  onPressed: (){
                                    controller.bankIdentifierCode.text = controller.allBanks[i]['display_name'];
                                    controller.bankBic.value = controller.allBanks[i]['bic'];
                                    print(controller.bankBic.value);
                                    controller.bankName.value = controller.allBanks[i]['name'];
                                    controller.predictBank.value = false;
                                    controller.bankId.value = controller.allBanks[i]['id'];
                                    controller.bankSelected.value = true;
                                  },
                                  child: Text(controller.allBanks[i]['display_name'], style: TextStyle(color: appColor))
                              ),

                            ] ,
                          )
                        ],
                        TextButton(
                            onPressed: (){
                              controller.enableBankFields.value = true;
                              controller.predictBank.value = false;
                            },
                            child: Text('Add Bank', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
                        )
                      ]
                  )
              )),
            ],
            if( !controller.bankFound.value)...[
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  color: Get.theme.primaryColor,
                  height:  20,
                  child: ListView(
                      children: [
                        TextButton(
                            onPressed: (){
                              controller.enableBankFields.value = true;
                              controller.predictBank.value = false;
                            },
                            child: Text('Add Bank', style: TextStyle(color: appColor))
                        )
                      ]
                  )
              ),
            ],
            TextFieldWidget(
              containerColor: !controller.enableBankFields.value?Colors.grey.shade200:null,
              isLast: false,
              readOnly: !controller.enableBankFields.value?true:false,
              initialValue: controller.bankName.value,
              onChanged: (input) => controller.bankName.value = input,
              hintText: "XXXXXXXXXXXXXXXX".tr,
              labelText: 'Bank Name'.tr,
              iconData: FontAwesomeIcons.bank,
            ),
           Obx(() =>  TextFieldWidget(
             isLast: false,
             containerColor: !controller.enableBankFields.value?Colors.grey.shade200:null,
             readOnly:!controller.enableBankFields.value?true:false,
             initialValue: controller.bankBic.value,
             onChanged: (input) => controller.bankBic.value = input,
             hintText: "XXXXXXXXXXXXXXXX".tr,
             labelText: 'Bank Identifier Code'.tr,
             iconData: FontAwesomeIcons.bank,
           ),),

            TextFieldWidget(
              isLast: false,
              readOnly: false,
              //initialValue: controller.allBanks.value,
              onChanged: (input) => controller.bankAccountNumber.value = input,
              hintText: "XXXXXXXXXXXXXXXX".tr,
              labelText: 'Your IBAN'.tr,
              iconData: FontAwesomeIcons.bank,
            ),
            Container(
              height: 44.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
              child: !controller.addBankAccountPressed.value?
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () async {
                  if(controller.bankName.value ==''){
                    Get.showSnackbar(Ui.warningSnackBar(message: 'Please Input a bank Name'.tr));
                  }
                  else{
                    if(controller.bankIdentifierCode.value ==''){
                      Get.showSnackbar(Ui.warningSnackBar(message: 'Please Input a bank identifier code'.tr));
                    }
                    else{
                      if(controller.bankAccountNumber.value ==''){
                        Get.showSnackbar(Ui.warningSnackBar(message: 'Please Input a bank account number'.tr));
                      }
                      else{
                        await controller.createBankAccount();
                        Navigator.of(context).pop();
                      }
                    }
                  }



                },
                child: Text('Add Bank Account'),
              )
              :SpinKitThreeBounce(color: Colors.white, size: 20,).paddingSymmetric(vertical: 10, horizontal: 20),
            ).marginOnly(top: 20),
          ]
      )));

  }

}
