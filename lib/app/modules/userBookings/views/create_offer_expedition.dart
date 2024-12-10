import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/user_widget.dart';
import '../controllers/all_expedition_offer_controller.dart';
import '../controllers/bookings_controller.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OfferExpeditionView extends GetView<TravelInspectController> {

  List bookings = [];
  var shippingDetails ;


  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>AllExpeditionsOffersController());

    var arguments = Get.arguments as Map<String, dynamic>;
    if(arguments!= null){
      shippingDetails = arguments['shippingDto'];
    }

    return Scaffold(
      //Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: false,
        backgroundColor: Get.theme.colorScheme.secondary,

        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 0,
          title: Obx(() => Text(
            !controller.editing.value ? AppLocalizations.of(context).newExpeditionOffer : AppLocalizations.of(context).modifyExpeditionOffer,
            style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
          )),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        bottomSheet: Obx(() =>

            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 90,
                child: Center(
                    child: !controller.editing.value ?
                    BlockButtonWidget(
                      onPressed: ()async =>{
                        if(controller.depTown.text.isNotEmpty && controller.arrTown.text.isNotEmpty){
                          Get.toNamed(Routes.ADD_SHIPPING_FORM),
                          Get.find<BookingsController>().offerExpedition.value = true,
                          await Get.find<TravelInspectController>().newShippingFunction(),
                        }else{
                          Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).fieldsRequired.tr)),
                        }

                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ?
                      SizedBox(
                        width: Get.width,
                        child: Center(
                            child: Text(AppLocalizations.of(context).continu.tr,
                              style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                            )
                        ),
                      ): SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                        :
                    BlockButtonWidget(
                      onPressed: () async =>{
                        showDialog(
                            context: Get.context,
                            barrierDismissible: false,
                            builder: (_){
                              return SpinKitThreeBounce(size: 30, color: Colors.white,);
                            }),
                        Get.find<TravelInspectController>().shipping = Get.find<BookingsController>().shippingDetails,
                        await Get.find<TravelInspectController>().editingFunction(),
                        Get.toNamed(Routes.ADD_SHIPPING_FORM, arguments: {'shippingDto': Get.find<BookingsController>().shippingDetails, 'heroTag': 'services_carousel'}),
                        Get.find<BookingsController>().offerExpedition.value = true,

                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ? SizedBox(
                        //width: Get.width/1.5,
                          child: Text(
                            AppLocalizations.of(context).updateShipping.tr,
                            style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                          )
                      ) : SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                )
            )
        ),

        body: Container(
          decoration: BoxDecoration(color: backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)), ),
          child: Theme(
            data: ThemeData(
              //canvasColor: Colors.yellow,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Get.theme.colorScheme.secondary,
                  background: Colors.red,
                  secondary: validateColor,
                )
            ),
            child: build_offer_details(context),
          ),
        )
    );
  }

  Widget build_offer_details(BuildContext context) {
    return ListView(
      primary: true,
      physics: AlwaysScrollableScrollPhysics(),
      //shrinkWrap: true,

      children: [
        Wrap(
          direction: Axis.horizontal,
          runSpacing: 20,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Obx(() => Container(
                  padding: EdgeInsets.all( 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    //border: controller.errorField.value ? Border.all(color: specialColor) : null,
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(controller.editing.value?AppLocalizations.of(context).modifyOfferDetails.tr:AppLocalizations.of(context).completeOfferDetails.tr, style: Get.textTheme.headline2.merge(TextStyle(color: appColor, fontSize: 15))).paddingSymmetric(horizontal: 22, vertical: 5)).marginOnly(bottom: 20, top: 20),

                        InkWell(
                            onTap: ()=> controller.chooseDepartureDate(),
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
                                  Text("${AppLocalizations.of(context).departureDate}".tr,
                                    style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
                                    textAlign: TextAlign.start,
                                  ),
                                  Obx(() =>
                                      ListTile(
                                          leading: Icon(Icons.calendar_today),
                                          title: Text(controller.departureDate.value,
                                            style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                          )
                                      )
                                  )
                                ],
                              ),
                            )
                        ),


                        InkWell(
                            onTap: ()=> controller.chooseArrivalDate(),
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
                                  Text("${AppLocalizations.of(context).arrivalDate}".tr,
                                    style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
                                    textAlign: TextAlign.start,
                                  ),
                                  Obx(() =>
                                      ListTile(
                                          leading: Icon(Icons.calendar_today),
                                          title: Text(controller.arrivalDate.value,
                                            style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                          )
                                      )
                                  )
                                ],
                              ),
                            )
                        ),

                        Column(
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
                                  border: Border.all(color: controller.errorCity1.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [

                                    Text(AppLocalizations.of(context).departureTown,
                                      style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
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
                                              style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                              onChanged: (value)=>{
                                                if(value.isNotEmpty){
                                                  controller.errorCity1Town.value = false
                                                },
                                                if(value.length > 2){
                                                  controller.predict1Town.value = true,
                                                  controller.filterSearchCity(value)
                                                }else{
                                                  controller.predict1Town.value = false,
                                                }
                                              },
                                              cursorColor: Get.theme.focusColor,
                                            ),
                                          ),
                                        ]
                                    )
                                  ]
                              ),
                            )),
                            if(controller.predict1Town.value)
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
                                                controller.predict1Town.value = false;
                                                controller.departureId.value = controller.countries[i]['id'];
                                              },
                                              child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                                          )
                                        ]
                                      ]
                                  )
                              )),
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
                                    Text(AppLocalizations.of(context).arrivalTown,
                                      style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
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
                                              readOnly: controller.departureId.value != 0 ? false : true,
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
                                                if(controller.departureId.value == 0){
                                                  controller.errorCity1.value = true;
                                                  Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).noDepartureCitySelected.tr));
                                                }
                                              },
                                              //initialValue: controller.travelCard.isEmpty || controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                                              style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                              onChanged: (value)=>{
                                                if(value.length > 2){
                                                  controller.predict2.value = true,
                                                  controller.filterSearchCity(value)
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
                                                controller.arrivalId.value = controller.countries[i]['id'];
                                              },
                                              child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                                          )
                                        ]
                                      ]
                                  )
                              )),],
                        ),

                        SizedBox(height: 200,),


                      ],
                    ),
                  ),
                )),
              ],
            )
          ],
        )
      ],

    ).marginOnly(bottom: 80);
  }



}
