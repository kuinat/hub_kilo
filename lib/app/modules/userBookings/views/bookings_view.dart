import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/ui.dart';
import '../../../../color_constants.dart';
import '../../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/card_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/user_widget.dart';
import '../controllers/bookings_controller.dart';

class BookingsView extends GetView<BookingsController> {

  List bookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Bookings".tr,
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
                  child: GestureDetector(
                    onTap: () {
                      //Get.toNamed(Routes.SEARCH, arguments: controller.heroTag.value);
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 12, left: 0),
                          child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
                        ),
                        Expanded(
                          child: Material(
                            color: Get.theme.primaryColor,
                            child: TextField(
                              //controller: controller.textEditingController,
                              style: Get.textTheme.bodyText2,
                              onChanged: (value)=>{ controller.filterSearchResults(value) },
                              autofocus: controller.heroTag.value == "search" ? true : false,
                              cursorColor: Get.theme.focusColor,
                              decoration: Ui.getInputDecoration(hintText: "Search for home service...".tr),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height/1.2,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: Ui.getBoxDecoration(color: backgroundColor),
                    child:  controller.items.isNotEmpty ? MyBookings(context)
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.folderOpen, color: inactive.withOpacity(0.3),size: 80),
                          Text('No Bookings found', style: Get.textTheme.headline5.merge(TextStyle(color: inactive.withOpacity(0.3))))
                        ],
                      ),
                    )
                ),
              ],
            ),
          )

        ));
  }

  List transportMeans = [
    "Water",
    "Land",
    "Air"
  ];

  Widget BottomFilterSheetWidget(BuildContext context){
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
  }


  Widget MyBookings(BuildContext context){
    return Obx(() => Expanded(
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: controller.items.length+1 ,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              if (index == controller.items.length) {
                return SizedBox(height: 80);
              } else {
                var travel = controller.items[index]['travel'];
                Future.delayed(Duration.zero, (){
                  controller.items.value.sort((a, b) => a['travel']["departure_date"].compareTo(b['travel']["departure_date"]));
                });
                return CardWidget(
                  travelType: travel['travel_type'] ,
                  editable: controller.items[index]['status'].toLowerCase()=='rejected'||controller.items[index]['status'].toLowerCase()=='pending'?true:false,
                  transferable: controller.items[index]['status'].toLowerCase()=='rejected'||controller.items[index]['status'].toLowerCase()=='pending'?true:false,
                  bookingState: controller.items[index]['status'],
                  depDate: travel['departure_date'],
                  arrTown: travel['arrival_town'],
                  depTown: travel['departure_town'],
                  arrDate: travel['arrival_date'],
                  qty: travel['travel_type'].toString().toLowerCase()=='air'?controller.items[index]['kilo_booked']:travel['travel_type'].toString().toLowerCase()=='road'?controller.items[index]['luggage_weight'].toInt():'null',
                  price: travel['travel_type'].toString().toLowerCase()=='air'?controller.items[index]['kilo_booked_price']:travel['travel_type'].toString().toLowerCase()=='road'?controller.items[index]['booking_price']:'null',
                  text: controller.items[index]['travel']['traveler']['user_name'],
                  negotiation:  Visibility(
                    visible:travel['travel_type'].toString().toLowerCase()=='air'&&controller.items[index]['status']=='pending'?travel['negotiation']:
                    travel['travel_type'].toString().toLowerCase()=='road'&&controller.items[index]['status']=='pending'?true:false,
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
                  imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                  packetImageUrl: travel['travel_type'].toString().toLowerCase()=='road'?
                  Domain.serverPort+'/web/image/m2st_hk_roadshipping.travel_booking/'+controller.items[index]['id'].toString()+'/luggage_image':
                  travel['travel_type'].toString().toLowerCase()=='air'?
                  Domain.serverPort+'/web/image/m2st_hk_airshipping.travel_booking/'+controller.items[index]['id'].toString()+'/luggage_image':
                  '',
                  recName: controller.items[index]['receiver']['receiver_name'],
                  recAddress: controller.items[index]['receiver']['receiver_address'],
                  recEmail: controller.items[index]['receiver']['receiver_email'],
                  recPhone: controller.items[index]['receiver']['receiver_phone'],
                  edit: () {
                    controller.phone.value= controller.items[index]['receiver']['receiver_phone'];
                    controller.name.value = controller.items[index]['receiver']['receiver_name'];
                    controller.email.value = controller.items[index]['receiver']['receiver_email'];
                    controller.address.value= controller.items[index]['receiver']['receiver_address'];
                    controller.description.value = controller.items[index]['type_of_luggage'];
                    if(travel['travel_type'].toString().toLowerCase()=='air'){
                      controller.quantity.value =double.parse(controller.items[index]['kilo_booked'].toString());
                    }
                    if(travel['travel_type'].toString().toLowerCase()=='road'){
                      controller.luggageWidth.value =controller.items[index]['luggage_width'];
                      controller.luggageHeight.value = controller.items[index]['luggage_height'];
                      controller.quantity.value=controller.items[index]['luggage_weight'];
                    }
                    //controller.quantity.value = controller.items[index]['luggage_weight'].toInt();
                    //controller.dimension.value = controller.items[index]['luggage_dimension'];


                    return Get.bottomSheet(
                      buildEditingSheet(context,controller.items[index] ),
                      isScrollControlled: true,);

                  },
                  confirm: ()=> showDialog(
                      context: context,
                      builder: (_)=>
                          PopUpWidget(
                            title: "Do you really want to delete this booking?",
                            cancel: 'Cancel',
                            confirm: 'Delete',
                            onTap: () async =>{
                              travel['travel_type'].toString().toLowerCase()=='air'?
                              await controller.deleteMyAirBooking(controller.items[index]['id']):
                              travel['travel_type'].toString().toLowerCase()=='road'?
                              await controller.deleteMyRoadBooking(controller.items[index]['id']):
                                  (){},

                              print(controller.items[index]['id'])
                            }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                          )
                  ),
                  transfer: ()=> showDialog(
                      context: context,
                      builder: (_)=>
                          PopUpWidget(
                            title: "Do you really want to transfer your booking?",
                            cancel: 'Cancel',
                            confirm: 'Transfer',
                            onTap: ()async=>{
                              travel['travel_type'].toString().toLowerCase()=='air'?
                              await controller.transferMyAirBookingNow(controller.items[index]['id']):
                              travel['travel_type'].toString().toLowerCase()=='road'?
                              await controller.transferMyRoadBookingNow(controller.items[index]['id']):
                                  (){},
                              Navigator.of(Get.context).pop(),
                            }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                          )
                  ),
                );}
            })
    ));
  }

  Widget buildEditingSheet(BuildContext context, var sampleBooking){
    return Container(
      height: Get.height/1.8,
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
                    controller.bookingStep.value = 0
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  child: Text("Back".tr, style: Get.textTheme.subtitle1),
                  elevation: controller.elevation.toDouble(),
                ) : SizedBox(width: 60),
                Spacer(),
                controller.bookingStep.value == 0 ?
                Text('Booking Details', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16))) :
                Text('Receiver Details', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16))),
                Spacer(),
                controller.bookingStep.value == 0 ?
                MaterialButton(
                  onPressed: () =>{
                    controller.bookingStep.value++
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
                          controller.buttonPressed.value = !controller.buttonPressed.value;
                          sampleBooking['travel']['travel_type'].toLowerCase() =='air'?
                          await controller.editAirBooking(sampleBooking['id']):
                          sampleBooking['travel']['travel_type'].toLowerCase() =='road'?
                          await controller.editRoadBooking(sampleBooking['id']):
                          (){};
                          controller.buttonPressed.value = !controller.buttonPressed.value;

                        })
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
                    : build_Receiver_details(context, sampleBooking)
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
    print(sampleBooking.toString());
    print(sampleBooking['kilo_booked'].toString());
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFieldWidget(
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              onChanged: (input) => controller.description.value = input,
              labelText: "Description".tr,
               initialValue: sampleBooking['type_of_luggage'],
              iconData: FontAwesomeIcons.fileLines,
            ),
            TextFieldWidget(
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              onChanged: (input) => controller.quantity.value = double.parse(input),
              labelText: "Quantity".tr,
              initialValue: sampleBooking['travel']['travel_type'].toString().toLowerCase()=='road'?sampleBooking["luggage_weight"].toString() : sampleBooking['travel']['travel_type'].toString().toLowerCase()=='air'?sampleBooking['kilo_booked'].toString():'1.0'
              ,
              iconData: FontAwesomeIcons.shoppingBag,
            ),
            Visibility(
              visible: sampleBooking["travel"]['travel_type'].toString().toLowerCase()!='air',
              child: TextFieldWidget(
                keyboardType: TextInputType.text,
                initialValue:sampleBooking['luggage_width'].toString() ,
                validator: (input) => input.isEmpty ? "field required!".tr : null,
                onChanged: (input) => controller.luggageWidth.value = double.parse(input),
                labelText: "Luggage Width".tr,
                iconData: FontAwesomeIcons.shoppingBag,
              ),
            ),
            Visibility(
              visible: sampleBooking["travel"]['travel_type'].toString().toLowerCase()!='air',
              child: TextFieldWidget(
                keyboardType: TextInputType.text,
                initialValue:sampleBooking['luggage_height'].toString() ,
                validator: (input) => input.isEmpty ? "field required!".tr : null,
                onChanged: (input) => controller.luggageHeight.value = double.parse(input),
                labelText: "Luggage Height".tr,
                iconData: FontAwesomeIcons.shoppingBag,
              ),
            ),

            Obx(() => Container(
              color: Colors.white,
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Align(
                    child: Text('Input 3 Packet Files'.tr),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(height: 20,),
                  controller.imageFiles.length<=0?GestureDetector(
                      onTap: () {
                        showDialog(
                            context: Get.context,
                            builder: (_){
                              return AlertDialog(
                                content: Container(
                                    height: 170,
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: ()async{
                                            await controller.pickImage(ImageSource.camera);
                                            Navigator.pop(Get.context);
                                          },
                                          leading: Icon(FontAwesomeIcons.camera),
                                          title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                        ),
                                        ListTile(
                                          onTap: ()async{
                                            await controller.pickImage(ImageSource.gallery);
                                            Navigator.pop(Get.context);
                                          },
                                          leading: Icon(FontAwesomeIcons.image),
                                          title: Text('Upload an image', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                        )
                                      ],
                                    )
                                ),
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
                      :Column(
                    children: [
                      SizedBox(
                        height:100,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(12),
                            itemBuilder: (context, index){
                              return ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image.file(
                                  controller.imageFiles[index],
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              );;
                            },
                            separatorBuilder: (context, index){
                              return SizedBox(width: 8);
                            },
                            itemCount: controller.imageFiles.length),
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
                                        content: Container(
                                            height: 170,
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: ()async{
                                                    await controller.pickImage(ImageSource.camera);
                                                    Navigator.pop(Get.context);
                                                  },
                                                  leading: Icon(FontAwesomeIcons.camera),
                                                  title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                ),
                                                ListTile(
                                                  onTap: ()async{
                                                    await controller.pickImage(ImageSource.gallery);
                                                    Navigator.pop(Get.context);
                                                  },
                                                  leading: Icon(FontAwesomeIcons.image),
                                                  title: Text('Upload an image', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                                                )
                                              ],
                                            )
                                        ),
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




            // Visibility(
            //   visible: sampleBooking["travel"]['travel_id'].toString().toLowerCase()=='road',
            //   child: TextFieldWidget(
            //     keyboardType: TextInputType.text,
            //     validator: (input) => input.isEmpty ? "field required!".tr : null,
            //     onChanged: (input) => controller.dimension.value = int.parse(input),
            //     labelText: "Dimension".tr,
            //     iconData: FontAwesomeIcons.shoppingBag,
            //   ),
            // ),


          ],
        ),
      ],
    );
  }
  Widget build_Receiver_details(BuildContext context, var sampleBooking) {
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
                title: Text("Select a user ?", style: Get.textTheme.headline1.merge(TextStyle(color: appColor)))
            ),
            !controller.selectUser.value ?
            Column(
              children: [
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.name.value = input,
                  labelText: "Full Name".tr,
                  initialValue: sampleBooking['receiver']['receiver_name'],
                  iconData: FontAwesomeIcons.person,
                ),
                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.email.value = input,
                  labelText: "Email".tr,
                  initialValue: sampleBooking['receiver']['receiver_email'],
                  iconData: Icons.alternate_email,
                ),
                Obx(() =>
                controller.editNumber.value==false?
                InkWell(
                    onTap: ()=>{controller.editNumber.value == true},
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
                          //Text(controller.currentUser.value.phone,style: Get.textTheme.bodyText1,),
                              ListTile(
                                  leading: FaIcon(FontAwesomeIcons.phone, size: 20),
                                  title: Text(sampleBooking['receiver']['receiver_phone'],style: Get.textTheme.bodyText1,

                                  )
                              ),


                          // Text('Edit...',style: Get.textTheme.bodyText1,),
                          TextButton(
                            onPressed: ((){
                              controller.editNumber.value = true;
                            }),
                            child: Text('Edit...',style: Get.textTheme.bodyText1,),)
                        ],
                      ),
                    )
                ):
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhoneFieldWidget(
                        labelText: "Phone Number".tr,
                        hintText: "223 665 7896".tr,
                        //initialValue: controller.currentUser.value.phone,
                        onSaved: (phone) {
                          controller.phone.value = "${phone.countryCode}${phone.number}";
                        },
                        onChanged: (phone) => controller.phone.value = "${phone.countryCode}${phone.number}"
                    ),
                    TextButton(
                      onPressed: ((){
                        controller.editNumber.value = false;

                      }),
                      child: Text('Cancel...',style: Get.textTheme.bodyText1,),)

                  ],),
                ),



                TextFieldWidget(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.isEmpty ? "field required!".tr : null,
                  onChanged: (input) => controller.address.value = input,
                  labelText: "Address".tr,
                  iconData: FontAwesomeIcons.addressCard,
                  initialValue: sampleBooking['receiver']['receiver_address'],
                ),
              ],
            ) :
            controller.visible.value?TextFieldWidget(
              keyboardType: TextInputType.text,
              validator: (input) => input.isEmpty ? "field required!".tr : null,
              //onChanged: (input) => controller.selectUser.value = input,
              labelText: "Select User".tr,
              iconData: FontAwesomeIcons.userGroup,
              onChanged: (value){
                var userFilter = [];
                if(value==''){
                  controller.users.value=controller.resetusers.value;
                }
                else{
                  for(var item in controller.users){
                    print(item['name'].toString());
                    if(item['name'].toLowerCase().contains(value)){
                      userFilter.add(item);
                      controller.users.value = userFilter;
                    }else{
                      controller.users.value = userFilter;
                    }
                    //controller.users.value = userFilter;
                  }
                }




              },
            ):TextButton(
                onPressed: (){
                  controller.visible.value = true;
                  controller.users.value = controller.resetusers.value;

                }, child: Text('Select another user')),

            if(controller.selectUser.value)
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
                        var travel = controller.users[index];
                        return GestureDetector(
                          onTap: (){
                            controller.receiverId.value = controller.users[index]['id'];
                            print(controller.receiverId.value.toString());
                            controller.selectedIndex.value = index;
                            //controller.selected.value = true;
                            controller.visible.value = false;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: controller.selectedIndex.value == index  ? Border.all(color: interfaceColor) : null ,
                              color: Get.theme.primaryColor,

                            ),
                            child: UserWidget(
                              user: controller.users[index]['name'],
                              selected: false,
                              imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                            ),
                          ),
                        );
                      })
              ) : Container(
                  child: Text('No other user than you', style: TextStyle(color: inactive, fontSize: 18)).marginOnly(top:MediaQuery.of(Get.context).size.height*0.2))


          ],
        ),
      ],
    );
  }


}
