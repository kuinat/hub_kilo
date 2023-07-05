
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import '../controller/import_identity_files_controller.dart';

class ImportIdentityFilesView extends GetView<ImportIdentityFilesController> {

  var selectedPiece = "Select identity piece".obs;

  var pieceList = [
    'Select identity piece'.tr,
    'CNI'.tr,
    'Passport'.tr,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: background,
          title:  Text(
            "Identity files".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: appColor)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: appColor),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        bottomSheet: SizedBox(
          height: 40,
          child: Center(
            child: MaterialButton(
              onPressed: () async{
                var id = await controller.createAttachment();
                await controller.sendImages(id, controller.identificationFile );
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: interfaceColor,
              child: Text("Submit form".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
              elevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
            ),
          ),
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
            child: Column(
              children: [
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
                        //validator:(input) => input == "Select your gender" ? "Select a gender".tr : null,
                        //onSaved: (input) => selectedGender.value == "Male"?controller.currentUser?.value?.sex = "M":controller.currentUser?.value?.sex = "F",
                        isExpanded: true,
                        alignment: Alignment.bottomCenter,

                        style: TextStyle(color: labelColor),
                        value: controller.selectedPiece.value,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: controller.pieceList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items, style: TextStyle(color: labelColor),),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String newValue) {
                          controller.selectedPiece.value = newValue;
                          if(controller.selectedPiece.value == "cni"){
                            controller.identityPieceSelected.value= "cni";
                          }
                          else{
                            controller.identityPieceSelected.value= "passport";
                          }


                        },).marginOnly(left: 20, right: 20, top: 10, bottom: 10).paddingOnly( top: 20, bottom: 14),
                    )
                ).paddingOnly(left: 5, right: 5, top: 20, bottom: 14,
                ),

                InkWell(
                    onTap: ()=>{controller.deliveryDate()},
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
                          Text("Delivery Date".tr,
                            style: Get.textTheme.bodyText1,
                            textAlign: TextAlign.start,
                          ),
                          Obx(() =>
                              ListTile(
                                  leading: Icon(Icons.calendar_today),
                                  title: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.dateOfDelivery.value)).toString(),
                                    style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
                                  )
                              )
                          )
                        ],
                      ),
                    )
                ),
                InkWell(
                    onTap: ()=>{ controller.expiryDate() },
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
                          Text("Expiry Date".tr,
                            style: Get.textTheme.bodyText1,
                            textAlign: TextAlign.start,
                          ),
                          Obx(() =>
                              ListTile(
                                  leading: Icon(Icons.calendar_today),
                                  title: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.dateOfExpiration.value)).toString(),
                                    style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
                                  )
                              ))
                        ],
                      ),
                    )
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("CNI or Passport Image".tr,
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Obx(() {
                            if(!controller.loadIdentityFile.value)
                              return buildLoader();
                            else return ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                controller.identificationFile,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            );
                          }
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {

                              await controller.selectCameraOrGalleryIdentityFile();
                              controller.loadIdentityFile.value = false;

                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),




              ],
            ),
            ),
        )
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
