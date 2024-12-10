import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../../common/ui.dart';
import '../../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../main.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controller/validation_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ValidationView extends GetView<ValidationController> {

  List bookings = [];
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).scanCode,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.headline5.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  onTap: ()async=> await Get.find<RootController>().changePage(3),
                  child: ClipOval(
                    child: FadeInImage(
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      image: NetworkImage('${Domain.serverPort}/image/res.partner/${Get.find<MyAuthService>().myUser.value.id}/image_1920?unique=true&file_response=true',
                          headers: Domain.getTokenHeaders()),
                      placeholder: AssetImage(
                          "assets/img/loading.gif"),
                      imageErrorBuilder:
                          (context, error, stackTrace) {
                        return Image.asset("assets/img/téléchargement (3).png", width: 20, height: 20);
                      },
                    ),
                  ),
                )
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: backgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0)), ),
          child: SingleChildScrollView(
            child: confirmDelivery(context)
          ),
        )
    );
  }

  Widget confirmDelivery(BuildContext context){
    return Obx(() =>
        Column(
          children: [
            SizedBox(height: 20),
            if(controller.validationType.value == 0 || controller.validationType.value == 1)...[
              DelayedAnimation(
                  delay: 100,
                  child: GestureDetector(
                      onTap: ()=>{
                        controller.validationType.value = 1,
                        controller.scan()
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
                                    child: Text(AppLocalizations.of(context).scanCode.tr, style: TextStyle(color: Get.theme.primaryColor)
                                    )
                                )
                              ],
                            )
                        ),
                      )
                  )
              ),
              SizedBox(height:60),
            ],
            if(controller.validationType.value == 0)
              Text('------ ${AppLocalizations.of(context).orUpperCase} ------'.tr, style: TextStyle(fontSize: 20)),
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
                          Text( AppLocalizations.of(context).validationCode.tr,
                            style: Get.textTheme.bodyText1,
                            textAlign: TextAlign.start,
                          ),
                          TextFormField(
                            maxLines: 1,
                            controller: controller.codeController,
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
                Obx(() =>
                controller.validationType.value != 0 ?
                DelayedAnimation(delay: 250,
                  child: GestureDetector(
                      onTap: ()=>{
                        controller.validationType.value = 0
                      },
                      child: Obx(()=> Card(
                          color: controller.validationType.value != 0 ? specialColor : null,
                          shadowColor:  controller.validationType.value != 0 ? specialColor :  null,
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(AppLocalizations.of(context).cancel.tr, style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)))
                          )
                      ))
                  ),
                ) : SizedBox()
                ),
                DelayedAnimation(
                    delay: 250,
                    child: BlockButtonWidget(
                      onPressed: () {
                        controller.loading.value = true;
                        controller.codeController.text.toLowerCase().contains('road')?
                        controller.verifyRoadShippingCode(controller.codeController.text.split('-').first, controller.codeController.text.split('-').last)
                            :controller.verifyAirShippingCode(controller.codeController.text.split('-').first, controller.codeController.text.split('-').last);
                        Timer(Duration(milliseconds: 100), () {
                          controller.codeController.clear();
                        });
                      },
                      color: Get.theme.colorScheme.secondary,
                      text: SizedBox(
                        width: 200,
                        child: Center(
                          child: !controller.loading.value? Text(
                            AppLocalizations.of(context).confirm,
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                          ): SizedBox(height: 30,
                              child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                        ),
                      ),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                )
              ],
            )
          ],
        )
    );
  }
}
