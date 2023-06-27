import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/user_widget.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/bookings_list_loader_widget.dart';

class BookingsView extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Shipping".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.initValues();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      border: Border.all(
                        color: Get.theme.focusColor.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 12, left: 0),
                        child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /1.8,
                        child: TextField(
                          //controller: controller.textEditingController,
                          style: Get.textTheme.bodyText2,
                          onChanged: (value)=>{ controller.filterSearchResults(value) },
                          autofocus: controller.heroTag.value == "search" ? true : false,
                          cursorColor: Get.theme.focusColor,
                          decoration: Ui.getInputDecoration(hintText: "Search for home service...".tr),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() => Container(
                    height: MediaQuery.of(context).size.height/1.2,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: Ui.getBoxDecoration(color: backgroundColor),
                    child:  controller.isLoading.value ? BookingsListLoaderWidget() :
                    controller.items.isNotEmpty ? MyBookings(context)
                        : SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height/4),
                          FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                          Text('No Shipping found', style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3)))),
                        ],
                      ),
                    )
                ),)

              ],
            ),
          )

        ));
  }

  /*Widget BottomFilterSheetWidget(BuildContext context){
    return Container(
      height: Get.height/2,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 15, left: 4, right: 4),
              children: [
                ExpansionTile(
                  title: Text("Travels".tr, style: Get.textTheme.bodyText2),
                  children: List.generate(transportMeans.length, (index) {
                    var _category = transportMeans.elementAt(index);
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
                  initiallyExpanded: true,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            child: Row(
              children: [
                Expanded(child: Text("Filter".tr, style: Get.textTheme.headline5)),
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  child: Text("Apply".tr, style: Get.textTheme.subtitle1),
                  elevation: 0,
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: (Get.width / 2) - 30),
            decoration: BoxDecoration(
              color: Get.theme.focusColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      ),
    );
  }*/

  Widget MyBookings(BuildContext context){
    return Obx(() => Column(
      children: [
        Expanded(
            child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: controller.items.length+1 ,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {

                  if (index == controller.items.length) {
                    return SizedBox(height: 80);
                  } else {

                    Future.delayed(Duration.zero, (){
                      controller.items.sort((a, b) => b["__last_update"].compareTo(a["__last_update"]));
                    });
                    return CardWidget(
                      luggageView: controller.luggageIndex == index ? true : false,
                      shippingDate: controller.items[index]['shipping_date'],
                      code: controller.items[index]['display_name'],
                      travelType: controller.items[index]['booking_type'],
                      editable: controller.items[index]['state'].toLowerCase()=='pending' ? true:false,
                      transferable: controller.items[index]['state'].toLowerCase()=='rejected' || controller.items[index]['state'].toLowerCase()=='pending' ? true:false,
                      bookingState: controller.items[index]['state'],
                      price: controller.items[index]['shipping_price'],
                      text: controller.items[index]['travelbooking_id'][1],
                      viewButton: BlockButtonWidget(
                        onPressed: () =>{
                          controller.loading.value = true,
                          controller.getLuggageInfo(controller.items[index]['luggage_ids'])
                        },
                        color: Colors.black,
                        text: !controller.loading.value? Text(
                          "View luggage info".tr,
                          style: Get.textTheme.headline1.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 16)),
                        ): SizedBox(height: 30,
                            child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                      ).paddingSymmetric(vertical: 10, horizontal: 20),
                      luggageWidget: ExpansionTile(
                        leading: Icon(FontAwesomeIcons.boxesPacking, size: 20),
                        title: Text("Luggage Info".tr, style: Get.textTheme.bodyText1.
                        merge(TextStyle(color: appColor, fontSize: 17))),
                        children: [
                          for(var a=0; a<controller.shippingLuggage.length; a++)...[
                            SizedBox(
                              height:100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for(var i=1; i<4; i++)...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: FadeInImage(
                                        width: 100,
                                        height: 100,
                                        image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${controller.shippingLuggage[a]['id']}/luggage_image$i?unique=true&file_response=true',
                                            headers: Domain.getTokenHeaders()),
                                        placeholder: AssetImage(
                                            "assets/img/loading.gif"),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/img/istockphoto-859916128-612x612.jpg',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.fitWidth);
                                        },
                                      )
                                    ),
                                    SizedBox(width: 10)
                                  ]
                                ],
                              ),
                            ),
                            AccountWidget(
                              icon: FontAwesomeIcons.shoppingBag,
                              text: Text('Name'),
                              value: controller.shippingLuggage[a]['name'],
                            ),
                            AccountWidget(
                              icon: FontAwesomeIcons.shoppingBag,
                              text: Text('Dimensions'),
                              value: "${controller.shippingLuggage[a]['average_width']} x ${controller.shippingLuggage[a]['average_height']}",
                            ),
                            AccountWidget(
                              icon: FontAwesomeIcons.weightScale,
                              text: Text('Average weight'),
                              value: controller.shippingLuggage[a]['average_weight'].toString(),
                            )
                          ],
                        ],
                      ),
                      negotiation:  Visibility(
                        visible:  true,
                        child: InkWell(
                          onTap: ()=>{
                            //print(controller.items[index]),
                            Get.toNamed(Routes.CHAT, arguments: {'bookingCard': controller.items[index]})
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Negotiate', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, decoration: TextDecoration.underline))),
                              SizedBox(width: 10),
                              FaIcon(FontAwesomeIcons.solidMessage, color: interfaceColor),
                            ],
                          ),
                        ),
                      ),
                      button: TextButton(
                          onPressed: ()async{

                            var data = await controller.getTravelInfo(controller.items[index]['travelbooking_id'][0]);
                            Get.toNamed(Routes.TRAVEL_INSPECT, arguments: {'travelCard': data, 'heroTag': 'services_carousel'});

                          },
                          child: Text('View travel info', style: Get.textTheme.headline1.merge(
                              TextStyle(fontSize: 18, decoration: TextDecoration.underline)))),
                      imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',

                      recName: controller.items[index]['receiver_partner_id'][1],
                      recAddress: controller.items[index]['receiver_address'],
                      recEmail: controller.items[index]['receiver_email'].toString(),
                      recPhone: controller.items[index]['receiver_phone'],
                      edit: () {

                        return Get.bottomSheet(
                          buildEditingSheet(context,controller.items[index] ),
                          isScrollControlled: true,);

                      },
                      confirm: ()=> showDialog(
                          context: context,
                          builder: (_)=>
                              PopUpWidget(
                                title: "Do you really want to Cancel this shipping?",
                                cancel: 'Back',
                                confirm: 'Cancel',
                                onTap: () async =>{

                                  print(controller.items[index]['id']),
                                  await controller.cancelShipping(controller.items[index]['id']),

                                }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                              )
                      ),
                      transfer: ()=> showDialog(
                          context: context,
                          builder: (_)=>
                              PopUpWidget(
                                title: "Do you really want to transfer your shipping?",
                                cancel: 'Cancel',
                                confirm: 'Transfer',
                                onTap: () async => {
                                  controller.transferShipping(controller.items[index]['id']),
                                  Navigator.of(Get.context).pop(),
                                }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                              )
                      ),
                    );}
                })
        )
      ],
    ));
  }

  Widget buildEditingSheet(BuildContext context, var sampleBooking){

    controller.shippingPrice.value = sampleBooking['shipping_price'];

    return Container(
      height: Get.height/1.2,
      decoration: BoxDecoration(
        color: background,
        //Get.theme.primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: Obx(() => Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            child: Row(
              children: [
                controller.bookingStep.value != 0 ?
                MaterialButton(
                  onPressed: () =>{
                    for(var i=0; i<controller.luggageId.length; i++)
                    controller.deleteShippingLuggage(controller.luggageId[i])
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  child: Text("Back".tr, style: Get.textTheme.subtitle1),
                  elevation: controller.elevation.toDouble(),
                ) : SizedBox(width: 60),
                Spacer(),
                controller.bookingStep.value == 0 ?
                Text('Shipping Details', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16))) :
                Text('Receiver Details', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16))),
                Spacer(),
                controller.bookingStep.value == 0 ?
                MaterialButton(
                  onPressed: () =>{
                    if(controller.luggageSelected.isNotEmpty){
                      controller.errorField.value = false,
                      controller.bookingStep.value++,
                      for(var i=0; i<controller.luggageSelected.length; i++)
                        controller.createShippingLuggage(controller.luggageSelected[i])
                    }else{
                      controller.errorField.value = true
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  child: Text("Next".tr, style: Get.textTheme.subtitle1),
                  elevation: 0,
                ) : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BlockButtonWidget(
                        text: Container(
                          height: 24,
                          alignment: Alignment.center,
                          child: !controller.buttonPressed.value ? Text(
                            "Edit".tr,
                            style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.primaryColor)),
                          ) : SizedBox(height: 20,
                              child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                        ),
                        color: Get.theme.colorScheme.secondary,
                        onPressed: ()async{
                          if(controller.selected.value){
                            await controller.editShipping(sampleBooking);
                            controller.buttonPressed.value = false;
                          }

                        }
                    )
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 15, left: 4, right: 4),
              children: [
                controller.bookingStep.value == 0 ?
                build_Book_travel(context, sampleBooking)
                    : build_Receiver_details(context)
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: (Get.width / 2) - 30),
            decoration: BoxDecoration(
              color: Get.theme.focusColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      )
      ),
    );
  }

  Widget build_Book_travel(BuildContext context, var sampleBooking) {
    controller.errorField.value = false;
    controller.luggageSelected.value = [];
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFieldWidget(
              initialValue: sampleBooking['shipping_price'].toString(),
              keyboardType: TextInputType.number,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              onChanged: (input) => controller.shippingPrice.value = double.parse(input),
              labelText: "Shipping Price".tr,
              iconData: Icons.monetization_on_rounded,
            ),
            Obx(() => Container(
              height: 200,
              padding: EdgeInsets.all( 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: controller.errorField.value ? Border.all(color: specialColor) : null,
                color: Colors.white,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Luggage Type", style: Get.textTheme.headline1.merge(TextStyle(color: appColor, fontSize: 15))),
                  SizedBox(height: 10),
                  Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          if(!controller.luggageLoading.value)...[
                            for(var i=0; i< controller.luggageModels.length; i++)...[
                              GestureDetector(
                                  onTap: () {
                                    if(controller.luggageSelected.contains(controller.luggageModels[i])){
                                      controller.luggageSelected.remove(controller.luggageModels[i]);
                                    }else{
                                      controller.luggageSelected.add(controller.luggageModels[i]);
                                    }

                                    print(controller.luggageSelected);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(right: 10),
                                    height: 150,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        border: controller.luggageSelected.contains(controller.luggageModels[i])
                                            ? Border.all(color: interfaceColor, width: 3) : Border.all(),
                                        color: backgroundColor
                                    ),
                                    child: Column(
                                      children: [
                                        controller.luggageModels[i]['type'] == "envelope" ?
                                        Text("${controller.luggageModels[i]['type']} ${controller.luggageModels[i]['nature']}") : Text("${controller.luggageModels[i]['type']}"),
                                        SizedBox(width: 10),
                                        controller.luggageModels[i]['type'] == "envelope" ?
                                        Icon(FontAwesomeIcons.envelope, size: 30) : Icon(FontAwesomeIcons.briefcase, size: 30),
                                        SizedBox(height: 10),
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
              ),
            )),

          ],
        ),
      ],
    );
  }

  Widget build_Receiver_details(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SwitchListTile( //switch at right side of label
                value: controller.selectUser.value,
                onChanged: (bool value){
                  controller.selectUser.value = value;
                },
                title: Text("Receiver not in the system ?", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18, color: appColor)))
            ),
            controller.selectUser.value ?
            Column(
              children: [
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.name.value = input,
                  labelText: "Full Name".tr,
                  iconData: FontAwesomeIcons.person,
                ),
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.email.value = input,
                  labelText: "Email".tr,
                  iconData: Icons.alternate_email,
                ),
                PhoneFieldWidget(
                  labelText: "Phone Number".tr,
                  hintText: "223 665 7896".tr,
                  initialCountryCode: "CM",
                  //initialValue: controller.currentUser?.value?.getPhoneNumber()?.number,
                  onChanged: (phone){
                    controller.phone.value = "${phone.countryCode}${phone.number}";
                  },
                ),
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.address.value = input,
                  labelText: "Address".tr,
                  iconData: FontAwesomeIcons.addressCard,
                ),
              ],
            ) :
            TextFieldWidget(
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              //onChanged: (input) => controller.selectUser.value = input,
              labelText: "Select User".tr,
              iconData: FontAwesomeIcons.userGroup,
              onChanged: (value)=>{
                controller.filterSearchResults(value)
              },
            ),

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

                  child: ListView.separated(
                    //physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.users.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5);
                      },
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            controller.receiverId.value = controller.users[index]['id'];
                            print(controller.receiverId.value.toString());
                            controller.selectedIndex.value = index;
                            controller.selected.value = true;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: controller.selectedIndex.value == index && controller.selected.value ? Border.all(color: interfaceColor) : null ,
                              color: Get.theme.primaryColor,

                            ),
                            child: UserWidget(
                                user: controller.users[index]['display_name'],
                                selected: false,
                                imageUrl: 'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-unknown-social-media-user-photo-default-avatar-profile-icon-vector-unknown-social-media-user-184816085.jpg'
                              //'${Domain.serverPort}/web/image/res.partner/${controller.users[index]['id']}/image_1920',
                            ),
                          ),
                        );
                      })
              ) : Container(
                  child: Text('No other user than you', style: TextStyle(color: inactive, fontSize: 18))
                      .marginOnly(top:MediaQuery.of(Get.context).size.height*0.2))
          ],
        ),
      ],
    );
  }
}
