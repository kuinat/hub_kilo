
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import '../../../models/media_model.dart';
import '../../../routes/app_routes.dart';
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
          ), child: _buildStepper(StepperType.vertical)))
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
                              title: Text(DateFormat('dd/MM/yyyy').format(controller.departureDate.value).toString(),
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black)),
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
                              title: Text(DateFormat('dd/MM/yyyy').format(controller.arrivalDate.value).toString(),
                                style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black)),
                              )
                          ))
                    ],
                  ),
                )
            ),
            TextFieldWidget(
              //initialValue: controller.user.value.name,
              onChanged: (input) => controller.departureTown.value = input,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              labelText: "Departure Town".tr,
              onTap: ()=>{
                controller.searchPlace
              },
              iconData: Icons.location_pin,
            ),
            TextFieldWidget(
              //onSaved: (input) => controller.user.value.name = input,
              //initialValue: controller.user.value.name,`
              onChanged: (input) => controller.arrivalTown.value = input,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              labelText: "Arrival Town".tr,
              iconData: Icons.location_pin,
            ),
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
            TextFieldWidget(
              //initialValue: controller.user.value.name,
              isFirst: false,
              isLast: false,
              keyboardType: TextInputType.number,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              onChanged: (input) => controller.quantity.value = int.parse(input),
              labelText: "Quantity".tr,
              iconData: Icons.shopping_cart_rounded,
            ),
            TextFieldWidget(
              //onSaved: (input) => controller.user.value.name = input,
              //initialValue: controller.user.value.name,
              keyboardType: TextInputType.number,
              onChanged: (input) => controller.price.value = int.parse(input),
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              labelText: "Price /kg".tr,
              iconData: Icons.attach_money,
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
              child: ExpansionTile(
                title: Text("Travel Type".tr, style: Get.textTheme.bodyText2),
                children: List.generate(controller.transportType.length, (index) {
                  var _category = controller.transportType.elementAt(index);
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: false,
                    onChanged: (value) {
                      //controller.toggleCategory(value, _category);
                    },
                    title: Text(
                      _category,
                      style: Get.textTheme.bodyText1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  );
                }),
                initiallyExpanded: false,
              )
            )
          ],
        )
    );
  }

  Widget stepThree(BuildContext context){
    return Form(
        key: controller.newTravelKey,
        child: ListView(
          children: [
            Obx(() {
              return ImageFieldWidget(
                label: "Image".tr,
                field: 'avatar',
                tag: controller.newTravelKey.hashCode.toString(),
                initialImage: controller.avatar.value,
                uploadCompleted: (uuid) {
                  controller.avatar.value = Media(id: uuid);
                },
                reset: (uuid) {
                  //controller.avatar.value = new Media(thumb: controller.user.value.avatar.thumb);
                },
              );
            }),
          ],
        )
    );
  }

  Widget overView(BuildContext context){
    return Container(
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
        children: [
          Text("Verify your informations".tr, style: Get.textTheme.headline6),
          ListTile(
            //leading: Icon(Icons.calendar_today),
            title: Text('Departure Date: ${DateFormat('dd/MM/yyyy').format(controller.departureDate.value)}'),
            subtitle: Text('Arrival Date: ${DateFormat('dd/MM/yyyy').format(controller.arrivalDate.value)}'),
          ),
          ListTile(
            //leading: Icon(Icons.location_pin, color: specialColor),
            title: Text('Departure Town: ${controller.departureTown.value}'),
            subtitle: Text('Arrival Town: ${controller.arrivalTown.value}'),
          ),
          ListTile(
            //leading: Icon(Icons.calendar_today),
            title: Text('Quantity: ${controller.quantity.value}'),
            subtitle: Text('Price /kg: ${controller.price.value} EUR'),
          ),
          Spacer(),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlockButtonWidget(
                  onPressed: () =>{
                    controller.buttonPressed.value = !controller.buttonPressed.value
                  },
                  color: Get.theme.colorScheme.secondary,
                  text: !controller.buttonPressed.value ? Text(
                    "Submit Form".tr,
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
            title: Text('Step ${i + 1}'),
            isActive: i == controller.formStep.value,
            state: i == controller.formStep.value
                ? StepState.editing
                : i < controller.formStep.value ? StepState.complete : StepState.indexed,
          ),
        _buildStep(
          title: Text('Completed'.tr),
          state: StepState.complete,
        )
      ],
    );
  }

  Step _buildStep({
    Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      subtitle: Text('Date / place'),
      state: state,
      isActive: isActive,
      content: LimitedBox(
        maxWidth: Get.width - 20,
        maxHeight: controller.formStep.value == 0 ? 450
            : controller.formStep.value == 1 ? 450 : controller.formStep.value == 2 ? 250 : 400,

        child: controller.formStep.value == 0 ? stepOne(Get.context)
        : controller.formStep.value == 1 ? stepTwo(Get.context)
            : controller.formStep.value == 2 ? stepThree(Get.context)
        : overView(Get.context)
      ),
    );
  }
}
