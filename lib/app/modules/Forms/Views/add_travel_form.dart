
import 'package:csc_picker/csc_picker.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controller/add_travel_controller.dart';

class AddTravelsView extends GetView<AddTravelController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Get.theme.colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: background,
          title:  Text(
            "New Travel Form".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: appColor)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: appColor),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
      body: Obx(() => Theme(
          data: ThemeData(
            //canvasColor: Colors.yellow,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: controller.formStep.value != 2 ? Get.theme.colorScheme.secondary : validateColor,
                background: Colors.red,
                secondary: validateColor,
              )
          ),
          child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height
              ),
              child: _buildStepper(StepperType.horizontal)
          )),
        /*OrientationBuilder(
              builder: (BuildContext context, Orientation orientation){
                switch (orientation) {
                  case Orientation.portrait:
                    return _buildStepper(StepperType.vertical);
                  case Orientation.landscape:
                    return _buildStepper(StepperType.horizontal);
                  default:
                    throw UnimplementedError(orientation.toString());
                }
              }
          )*/
      )
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
                      Text("Departure Date".tr,
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      Obx(() =>
                          ListTile(
                              leading: Icon(Icons.calendar_today),
                              title: Text(controller.departureDate.value,
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
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
                      Text("Arrival Date".tr,
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      Obx(() =>
                          ListTile(
                              leading: Icon(Icons.calendar_today),
                              title: Text(controller.arrivalDate.value,
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
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
                    Text("Departure Town",
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
                              style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
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
                    Text("Arrival Town",
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
                                  Get.showSnackbar(Ui.warningSnackBar(message: "Please, first select a departure city!!! ".tr));
                                }
                              },
                              //initialValue: controller.travelCard.isEmpty || controller.townEdit.value ? controller.departureTown.value : controller.travelCard['departure_town'],
                              style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
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
          ]
        )
    );
  }

  Widget stepTwo(BuildContext context){
    return Form(
        key: controller.newTravelKey,
        child: ListView(
          primary: true,
          //padding: EdgeInsets.all(10),
          children: [
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                    border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                child: ExpansionTile(
                  title: Text("Travel Type".tr, style: Get.textTheme.bodyText2),
                  children: [
                    Obx(() => SwitchListTile( //switch at right side of label
                        value: controller.travelType.value == 'road' ? true : false,
                        onChanged: (bool value){
                          controller.travelType.value = 'road';
                          print(controller.travelType.value);
                        },
                        title: Text('road')
                    )),
                    /*Obx(() => SwitchListTile( //switch at right side of label
                        value: controller.travelType.value == 'air' ? true : false,
                        onChanged: (bool value){
                          controller.travelType.value = 'air';
                          print(controller.travelType.value);
                        },
                        title: Text("air")
                    )),
                    Obx(() => SwitchListTile( //switch at right side of label
                        value: controller.travelType.value == 'sea' ? true : false,
                        onChanged: (bool value){
                          controller.travelType.value = 'sea';
                          print(controller.travelType.value);
                        },
                        title: Text('sea')
                    )),*/
                  ],
                  initiallyExpanded: controller.travelCard.isEmpty ? false : true,
                )
            ),
            if(controller.travelType.value != "road")...[
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
            ]else...[
              SizedBox(height: 30),
              SwitchListTile( //switch at right side of label
                  value: controller.canBargain.value,
                  onChanged: (bool value){
                    controller.canBargain.value = value;
                  },
                  title: Text("Bargain?")
              ),
              //Text("The price will depend on the luggage", style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 18)))
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
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        children: [
          Text("Verify your informations".tr, style: Get.textTheme.headline6),
          AccountWidget(
            icon: FontAwesomeIcons.calendarDay,
            text: Text('Departure \nDate'),
            value: controller.departureDate.value,
          ),
          AccountWidget(
            icon: FontAwesomeIcons.calendarDay,
            text: Text('Arrival \nDate'),
            value: controller.arrivalDate.value,
          ),
          AccountWidget(
            icon: FontAwesomeIcons.locationDot,
            text: Text('Departure \nTown'),
            value: controller.depTown.text,
          ),
          AccountWidget(
            icon: FontAwesomeIcons.locationDot,
            text: Text('Arrival \nTown'),
            value: controller.arrTown.text,
          ),
          if(controller.travelType.value != "road")...[
            AccountWidget(
              icon: FontAwesomeIcons.shoppingBasket,
              text: Text('Quantity'),
              value: controller.quantity.value.toString(),
            ),
            AccountWidget(
                icon: FontAwesomeIcons.moneyBill,
                text: Text('Accept bargain?'),
                value: controller.canBargain.value ? 'YES' : 'NO'
            ),
            AccountWidget(
                icon: FontAwesomeIcons.moneyCheck,
                text: Text('Price /kg'),
                value: '${controller.price.value} EUR'
            )
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Icon( FontAwesomeIcons.plane, color: interfaceColor, size: 18),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  width: 1,
                  height: 24,
                  color: Get.theme.focusColor.withOpacity(0.3),
                ),
                Expanded(
                  child: Text("Travel type"),
                ),
                controller.travelType.value == 'air' ? FaIcon(FontAwesomeIcons.planeDeparture) :
                controller.travelType.value == 'sea' ? FaIcon(FontAwesomeIcons.ship) : FaIcon(FontAwesomeIcons.bus),
              ],
            ),
          ),
          Spacer(),
          Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                controller.travelCard.isEmpty ?
                BlockButtonWidget(
                  onPressed: () {

                    if(controller.travelType.value == "air"){
                      print("Air");
                      //controller.createAirTravel();
                    }
                    if(controller.travelType.value == "road"){
                      print("Land");
                      if(controller.departureId.value != 0){
                        controller.buttonPressed.value = true;
                        controller.createRoadTravel();
                      }else{
                        Get.showSnackbar(Ui.notificationSnackBar(message: "No arrival city seleced!!! ".tr));
                      }
                    }
                    if(controller.travelType.value == "sea"){
                      print("Sea");
                      //controller.createSeaTravel()
                    }
                  },
                  color: Get.theme.colorScheme.secondary,
                  text: !controller.buttonPressed.value ? Text(
                    "Submit Form".tr,
                    style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                  ) : SizedBox(height: 20,
                      child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                ).paddingSymmetric(vertical: 10, horizontal: 20)
                    :
                BlockButtonWidget(
                  onPressed: () {

                    if(controller.travelType.value == "air"){
                      print("Air");
                      //controller.updateAirTravel(controller.travelCard['id']);
                    }
                    if(controller.travelType.value == "road"){
                      print("Land");
                      controller.buttonPressed.value = true;
                      controller.updateRoadTravel();
                    }
                    if(controller.travelType.value == "sea"){
                      print("Sea");
                      //controller.createSeaTravel()
                    }
                  },
                  color: Get.theme.colorScheme.secondary,
                  text: !controller.buttonPressed.value ? Text(
                    "Update Travel".tr,
                    style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                  ) : SizedBox(height: 20,
                      child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                ).paddingSymmetric(vertical: 10, horizontal: 20)
              ]
          )
          )
        ],
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type) {
    final canCancel = controller.formStep.value > 0;
    final canContinue = controller.formStep.value < 2 ;
    return CupertinoStepper(
      type: type,
      currentStep: controller.formStep.value,
      onStepTapped: (step) => controller.formStep.value = step,
      onStepCancel: canCancel ? () => controller.formStep.value-- : null,
      onStepContinue: canContinue ? (){
        if(controller.depTown.text.isNotEmpty && controller.arrTown.text.isNotEmpty){
          controller.formStep.value++;
        }else{
          Get.showSnackbar(Ui.ErrorSnackBar(message: "All fields are required ".tr));
        }

      } : null,
      steps: [
        for (var i = 0; i < 2; ++i)
          _buildStep(
            title: Text(''),
            isActive: i == controller.formStep.value,
            state: i == controller.formStep.value
                ? StepState.editing
                : i < controller.formStep.value ? StepState.complete : StepState.indexed,
          ),
        _buildStep(
          title: Icon(FontAwesomeIcons.thumbsUp),
          state: StepState.editing,
        )
      ]
    );
  }

  Step _buildStep({
    Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      subtitle: Text('Add Travel'),
      state: state,
      isActive: isActive,
      content: LimitedBox(
        maxWidth: Get.width - 20,
        maxHeight: controller.formStep.value != 2 ? 450 : 500,

        child: controller.formStep.value == 0 ? stepOne(Get.context)
        : controller.formStep.value == 1 ? stepTwo(Get.context)
        : overView(Get.context)
      ),
    );
  }
}
