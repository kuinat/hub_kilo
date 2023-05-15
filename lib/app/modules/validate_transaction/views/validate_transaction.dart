import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/ui.dart';
import '../../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controller/validation_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ValidationView extends GetView<ValidationController> {

  List bookings = [];
  String barcode = "";
  TextEditingController codeController = TextEditingController();

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
          padding: EdgeInsets.only(top: 10, bottom: 50),
          decoration: Ui.getBoxDecoration(color: backgroundColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: ()=>{
                          controller.currentState.value = 0
                        },
                        child: Obx(()=> Card(
                            color: controller.currentState.value == 0 ? interfaceColor : inactive,
                            elevation: controller.currentState.value == 0 ? 10 : null,
                            shadowColor:  inactive,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Validate Delivery'.tr, style: TextStyle(color: Get.theme.primaryColor))
                            )
                        ))
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                        onTap: ()=>{
                          controller.currentState.value = 1
                        },
                        child: Obx(() => Card(
                            color: controller.currentState.value == 1 ? interfaceColor : inactive,
                            elevation: controller.currentState.value == 1 ? 10 : null,
                            shadowColor: inactive,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Delivery Code'.tr, style: TextStyle(color: Get.theme.primaryColor))
                            )
                        )
                        )
                    )
                  ],
                ),
                SizedBox(height: 20),
                Obx(() => controller.currentState.value == 0 ? confirmDelivery(context) :
                myDeliveryCode(context)
                )
              ],
            )
          ),
        )
    );
  }

  Widget confirmDelivery(BuildContext context){
    return Column(
      children: [
        if(controller.validationType.value == 0 || controller.validationType.value == 1)...[
          DelayedAnimation(
              delay: 100,
              child: GestureDetector(
                  onTap: ()=>{
                    controller.validationType.value = 1
                  },
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
                                child: Text('Scanner le Code'.tr, style: TextStyle(color: Get.theme.primaryColor)
                                )
                            )
                          ],
                        )
                    ),
                  )
              )
          ),
          SizedBox(height: 20),
          DelayedAnimation(delay: 150,
              child: Text('Scan details example', style: TextStyle(color: pink))),
          SizedBox(height:60),
        ],
        if(controller.validationType.value == 0)
        Text('---------- OR ----------'.tr, style: TextStyle(fontSize: 20)),
        //Divider(color: inactive),
        SizedBox(height: 30),
        if(controller.validationType.value == 0 || controller.validationType.value == 2)
        DelayedAnimation(delay: 200,
        child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
            margin: EdgeInsets.all(20),
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
                Text( "Validation code".tr,
                  style: Get.textTheme.bodyText1,
                  textAlign: TextAlign.start,
                ),
                TextFormField(
                  maxLines: 1,
                  controller: codeController,
                  onTap: ()=>{
                    controller.validationType.value = 2
                  },
                  //validator: validator,
                  style: Get.textTheme.bodyText2,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  decoration: Ui.getInputDecoration(
                    hintText: 'xxxx xxxx xxxx',
                    iconData: Icons.lock,
                  ),
                ),
              ],
            )
        )),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(controller.validationType.value != 0)
            DelayedAnimation(delay: 250,
                child: GestureDetector(
                    onTap: ()=>{
                      controller.validationType.value = 0
                    },
                    child: Obx(()=> Card(
                        color: controller.validationType.value != 0 ? specialColor : null,
                        elevation: controller.validationType.value != 0 ? 10 : null,
                        shadowColor:  controller.validationType.value != 0 ? specialColor :  null,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Cancel'.tr, style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)))
                        )
                    ))
                ),
            ),
            DelayedAnimation(delay: 250,
                child: BlockButtonWidget(
                  onPressed: () {},
                  color: Get.theme.colorScheme.secondary,
                  text: Text(
                    "Validate Transaction".tr,
                    style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                ).paddingSymmetric(vertical: 10, horizontal: 20)
            )
          ],
        )
      ],
    );
  }

  Widget myDeliveryCode(BuildContext context){
    return Column(
      children: [
        DelayedAnimation(delay: 100,
        child: Container(
          padding: EdgeInsets.only(top: 00,bottom: 20, left: 60, right: 60),
          child: AspectRatio(
              aspectRatio: 0.5,
              child: QrImage(
                data: "Fikish",
                version: QrVersions.auto,
                size: 120,
                gapless: false,
              )
          ),
        )
        ),
      ],
    );
  }
}
