import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/computer_model.dart';
import '../../../models/envelop_model.dart';
import '../../../models/kilos_model.dart';
import '../../../models/my_user_model.dart';
import '../../add_ravel_form/widgets/bank_account_dialog.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/user_widget.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../widgets/choose_luggage_type_dialog.dart';
import '../widgets/computer_dialog.dart';
import '../widgets/envelop_dialog.dart';
import '../widgets/kilos_dialog.dart';
import '../controllers/travel_inspect_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../common/animation_controllers/animatonFadeIn.dart';

import '../widgets/computer_widget.dart';
import '../widgets/envelop_widget.dart';
import '../widgets/kilos_widget.dart';
import '../widgets/other_dialog.dart';
import '../widgets/other_widget.dart';

class AddShippingView extends GetView<TravelInspectController> {

  List bookings = [];
  int activeStep = 5; // Initial step set to 5.

  int upperBound = 6;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //Get.theme.colorScheme.secondary,
        backgroundColor: Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 0,
          title: Obx(() => Text(
            !controller.editing.value ?controller.travelCard['booking_type'] == null? "Nouvelle offre d' expédition":controller.travelCard['booking_type'].toLowerCase() == "road"?'Nouvelle expédition terrestre':'Nouvelle expédition aérienne' : controller.shipping['display_name'].toString(),
            style: Get.textTheme.headline6.merge(TextStyle(color: Colors.white)),
          )),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {
              Navigator.pop(context),
              Get.find<BookingsController>().offerExpedition.value = false,
            },
          ),
        ),

        bottomSheet: Obx(() =>
        controller.showButton.value ?
        Row(
          children: [
            IconButton(

                onPressed: ()=> {
                  controller.selectedUser.value = false,
                  controller.showButton.value = false,
                  controller.formStep.value--
                },
                icon: Icon(Icons.arrow_circle_left, color: interfaceColor, size: 40)
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 90,
                child: Center(
                    child: Obx(() =>
                    !controller.editing.value && controller.formStep.value == 4 ?
                    BlockButtonWidget(
                      onPressed: () async =>{
                        controller.buttonPressed.value = true,
                        if(controller.user.value.birthday == '--/--/--' || controller.user.value.birthplace =='--' || controller.user.value.street =='--' || controller.user.value.sex.toString() =='false'){
                          if(controller.birthDate.value.toString().contains('-')){
                            controller.user.value.birthday = controller.birthDate.value,
                          },
                          controller.updateProfile(),
                        },

                        if ((controller.travelCard['booking_type'] != null && controller.travelCard['booking_type'].toLowerCase() == "road") || Get.find<BookingsController>().offerExpedition.value) {
                          for(var a=1; a<13; a++){
                            controller.sendRoadImages(a, controller.imageFiles[a-1]),
                          },
                          print('Valueeeeeeeeeeeeeeee: ${Get.find<BookingsController>().offerExpedition.value}'),
                          //Get.find<BookingsController>().offerExpedition.value = false,
                          Get.find<BookingsController>().offerExpedition.value?
                          await controller.createExpeditionOffer()
                              :await controller.shipRoadNow(),
                        }
                        else{
                          await controller.createAirLuggage(),
                          if(controller.airLuggageCreated.value){
                            await controller.shipAirNow(),
                          }
                          else{
                            Get.showSnackbar(Ui.ErrorSnackBar(message: "Your luggage was not created, Please try again".tr)),
                          }


                        }


                      },
                      color: Get.theme.colorScheme.secondary,
                      text: !controller.buttonPressed.value ?
                      SizedBox(
                        width: Get.width/1.8,
                        child: Center(
                            child: Text(AppLocalizations.of(context).submitForm.tr,
                              style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                            )
                        ),
                      ): SizedBox(height: 20,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                        : controller.formStep.value == 3?
                    BlockButtonWidget(
                      onPressed: () async =>{
                        controller.buttonPressed.value = true,


                        if ((controller.travelCard['booking_type'] != null && controller.travelCard['booking_type'].toLowerCase() == "road") || Get.find<BookingsController>().offerExpedition.value) {
                          for(var a=1; a<13; a++){
                            controller.sendRoadImages(a, controller.imageFiles[a-1]),
                          },
                          print('Valueeeeeeeeeeeeeeee: ${Get.find<BookingsController>().offerExpedition.value}'),
                          //Get.find<BookingsController>().offerExpedition.value = false,
                          Get.find<BookingsController>().offerExpedition.value?
                          controller.editExpeditionOffer(controller.shipping):
                          controller.editRoadShipping(controller.shipping),

                        }
                        else{
                          await controller.updateAirLuggage(),
                          if(controller.selectedPackages.isNotEmpty)
                            {
                              await controller.createAirLuggage(),
                              if(controller.airLuggageCreated.value){
                                await controller.editAirShipping(controller.shipping),
                              }
                              else{
                                Get.showSnackbar(Ui.ErrorSnackBar(message: "Your luggage was not created, Please try again".tr)),
                              }
                            }else{
                            await controller.editAirShipping(controller.shipping),
                          }


                        }

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
                    ).paddingSymmetric(vertical: 10, horizontal: 20) : SizedBox()
                    )
                )
            )
          ],
        )
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(controller.formStep.value != 0)
                previousButton(),
              Spacer(),
              if(!controller.showButton.value)
                nextButton(),
            ],
          ),
        )
        ),

        body: Obx(() => Container(
          decoration: BoxDecoration(color: backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)), ),
          child: Theme(
              data: ThemeData(
                //canvasColor: Colors.yellow,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: !controller.editing.value ? controller.formStep.value != 4 ? Get.theme.colorScheme.secondary : validateColor
                        :controller.formStep.value != 3 ? Get.theme.colorScheme.secondary : validateColor,
                    background: Colors.red,
                    secondary: validateColor,
                  )
              ),
              child: _buildStepperForm(Get.context)

          ),
        ),
        )
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

              if(controller.editing.value)...[
                Icon(Icons.balance,color: controller.formStep.value == 1 ? Colors.white : null),
                Icon(Icons.image,color: controller.formStep.value == 2 ? Colors.white : null),
                Icon(Icons.verified_user_sharp,color: controller.formStep.value == 3 ? Colors.white : null),
                Icon(Icons.verified,color: controller.formStep.value == 4 ? Colors.white : null),

              ] else...[
                Icon(Icons.balance,color: controller.formStep.value == 1 ? Colors.white : null),
                Icon(Icons.image,color: controller.formStep.value == 2 ? Colors.white : null),
                Icon(Icons.person_add,color: controller.formStep.value == 2 ? Colors.white : null ),
                Icon(Icons.verified_user_sharp,color: controller.formStep.value == 4 ? Colors.white : null),
                Icon(Icons.verified,color: controller.formStep.value == 5 ? Colors.white : null),


              ]

            ],



            // activeStep property set to activeStep variable defined above.
            activeStep: controller.formStep.value,

            enableNextPreviousButtons: false,
            enableStepTapping: false,


            // This ensures step-tapping updates the activeStep.
            onStepReached: (index) {
              // controller.formStep.value = index;
              // Get.showSnackbar(Ui.InfoSnackBar(message: "${AppLocalizations.of(Get.context).step} $index"));


            },
          ),
          header(),

          Expanded(
            child:controller.editing.value ?
            controller.formStep.value == 0 ? controller.shipping['booking_type'] == "By Air"?FadeIn(delay: 30,child: build_book_air_travel(context)):FadeIn(delay: 30,child: build_book_road_travel(Get.context, controller.travelCard['booking_type']))
                : controller.formStep.value == 1 ? DelayedAnimation(delay: 30, child: addImages(Get.context))
                :controller.formStep.value == 2 ? FadeIn(delay: 30, child: build_Receiver_details(Get.context))
                : DelayedAnimation(delay: 30, child: build_overView(Get.context))
                :
            controller.formStep.value == 0 ? !Get.find<BookingsController>().offerExpedition.value?
            controller.travelCard['booking_type'] != null &&controller.travelCard['booking_type'].toLowerCase() == "air"?
            FadeIn(delay: 30,child: build_book_air_travel(context)):FadeIn(delay: 30,child: build_book_road_travel(Get.context, controller.travelCard['booking_type'])):FadeIn(delay: 30,child: build_book_road_travel(Get.context, controller.travelCard['booking_type']))
                : controller.formStep.value == 1 ? DelayedAnimation(delay: 30, child: addImages(Get.context))
                : controller.formStep.value == 2 ? FadeIn(delay: 30, child: complete_user_info(Get.context))
                : controller.formStep.value == 3? DelayedAnimation(delay: 30, child: build_Receiver_details(Get.context))
                :FadeIn(delay: 30, child: build_overView(Get.context)),
          ),
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



  /// Returns the next button.
  Widget nextButton() {
    return Container(
      // width: Get.width,
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
          // Increment activeStep, when the next button is tapped. However, check for upper bound.
          if(!controller.editing.value){

            if(controller.formStep.value != 4){
              if(controller.formStep.value == 0){
                if(controller.travelCard['booking_type'] == 'road' || Get.find<BookingsController>().offerExpedition.value){
                  if(controller.luggageSelected.isNotEmpty){
                    controller.formStep.value++;

                  }else{
                    Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).atLeastLuggageModelError));
                  }
                }
                else{
                  if(controller.selectedPackages.length > 0){

                    controller.formStep.value +=2;

                  }
                  else{
                    Get.showSnackbar(Ui.warningSnackBar(
                        message: 'Please add at least one luggage to ship'
                            .tr));
                  }
                }

              }else{
                if(controller.formStep.value == 1){
                  if(controller.imageFiles.length >= 12){
                    if(controller.travelCard['booking_type'] == 'road'|| Get.find<BookingsController>().offerExpedition.value){
                      controller.luggageId.value = [];
                      for(var i = 0; i < controller.luggageSelected.length; i++){
                        controller.createShippingLuggage();
                      }
                    }
                    else{
                      controller.formStep.value++;
                    }
                  }else{
                    Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).numberImageSelectedError));
                  }
                }else{
                  if(controller.formStep.value == 2){
                    if(controller.birthDate.value == '--/--/--' || controller.birthPlace.value=='--' || controller.residence.value =='--' ||controller.user.value.sex.toString()=='false'){
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).fieldsRequired));
                    }else{
                      controller.formStep.value++;
                    }
                  }
                  else{
                    if(controller.createUser.value){
                      if(controller.selectedUser.value){
                        controller.formStep.value++;
                        controller.showButton.value = true;

                      }else{
                          controller.formStep.value++;
                          controller.showButton.value = true;

                        //Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).selectBeneficiaryError));
                      }
                    }else{
                      if(controller.receiverDto.isNotEmpty){
                        controller.formStep.value++;
                        controller.showButton.value = true;
                      }else{
                        Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).selectBeneficiaryError));
                      }
                    }
                  }

                }
              }
            }

          }
          else{
            if(controller.formStep.value != 3){
              if(controller.formStep.value == 0){
                if(controller.shipping['booking_type'] == 'By Road' || controller.shipping['booking_type'] == ''){
                  if(controller.editLuggage.value){
                    if(controller.luggageSelected.isNotEmpty){
                      controller.formStep.value++;
                    }else{
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).selectLuggageModelError));
                    }
                  }else{
                    controller.formStep.value++;
                  }
                }
                else{
                  if(controller.selectedPackages.length + controller.specificAirShippingLuggage.length > 0){

                    controller.formStep.value +=2;

                  }
                  else{
                    Get.showSnackbar(Ui.warningSnackBar(
                        message: 'Please add at least one luggage to ship'
                            .tr));
                  }



                }

              }else{
                if(controller.formStep.value == 1){
                  if(!controller.editLuggage.value){
                    controller.formStep.value++;
                  }else{
                    if(controller.imageFiles.length >= 12){
                      controller.luggageId.value = [];
                      for(var i = 0; i < controller.luggageSelected.length; i++){
                        controller.createShippingLuggage();
                      }

                    }else{
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).luggageModelImageError));
                    }
                  }
                }else{
                  if(controller.formStep.value == 2){
                    if(controller.createUser.value){
                      if(controller.selectedUser.value){
                        controller.formStep.value++;
                        controller.showButton.value = true;
                      }else{
                        if(controller.name.value.isNotEmpty && controller.profileImage != null){
                          controller.formStep.value++;
                          controller.showButton.value = true;
                        }else {
                          Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).selectBeneficiaryError));
                        }
                      }
                    }else{
                      if(controller.receiverDto.isNotEmpty){
                        controller.formStep.value++;
                        controller.showButton.value = true;
                      }else{
                        Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(Get.context).selectBeneficiaryError));
                      }
                    }
                  }

                }
              }

            }else{
              controller.showButton.value = true;
            }
          }

        },
        child: Text('Next'),
      ),
    );
  }

  /// Returns the previous button.
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
          if (activeStep > 0) {
            activeStep--;

          }
          controller.showButton.value = false;
          controller.buttonPressed.value = false;
          if(controller.travelCard['booking_type'] != null){
            if(controller.travelCard['booking_type'] == 'road'){
              if(controller.formStep.value == 1){
                if(controller.editLuggage.value || !controller.editing.value){
                  controller.deleteShippingLuggage(controller.luggageId);
                }else{
                  controller.formStep.value--;
                }

              }else{
                controller.formStep.value--;
              }
            }
            else{
              if(controller.formStep.value == 1){
                if(controller.editLuggage.value || !controller.editing.value){
                  controller.deleteShippingLuggage(controller.luggageId);
                }else{
                  controller.formStep.value--;
                }

              }else{
                if(controller.formStep.value == 2){
                  controller.formStep.value -=2;
                }
                else{
                  controller.formStep.value--;
                }

              }

            }
          }
          else{
            if(controller.shipping['booking_type'] == 'By Road'){
              if(controller.formStep.value == 1){
                if(controller.editLuggage.value || !controller.editing.value){
                  controller.deleteShippingLuggage(controller.luggageId);
                }else{
                  controller.formStep.value--;
                }

              }else{
                controller.formStep.value--;
              }
            }
            else{
              if(controller.formStep.value == 1){
                if(controller.editLuggage.value || !controller.editing.value){
                  controller.deleteShippingLuggage(controller.luggageId);
                }else{
                  controller.formStep.value--;
                }

              }else{
                if(controller.formStep.value == 2){
                  controller.formStep.value -=2;
                }
                else{
                  controller.formStep.value--;
                }

              }

            }

          }
        },
        child: Text('Prev'),
      ),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    if(!controller.editing.value) {
      switch (controller.formStep.value) {
        case 1:
          return 'Parcel Images';

        case 2:
          return 'Publisher Information';

        case 3:
          return 'Beneficiary';

        case 4:
          return 'Details Summary';



        default:
          return 'Luggage ';
      }
    }
    else{
      switch (controller.formStep.value) {
        case 1:
          return 'Parcel Images';

        case 2:
          return 'Beneficiary';

        case 3:
          return 'Details Summary ';


        default:
          return 'Luggage ';
      }
    }

  }

  Widget build_book_road_travel(BuildContext context, String travelType) {

    return Obx(
            () => ListView(
          primary: true,
          children: [
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 20,
              children: <Widget>[
                if(controller.editing.value)
                  SwitchListTile( //switch at right side of label
                      value: controller.editLuggage.value,
                      onChanged: (bool value)async{

                        controller.editLuggage.value = value;

                      },//luggageSelected
                      title: Text(AppLocalizations.of(context).editLuggageType, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, color: appColor)))
                  ),
                !controller.editing.value || controller.editLuggage.value ?
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context).selectLuggageType, style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
                          SizedBox(height: 10),
                          ExpansionTile(
                            title: Text(AppLocalizations.of(context).luggageType.tr, style: Get.textTheme.bodyText1.merge(TextStyle(color: appColor, fontSize: 15))),
                            children: [
                              Obx(() => RadioListTile(
                                title: Text(controller.roadLuggageTypes[0], style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
                                value: controller.locale.languageCode=='fr'? controller.roadLuggageTypeFrench.value:controller.roadLuggageType.value,
                                groupValue: AppLocalizations.of(context).envelopeType,
                                onChanged: (value){
                                  controller.roadLuggageType.value = "envelope";
                                  controller.roadLuggageTypeFrench.value = "enveloppe";
                                },
                              )),
                              Obx(() => RadioListTile(
                                title: Text(controller.roadLuggageTypes[1], style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
                                value: controller.locale.languageCode=='fr'? controller.roadLuggageTypeFrench.value:controller.roadLuggageType.value,
                                groupValue: AppLocalizations.of(context).briefcaseType,
                                onChanged: (value){
                                  controller.roadLuggageType.value = "briefcase";
                                  controller.roadLuggageTypeFrench.value = "mallette";
                                },
                              )),
                              Obx(() => RadioListTile(
                                title: Text(controller.roadLuggageTypes[2], style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
                                value: controller.locale.languageCode=='fr'? controller.roadLuggageTypeFrench.value:controller.roadLuggageType.value,
                                groupValue: AppLocalizations.of(context).suitcaseType,
                                onChanged: (value){
                                  controller.roadLuggageType.value = "suitcase";
                                  controller.roadLuggageTypeFrench.value = "valise";
                                },
                              )),
                            ],
                            initiallyExpanded: true,
                          ),
                          if(controller.roadLuggageType.value.isNotEmpty && controller.roadLuggageType.value != "other")
                            SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            if(!controller.luggageLoading.value)...[
                                              for(var i=0; i< controller.luggageModels.length; i++)...[
                                                if(controller.luggageModels[i]['type'] == controller.roadLuggageType.value)
                                                  GestureDetector(
                                                      onTap: () {
                                                        print('luggageSelected: ${controller.luggageSelected.value}');
                                                        if(controller.luggageSelected.isNotEmpty){
                                                          controller.luggageSelected.removeAt(0);
                                                          controller.luggageSelected.add(controller.luggageModels[i]);
                                                          controller.luggageDto.value = controller.luggageModels[i];
                                                          controller.luggageHeight.value = controller.luggageModels[i]['average_height'].toString();
                                                          controller.luggageWidth.value = controller.luggageModels[i]['average_width'].toString();
                                                          controller.luggageWeight.value = controller.luggageModels[i]['average_weight'].toString();
                                                          controller.luggageDescription.value = controller.luggageModels[i]['name'];

                                                          controller.descriptionText.text = controller.luggageModels[i]['name'];
                                                          controller.heightText.text = controller.luggageModels[i]['average_height'].toString();
                                                          controller.widthText.text = controller.luggageModels[i]['average_width'].toString();
                                                          controller.weightText.text = controller.luggageModels[i]['average_weight'].toString();
                                                          print(controller.weightText.text);
                                                        }else{
                                                          controller.luggageSelected.add(controller.luggageModels[i]);
                                                          controller.luggageDto.value = controller.luggageModels[i];
                                                          print(controller.luggageDto);
                                                          controller.luggageHeight.value = controller.luggageModels[i]['average_height'].toString();
                                                          controller.luggageWidth.value = controller.luggageModels[i]['average_width'].toString();
                                                          controller.luggageWeight.value = controller.luggageModels[i]['average_weight'].toString();
                                                          controller.luggageDescription.value = controller.luggageModels[i]['name'];

                                                          controller.descriptionText.text = controller.luggageModels[i]['name'];
                                                          controller.heightText.text = controller.luggageModels[i]['average_height'].toString();
                                                          controller.widthText.text = controller.luggageModels[i]['average_width'].toString();
                                                          controller.weightText.text = controller.luggageModels[i]['average_weight'].toString();
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(5),
                                                        margin: EdgeInsets.only(right: 10),
                                                        height: 150,
                                                        width: 130,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            border: controller.luggageSelected.contains(controller.luggageModels[i])
                                                                ? Border.all(color: interfaceColor, width: 3) : Border.all(color: Colors.grey),
                                                            color: backgroundColor
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            controller.luggageModels[i]['type'] == "envelope" ?
                                                            Text("${controller.luggageModels[i]['type']} ${controller.luggageModels[i]['nature']}") : Text("${controller.luggageModels[i]['type']}"),
                                                            SizedBox(width: 10),
                                                            controller.luggageModels[i]['type'] == "envelope" ?
                                                            Icon(FontAwesomeIcons.envelope, size: 30) : controller.luggageModels[i]['type'] == "briefcase" ? Icon(FontAwesomeIcons.briefcase, size: 30) : Icon(FontAwesomeIcons.suitcase, size: 30),
                                                            ListTile(
                                                                title: Text("${controller.luggageModels[i]['average_height']} x ${controller.luggageModels[i]['average_width']}", style: TextStyle(color: appColor)),
                                                                subtitle: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("${controller.luggageModels[i]['amount_to_deduct']} EUR", style: TextStyle(color: Colors.red)),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Icon(FontAwesomeIcons.shoppingBag, size: 13,),
                                                                        SizedBox(width: 10),
                                                                        Text('${controller.luggageModels[i]['average_weight']} Kg'),
                                                                      ],
                                                                    )
                                                                  ],
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )
                                              ]
                                            ]else...[
                                              Row(
                                                children: [
                                                  SizedBox(width: MediaQuery.of(context).size.width/2.7),
                                                  SizedBox(
                                                      height: 20,
                                                      child: SpinKitThreeBounce(color: interfaceColor, size: 20)),
                                                ],
                                              )
                                            ]
                                          ],
                                        ))
                                  ],
                                )
                            ),

                          if(controller.luggageSelected.isNotEmpty)
                            ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(AppLocalizations.of(context).luggageDetails, style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
                              children: [
                                TextFieldWidget(
                                  controller: controller.weightText,
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  //initialValue: controller.luggageWeight.value,
                                  validator: (input) => input.isEmpty ? AppLocalizations.of(context).fieldsRequired.tr : null,
                                  onChanged: (input) => controller.luggageWeight.value = input,
                                  labelText: AppLocalizations.of(context).weight.tr,
                                  iconData: FontAwesomeIcons.weightHanging,
                                ),
                                TextFieldWidget(
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  controller: controller.heightText,
                                  //initialValue: controller.luggageHeight.value,
                                  validator: (input) => input.isEmpty ? AppLocalizations.of(context).fieldsRequired.tr : null,
                                  onChanged: (input) => controller.luggageHeight.value = input,
                                  labelText: AppLocalizations.of(context).height.tr,
                                  iconData: FontAwesomeIcons.rulerVertical,
                                ),

                                TextFieldWidget(
                                  readOnly: false,
                                  controller: controller.widthText,
                                  //initialValue: controller.luggageWidth.value,
                                  keyboardType: TextInputType.number,
                                  validator: (input) => input.isEmpty ? AppLocalizations.of(context).fieldsRequired.tr : null,
                                  onChanged: (input) => controller.luggageWidth.value = input,
                                  labelText: AppLocalizations.of(context).width.tr,
                                  iconData: FontAwesomeIcons.rulerHorizontal,
                                ),
                                Column(
                                    children: <Widget>[
                                      Card(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:  TextFormField(
                                                textInputAction: TextInputAction.done,
                                                //initialValue: controller.luggageDescription.value,
                                                controller: controller.descriptionText,
                                                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                                cursorColor: Colors.black,
                                                maxLines: 5,
                                                minLines: 2,
                                                onChanged: (input) => controller.luggageDescription.value = input,
                                                decoration: InputDecoration(
                                                  label: Text(AppLocalizations.of(context).description, style: TextStyle(fontSize: 14, color: Colors.black),),
                                                  fillColor: Palette.background,
                                                  filled: true,
                                                  prefixIcon: Icon(Icons.description),
                                                  hintText: AppLocalizations.of(context).enterLuggageDescription, ),

                                              )
                                          )
                                      )
                                    ]
                                )
                              ],
                            )
                        ],
                      ),
                    )),
                  ],
                ) :
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Obx(() => Container(
                        padding: EdgeInsets.all( 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        child: Column(
                            children: [
                              for(var item in controller.luggageSelected)...[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 10),
                                  height: 150,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: interfaceColor, width: 3),
                                      color: backgroundColor
                                  ),
                                  child: Column(
                                    children: [
                                      item['type'] == "envelope" ?
                                      Text("${item['type']} ${item['nature']}") : Text("${item['type']}"),
                                      SizedBox(width: 10),
                                      item['type'] == "envelope" ?
                                      Icon(FontAwesomeIcons.envelope, size: 30) : item['type'] == "briefcase" ? Icon(FontAwesomeIcons.briefcase, size: 30) : Icon(FontAwesomeIcons.suitcase, size: 30),
                                      SizedBox(height: 10),
                                      ListTile(
                                          title: Text("${item['average_height']} x ${item['average_width']}", style: TextStyle(color: appColor)),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${item['amount_to_deduct']} EUR", style: TextStyle(color: Colors.red)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(FontAwesomeIcons.shoppingBag, size: 13,),
                                                  SizedBox(width: 10),
                                                  Text('${item['average_weight']} Kg'),
                                                ],
                                              )
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                )
                              ]
                            ]
                        )
                    )),
                  ],
                )
              ],
            )
          ],

        ).marginOnly(bottom: 80)
    );
  }



  Widget addImages(BuildContext context){
    return ListView(
      primary: true,
      children: [
        SizedBox(height: 15),
        if(!controller.editing.value || controller.editLuggage.value)...[
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
          // Obx(() => Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //     color: Colors.white,
          //   ),
          //   padding: EdgeInsets.all(10),
          //   margin: EdgeInsets.only(bottom: 20),
          //   child: Column(
          //     children: [
          //       Align(
          //         child: Text(AppLocalizations.of(context).inputPacketFiles.tr, style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
          //         alignment: Alignment.topLeft,
          //       ),
          //       SizedBox(height: 10),
          //       controller.imageFiles.length <= 0 ? GestureDetector(
          //           onTap: () {
          //             showDialog(
          //                 context: Get.context,
          //                 builder: (_){
          //                   return AlertDialog(
          //                     shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.all(Radius.circular(20))
          //                     ),
          //                     content: Container(
          //                         height: 140,
          //                         padding: EdgeInsets.all(10),
          //                         child: Column(
          //                             children: [
          //                               ListTile(
          //                                 onTap: ()async{
          //                                   await controller.pickImage(ImageSource.camera);
          //                                   Navigator.pop(Get.context);
          //                                 },
          //                                 leading: Icon(FontAwesomeIcons.camera),
          //                                 title: Text(AppLocalizations.of(context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
          //                               ),
          //                               ListTile(
          //                                 onTap: ()async{
          //                                   await controller.pickImage(ImageSource.gallery);
          //                                   Navigator.pop(Get.context);
          //                                 },
          //                                 leading: Icon(FontAwesomeIcons.image),
          //                                 title: Text(AppLocalizations.of(context).uploadImage, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
          //                               )
          //                             ]
          //                         )
          //                     ),
          //                     actions: [
          //                       TextButton(
          //                           onPressed: ()=> Navigator.pop(context),
          //                           child: Text(AppLocalizations.of(context).cancel, style: Get.textTheme.headline4.merge(TextStyle(color: inactive)),))
          //                     ],
          //                   );
          //                 });
          //           },
          //           child: Container(
          //             width: 100,
          //             height: 100,
          //             padding: EdgeInsets.all(20),
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          //             child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
          //           )
          //       )
          //           : Column(
          //         children: [
          //           SizedBox(
          //             height:Get.height/2.2,
          //             child: ListView.separated(
          //                 scrollDirection: Axis.vertical,
          //                 padding: EdgeInsets.all(12),
          //                 itemBuilder: (context, index){
          //                   return Stack(
          //                     //mainAxisAlignment: MainAxisAlignment.end,
          //                     children: [
          //                       Padding(
          //                           padding: EdgeInsets.symmetric(vertical: 10),
          //                           child: ClipRRect(
          //                             borderRadius: BorderRadius.all(Radius.circular(10)),
          //                             child: Image.file(
          //                               controller.imageFiles[index],
          //                               fit: BoxFit.cover,
          //                               width: Get.width/2,
          //                               height: 100,
          //                             ),
          //                           )
          //                       ),
          //                       Positioned(
          //                         top:0,
          //                         right:0,
          //                         child: Align(
          //                           //alignment: Alignment.centerRight,
          //                           child: IconButton(
          //                               onPressed: (){
          //                                 controller.imageFiles.removeAt(index);
          //                               },
          //                               icon: Icon(Icons.delete, color: inactive, size: 25, )
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 },
          //                 separatorBuilder: (context, index){
          //                   return SizedBox(width: 8);
          //                 },
          //                 itemCount: controller.imageFiles.length),
          //           ),
          //           Align(
          //             alignment: Alignment.centerRight,
          //             child: Visibility(
          //                 child: InkWell(
          //                   onTap: (){
          //                     showDialog(
          //                         context: Get.context,
          //                         builder: (_){
          //                           return AlertDialog(
          //                             shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.all(Radius.circular(20))
          //                             ),
          //                             content: Container(
          //                                 height: 140,
          //                                 padding: EdgeInsets.all(10),
          //                                 child: Column(
          //                                   children: [
          //                                     ListTile(
          //                                       onTap: ()async{
          //                                         await controller.pickImage(ImageSource.camera);
          //                                         Navigator.pop(Get.context);
          //                                       },
          //                                       leading: Icon(FontAwesomeIcons.camera),
          //                                       title: Text(AppLocalizations.of(context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
          //                                     ),
          //                                     ListTile(
          //                                       onTap: ()async{
          //                                         await controller.pickImage(ImageSource.gallery);
          //                                         Navigator.pop(Get.context);
          //                                       },
          //                                       leading: Icon(FontAwesomeIcons.image),
          //                                       title: Text(AppLocalizations.of(context).uploadImage, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
          //                                     )
          //                                   ],
          //                                 )
          //                             ),
          //                             actions: [
          //                               TextButton(
          //                                   onPressed: ()=> Navigator.pop(context),
          //                                   child: Text(AppLocalizations.of(context).cancel, style: Get.textTheme.headline4.merge(TextStyle(color: inactive)),))
          //                             ],
          //                           );
          //                         });
          //                   },
          //                   child: Icon(FontAwesomeIcons.circlePlus),
          //                 )
          //             ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),),
        ]else...[
          for(var i in controller.shippingLuggage)...[
            SizedBox(
                width: double.infinity,
                height: Get.height/2,
                child:  Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 12,
                          itemBuilder: (context, index){
                            return InkWell(
                                onTap: ()=> showDialog(context: context, builder: (_){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                          child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: FadeInImage(
                                          width: Get.width,
                                          height: Get.height/2,
                                          image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${i['id']}/luggage_image${index+1}?unique=true&file_response=true',
                                              headers: Domain.getTokenHeaders()),
                                          placeholder: AssetImage(
                                              "assets/img/loading.gif"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Container(
                                                    width: Get.width/1.5,
                                                    height: Get.height/3,
                                                    color: Colors.white,
                                                    child: Center(
                                                        child: Icon(Icons.photo, size: 150)
                                                    )
                                                )
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                }),
                                child: Card(
                                    margin: EdgeInsets.all(10),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: FadeInImage(
                                          width: 120,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${i['id']}/luggage_image${index+1}?unique=true&file_response=true',
                                              headers: Domain.getTokenHeaders()),
                                          placeholder: AssetImage(
                                              "assets/img/loading.gif"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                                width: 120,
                                                height: 80,
                                                fit: BoxFit.fitWidth);
                                          },
                                        )
                                    )
                                )
                            );
                          }),
                    )
                  ],
                )
            ),
          ]
        ]
      ],
    ).marginOnly(bottom: 50);
  }

  Widget complete_user_info(BuildContext context) {

    return ListView(
        primary: true,
        children: [Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(() => Container(
                padding: EdgeInsets.all( 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: (){
                          if(controller.birthDate.value == "--/--/--"){
                            controller.chooseBirthDate();
                            //controller.user.value.birthday = DateFormat('yy/MM/dd').format(controller.birthDate.value);
                            ///controller.birthDateSet.value = true;
                          }
                          else{
                            controller.chooseBirthDate();
                          }
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
                                    )
                                );
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
                            subtitle: Text(controller.user.value.sex=='false'?AppLocalizations.of(context).notDefined:controller.user.value.sex.toString(),style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
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
                                border: Border.all(color: controller.errorCity1.value ? specialColor : Get.theme.focusColor.withOpacity(0.05))),
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
                                            //initialValue: controller.travelCard.isEmpty  controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                                            style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                            onChanged: (value)=>{
                                              if(value.isNotEmpty){
                                                controller.errorCity1Profile.value = false
                                              },
                                              if(value.length > 2){
                                                controller.predict1Profile.value = true,
                                                controller.filterSearchCity(value)
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
                                          //initialValue: controller.travelCard.isEmpty  controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                                          style: Get.textTheme.headline1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                          onChanged: (value)=>{
                                            if(value.length > 2){
                                              controller.predict2Profile.value = true,
                                              controller.filterSearchCity(value)
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
              )
              )
            ]
        )]
    );
  }

  Widget build_Receiver_details(BuildContext context) {
    return ListView(
        primary: true,
        children: [Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SwitchListTile( //switch at right side of label
                value: controller.createUser.value,
                onChanged: (bool value){
                  controller.createUser.value = value;
                },
                title: Text(AppLocalizations.of(context).newReceiver, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, color: Colors.black)))
            ),
            controller.createUser.value ?
            Column(
              children: [
                TextFieldWidget(
                  readOnly: false,
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? AppLocalizations.of(context).fieldsRequired.tr : null,
                  onChanged: (input) => controller.name.value = input,
                  labelText: AppLocalizations.of(context).fullName.tr,
                  iconData: FontAwesomeIcons.person,
                ),
                Obx(() =>
                    Column(
                      children: [
                        TextFieldWidget(
                          readOnly: false,
                          keyboardType: TextInputType.text,
                          validator: (input) => input.isEmpty ? AppLocalizations.of(context).fieldsRequired.tr : null,
                          onChanged: (input) =>{
                            if(input.length > 3){
                              controller.searchUser(input)
                            }
                          },
                          labelText: AppLocalizations.of(context).emailAddress.tr,
                          iconData: Icons.alternate_email,
                        ),
                        controller.typing.value ?
                        !controller.userExist.value ?
                        Text(AppLocalizations.of(context).emailAvailable, style: TextStyle(color: validateColor)) :
                        Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            width: Get.width,
                            child: Row(
                              children: [
                                Text(AppLocalizations.of(context).emailExist.tr, style: Get.textTheme.bodyText1.
                                merge(TextStyle(color: specialColor, fontSize: 14))),
                                Spacer(),
                                TextButton(onPressed: ()=>{
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          title: Text(AppLocalizations.of(context).selectUser, style: TextStyle(color: appColor, fontSize: 14)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          content: SizedBox(
                                              height: controller.viewUsers.length > 2 ? Get.height/3 : 100,
                                              child: SingleChildScrollView(
                                                  child: Obx(() => Column(
                                                      children: [
                                                        for(var a=0; a<controller.viewUsers.length; a++)...[
                                                          InkWell(
                                                              onTap: ()=>{
                                                                controller.receiverDto.value = controller.viewUsers[a],
                                                                controller.receiverId.value = controller.viewUsers[a]['partner_id'][0]['id'],
                                                                controller.selectedIndex.value = a,
                                                                controller.selectedUser.value = true,
                                                                controller.createUser.value = false
                                                              },
                                                              child: UserWidget(
                                                                user: controller.viewUsers[a]['partner_id'][0]['name'],
                                                                selected: controller.selectedIndex.value == a && controller.selectedUser.value ? true : false,
                                                                imageUrl: '${Domain.serverPort}/image/res.users/${controller.viewUsers[a]['id']}/image_1920?unique=true&file_response=true',
                                                              )
                                                          )
                                                        ]
                                                      ]
                                                  ))
                                              )
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(onPressed: ()=> Navigator.pop(context), child: Text(AppLocalizations.of(context).back, style: Get.textTheme.headline4.merge(TextStyle(color: inactive)))),
                                                SizedBox(width: 10),
                                                TextButton(
                                                    onPressed: ()=> {
                                                      if(controller.selectedUser.value){
                                                        Navigator.pop(context),
                                                        controller.showButton.value = true,
                                                        controller.formStep.value++,
                                                      }
                                                      else{
                                                        Get.showSnackbar(Ui.warningSnackBar(message: 'Please select a beneficiary before proceeding')),
                                                      }

                                                    },
                                                    child: Text(AppLocalizations.of(context).next, style: Get.textTheme.headline4))
                                              ],
                                            )
                                          ],
                                        );
                                      }
                                  )
                                }, child: Text(AppLocalizations.of(context).view, style: TextStyle(decoration: TextDecoration.underline, color: interfaceColor))
                                )
                              ],
                            )
                        ) : SizedBox(height: 10),

                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 10 ),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelStyle: TextStyle(
                          color: Colors.grey
                      ),
                      hintText: '032655333333',
                      label: Text(AppLocalizations.of(context).phoneNumber, style: TextStyle( color: Colors.black, fontSize: 14)),
                      suffixIcon: Icon(Icons.phone_android_outlined),
                    ),
                    style: TextStyle( color: Colors.grey.shade700, fontSize: 12),
                    initialCountryCode: 'BE',
                    onSaved: (phone) {
                      return controller.phone.value = phone.completeNumber;
                    },
                    onChanged: (phone) {
                      String phoneNumber = phone.completeNumber;
                      controller.phone.value = phoneNumber;
                    },
                  ),
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
                        Text(AppLocalizations.of(context).cityBirth,
                          style: Get.textTheme.bodyText1.merge(TextStyle(fontSize: 14, color: Colors.black)),
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
                                  controller: controller.city,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                                  ),
                                  //initialValue: controller.travelCard.isEmpty || controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                                  style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                  onChanged: (value)=>{
                                    if(value.isNotEmpty){
                                      controller.errorCity1.value = false
                                    },
                                    if(value.length > 2){
                                      controller.predict1.value = true,
                                      controller.filterSearchCity(value)
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
                      margin: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
                      color: Get.theme.primaryColor,
                      height: 200,
                      child: ListView(
                          children: [
                            for(var i =0; i < controller.countries.length; i++)...[
                              TextButton(
                                  onPressed: (){
                                    controller.city.text = controller.countries[i]['display_name'];
                                    controller.predict1.value = false;
                                    controller.cityId.value = controller.countries[i]['id'];
                                  },
                                  child: Text(controller.countries[i]['display_name'], style: TextStyle(color: appColor))
                              )
                            ]
                          ]
                      )
                  )),
                TextFieldWidget(
                  readOnly: false,
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? AppLocalizations.of(context).fieldsRequired.tr : null,
                  onChanged: (input) => controller.street.value = input,
                  labelText: AppLocalizations.of(context).street.tr,
                  iconData: FontAwesomeIcons.locationPin,
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(AppLocalizations.of(context).profileImage.tr,
                        style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 14)),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Obx(() {
                            if(!controller.loadProfileImage.value)
                              return buildLoader();
                            else return ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                controller.profileImage,
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

                              await controller.selectCameraOrGalleryProfileImage();
                              controller.loadProfileImage.value = false;

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
            ) :
            Column(
              children: [
                TextFieldWidget(
                  readOnly: false,
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? AppLocalizations.of(context).fieldsRequired.tr : null,
                  //onChanged: (input) => controller.selectUser.value = input,
                  //labelText: "Research receiver".tr,
                  iconData: FontAwesomeIcons.search,
                  hintText: AppLocalizations.of(context).searchByName,
                  onChanged: (value)=>{
                    controller.filterSearchResults(value)
                  },
                ),
                controller.loadingBeneficiaries.value ?
                Column(
                  children: [
                    for(var i=0; i < 5; i++)...[
                      Container(
                          width: Get.width,
                          height: 60,
                          margin: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 40,
                            ),
                          ))
                    ]
                  ],
                ) :
                controller.users.isNotEmpty ?
                Container(
                    margin: EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
                    // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                    ),

                    child: ListView.builder(
                      //physics: AlwaysScrollableScrollPhysics(),
                        itemCount: controller.users.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          if(controller.editing.value){
                            controller.receiverId.value = controller.shipping['receiver_partner_id'][0];
                            if(controller.shipping['receiver_partner_id'][0] == controller.users[index]['id']){
                              controller.receiverDto.value = controller.users[index];
                            }
                          }


                          return GestureDetector(
                              onTap: (){

                                controller.receiverDto.value = controller.users[index];
                                controller.receiverId.value = controller.users[index]['id'];
                                print(controller.receiverId.value.toString());
                                controller.selectedIndex.value = index;
                                controller.selected.value = true;

                              },
                              child: Obx(() => UserWidget(
                                user: controller.users[index]['name'],
                                selected: controller.editing.value && !controller.selected.value?
                                controller.shipping['receiver_partner_id'][0] == controller.users[index]['id'] ? true : false :
                                controller.selectedIndex.value == index && controller.selected.value ? true : false,
                                imageUrl: '${Domain.serverPort}/image/res.partner/${controller.users[index]['id']}/image_1920?unique=true&file_response=true',
                              ))
                          );
                        })
                ) : Container(
                    child: Text(AppLocalizations.of(context).noReceiverFound, style: TextStyle(color: inactive, fontSize: 18))
                        .marginOnly(top:MediaQuery.of(Get.context).size.height*0.2)
                )
              ],
            ),
          ],
        )]
    ).marginOnly(bottom: 100);
  }

  Widget build_overView(BuildContext context){

    return ListView(
        primary: true,
        children: [Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(AppLocalizations.of(context).verifyTravelInfo.tr, textAlign: TextAlign.center, style: Get.textTheme.headline6)
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(AppLocalizations.of(context).receiverInfo.tr, style: Get.textTheme.headline4.merge(TextStyle(color: buttonColor)))
            ),
            SizedBox(height: 10),
            if(controller.editing.value)...[
              if(!controller.createUser.value)...[
                !controller.selectedUser.value ?
                !controller.selected.value ?
                UserWidget(
                  user: controller.shipping['receiver_partner_id'][1],
                  selected: false,
                  imageUrl: '${Domain.serverPort}/image/res.partner/${controller.shipping['receiver_partner_id'][0]}/image_1920?unique=true&file_response=true',
                ) :
                UserWidget(
                  user: controller.receiverDto['name'],
                  selected: false,
                  imageUrl: '${Domain.serverPort}/image/res.partner/${controller.receiverDto['id']}/image_1920?unique=true&file_response=true',
                ) :
                UserWidget(
                  user: controller.receiverDto['partner_id'][0]['name'],
                  selected: false,
                  imageUrl: '${Domain.serverPort}/image/res.partner/${controller.receiverDto['partner_id'][0]['id']}/image_1920?unique=true&file_response=true',
                )
              ]else...[
                if(!controller.selectedUser.value)
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.file(
                            controller.profileImage,
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
                                      child: Text(controller.name.value, style: Get.textTheme.headline4.merge(TextStyle(fontSize: 13, color: buttonColor)), overflow: TextOverflow.ellipsis,)
                                  )
                                ]
                            )
                        )
                      ]
                  )
              ],
            ]else...[
              controller.createUser.value && !controller.selectedUser.value ?
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        controller.profileImage,
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
                                  child: Text(controller.name.value, style: Get.textTheme.headline4.merge(TextStyle(fontSize: 13, color: buttonColor)), overflow: TextOverflow.ellipsis,)
                              )
                            ]
                        )
                    )
                  ]
              ) :

              Obx(() => UserWidget(
                user: controller.selectedUser.value ? controller.receiverDto.isEmpty?'': controller.receiverDto['partner_id'][0]['name'] : controller.receiverDto['name'],
                selected: false,
                imageUrl: controller.selectedUser.value ?
                '${Domain.serverPort}/image/res.partner/${controller.receiverDto['partner_id'][0]['id']}/image_1920?unique=true&file_response=true'
                :'${Domain.serverPort}/image/res.partner/${controller.receiverDto['id']}/image_1920?unique=true&file_response=true',
              ))
            ],
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(AppLocalizations.of(context).luggageInfo, style: Get.textTheme.headline4.merge(TextStyle(color: buttonColor)))
            ),

            if((controller.travelCard['booking_type'] != null && controller.travelCard['booking_type'].toLowerCase() == "road") || Get.find<BookingsController>().offerExpedition.value)...[
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  height: 170,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: backgroundColor
                  ),
                  child: Column(
                      children: [
                        controller.luggageDto['type'] == "envelope" ?
                        Text("${controller.luggageDto['type']} ${controller.luggageDto['nature']}") : Text("${controller.luggageDto['type']}"),
                        SizedBox(width: 10),
                        controller.luggageDto['type'] == "envelope" ?
                        Icon(FontAwesomeIcons.envelope, size: 30) : controller.luggageDto['type'] == "briefcase" ? Icon(FontAwesomeIcons.briefcase, size: 30) : Icon(FontAwesomeIcons.suitcase, size: 30),
                        SizedBox(height: 10),
                        ListTile(
                            title: Text("${controller.luggageHeight.value} x ${controller.luggageWidth.value}", style: TextStyle(color: appColor)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${controller.luggageDto['amount_to_deduct']} EUR", style: TextStyle(color: Colors.red)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(FontAwesomeIcons.shoppingBag, size: 13,),
                                    SizedBox(width: 10),
                                    Text('${controller.luggageWeight.value} Kg'),
                                  ],
                                )
                              ],
                            )
                        ),
                      ]
                  )
              ),
              SizedBox(
                height:100,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index){
                      return Stack(
                        //mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(controller.editing.value && !controller.editLuggage.value)...[
                            ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: FadeInImage(
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${controller.shippingLuggage[index]['id']}/luggage_image${index+1}?unique=true&file_response=true',
                                        headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fitWidth);
                                    }
                                )
                            )
                          ]else...[
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                controller.imageFiles[index],
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            )
                          ]
                        ],
                      );
                    },
                    separatorBuilder: (context, index){
                      return SizedBox(width: 8);
                    },
                    itemCount: controller.editing.value && !controller.editLuggage.value ?
                    controller.shippingLuggage.length : controller.imageFiles.length ),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text(controller.luggageDescription.value, style: TextStyle(color: appColor, fontSize: 12), maxLines: 2),
                trailing: controller.luggageDescription.value.length > 60 ? Text(AppLocalizations.of(context).readMore) : Text(''),
                onTap: ()=> {
                  showDialog(
                      context: context,
                      builder: (_){
                        return AlertDialog(
                          title: Text(controller.luggageDescription.value, style: TextStyle(color: appColor, fontSize: 12)),
                        );
                      }
                  )
                },
              )
            ]
            else...[

              SizedBox(
                height: Get.height/2,
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    primary: false,
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.selectedPackages.length,
                    itemBuilder: (_, index) {
                      return Container(
                        width: 120,
                        height: 150,

                        child: controller.selectedPackages[index].luggageType=='KILO'?
                        KilosWidget(
                          onPressed: (){

                          },
                          imageFiles: controller.selectedPackages[index].imageFiles,
                          kilosDescription: controller.selectedPackages[index].kilosDescription,
                          kilosWeight: controller.selectedPackages[index].kilosWeight,
                          kilosPrice: controller.selectedPackages[index].kilosPrice.value,
                          luggageModelId: controller.selectedPackages[index].luggageModelId,
                          editing: false,
                        ):
                        controller.selectedPackages[index].luggageType=='ENVELOP'?
                        EnvelopWidget(
                          onPressed: (){

                          },
                          envelopDescription: controller.selectedPackages[index].envelopDescription,
                          envelopWeight: controller.selectedPackages[index].envelopWeight,
                          imageFiles: controller.selectedPackages[index].imageFiles,
                          envelopPrice: controller.selectedPackages[index].envelopPrice.value,
                          luggageModelId: controller.selectedPackages[index].luggageModelId,
                          editing: false,
                        ):
                        controller.selectedPackages[index].luggageType=='COMPUTER'?
                        ComputerWidget(
                          onPressed: (){

                          },
                          computerDescription: controller.selectedPackages[index].computerDescription,
                          computerWeight: controller.selectedPackages[index].computerWeight,
                          imageFiles: controller.selectedPackages[index].imageFiles,
                          computerPrice: controller.selectedPackages[index].computerPrice.value,
                          luggageModelId: controller.selectedPackages[index].luggageModelId,
                          editing: false,
                        ):
                        OtherWidget(
                          onPressed: (){

                          },
                          otherDescription: controller.selectedPackages[index].otherDescription,
                          otherWeight: controller.selectedPackages[index].otherWeight,
                          imageFiles: controller.selectedPackages[index].imageFiles,
                          otherPrice: controller.selectedPackages[index].otherPrice.value,
                          modelName: controller.selectedPackages[index].luggageType.value,
                          luggageModelId: controller.selectedPackages[index].luggageModelId,
                          editing: false,
                        )


                      );
                    }).marginOnly(bottom: 100),
              )

            ]

          ],
        )]
    );
  }



  Widget build_book_air_travel(BuildContext context){
    return ListView(
      children: [


        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [Colors.purple,Colors.blue ] )),

          child: MaterialButton(
            onPressed: () async {
              controller.imageFiles.clear();
              showDialog(
                  useSafeArea: true,
                  context: Get.context,
                  builder: (_){
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: ChooseLuggageTypeDialog());
                  });

            },
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            //color: this.color,
            disabledElevation: 0,
            disabledColor: Get.theme.focusColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                Text('Add Luggage', style: TextStyle(color: Colors.white),)

              ],),
            elevation: 0,
          ),
        ).marginOnly(bottom: 30),

        Obx(() =>  controller.editing.value ?
        Row(children: [
          Expanded(child: Text('Number of Luggage shipped:', style: TextStyle(color: labelColor),)),
          Text((controller.specificAirShippingLuggage.length ).toString(), style: TextStyle(fontSize: 16),).marginOnly(bottom: 10),
        ],):
        Row(children: [
          Expanded(child: Text('Number of Luggage to ship:', style: TextStyle(color: labelColor))),
          Text(controller.selectedPackages.length.toString(), style: TextStyle(fontSize: 16),).marginOnly(bottom: 10),
        ],)),


        Obx(() =>  controller.editing.value ?
        SizedBox(
          height: Get.height/4,
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 10),
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: controller.specificAirShippingLuggage.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                    child:  Container(
                      width: Get.width-40,
                      height: 150,

                      child: controller.specificAirShippingLuggage[index]['luggage_type_id'][1]=='KILO'?
                      KilosWidget(
                        onEditPressed: (){
                          showDialog(
                              useSafeArea: true,
                              context: Get.context,
                              builder: (_){
                                return Dialog(

                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        )),
                                    child: KilosDialog(editing: true, luggage: controller.specificAirShippingLuggage[index]));
                              });
                        },

                        kilosDescription: controller.specificAirShippingLuggage[index]['name'],
                        kilosWeight: controller.specificAirShippingLuggage[index]['average_weight'],
                        kilosPrice: controller.specificAirShippingLuggage[index]['price'],
                        luggageModelId: controller.specificAirShippingLuggage[index]['luggage_type_id'][0],
                        imageFiles: [],
                        editing: true,
                      ):
                      controller.specificAirShippingLuggage[index]['luggage_type_id'][1]=='ENVELOP'?
                      EnvelopWidget(
                        onEditPressed: (){
                          showDialog(
                              useSafeArea: true,
                              context: Get.context,
                              builder: (_){
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        )),
                                    child: EnvelopDialog(editing: true,luggage: controller.specificAirShippingLuggage[index]));
                              });

                        },
                        envelopDescription: controller.specificAirShippingLuggage[index]['name'],
                        imageFiles: [],
                        envelopPrice: controller.specificAirShippingLuggage[index]['price'],
                        envelopWeight: controller.specificAirShippingLuggage[index]['average_weight'],
                        luggageModelId: controller.specificAirShippingLuggage[index]['luggage_type_id'][0],
                        editing: true,
                      ):
                      controller.specificAirShippingLuggage[index]['luggage_type_id'][1]=='COMPUTER'?
                      ComputerWidget(
                        onEditPressed: (){
                          showDialog(
                              useSafeArea: true,
                              context: Get.context,
                              builder: (_){
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        )),
                                    child: ComputerDialog(editing: true,luggage: controller.specificAirShippingLuggage[index]));
                              });

                        },
                        computerDescription: controller.specificAirShippingLuggage[index]['name'],
                        imageFiles: [],
                        computerPrice:controller.specificAirShippingLuggage[index]['price'],
                        computerWeight: controller.specificAirShippingLuggage[index]['average_weight'],
                        luggageModelId: controller.specificAirShippingLuggage[index]['luggage_type_id'][0],
                        editing: true,
                      ):
                      OtherWidget(
                        onEditPressed: (){
                          showDialog(
                              useSafeArea: true,
                              context: Get.context,
                              builder: (_){
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        )),
                                    child: OtherDialog(editing: true,luggage: controller.specificAirShippingLuggage[index]));
                              });

                        },
                        otherDescription: controller.specificAirShippingLuggage[index]['name'],
                        imageFiles: [],
                        otherPrice:controller.specificAirShippingLuggage[index]['price'],
                        otherWeight: controller.specificAirShippingLuggage[index]['average_weight'],
                        modelName: controller.specificAirShippingLuggage[index]['luggage_type_id'][1].toString().toLowerCase() ,
                        luggageModelId: controller.specificAirShippingLuggage[index]['luggage_type_id'][0],
                        editing: true,
                      ),


                    ),

                    onTap: ()=>{
                      if(controller.specificAirShippingLuggage[index]['luggage_type_id'][1]=='KILO'){
                        controller.kilosLuggageId.value = controller.specificAirShippingLuggage[index]['id']

                      }else if(controller.specificAirShippingLuggage[index]['luggage_type_id'][1]=='ENVELOP'){
                        controller.envelopLuggageId.value = controller.specificAirShippingLuggage[index]['id']

                      }else if(controller.specificAirShippingLuggage[index]['luggage_type_id'][1]=='COMPUTER'){
                        controller.computerLuggageId.value = controller.specificAirShippingLuggage[index]['id']

                      }else{
                        controller.modelLuggageId.value = controller.specificAirShippingLuggage[index]['id']
                      }


                    }
                  //Get.toNamed(Routes.E_SERVICE, arguments: {'eService': travel, 'heroTag': 'services_carousel'})
                );
              }),
        ):SizedBox(),
        ),

        Obx(() =>  controller.editing.value ?
        Row(children: [
          Expanded(child: Text('New Added Luggage:', style: TextStyle(color: labelColor),)),
          Text(( controller.selectedPackages.length).toString(), style: TextStyle(fontSize: 16),).marginOnly(bottom: 10),
        ],):SizedBox()
       ),



        Obx(() => controller.selectedPackages.isNotEmpty ?
        SizedBox(
          height: Get.height/2,
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 10),
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
              itemCount: controller.selectedPackages.length,
              itemBuilder: (_, index) {
                return Container(
                  width: 120,
                  height: 150,

                  child: controller.selectedPackages[index].luggageType=='KILO'?
                  KilosWidget(
                    onPressed: (){
                      controller.selectedPackages.remove(controller.selectedPackages[index]);

                    },
                    kilosPrice: controller.selectedPackages[index].kilosPrice.value,
                    kilosDescription: controller.selectedPackages[index].kilosDescription,
                    kilosWeight: controller.selectedPackages[index].kilosWeight,
                    imageFiles: controller.selectedPackages[index].imageFiles,
                    luggageModelId: controller.selectedPackages[index].luggageModelId,
                    editing: false,
                  ):
                  controller.selectedPackages[index].luggageType=='ENVELOP'?
                  EnvelopWidget(
                    onPressed: (){
                      controller.selectedPackages.remove(controller.selectedPackages[index]);

                    },
                    envelopPrice: controller.selectedPackages[index].envelopPrice.value,
                    envelopDescription: controller.selectedPackages[index].envelopDescription,
                    envelopWeight: controller.selectedPackages[index].envelopWeight,
                    imageFiles: controller.selectedPackages[index].imageFiles,
                    luggageModelId: controller.selectedPackages[index].luggageModelId,
                    editing: false,
                  ):
                  controller.selectedPackages[index].luggageType=='COMPUTER'?
                  ComputerWidget(
                    onPressed: (){
                      controller.selectedPackages.remove(controller.selectedPackages[index]);

                    },
                    computerPrice:controller.selectedPackages[index].computerPrice.value ,
                    computerDescription: controller.selectedPackages[index].computerDescription,
                    computerWeight: controller.selectedPackages[index].computerWeight,
                    imageFiles: controller.selectedPackages[index].imageFiles,
                    luggageModelId: controller.selectedPackages[index].luggageModelId,
                    editing: false,
                  )
                      : OtherWidget(
                    onPressed: (){
                      controller.selectedPackages.remove(controller.selectedPackages[index]);

                    },
                    otherPrice:controller.selectedPackages[index].otherPrice.value ,
                    otherDescription: controller.selectedPackages[index].otherDescription,
                    otherWeight: controller.selectedPackages[index].otherWeight,
                    imageFiles: controller.selectedPackages[index].imageFiles,
                    modelName:controller.selectedPackages[index].luggageType.value ,
                    luggageModelId: controller.selectedPackages[index].luggageModelId,
                    editing: false,
                  ),


                ).marginOnly(bottom: 10);
              }),
        ):SizedBox(),),


      ],
    ).paddingOnly(top: 20);

  }




}
