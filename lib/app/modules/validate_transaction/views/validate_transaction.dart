import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/ui.dart';
import '../../../../../color_constants.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controller/validation_controller.dart';

class ValidationView extends GetView<ValidationController> {

  List bookings = [];
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Validate Transaction".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => {Navigator.pop(context)},
          ),
          actions: [NotificationsButtonWidget()],

        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 50, bottom: 50),
            decoration: Ui.getBoxDecoration(color: backgroundColor),
            child: Column(
              children: [
                GestureDetector(
                  onTap: ()=>{},
                  child: Card(
                    color: interfaceColor,
                      elevation: 10,
                    shadowColor: inactive,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(Icons.qr_code_scanner, size: 80, color: Colors.white),
                          SizedBox(height: 10),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Text('Scanner le Code', style: TextStyle(color: Get.theme.primaryColor)
                              )
                          )
                        ],
                      )
                    ),
                  )
                ),
                SizedBox(height: 20),
                Text('Scan details example', style: TextStyle(color: pink)),
                SizedBox(height:60),
                Text('---------- OR ----------', style: TextStyle(fontSize: 20)),
                //Divider(color: inactive),
                SizedBox(height: 30),
                TextFieldWidget(
                  labelText: "Validation code".tr,
                  hintText: "xxxx xxxx xxxx".tr,
                  //initialValue: controller.currentUser?.value?.email,
                  //onSaved: (input) => controller.currentUser.value.email = input,
                  //validator: (input) => !input.isEmpty ? "Enter a code".tr : null,
                  iconData: Icons.lock,
                ),
                Spacer(),
                BlockButtonWidget(
                  onPressed: () {

                  },
                  color: Get.theme.colorScheme.secondary,
                  text: Text(
                    "Validate Transaction".tr,
                    style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                ).paddingSymmetric(vertical: 10, horizontal: 20),
              ],
            )
        )
    );
  }

}
