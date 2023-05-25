
import 'package:csc_picker/csc_picker.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
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
      backgroundColor: background,
      //Get.theme.colorScheme.secondary,
        appBar: AppBar(
          title: Text(
            "New Travel Form".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: appColor)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: appColor),
            onPressed: () => {Navigator.pop(context)},
          )
        ),
      body: Obx(() => Theme(
          data: ThemeData(
            //canvasColor: Colors.yellow,
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: controller.formStep.value != 3 ? Get.theme.colorScheme.secondary : validateColor,
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
      /*Container(
          height: Get.height,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
            ],
          ),
          //decoration: Ui.getBoxDecoration(color: backgroundColor),
          child: Column(
            children: [

              Container(
                height: Get.height/1.5,
                child: Obx(()=> controller.formStep.value == 0 ?
                AnimatedSwitcher(
                  duration: Duration(seconds: 3),
                child: stepOne(context)) :
                    AnimatedSwitcher(
                      duration: Duration(seconds: 5),
                    child: stepTwo(context))
                ),
              ),
              Spacer(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DelayedAnimation(delay: 250,
                        child: BlockButtonWidget(
                          onPressed: () =>{controller.formStep.value = 0},
                          color: inactive,
                          text: Text(
                            "Back".tr,
                            style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ).paddingSymmetric(vertical: 10, horizontal: 20)
                    ),
                    DelayedAnimation(delay: 250,
                        child: BlockButtonWidget(
                          onPressed: () =>{controller.formStep.value++},
                          color: Get.theme.colorScheme.secondary,
                          text: Text(
                            "Next".tr,
                            style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ).paddingSymmetric(vertical: 10, horizontal: 20)
                    )
                  ]
              )
            ],
          )
      )*/
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
                onTap: ()=>{controller.chooseDepartureDate()},
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
                              title: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.departureDate.value)).toString(),
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
                              )
                          )
                      )
                    ],
                  ),
                )
            ),
            InkWell(
                onTap: ()=>{controller.chooseArrivalDate()},
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
                              title: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.arrivalDate.value)).toString(),
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 16)),
                              )
                          ))
                    ],
                  ),
                )
            ),
            Obx(() => Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                  ],
                  border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
              child: ExpansionTile(
                  title: Column(
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
                          SizedBox(width: 15),
                          Text(controller.travelCard.isEmpty || controller.townEdit.value ? controller.departureTown.value
                              : controller.travelCard['departure_town'].toString()),
                        ]
                      )
                    ]
                  ),
              initiallyExpanded: false,
              children: [

                CSCPicker(
                  onCountryChanged: (value) {
                    controller.country1.value = value;
                  },
                  onStateChanged:(value) {

                  },
                  onCityChanged:(value) {
                    controller.townEdit.value = !controller.townEdit.value;
                    controller.departureTown.value = "$value, ${controller.country1.value}";

                  },
                ),
              ],),
            )),
            Obx(() => Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                  ],
                  border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
              child: ExpansionTile(
                title: Column(
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
                        SizedBox(width: 15),
                        Text(controller.travelCard.isEmpty || controller.town2Edit.value ? controller.arrivalTown.value
                            : controller.travelCard['arrival_town'].toString()),
                      ],
                    )
                  ],
                ),
                initiallyExpanded: false,
                children: [

                  CSCPicker(
                    onCountryChanged: (value) {
                      controller.country2.value = value;
                    },
                    onStateChanged:(value) {

                    },
                    onCityChanged:(value) {
                      controller.town2Edit.value = !controller.town2Edit.value;
                      controller.arrivalTown.value = "$value, ${controller.country2.value}";

                    },
                  ),
                ],),
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
                  children: List.generate(controller.transportType.length, (index) {
                    var type = controller.transportType.elementAt(index);
                    return SwitchListTile( //switch at right side of label
                        value: controller.selectedTravel.contains(type),
                        onChanged: (bool value){
                          controller.toggleTravels(value, type);
                          controller.travelType.value = type;
                        },
                        title: Text(controller.transportType[index])
                    );
                  }),
                  initiallyExpanded: false,
                )
            ),
            if(controller.travelType.value != "Land")...[
              TextFieldWidget(
                initialValue: controller.travelCard.isNotEmpty ? controller.travelCard['kilo_qty'].toString() : "",
                keyboardType: TextInputType.number,
                validator: (input) => input.isEmpty ? "field required!".tr : null,
                onChanged: (input) => controller.quantity.value = int.parse(input),
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
              TextFieldWidget(
                initialValue: "The price will depend on the luggage",
                keyboardType: TextInputType.number,
                validator: (input) => input.isEmpty ? "field required!".tr : null,
                labelText: "Price".tr,
                iconData: Icons.attach_money,
              )
            ]
          ],
        )
    );
  }

  Widget stepThree(BuildContext context){
    return Form(
        key: controller.newTravelKey,
        child: ListView(
          children: [
            SwitchListTile( //switch at right side of label
                value: controller.canBargain.value,
                onChanged: (bool value){
                  controller.canBargain.value = value;
                },
                title: Text("Bargain?")
            ),
            TextFieldWidget(
              initialValue: controller.travelCard.isNotEmpty ? controller.travelCard['type_of_luggage_accepted'].toString() : controller.restriction.value,
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              onChanged: (input) => controller.restriction.value = input,
              labelText: "Restriction".tr,
              iconData: FontAwesomeIcons.fileLines,
            ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("CNI Image".tr,
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Obx(() {
                        if(!controller.loadPassport.value)
                          return buildLoader();
                        else return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.file(
                            controller.passport,
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
                          controller.ticketUpload.value = false;
                          await controller.selectCameraOrGallery();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Ticket Image".tr,
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Obx(() {
                        if(!controller.loadTicket.value)
                          return buildLoader();
                        else return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.file(
                            controller.ticket,
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
                          controller.ticketUpload.value = true;
                          await controller.selectCameraOrGallery();

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
            value: DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.departureDate.value)).toString(),
          ),
          AccountWidget(
            icon: FontAwesomeIcons.calendarDay,
            text: Text('Arrival \nDate'),
            value: DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.arrivalDate.value)).toString(),
          ),
          AccountWidget(
            icon: FontAwesomeIcons.locationDot,
            text: Text('Departure \nTown'),
            value: controller.departureTown.value,
          ),
          AccountWidget(
            icon: FontAwesomeIcons.locationDot,
            text: Text('Arrival \nTown'),
            value: controller.arrivalTown.value,
          ),
          if(controller.travelType.value != 'Road')
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
          if(controller.travelType.value != 'Road')
          AccountWidget(
              icon: FontAwesomeIcons.moneyCheck,
              text: Text('Price /kg'),
              value: '${controller.price.value} EUR'
          ),
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
                controller.travelType.value == 'Air' ? FaIcon(FontAwesomeIcons.planeDeparture) :
                controller.travelType.value == 'Sea' ? FaIcon(FontAwesomeIcons.ship) : FaIcon(FontAwesomeIcons.bus),
              ],
            ),
          ),
          Spacer(),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                controller.travelCard.isEmpty ?
                BlockButtonWidget(
                  onPressed: () =>{
                    controller.buttonPressed.value = !controller.buttonPressed.value,
                    controller.postTravel()
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
                  onPressed: () =>{
                    controller.buttonPressed.value = !controller.buttonPressed.value,
                    controller.updateTravel(controller.travelCard['id'])
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
        ],
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type) {
    final canCancel = controller.formStep.value > 0;
    final canContinue = controller.formStep.value < 3;
    return CupertinoStepper(
      type: type,
      currentStep: controller.formStep.value,
      onStepTapped: (step) => controller.formStep.value = step,
      onStepCancel: canCancel ? () => controller.formStep.value-- : null,
      onStepContinue: canContinue ? () => controller.formStep.value++ : null,
      steps: [
        for (var i = 0; i < 3; ++i)
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
      //subtitle: Text('Date / place'),
      state: state,
      isActive: isActive,
      content: LimitedBox(
        maxWidth: Get.width - 20,
        maxHeight: controller.formStep.value != 3 ? 450 : 600,

        child: controller.formStep.value == 0 ? stepOne(Get.context)
        : controller.formStep.value == 1 ? stepTwo(Get.context)
            : controller.formStep.value == 2 ? stepThree(Get.context)
        : overView(Get.context)
      ),
    );
  }
}
