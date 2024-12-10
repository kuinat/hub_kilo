
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:multiselect/multiselect.dart';
import '../../../../color_constants.dart';
import '../../../../common/animation_controllers/animatonFadeIn.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../controller/add_travel_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/bank_account_dialog.dart';
import '../widgets/fly_document_widget.dart';


class AddTravelsView extends GetView<AddTravelController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    Get.put(AddTravelController());
    return Scaffold(
      //Get.theme.colorScheme.secondary,
        backgroundColor: Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 0,
          title:  Text(
            AppLocalizations.of(context).travelFormHeadText.tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
          ),
          centerTitle: true,
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
        controller.formStepRoad.value == 3 ?
        Row(
          children: [
            IconButton(
                onPressed: ()=> {
                  controller.showButton.value = false,
                  controller.formStepRoad.value--
                },
                icon: Icon(Icons.arrow_circle_left, color: interfaceColor, size: 40)
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 90,
                child: Center(
                    child: Obx(() =>
                    !controller.editing.value && controller.formStepRoad.value == 3 ?
                    BlockButtonWidget(
                      onPressed: () async =>{
                        if(controller.departureId.value != 0){
                          controller.buttonPressed.value = true,
                          if(controller.user.value.birthday == '--/--/--' || controller.user.value.birthplace =='--' || controller.user.value.street =='--' || controller.user.value.sex.toString() =='false'){
                            if(controller.birthDate.value.toString().contains('-')){
                              controller.user.value.birthday = controller.birthDate.value,
                            },
                            await controller.updateProfile(),
                          },
                          controller.createRoadTravel(),
                        }else{
                          Get.showSnackbar(Ui.notificationSnackBar(message: AppLocalizations.of(context).noArrivalCitySelected.tr)),
                        }
                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ?
                      SizedBox(
                        width: Get.width/1.8,
                        child: Center(
                            child: Text('Confirmer et créer'.tr,
                              style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                            )
                        ),
                      ): SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                        : controller.formStepRoad.value == 3 ?
                    BlockButtonWidget(
                      onPressed: ()=>{

                        if(controller.travelType.value == "air"){
                          print("Air"),
                          controller.updateAirTravel(),
                          //controller.updateAirTravel(controller.travelCard['id']);
                        },
                        if(controller.travelType.value == "road"){
                          print("Land"),
                          controller.buttonPressed.value = true,
                          controller.updateRoadTravel(),
                        },
                        if(controller.travelType.value == "sea"){
                          print("Sea"),
                          //controller.createSeaTravel()
                        }

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
        ) : Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              previousButton(),
              nextButton(),
            ],
          ),
        ),
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
    switch (controller.formStepRoad.value) {
      case 1:
        return 'Bank Details';
      case 2:
        return 'User Informations'.tr;

      case 2:
        return AppLocalizations.of(Get.context).verifyTravelInfo.tr;

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
              child: FaIcon(FontAwesomeIcons.bus, size: 40, color: Colors.white)
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
              Icon(Icons.directions_bus,color: controller.formStepRoad.value == 0 ? Colors.white : null),
              Icon(Icons.credit_card,color: controller.formStepRoad.value == 1 ? Colors.white : null),
              Icon(Icons.person,color: controller.formStepRoad.value == 2 ? Colors.white : null),
              Icon(Icons.verified,color: controller.formStepRoad.value == 3 ? Colors.white : null),
            ],

            // activeStep property set to activeStep variable defined above.
            activeStep: controller.formStepRoad.value,

            enableNextPreviousButtons: false,
            enableStepTapping: false,
            // This ensures step-tapping updates the activeStep.
            onStepReached: (index) {
              //controller.formStepRoad.value = index;
            },
          ),
          header(),
          Expanded(
              child: controller.formStepRoad.value == 0 ? FadeIn(delay: 30,child: stepOne(context)) :
              controller.formStepRoad.value == 1 ? FadeIn(delay: 60,child: buildBankWidget(context)) :
              controller.formStepRoad.value == 2 ? FadeIn(delay: 60,child: userInfo(context)) : FadeIn(delay: 90,child: overView(context))
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
        gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] ), ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          // Increment activeStep, when the next button is tapped. However, check for upper bound.
          if(controller.formStepRoad.value == 0){
            if(controller.depTown.text.isNotEmpty && controller.arrTown.text.isNotEmpty){

              controller.formStepRoad.value++;

            }else{
              Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).fieldsRequired.tr));
            }
          }else{
            if(controller.formStepRoad.value == 1){
              if(!controller.bankAccountNumberSelected.value ){
                Get.showSnackbar(Ui.warningSnackBar(message: 'Please select a bank account'.tr));
              }
              else{
                controller.formStepRoad.value++;
              }
            }
            else {
              if(controller.formStepRoad.value == 2){
                if(controller.birthDate.value == '--/--/--' || controller.birthPlace.value=='--' || controller.residence.value =='--' || controller.user.value.sex.toString() =="false"){
                  Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).fieldsRequired.tr));
                }
                else
                {
                  controller.formStepRoad.value++;
                }
              }
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
          if (controller.formStepRoad.value > 0) {
            controller.formStepRoad.value--;
            controller.showButton.value == false;
          }
        },
        child: Text('Prev', style: TextStyle(color: controller.formStepRoad.value > 0 ? Colors.white : inactive)),
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

  Widget airOrRoadTravel(BuildContext context) {
    return Container(
        height: Get.height*0.7,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: EdgeInsets.all(20),
        child: ListView(
          primary: true,
          //padding: EdgeInsets.all(10),
          children: [
            Text(AppLocalizations.of(context).travelType.tr,
              style: Get.textTheme.headline6.merge(TextStyle(color: buttonColor)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            InkWell(
                onTap: ()=>{
                  Get.lazyPut(()=>AddTravelController()),
                  controller.travelType.value = 'road',
                  if(Get.find<HomeController>().existingPublishedRoadTravel.isTrue){
                    Get.showSnackbar(Ui.warningSnackBar(message: 'You already have a road travel in Published state, complete it before creating another travel'))
                  }
                  else{

                    //Navigator.of(context).pop(),
                    Get.offNamed(Routes.ADD_TRAVEL_FORM)
                  }

                },
                child: Obx(() => Container(
                    height: 130,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        image: DecorationImage(
                            image: AssetImage("assets/img/photo_2023-08-25_10-14-00.jpg"), fit: BoxFit.contain),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                        border: controller.travelType.value == 'road' ? Border.all(color: interfaceColor, width: 2) : null),
                    child: Text(AppLocalizations.of(context).road,style: TextStyle(fontSize: 20))
                ))
            ),
            InkWell(
                onTap: ()=>{
                  Get.lazyPut(()=>AddTravelController()),
                  controller.travelType.value = 'air',
                  //Navigator.of(context).pop(),
                  if(Get.find<HomeController>().existingPublishedAirTravel.isTrue){
                    Get.showSnackbar(Ui.warningSnackBar(message: 'You already have an air travel in Published state, complete it before creating another travel'))
                  }
                  else{

                    if(!controller.isIdentityFileConform.value){
                      if(controller.isIdentityFileUnderAnalysis.value){
                        showDialog(
                            context: Get.context,
                            builder: (_){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                icon: Icon(Icons.warning_amber_rounded, size: 40),
                                title: Text(AppLocalizations.of(Get.context).identityFilesNonConform, style: Get.textTheme.headline2.merge(TextStyle(color: interfaceColor, fontSize: 14))),
                                content: Text('You have already uploaded an identity file, it is under analysis. When it is confirmed you can create air travel', style: Get.textTheme.headline4.merge(TextStyle(color: Colors.black, fontSize: 12))),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(Get.context),
                                          child: Text(AppLocalizations.of(Get.context).back, style: Get.textTheme.headline4.merge(TextStyle(color: specialColor))
                                          )
                                      ),

                                    ],
                                  )
                                ],
                              );
                            })
                      }
                      else{
                        showDialog(
                            context: Get.context,
                            builder: (_){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                icon: Icon(Icons.warning_amber_rounded, size: 40),
                                title: Text(AppLocalizations.of(Get.context).identityFilesNonConform, style: Get.textTheme.headline2.merge(TextStyle(color: interfaceColor, fontSize: 14))),
                                content: Text('You have not yet uploaded an identity file, '+"\n${AppLocalizations.of(Get.context).wantUploadNewFile}", style: Get.textTheme.headline4.merge(TextStyle(color: Colors.black, fontSize: 12))),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(Get.context),
                                          child: Text(AppLocalizations.of(Get.context).back, style: Get.textTheme.headline4.merge(TextStyle(color: specialColor))
                                          )
                                      ),
                                      SizedBox(width: 10),
                                      TextButton(
                                          onPressed: () => {
                                            Navigator.pop(Get.context),
                                            Get.toNamed(Routes.IDENTITY_FILES),
                                          },
                                          child: Text(AppLocalizations.of(Get.context).uploadFile, style: Get.textTheme.headline4
                                          )
                                      ),
                                    ],
                                  )
                                ],
                              );
                            })
                      }

                    }
                    else{
                      Get.offNamed(Routes.ADD_AIR_TRAVEL_FORM)
                    }
                  }



                },
                child: Obx(() => Container(
                    height: 130,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        image: DecorationImage(
                            image: AssetImage("assets/img/photo_2023-08-25_10-14-45.jpg"), fit: BoxFit.contain),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                        border: controller.travelType.value == 'air' ? Border.all(color: interfaceColor, width: 2) : null),
                    child: Text(AppLocalizations.of(context).air,style: TextStyle(fontSize: 20))
                ),)
            ),
            /*if(controller.travelType.value != "road")...[
              TextFieldWidget(
                initialValue: controller.travelCard.isNotEmpty ? controller.travelCard['kilo_qty'].toString() : "",
                keyboardType: TextInputType.number,
                validator: (input) => input.isEmpty ? "field required!".tr : null,
                onChanged: (input) => controller.quantity.value = double.parse(input),
                labelText: "Quantity".tr,
                iconData: Icons.shopping_cart_rounded,
              ),
              TextFieldWidget(
                //onSaved: (input) => controller.user.value.name = input,
                initialValue: controller.travelCard.isNotEmpty ? controller.travelCard['price_per_kilo'].toString() : "",
                keyboardType: TextInputType.number,
                onChanged: (input) => controller.price.value = double.parse(input),
                validator: (input) => input.isEmpty ? "field required!".tr : null,
                labelText: "Price /kg".tr,
                iconData: Icons.attach_money,
              )
            ]*/
          ],
        )
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
            if (controller.allAccountNumbers.isNotEmpty)...[
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

  Widget userInfo(BuildContext context){
    return Form(
      key: controller.newTravelKey,
      child: ListView(
        primary: true,
        children: [
          SizedBox(height: 20),
          InkWell(
              onTap: controller.birthDate.value == '--/--/--'?(){
                controller.chooseBirthDate();
                //controller.user.value.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value);

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
                            style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12,)),
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
                  style: Get.textTheme.bodyText1,
                  value: controller.user.value.sex =='false'?controller.genderList[0]:controller.user.value.sex=="male"?controller.selectedGender.value=controller.genderList[1]:controller.selectedGender.value=controller.genderList[2],
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: controller.genderList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items,style: TextStyle(color:Colors.grey.shade700),),
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
                                  style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 14)),
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
                    subtitle: Text(controller.user.value.birthplace==null?'':controller.user.value.birthplace,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700)),
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
                        style: Get.textTheme.bodyText1,
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
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 14)),
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
                  subtitle: Text(controller.user.value.street==null?'':controller.user.value.street,style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700)),
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
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: Get.height/4),
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
          AccountWidget(
              icon: FontAwesomeIcons.bank,
              text: 'Account Number',
              value: '${controller.ibanCode.text}'
          ),
        ],
      ),
    );
  }

}
