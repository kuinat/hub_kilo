
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:multiselect/multiselect.dart';
import '../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../common/animation_controllers/animatonFadeIn.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controller/add_travel_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/bank_account_dialog.dart';
import '../widgets/fly_document_widget.dart';


class AddAirTravelsView extends GetView<AddTravelController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    Get.put(AddTravelController());
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        //Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
          title:  Text(
            AppLocalizations.of(context).travelFormHeadText.tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {
              //Navigator.pop(context),
              Get.back(),
              Get.delete<AddTravelController>(),
              //Get.delete<AddTravelsView>(),

            },
          ),
        ),
        bottomSheet: Obx(() =>
        controller.formStepAir.value == 5 ?
        Row(
          children: [
            IconButton(
                onPressed: ()=> {
                  controller.showButton.value = false,
                  controller.formStepAir.value--
                },
                icon: Icon(Icons.arrow_circle_left, color: interfaceColor, size: 40)
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 90,
                child: Center(
                    child: Obx(() =>
                    !controller.editing.value && controller.formStepAir.value == 5 ?
                    controller.departureId.value != 0 ?
                    BlockButtonWidget(
                      onPressed: () async {
                        if(!controller.loadTicket.value || !controller.loadCovidTest.value){
                          showDialog(
                              useSafeArea: true,
                              context: Get.context,
                              builder: (_){
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      )),
                                  child: SizedBox(
                                    height: Get.height/3,
                                    child: ListView(
                                      children: [
                                        Align(alignment: Alignment.centerRight,
                                          child: IconButton(onPressed: (){
                                            Navigator.of(context).pop();
                                          }, icon: Icon(FontAwesomeIcons.remove, color: Colors.red)),
                                        ).marginOnly(bottom: 20),
                                        Obx(() => FlyDocumentWidget(
                                          icon: Icon(Icons.airplane_ticket
                                              ,color: !controller.loadTicket.value?inactive:interfaceColor),
                                          text: Text('Upload Fly ticket', style: TextStyle(fontSize: 12.0, color: !controller.loadTicket.value?inactive:interfaceColor)),
                                          onTap: (e) async {
                                            controller.uploadTicket.value = true;
                                            controller.uploadCovidTest.value = false;
                                            controller.selectCameraOrGallery();
                                          },
                                          suffixIcon: Icon(
                                            Icons.upload,
                                            size: 15,
                                            color: !controller.loadTicket.value?inactive:interfaceColor,
                                          ),
                                        )),
                                        Obx(() => FlyDocumentWidget(
                                          icon: Icon(Icons.medical_services
                                            ,color: !controller.loadCovidTest.value?inactive:interfaceColor,),
                                          text: Text('Upload Covid Test', style: TextStyle(fontSize: 12.0, color:!controller.loadCovidTest.value? inactive:interfaceColor)),
                                          onTap: (e) async {
                                            controller.uploadCovidTest.value = true;
                                            controller.uploadTicket.value = false;
                                            controller.selectCameraOrGallery();

                                          },
                                          suffixIcon: Icon(
                                            Icons.upload,
                                            size: 15,
                                            color: !controller.loadCovidTest.value?inactive:interfaceColor,
                                          ),
                                        ),),
                                        Align(alignment: Alignment.centerRight,
                                          child: TextButton(onPressed: (){
                                            Navigator.of(context).pop();
                                          }, child: Text('ok', style: TextStyle(color: interfaceColor),)),
                                        ).marginOnly(bottom: 20),



                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                        if(controller.loadTicket.value && controller.loadCovidTest.value){
                          if(controller.departureId.value != 0){
                            controller.buttonPressed.value = true;
                            if(controller.user.value.birthday == '--/--/--' || controller.user.value.birthplace =='--' || controller.user.value.street =='--' || controller.user.value.sex.toString() =='false'){
                              if(controller.birthDate.value.toString().contains('-')){
                                controller.user.value.birthday = controller.birthDate.value;
                              }
                              await controller.updateProfile();
                            }
                            controller.createAirTravel();
                          }else{
                            Get.showSnackbar(Ui.notificationSnackBar(message: AppLocalizations.of(context).noArrivalCitySelected.tr));
                          }
                        }
                        else{
                          Get.showSnackbar(Ui.notificationSnackBar(message: 'Please upload travel documents as Covid Test and fly documents'.tr));
                        }
                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ?
                      SizedBox(
                        width: Get.width/1.8,
                        child: Center(
                            child: Text(!controller.loadTicket.value || !controller.loadCovidTest.value? 'Upload Travel files':AppLocalizations.of(context).submitForm.tr,
                              style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                            )
                        ),
                      ): SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                        : BlockButtonWidget(
                        onPressed: () async {

                        },
                        color: Get.theme.colorScheme.secondary.withOpacity(0.5),
                        text: SizedBox(
                          width: Get.width/1.8,
                          child: Center(
                              child: Text(AppLocalizations.of(context).submitForm.tr,
                                style: Get.textTheme.headline5.merge(TextStyle(color: Colors.white)),
                              )
                          ),
                        )
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                        : controller.formStepRoad.value == 3 ?
                    BlockButtonWidget(
                      onPressed: ()=>{
                        controller.updateAirTravel(),
                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ? SizedBox(
                        //width: Get.width/1.5,
                          child: Text(
                            AppLocalizations.of(context).updateTravel.tr,
                            style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                          )
                      ) : SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20) : SizedBox()
                    )
                )
            )
          ],
        ) :
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              previousButton(),
              nextButton(),
            ],
          ),
        )
        ),
        body: Obx(() =>
            Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(color: backgroundColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)), ),
                child: _buildStepperForm(context)
            )
        )
    );
  }

  String headerText() {
    switch (controller.formStepAir.value) {
      case 1:
        return 'Where to receive the package?';

      case 2:
        return 'Luggage type';

      case 3:
        return 'Bank Details';

      case 4:
        return 'Publisher Information';

      case 5:
        return 'Details Summary';

      default:
        return 'Departure and Arrival Date/Town';
    }
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                headerText(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FaIcon(FontAwesomeIcons.planeDeparture, size: 20, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildStepperForm(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconStepper(
            activeStepColor: Colors.purple.shade400,
            icons: [
              Icon(Icons.local_airport_rounded,color: controller.formStepAir.value == 0 ? Colors.white : null),
              Icon(Icons.location_pin,color: controller.formStepAir.value == 1 ? Colors.white : null),
              Icon(Icons.balance,color: controller.formStepAir.value == 2 ? Colors.white : null),
              Icon(Icons.credit_card,color: controller.formStepAir.value == 3 ? Colors.white : null),
              Icon(Icons.verified_user_sharp,color: controller.formStepAir.value == 4 ? Colors.white : null),
              Icon(Icons.verified,color: controller.formStepAir.value == 5 ? Colors.white : null),
            ],

            // activeStep property set to activeStep variable defined above.
            activeStep: controller.formStepAir.value,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            // This ensures step-tapping updates the activeStep.
            onStepReached: (index) {
              //controller.formStepAir.value = index;
            },
          ),
          header(),
          Expanded(
              child: controller.formStepAir.value == 0 ? FadeIn(delay: 30,child: stepOne(context)) :
              controller.formStepAir.value == 1 ? DelayedAnimation(delay: 30,child: travelerPickUpAddress(context)) :
              controller.formStepAir.value == 2 ? FadeIn(delay: 30,child: luggageType(context)) :
              controller.formStepAir.value == 3 ? DelayedAnimation(delay: 30,child: buildBankWidget(context)) :
              controller.formStepAir.value == 4 ? FadeIn(delay: 30,child: userInformations(context)) : DelayedAnimation(delay: 30,child: overView(context))
          ),
        ],
      ),
    );
  }

  Widget nextButton() {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          if(controller.formStepAir.value != 5){

            if(controller.depTown.text.isNotEmpty && controller.arrTown.text.isNotEmpty){
              if(controller.formStepAir == 0){
                controller.formStepAir.value++;
              }
              else{
                if(controller.formStepAir == 1){
                  if(controller.travelerPickUpCountry.text.isNotEmpty) {
                    //if(controller.travelerPickUpState.text.isNotEmpty){
                    if (controller.travelerPickUpCity.text.isNotEmpty) {
                      if (controller.pickUpStreet.isNotEmpty) {
                        controller.formStepAir.value++;

                      }
                      else {
                        Get.showSnackbar(Ui.warningSnackBar(
                            message: 'Please input a street  where you will pick up all the packages'
                                .tr));
                      }
                    }
                    else {
                      Get.showSnackbar(Ui.warningSnackBar(
                          message: 'Please input a city  where you will pick up all the packages'
                              .tr));
                    }
                    // }
                    // else{
                    //   Get.showSnackbar(Ui.warningSnackBar(message: 'Please input a state where you will pick up all the packages'.tr));
                    // }
                  }
                  else{
                    Get.showSnackbar(Ui.warningSnackBar(message: 'Please input a country where you will pick up all the packages'.tr));
                  }
                }else{
                  if(controller.formStepAir.value == 2){
                    if(controller.luggagesInfo.isNotEmpty){
                      controller.formStepAir.value++;
                    }
                    else{
                      Get.showSnackbar(Ui.warningSnackBar(
                          message: 'Please select at least one luggage type and enter a quantity and price'
                              .tr));

                    }
                  }
                  else{
                    if(controller.formStepAir.value == 3){
                      if(!controller.bankAccountNumberSelected.value ){
                        Get.showSnackbar(Ui.warningSnackBar(message: 'Please Select a bank account'.tr));
                      }
                      else
                      {
                        controller.formStepAir.value++;
                      }
                    }
                    else{
                      if(controller.formStepAir.value == 4){
                        if(controller.birthDate.value == '--/--/--' || controller.birthPlace.value=='--' || controller.residence.value =='--'|| controller.user.value.sex.toString() =="false"){
                          Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).fieldsRequired.tr));
                        }
                        else
                        {
                          controller.formStepAir.value++;
                        }
                      }


                    }

                  }
                }
              }
            }else{
              Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).fieldsRequired.tr));
            }

          }
        },
        child: Text('Next'),
      ),
    );
  }

  Widget previousButton() {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
          if (controller.formStepAir.value > 0) {
            controller.formStepAir.value--;
          }
        },
        child: Text('Prev', style: TextStyle(color: controller.formStepAir.value > 0 ? Colors.white : inactive)),
      ),
    );
  }


  Widget stepOne(BuildContext context){
    return Form(
        key: controller.newTravelKey,
        child: ListView(
            primary: true,
            //padding: EdgeInsets.all(10),
            children: [
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
                        Text("${AppLocalizations.of(context).date} ${AppLocalizations.of(context).departure}".tr,
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
                  onTap: ()=>{ controller.chooseArrivalDate() },
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
                        Text("${AppLocalizations.of(context).date} ${AppLocalizations.of(context).arrival}".tr,
                          style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
                          textAlign: TextAlign.start,
                        ),
                        Obx(() =>
                            ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text(controller.arrivalDate.value,
                                  style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                )
                            ))
                      ],
                    ),
                  )
              ),
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
              )),
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
                )),
              SizedBox(height: 50,)
            ]
        )
    );
  }

  Widget travelerPickUpAddress(BuildContext context){
    return Container(
      //padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          //color: background,
          //Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child:  ListView(
          children: [
            Obx(() {
              return Column(
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
                        border: Border.all(color: controller.errorPickUpCity.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Text('Country where you would like to pick up the packages?',
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
                                    controller: controller.travelerPickUpCountry,
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
                                        controller.errorPickUpCountry.value = false
                                      },
                                      if(value.length > 2){
                                        controller.predictPickUpCountry.value = true,
                                        controller.filterSearchResultsCountriesOnly(value)
                                      }else{
                                        controller.predictPickUpCountry.value = false,
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
              );
            }),
            if(controller.predictPickUpCountry.value)
              Obx(() => Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                  color: Get.theme.primaryColor,
                  height: 200,
                  child: ListView(
                      children: [
                        for(var i =0; i < controller.countriesOnly.length; i++)...[
                          TextButton(
                              onPressed: (){
                                controller.travelerPickUpCountry.text = controller.countriesOnly[i]['display_name'];
                                controller.pickUpCountry.value = controller.travelerPickUpCountry.text;
                                controller.predictPickUpCountry.value = false;
                                controller.travelerPickUpCountryId.value = controller.countriesOnly[i]['id'];
                              },
                              child: Text(controller.countriesOnly[i]['display_name'], style: TextStyle(color: appColor))
                          )
                        ]
                      ]
                  )
              )),

            Obx(() {
              return Column(
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
                        border: Border.all(color: controller.errorPickUpCity.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('State where you would like to pick up the packages?',
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
                                    controller: controller.travelerPickUpState,
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
                                        controller.errorPickUpState.value = false
                                      },
                                      if(value.length > 2){
                                        controller.predictPickUpState.value = true,
                                        controller.filterSearchResultsStates(value)
                                      }else{
                                        controller.predictPickUpState.value = false,
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
              );
            }),
            if(controller.predictPickUpState.value)
              Obx(() => Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                  color: Get.theme.primaryColor,
                  height: 200,
                  child: ListView(
                      children: [
                        for(var i =0; i < controller.states.length; i++)...[
                          TextButton(
                              onPressed: (){
                                controller.travelerPickUpState.text = controller.states[i]['display_name'];
                                controller.pickUpState.value = controller.travelerPickUpState.text;
                                controller.predictPickUpState.value = false;
                                controller.travelerPickUpStateId.value = controller.states[i]['id'];
                              },
                              child: Text(controller.states[i]['display_name'], style: TextStyle(color: appColor))
                          )
                        ]
                      ]
                  )
              )),


            Obx(() {
              return Column(
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
                        border: Border.all(color: controller.errorPickUpCity.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('City where you would like to pick up the packages?',
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
                                    controller: controller.travelerPickUpCity,
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
                                        controller.errorPickUpCity.value = false
                                      },
                                      if(value.length > 2){
                                        controller.predictPickUpCity.value = true,
                                        controller.filterSearchResults(value)
                                      }else{
                                        controller.predictPickUpCity.value = false,
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
              );
            }),
            if(controller.predictPickUpCity.value)
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
                                controller.travelerPickUpCity.text = controller.countries[i]['display_name'];
                                controller.pickUpCity.value = controller.travelerPickUpCity.text;
                                controller.predictPickUpCity.value = false;
                                controller.travelerPickUpCityId.value = controller.countries[i]['id'];
                              },
                              child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                          )
                        ]
                      ]
                  )
              )),



            TextFieldWidget(
              isLast: false,
              readOnly: false,
              initialValue: controller.pickUpStreet.value,
              onChanged: (input) => controller.pickUpStreet.value = input,
              hintText: "Avenue du 20 Mai".tr,
              labelText: 'Street'.tr,
              iconData: Icons.streetview,
            ),


          ],
        ).marginOnly(bottom: 80)

    );

  }

  Widget luggageType(BuildContext context){
    return Obx(() => ListView(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Select the type of luggage you want to transport'.tr, style: Get.textTheme.headline2.merge(TextStyle(color: appColor, fontSize: 14))).paddingSymmetric(horizontal: 22, vertical: 5)).marginOnly(bottom: 20),

        SizedBox(
          height: 160,
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 10),
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: controller.airLuggageModelList.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                    child: Obx(() => Container(
                      width: 120,
                      height: 100,

                      child: Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            Container(

                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: controller.selectedPackages.contains(controller.airLuggageModelList[index])? interfaceColor:inactive,
                                      width: controller.selectedPackages.contains(controller.airLuggageModelList[index])?4:1, )),
                                child:Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: FadeInImage(
                                          width: 60,
                                          height: 60,
                                          image: NetworkImage('https://preprod.hubkilo.com/web/image/m2st_hk_airshipping.luggage.type/${controller.airLuggageModelList[index]['id']}/image',
                                              headers: Domain.getTokenHeaders()),
                                          placeholder: AssetImage(
                                              "assets/img/loading.gif"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.white,
                                                    child: Center(
                                                        child: Icon(Icons.photo, size: 150)
                                                    )
                                                )
                                            );
                                          },
                                        ),
                                      ),
                                      Text(controller.airLuggageModelList[index]['display_name'],
                                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                                      ),

                                    ])),
                            Visibility(
                                visible: controller.selectedPackages.contains(controller.airLuggageModelList[index]),
                                child: Positioned(
                                  top: 5,
                                  right: 8,
                                  child: Icon(FontAwesomeIcons.check, color: Colors.green,fill: 1.0,grade: 20, size: 30, weight: 10, opticalSize: 5,),
                                ))

                         ])

                    ),),

                    onTap: ()=>
                    {
                      if(!controller.selectedPackages.contains(controller
                          .airLuggageModelList[index])){
                        showDialog(
                            context: context,
                            builder: (context) =>
                            Card(
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: (){
                                          Navigator.of(context).pop();
                                        }, icon: Icon(FontAwesomeIcons.remove, color: Colors.red,), ),

                                      ),
                                      TextFieldWidget(
                                        isLast: false,
                                        readOnly: false,
                                        //initialValue: controller.kilosQuantity.value.toString(),
                                        onChanged: (input) => controller.quantityInfo = double.parse(input),
                                        hintText: "0.05 kg".tr,
                                        labelText: 'Number of ${controller.airLuggageModelList[index]['display_name'].toString().toLowerCase()} available'.tr,
                                        keyboardType: TextInputType.number,
                                        iconData: Icons.production_quantity_limits,
                                      ),

                                      TextFieldWidget(
                                        isLast: false,
                                        readOnly: false,
                                        //initialValue: controller.kilosPrice.value.toString(),
                                        onChanged: (input) => controller.priceInfo = double.parse(input),
                                        keyboardType: TextInputType.number,
                                        hintText: "10 \$".tr,
                                        labelText: 'Price per ${controller.airLuggageModelList[index]['display_name'].toString().toLowerCase()}'.tr,
                                        iconData: Icons.money,
                                      ),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: (){
                                            controller.selectedPackages.add(controller.airLuggageModelList[index]);
                                            controller.luggagesInfo.add([controller.airLuggageModelList[index]['display_name'].toString(),controller.quantityInfo, controller.priceInfo]);

                                            print(controller.luggagesInfo);
                                            print(controller.selectedPackages.length);

                                            Navigator.of(context).pop();
                                          }, child: Text('Add', style: TextStyle(color: interfaceColor),), ),

                                      ),

                                    ],).marginAll(20)

                                ],
                              )
                            ).marginOnly(bottom: 200, top: 100, left: 20, right: 20),),


                      }
                      else
                        {
                          // controller.luggagesInfo.remove(controller
                          //     .airLuggageModelList[index]),
                          controller.selectedPackages.remove(controller.airLuggageModelList[index]),
                          //controller.luggagesInfo.removeAt(index),
                          controller.luggagesInfo.removeWhere((element) => element[0] == controller.airLuggageModelList[index]['display_name'].toString() ),
                print(controller.luggagesInfo),
                        }
                    }
                  //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                );
              }),
        ),



        for(int i = 0; i <controller.luggagesInfo.length; i++ )...[
          if(!controller.selectedPackages.where((element) => element['display_name'] == controller.luggagesInfo[i]).isNotEmpty)...[
            TextFieldWidget(
              isLast: false,
              readOnly: true,
              initialValue: controller.luggagesInfo[i][1].toString(),
              hintText: "0.05 kg".tr,
              labelText: 'Number of ${controller.luggagesInfo[i][0].toString().toLowerCase()} available'.tr,
              keyboardType: TextInputType.number,
              iconData: Icons.production_quantity_limits,
            ),

            TextFieldWidget(
              isLast: false,
              readOnly: true,
              initialValue: controller.luggagesInfo[i][2].toString(),
              keyboardType: TextInputType.number,
              hintText: "10 \$".tr,
              labelText: 'Price per ${controller.luggagesInfo[i][0].toString().toLowerCase()}'.tr,
              iconData: Icons.money,
            ),
          ]



        ]


      ],
    ).paddingOnly(top: 20)).marginOnly(bottom: 80);

  }

  Widget userInformations(BuildContext context){
    return Form(
      key: controller.newTravelKey,
      child: ListView(
        primary: true,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(AppLocalizations.of(context).userProfileInfoText.tr, style: Get.textTheme.headline2.merge(TextStyle(color: appColor, fontSize: 15))).paddingSymmetric(horizontal: 22, vertical: 5)).marginOnly(bottom: 20),
          InkWell(
              onTap: controller.birthDate.value == '--/--/--'?(){
                controller.chooseBirthDate();
                //controller.user.value.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value);
                //controller.birthDateSet.value = true;
              }:(){
                controller.chooseBirthDate();
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
                    Text(AppLocalizations.of(context).dateBirth.tr,
                      style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
                      textAlign: TextAlign.start,
                    ),
                    Obx(() {
                      return ListTile(
                          leading: FaIcon(
                              FontAwesomeIcons.birthdayCake, size: 20),
                          title: Text(controller.birthDate.value.toString(),
                            style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                          ));
                    })
                  ],
                ),
              )
          ),
          controller.user.value.sex =='false'?
          Container(
              margin: EdgeInsets.only(left: 5, right: 5, top:20),
              padding: EdgeInsets.only(top: 15, bottom: 15),
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
                      hintText: ''),
                  onSaved: (input) => (controller.selectedGender.value == "Male"||controller.selectedGender.value == "Homme")?controller.user?.value?.sex = "male":controller.user?.value?.sex = "female",
                  isExpanded: true,
                  alignment: Alignment.bottomCenter,
                  style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  value: controller.user.value.sex =='false'?controller.genderList[0]:controller.user.value.sex=="male"?controller.selectedGender.value=controller.genderList[1]:controller.selectedGender.value=controller.genderList[2],
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: controller.genderList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    controller.selectedGender.value = newValue;
                    if(controller.selectedGender.value == "Male"|| controller.selectedGender.value == "Homme" ){
                      controller.user.value.sex = "male";
                    }
                    else{
                      controller.user.value.sex = "female";
                    }

                  },).marginOnly(left: 20, right: 20).paddingOnly( top: 20, bottom: 14),
              )
          ).paddingOnly(bottom: 14,
          ):
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
            child: Obx(() =>
                ListTile(
                  title: Text(AppLocalizations.of(context).gender,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
                  leading: FaIcon(FontAwesomeIcons.venusMars, size: 20),
                  subtitle: Text(controller.user.value.sex=='false'?'not defined':controller.user.value.sex,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  ),
                )
            ),
          ),
          Obx(() {
            return controller.user.value.birthplace=='--'?
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
                      border: Border.all(color: controller.errorCity1Profile.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(AppLocalizations.of(context).cityBirth,
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
                                  controller: controller.birthPlaceTown,
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
                                      controller.errorCity1Profile.value = false
                                    },
                                    if(value.length > 2){
                                      controller.predict1Profile.value = true,
                                      controller.filterSearchResults(value)
                                    }else{
                                      controller.predict1Profile.value = false,
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
            )
                :
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
              child: Obx(() =>
                  ListTile(
                    title: Text(AppLocalizations.of(context).placeBirth,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
                    leading: FaIcon(FontAwesomeIcons.locationPin, size: 20),
                    subtitle: Text(controller.user.value.birthplace==null?'':controller.user.value.birthplace,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                    ),
                  )
              ),
            );
          }),
          if(controller.predict1Profile.value)
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
                              controller.birthPlaceTown.text = controller.countries[i]['display_name'];
                              controller.birthPlace.value = controller.birthPlaceTown.text;
                              controller.predict1Profile.value = false;
                              controller.birthCityId.value = controller.countries[i]['id'];
                            },
                            child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                        )
                      ]
                    ]
                )
            )),
          controller.user.value.street=='--'?
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
                                controller: controller.residentialTown,
                                //readOnly: controller.birthCityId.value != 0 ? false : true,
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
                                    controller.errorCity1Profile.value = true;
                                    Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).residentialAddressNotSelectedError.tr));
                                  }
                                },
                                //initialValue: controller.travelCard.isEmpty || controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                onChanged: (value)=>{
                                  if(value.length > 2){
                                    controller.predict2Profile.value = true,
                                    controller.filterSearchResults(value)
                                  }else{
                                    controller.predict2Profile.value = false,
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
          )
              :
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
            child: Obx(() =>
                ListTile(
                  title: Text(AppLocalizations.of(context).residentialAddress,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14))),
                  leading: FaIcon(FontAwesomeIcons.locationPin, size: 20),
                  subtitle: Text(controller.user.value.street==null?'':controller.user.value.street,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  ),

                )
            ),
          ),
          if(controller.predict2Profile.value)
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
                              controller.residentialTown.text = controller.countries[i]['display_name'];
                              controller.residence.value = controller.residentialTown.text;
                              controller.predict2Profile.value = false;
                              controller.residentialAddressId.value = controller.countries[i]['id'];
                            },
                            child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                        )
                      ]
                    ]
                )
            )),


        ],
      ),
    );
  }

  Widget buildBankWidget(BuildContext context){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            controller.user.value.vat == 'false'? controller.user.value.airTravelIds.isEmpty ? SwitchListTile( //switch at right side of label
                value: controller.professionalTransporter.value,
                onChanged: (bool value){
                  controller.professionalTransporter.value = value;
                  print(controller.user.value.vat);
                },
                title: Text('Are u a Professional Transporter?', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: appColor)))
            )
                :Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                    border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                child: ListTile(
                  title: Text('Transporter type: ',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                  leading: FaIcon(FontAwesomeIcons.businessTime, size: 20),
                  subtitle: Text('Individual Transporter',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                  ),
                )
            )
                :Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                    border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                child:
                ListTile(
                  title: Text('Transporter type: ',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                  leading: FaIcon(FontAwesomeIcons.businessTime, size: 20),
                  subtitle: Text('Professional Transporter',style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black)),
                  ),
                )

            ),
            if(controller.professionalTransporter.value)...[
              TextFieldWidget(
                isLast: false,
                readOnly: false,
                initialValue: controller.vatNumber.value,
                onChanged: (input) => controller.vatNumber.value = input,
                hintText: "XXXXXXXXXXXXXXXX".tr,
                labelText: 'TVA number'.tr,
                iconData: Icons.streetview,
              ),

            ],

            if(!controller.bankAccountNumberSelected.value)...[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 44.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    onPressed: () {
                      showDialog(
                          useSafeArea: true,
                          context: Get.context,
                          barrierDismissible: false,
                          builder: (_){
                            return BankAccountDialog();
                          });
                    },
                    child: Text('Create New Bank Account'),
                  ),
                ),
              ).marginOnly(top:20, bottom: 20),

            ],
            if(controller.allAccountNumbers.isNotEmpty)...[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    width: Get.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 5, right: 5),
                    color: Get.theme.primaryColor,
                    child: Text('Select a bank account', style: TextStyle(color: Colors.black),)
                ),
              ).marginOnly(top: 20),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  color: Get.theme.primaryColor,
                  height:  200,
                  child: Obx(() => ListView.builder(
                    itemCount: controller.allAccountNumbers.length ,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: (){
                            controller.ibanCode.text = controller.allAccountNumbers[index]['display_name'];
                            controller.bankAccountNumber.value = controller.allAccountNumbers[index]['acc_number'];
                            controller.predictBankAccountNumber.value = false;
                            print(controller.allAccountNumbers.length);
                            //controller.bankId.value = controller.allAccountNumbers[i]['id'];
                            controller.bankAccountNumberSelected.value = !controller.bankAccountNumberSelected.value;
                            controller.selectedBankAccountIndex.value = index;

                          },
                          child:Obx(() =>  Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(10) ,
                                border: Border.all(width: controller.selectedBankAccountIndex.value == index&&controller.bankAccountNumberSelected.value?2:0.5,  color: controller.selectedBankAccountIndex.value == index && controller.bankAccountNumberSelected.value?interfaceColor:Colors.grey,)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(FontAwesomeIcons.creditCard),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller.allAccountNumbers[index]['acc_number'], style: TextStyle(color: Colors.black, fontSize: 12),),
                                    Text(controller.allAccountNumbers[index]['bank_name'],style: TextStyle(color: Colors.grey, fontSize: 12))
                                  ],)

                              ],).paddingSymmetric(horizontal: 20, vertical: 10),

                          )));
                    },


                  ))
              ),
            ]
          ],
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

  Widget overView(BuildContext context){
    return Container(
      //height: Get.height/1.2,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: ListView(
        children: [

          AccountWidget(
            icon: FontAwesomeIcons.calendarDay,
            text: AppLocalizations.of(context).departureDate,
            value: controller.departureDate.value,
          ),
          AccountWidget(
            icon: FontAwesomeIcons.calendarDay,
            text: AppLocalizations.of(context).arrivalDate,
            value: controller.arrivalDate.value,
          ),
          AccountWidget(
            icon: FontAwesomeIcons.locationDot,
            text: AppLocalizations.of(context).departureTown,
            value: controller.depTown.text,
          ),
          AccountWidget(
            icon: FontAwesomeIcons.locationDot,
            text: AppLocalizations.of(context).arrivalTown,
            value: controller.arrTown.text,
          ),
          if(controller.travelType.value != "road")...[
            AccountWidget(
              icon: FontAwesomeIcons.locationDot,
              text: 'Pick up Country',
              value: controller.travelerPickUpCountry.text,
            ),
            AccountWidget(
              icon: FontAwesomeIcons.locationDot,
              text: 'Pick up State',
              value: controller.travelerPickUpState.text,
            ),
            AccountWidget(
              icon: FontAwesomeIcons.city,
              text: 'Pick up City',
              value: controller.travelerPickUpCity.text,
            ),
            AccountWidget(
              icon: FontAwesomeIcons.locationDot,
              text: 'Pick up Street',
              value: controller.pickUpStreet.value,
            ),


    for(int i = 0; i <controller.luggagesInfo.length; i++ )...[
      AccountWidget(
        icon: FontAwesomeIcons.shoppingBasket,
        text: 'Number of ${controller.luggagesInfo[i][0]}',
        value: controller.luggagesInfo[i][1].toString().toLowerCase(),
      ),

      AccountWidget(
          icon: FontAwesomeIcons.moneyCheck,
          text: 'Price',
          value: '${controller.luggagesInfo[i][2]} EUR'
      ),

    ],
            AccountWidget(
                icon: FontAwesomeIcons.bank,
                text: 'Account Number',
                value: '${controller.ibanCode.text}'
            ),

            if(controller.loadTicket.value)...[
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        controller.ticket,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                        height: 40,
                        width: 200,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text('Ticket Image', style: Get.textTheme.headline4.merge(TextStyle(fontSize: 13, color: buttonColor)), overflow: TextOverflow.ellipsis,)
                              )
                            ]
                        )
                    )
                  ]
              ).marginOnly(bottom: 20, left: 20),
            ],


            if(controller.loadCovidTest.value)...[
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        controller.covidTest,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                        height: 40,
                        width: 200,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text('Covid Test Image', style: Get.textTheme.headline4.merge(TextStyle(fontSize: 13, color: buttonColor)), overflow: TextOverflow.ellipsis,)
                              )
                            ]
                        )
                    )
                  ]
              ).marginOnly(bottom: 20, left: 20),
            ]

          ],
        ],
      ).marginOnly(bottom: 50),
    );
  }

}
