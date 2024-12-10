import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../account/widgets/account_link_widget.dart';

import '../../e_service/widgets/e_service_til_widget.dart';
import '../../e_service/widgets/e_service_title_bar_widget.dart';
import '../../global_widgets/Travel_card_widget.dart';
import '../../global_widgets/pop_up_widget.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../../../../common/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../userTravels/controllers/user_travels_controller.dart';


class ShippingDetails extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut(()=>BookingsController());
    Get.lazyPut<TravelInspectController>(
          () => TravelInspectController(),
    );
    var arguments = Get.arguments as Map<String, dynamic>;
    if(arguments!= null){
      Get.find<BookingsController>().shippingType.value = arguments['shippingType'];
    }
    print('Shipping Type is: ${Get.find<BookingsController>().shippingType.value}');
    return Obx(() {

      return Scaffold(
          bottomNavigationBar: controller.owner.value? buildBottomWidget(context) : buildTravellerView(context),
          floatingActionButton: Obx(() =>
          controller.shippingType.value=='shippingOffer' &&
              controller.shippingDetails['partner_id'][0] != Get.find<MyAuthService>().myUser.value.id
              && (controller.shippingDetails["travelbooking_id"].toString() == 'false' || controller.shippingDetails["travelbooking_id"].toString()== "m1st_hk_roadshipping.travelbooking()")?
          Obx(() =>
              Stack(
                children: [
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(controller.showButton.value)...[

                          DelayedAnimation(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              style: ElevatedButton.styleFrom(backgroundColor: interfaceColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              onPressed: () async{

                                print('Published Travel: ${controller.publishedTravel}');
                                controller.publishedTravel == null?showDialog(
                                    context: context,
                                    builder: (_)=> AlertDialog(

                                      insetPadding: EdgeInsets.all(20),
                                      contentPadding: EdgeInsets.all(20),
                                      icon: Icon(Icons.warning, color: Colors.red,),
                                      titleTextStyle: TextStyle(color: Colors.black, fontSize: 14),
                                      content: Text(AppLocalizations.of(context).noTravelPublishedState, style: TextStyle(color: Colors.black),),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: inactive),)),

                                      ],
                                    ))
                                    :
                                showDialog(
                                    context: context,
                                    builder: (_)=> AlertDialog(

                                      insetPadding: EdgeInsets.zero,
                                      contentPadding: EdgeInsets.all(5),
                                      title: Text(AppLocalizations.of(context).joinTravelQuestion),
                                      titleTextStyle: TextStyle(color: Colors.black, fontSize: 14),

                                      content: controller.publishedTravel != null?SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: TravelCardWidget(
                                          isUser: true,
                                          travelState: controller.publishedTravel['state'],
                                          depDate: DateFormat("dd MMM yyyy", 'fr_CA').format(DateTime.parse(controller.publishedTravel['departure_date'])).toString(),
                                          arrTown: controller.publishedTravel['arrival_city_id'][1],
                                          depTown: controller.publishedTravel['departure_city_id'][1],
                                          qty: controller.publishedTravel['total_weight'],
                                          price: controller.publishedTravel['booking_price'],
                                          color: background,
                                          text: Text(""),
                                          imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                          homePage: false,

                                          action: ()=> {

                                            ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
                                              content: Text(AppLocalizations.of(context).loadingData),
                                              duration: Duration(seconds: 2),
                                            )),

                                            //controller.publishTravel(controller.items[index]['id'])
                                          },
                                          travelBy: controller.publishedTravel['booking_type'],

                                        ),
                                      ):Text(AppLocalizations.of(context).loadingData),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: inactive),)),
                                        TextButton(onPressed: () async {
                                          Navigator.of(context).pop();
                                          await controller.joinShippingTravel(controller.shippingDetails, Get.find<BookingsController>().publishedTravel['id']);
                                        }, child: Text(AppLocalizations.of(context).join,style: TextStyle(color: interfaceColor),))
                                      ],
                                    ));

                              },
                              label: Text(AppLocalizations.of(context).joinTravel.toUpperCase(), ),

                            ),
                            delay: 30,
                          ),

                          SizedBox(height: 5,),

                          DelayedAnimation(
                            child:ElevatedButton.icon(
                              icon: Icon(Icons.airplanemode_active),
                              style: ElevatedButton.styleFrom(backgroundColor: doneStatus, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              label: SizedBox(
                                  height: 20,
                                  width: Get.width*0.23,
                                  child: Text(AppLocalizations.of(context).createTravel.toUpperCase(), style: TextStyle(overflow: TextOverflow.ellipsis), )),
                              onPressed: (){
                                Navigator.of(Get.context).pop();
                                Get.toNamed(Routes.ADD_TRAVEL_FORM);
                              },

                            ) ,
                            delay: 60 ,
                          ),
                          SizedBox(height: 5,),

                        ],

                        !controller.showButton.value ?
                        FloatingActionButton(
                          onPressed: ()=>
                          controller.showButton.value = !controller.showButton.value,
                          child: Icon(FontAwesomeIcons.add),
                        ) :
                        FloatingActionButton(
                          onPressed: ()=>
                          controller.showButton.value = !controller.showButton.value,
                          child: Icon(FontAwesomeIcons.close),
                          backgroundColor: specialColor,
                        ),

                      ],
                    ),
                  )
                ],
              )
          )
              : controller.shippingType.value=='receptionOffer' &&
              controller.shippingDetails['parcel_reception_receiver_partner_id'][0] != Get.find<MyAuthService>().myUser.value.id
              && (controller.shippingDetails["travelbooking_id"].toString() == 'false' || controller.shippingDetails["travelbooking_id"].toString()== "m1st_hk_roadshipping.travelbooking()")?
              Obx(() =>
                  Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            if(controller.showButton.value)...[

                              DelayedAnimation(
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.add),
                                  style: ElevatedButton.styleFrom(backgroundColor: interfaceColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  onPressed: () async{

                                    print('Published Travel: ${controller.publishedTravel}');
                                    controller.publishedTravel == null?showDialog(
                                        context: context,
                                        builder: (_)=> AlertDialog(

                                          insetPadding: EdgeInsets.all(20),
                                          contentPadding: EdgeInsets.all(20),
                                          icon: Icon(Icons.warning, color: Colors.red,),
                                          titleTextStyle: TextStyle(color: Colors.black, fontSize: 14),
                                          content: Text(AppLocalizations.of(context).noTravelPublishedState, style: TextStyle(color: Colors.black),),
                                          actions: [
                                            TextButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: inactive),)),

                                          ],
                                        ))
                                        :
                                    showDialog(
                                        context: context,
                                        builder: (_)=> AlertDialog(

                                          insetPadding: EdgeInsets.zero,
                                          contentPadding: EdgeInsets.all(5),
                                          title: Text(AppLocalizations.of(context).joinTravelQuestion),
                                          titleTextStyle: TextStyle(color: Colors.black, fontSize: 14),

                                          content: controller.publishedTravel != null?SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: TravelCardWidget(
                                              isUser: true,
                                              travelState: controller.publishedTravel['state'],
                                              depDate: DateFormat("dd MMM yyyy", 'fr_CA').format(DateTime.parse(controller.publishedTravel['departure_date'])).toString(),
                                              arrTown: controller.publishedTravel['arrival_city_id'][1],
                                              depTown: controller.publishedTravel['departure_city_id'][1],
                                              qty: controller.publishedTravel['total_weight'],
                                              price: controller.publishedTravel['booking_price'],
                                              color: background,
                                              text: Text(""),
                                              imageUrl: 'https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                              homePage: false,

                                              action: ()=> {

                                                ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
                                                  content: Text(AppLocalizations.of(context).loadingData),
                                                  duration: Duration(seconds: 2),
                                                )),

                                                //controller.publishTravel(controller.items[index]['id'])
                                              },
                                              travelBy: controller.publishedTravel['booking_type'],

                                            ),
                                          ):Text(AppLocalizations.of(context).loadingData),
                                          actions: [
                                            TextButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: inactive),)),
                                            TextButton(onPressed: () async {
                                              Navigator.of(context).pop();
                                              await controller.joinShippingTravel(controller.shippingDetails, Get.find<BookingsController>().publishedTravel['id']);
                                            }, child: Text(AppLocalizations.of(context).join,style: TextStyle(color: interfaceColor),))
                                          ],
                                        ));

                                  },
                                  label: Text(AppLocalizations.of(context).joinTravel.toUpperCase(), ),

                                ),
                                delay: 30,
                              ),

                              SizedBox(height: 5),

                              DelayedAnimation(
                                child:ElevatedButton.icon(
                                  icon: Icon(Icons.airplanemode_active),
                                  style: ElevatedButton.styleFrom(backgroundColor: doneStatus, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  label: SizedBox(
                                      height: 20,
                                      width: Get.width*0.23,
                                      child: Text(AppLocalizations.of(context).createTravel.toUpperCase(), style: TextStyle(overflow: TextOverflow.ellipsis), )),
                                  onPressed: (){
                                    Navigator.of(Get.context).pop();
                                    Get.toNamed(Routes.ADD_TRAVEL_FORM);
                                  },

                                ) ,
                                delay: 60 ,
                              ),
                              SizedBox(height: 5),

                            ],

                            !controller.showButton.value ?
                            FloatingActionButton(
                              onPressed: ()=>
                              controller.showButton.value = !controller.showButton.value,
                              child: Icon(FontAwesomeIcons.add),
                            ) :
                            FloatingActionButton(
                              onPressed: ()=>
                              controller.showButton.value = !controller.showButton.value,
                              child: Icon(FontAwesomeIcons.cancel),
                              backgroundColor: specialColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              )
              : controller.shippingDetails['state'] == "paid" ||  controller.shippingDetails['state'] == "confirm" ?
          ElevatedButton.icon(
              onPressed: ()=>{
                Get.bottomSheet(
                  buildCodeSheet(context, controller.shippingDetails['travel_code'], controller.shippingDetails),
                  isScrollControlled: true,
                )
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              icon: Icon(FontAwesomeIcons.qrcode),
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(AppLocalizations.of(context).validationCode),
              )
          ) : SizedBox()
          ),
          body: CustomScrollView(
              primary: true,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 310,
                  elevation: 0,
                  floating: true,
                  iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                      icon: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Get.theme.primaryColor.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ]),
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: FaIcon(FontAwesomeIcons.arrowLeft, color: buttonColor)
                          )
                      ),
                      onPressed: () => {
                        Get.find<BookingsController>().transferBooking.value = false,
                        Get.find<TravelInspectController>().editing.value = false,
                        Get.back()
                      }
                  ),
                  bottom: buildEServiceTitleBarWidget(context),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Obx(() {

                      var bookingState = controller.shippingDetails['state'];

                      return Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          controller.shippingDetails['disagree'] != null?
                          Banner(
                              message: !controller.shippingDetails['disagree'] ?
                              controller.shippingDetails['state'] == "received" ?
                              AppLocalizations.of(context).delivered : controller.shippingDetails['state'] == "confirm" ?
                              AppLocalizations.of(context).received : controller.shippingDetails['state'] == 'rejected' ?
                              AppLocalizations.of(context).cancelled : controller.shippingDetails['state'] : AppLocalizations.of(context).rejected,
                              color: !controller.shippingDetails['disagree'] ?
                              controller.shippingDetails['state'] == 'accepted' ?
                              pendingStatus : controller.shippingDetails['state'] == 'rejected' ?
                              specialColor : controller.shippingDetails['state'] == 'received' ?
                              interfaceColor : controller.shippingDetails['state'] == "paid" ? validateColor : controller.shippingDetails['state'] == "confirm" ? doneStatus : inactive : specialColor,
                              location: BannerLocation.topEnd,
                              child: Container(
                                height: 370,
                                width: double.infinity,
                                color: doneStatus,
                                child: Lottie.asset("assets/img/home-delivery.json"),
                              )
                          )
                          :Banner(
                              message: controller.shippingDetails['state'] == "received" ?
                              AppLocalizations.of(context).delivered : controller.shippingDetails['state'] == "confirm" ?
                              AppLocalizations.of(context).received : controller.shippingDetails['state'] == 'rejected' ?
                              AppLocalizations.of(context).cancelled : controller.shippingDetails['state'] ,
                              color: controller.shippingDetails['state'] == 'accepted' ?
                              pendingStatus : controller.shippingDetails['state'] == 'rejected' ?
                              specialColor : controller.shippingDetails['state'] == 'received' ?
                              interfaceColor : controller.shippingDetails['state'] == "paid" ? validateColor : controller.shippingDetails['state'] == "confirm" ? doneStatus : inactive ,
                              location: BannerLocation.topEnd,
                              child: Container(
                                height: 370,
                                width: double.infinity,
                                color: doneStatus,
                                child: Lottie.asset("assets/img/home-delivery.json"),
                              )
                          ),
                          buildCarouselBullets(context)
                        ],
                      );
                    }),
                  ).marginOnly(bottom: 50),
                ),
                // WelcomeWidget(),
                SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Obx(() => EServiceTilWidget(
                              title: Text(AppLocalizations.of(context).shippingDetails.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black))),
                              actions: ElevatedButton.icon(
                                  onPressed: ()async{

                                    controller.shippingLoading.value = true;
                                    if(controller.shippingDetails['luggage_ids'] != null){

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(AppLocalizations.of(context).loadingData),
                                        duration: Duration(seconds: 10),
                                      ));

                                      controller.shippingDetails['booking_type'] == 'By Road' || controller.shippingDetails['booking_type'] ==''?
                                      await controller.getRoadLuggageInfo(controller.shippingDetails['luggage_ids'])
                                          :await controller.getSpecificAirShippingLuggages(controller.shippingDetails['luggage_ids']);

                                    }else{
                                      Get.showSnackbar(Ui.notificationSnackBar(message: AppLocalizations.of(context).cannotViewLuggageInfo));
                                    }

                                    if(!controller.shippingLoading.value) {
                                      if(controller.shippingDetails['booking_type'] == 'By Road' || controller.shippingDetails['booking_type'] ==''){
                                        showDialog(
                                            context: context,
                                            builder: (_){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    )),
                                                child: SizedBox(
                                                    height: MediaQuery.of(context).size.height/1.7,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Text(AppLocalizations.of(context).luggageInfo.tr, style: Get.textTheme.bodyText1.
                                                        merge(TextStyle(color: appColor, fontSize: 17))),
                                                        SizedBox(height: 15),
                                                        for(var a=0; a<controller.roadShippingLuggage.length; a++)...[
                                                          SizedBox(
                                                              width: double.infinity,
                                                              height: 140,
                                                              child:  Column(
                                                                children: [
                                                                  Expanded(
                                                                    child: ListView.builder(
                                                                        scrollDirection: Axis.horizontal,
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
                                                                                        image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${controller.roadShippingLuggage[a]['id']}/luggage_image${index+1}?unique=true&file_response=true',
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
                                                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                  child: ClipRRect(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                      child: FadeInImage(
                                                                                        width: 120,
                                                                                        height: 100,
                                                                                        fit: BoxFit.cover,
                                                                                        image: NetworkImage('${Domain.serverPort}/image/m1st_hk_roadshipping.luggage/${controller.roadShippingLuggage[a]['id']}/luggage_image${index+1}?unique=true&file_response=true',
                                                                                            headers: Domain.getTokenHeaders()),
                                                                                        placeholder: AssetImage(
                                                                                            "assets/img/loading.gif"),
                                                                                        imageErrorBuilder:
                                                                                            (context, error, stackTrace) {
                                                                                          return Image.asset(
                                                                                              'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                                                                              width: 100,
                                                                                              height: 100,
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
                                                          SizedBox(height: 15),
                                                          AccountWidget(
                                                            icon: FontAwesomeIcons.rulerHorizontal,
                                                            text: AppLocalizations.of(context).dimensions,
                                                            value: "${controller.roadShippingLuggage[a]['average_width']} x ${controller.roadShippingLuggage[a]['average_height']}",
                                                          ),
                                                          AccountWidget(
                                                            icon: FontAwesomeIcons.weightScale,
                                                            text: AppLocalizations.of(context).weight,
                                                            value: controller.roadShippingLuggage[a]['average_weight'].toString() + " Kg",
                                                          ),
                                                          AccountWidget(
                                                              icon: FontAwesomeIcons.file,
                                                              text: AppLocalizations.of(context).description,
                                                              value: controller.roadShippingLuggage[a]['name']
                                                          ),
                                                          Spacer(),
                                                          Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: TextButton(onPressed: (){
                                                                controller.editPhotos.value = true;
                                                                Navigator.of(context).pop();

                                                              },
                                                                  child: Text(AppLocalizations.of(context).back, style: TextStyle(color: appColor)))
                                                          )
                                                        ],
                                                      ],
                                                    )
                                                ),
                                              );
                                            });
                                      }
                                      else{

                                        showDialog(
                                            context: context,
                                            builder: (_){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    )),
                                                child: SizedBox(
                                                    height: MediaQuery.of(context).size.height/1.7,
                                                    child: ListView(
                                                      padding: EdgeInsets.all(20),
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Text(AppLocalizations.of(context).luggageInfo.tr, style: Get.textTheme.bodyText1.
                                                        merge(TextStyle(color: appColor, fontSize: 17))),
                                                        SizedBox(height: 15),
                                                        for(var a=0; a<controller.airShippingLuggage.length; a++)...[
                                                          ExpansionTile(
                                                            initiallyExpanded: controller.airShippingLuggage.length==1?true:false,
                                                            title: Text(controller.airShippingLuggage[a]['luggage_type_id'][1], style: TextStyle(color: labelColor)),
                                                            children: [
                                                              SizedBox(
                                                                  width: double.infinity,
                                                                  height: 140,
                                                                  child:  Column(
                                                                    children: [
                                                                      Expanded(
                                                                        child: ListView.builder(
                                                                            scrollDirection: Axis.horizontal,
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
                                                                                            image: NetworkImage('${Domain.serverPort}/image/m2st_hk_airshipping.luggage/${controller.airShippingLuggage[a]['id']}/luggage_image${index+1}?unique=true&file_response=true',
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
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: ClipRRect(
                                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                          child: FadeInImage(
                                                                                            width: 120,
                                                                                            height: 100,
                                                                                            fit: BoxFit.cover,
                                                                                            image: NetworkImage('${Domain.serverPort}/image/m2st_hk_airshipping.luggage/${controller.airShippingLuggage[a]['id']}/luggage_image${index+1}?unique=true&file_response=true',
                                                                                                headers: Domain.getTokenHeaders()),
                                                                                            placeholder: AssetImage(
                                                                                                "assets/img/loading.gif"),
                                                                                            imageErrorBuilder:
                                                                                                (context, error, stackTrace) {
                                                                                              return Image.asset(
                                                                                                  'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                                                                                  width: 100,
                                                                                                  height: 100,
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
                                                              SizedBox(height: 15),
                                                              AccountWidget(
                                                                icon: FontAwesomeIcons.rulerHorizontal,
                                                                text: AppLocalizations.of(context).dimensions,
                                                                value: "${controller.airShippingLuggage[a]['average_width']} x ${controller.airShippingLuggage[a]['average_height']}",
                                                              ),
                                                              AccountWidget(
                                                                icon: FontAwesomeIcons.weightScale,
                                                                text: AppLocalizations.of(context).weight,
                                                                value: controller.airShippingLuggage[a]['average_weight'].toString() + " Kg",
                                                              ),
                                                              AccountWidget(
                                                                  icon: FontAwesomeIcons.file,
                                                                  text: AppLocalizations.of(context).description,
                                                                  value: controller.airShippingLuggage[a]['name']
                                                              ),

                                                              Align(
                                                                  alignment: Alignment.bottomRight,
                                                                  child: TextButton(onPressed: (){
                                                                    controller.editPhotos.value = true;
                                                                    Navigator.of(context).pop();

                                                                  },
                                                                      child: Text(AppLocalizations.of(context).back, style: TextStyle(color: appColor)))
                                                              )
                                                            ],
                                                          )

                                                        ],
                                                      ],
                                                    )
                                                ),
                                              );
                                            });
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  icon: Icon(FontAwesomeIcons.boxesPacking),
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(AppLocalizations.of(context).luggageInfo),
                                  )
                              ),
                              content: controller.shippingType == "receptionOffer"?
                              Column(
                                children: [

                                  ListTile(
                                      title: Text(AppLocalizations.of(context).reference, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: buttonColor))),
                                      trailing: Text(controller.shippingDetails['name'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 13)))
                                    //Text(controller.travelCard['state'] == "negotiating" ? "Published" : controller.travelCard['state'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                  ),
                                  ListTile(
                                      title: Text(AppLocalizations.of(context).shippingDate, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: buttonColor))),
                                      trailing: Text(DateFormat("dd MMM yyyy").format(DateTime.parse(controller.shippingDetails['create_date'])), style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 13)))
                                    //Text(controller.travelCard['state'] == "negotiating" ? "Published" : controller.travelCard['state'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                  ),

                                  ExpansionTile(
                                    leading: Icon(FontAwesomeIcons.userCheck, size: 20),
                                    title: Text("Infos de l' expediteur".tr, style: Get.textTheme.bodyText1.
                                    merge(TextStyle(color: appColor, fontSize: 17))),
                                    children: [
                                      AccountWidget(
                                        icon: FontAwesomeIcons.person,
                                        text: AppLocalizations.of(context).fullName,
                                        value: controller.shippingDetails['parcel_reception_shipper'][1].toString() ,
                                      ),
                                      AccountWidget(
                                        icon: Icons.alternate_email,
                                        text: AppLocalizations.of(context).emailAddress,
                                        value: controller.shippingDetails['parcel_reception_shipper_email'].toString(),
                                      ),

                                      AccountWidget(
                                        icon: FontAwesomeIcons.phone,
                                        text: AppLocalizations.of(context).phoneNumber,
                                        value: controller.shippingDetails['parcel_reception_shipper_phone'].toString(),
                                      )
                                    ],
                                    initiallyExpanded: true,
                                  ),

                                ],
                              )
                              :Column(
                                children: [

                                  ListTile(
                                      title: Text(AppLocalizations.of(context).reference, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: buttonColor))),
                                      trailing: Text(controller.shippingDetails['name'], style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 13)))
                                    //Text(controller.travelCard['state'] == "negotiating" ? "Published" : controller.travelCard['state'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                  ),
                                  ListTile(
                                      title: Text(AppLocalizations.of(context).shippingDate, style: Get.textTheme.headline2.merge(TextStyle(fontSize: 14, color: buttonColor))),
                                      trailing: Text(DateFormat("dd MMM yyyy").format(DateTime.parse(controller.shippingDetails['create_date'])), style: Get.textTheme.headline1.merge(TextStyle(color: Colors.black, fontSize: 13)))
                                    //Text(controller.travelCard['state'] == "negotiating" ? "Published" : controller.travelCard['state'], style: Get.textTheme.headline1.merge(TextStyle(fontSize: 18))),
                                  ),

                                  ExpansionTile(
                                    leading: Icon(FontAwesomeIcons.userCheck, size: 20),
                                    title: Text(AppLocalizations.of(context).receiverInfo.tr, style: Get.textTheme.bodyText1.
                                    merge(TextStyle(color: appColor, fontSize: 17))),
                                    children: [
                                      AccountWidget(
                                        icon: FontAwesomeIcons.person,
                                        text: AppLocalizations.of(context).fullName,
                                        value: controller.shippingDetails['receiver_source'] == "database" ?
                                        controller.shippingDetails['receiver_partner_id'][1] : controller.shippingDetails['receiver_name_set'],
                                      ),
                                      AccountWidget(
                                        icon: Icons.alternate_email,
                                        text: AppLocalizations.of(context).emailAddress,
                                        value: controller.shippingDetails['receiver_source'].toString() == "database" ?
                                        controller.shippingDetails['receiver_email'].toString() : controller.shippingDetails['receiver_email_set'].toString(),
                                      ),
                                      AccountWidget(
                                        icon: FontAwesomeIcons.addressCard,
                                        text: AppLocalizations.of(context).residentialAddress,
                                        value: controller.shippingDetails['receiver_source'] == "database" ? controller.shippingDetails['receiver_city_id'] != false ?
                                        "${controller.shippingDetails['receiver_city_id'][1]}, ${controller.shippingDetails['receiver_address']}" : "___" :
                                        "${controller.shippingDetails['receiver_city_id'] != false ? controller.shippingDetails['receiver_city_id'][1] : " "}, ${controller.shippingDetails['receiver_street_set']}",
                                      ),
                                      AccountWidget(
                                        icon: FontAwesomeIcons.phone,
                                        text: AppLocalizations.of(context).phoneNumber,
                                        value: controller.shippingDetails['receiver_source'] == "database" ?
                                        controller.shippingDetails['receiver_phone'] : controller.shippingDetails['receiver_phone_set'],
                                      )
                                    ],
                                    initiallyExpanded: true,
                                  ),

                                ],
                              )
                          )),
                          if(controller.owner.value)...[

                            if(controller.shippingDetails["travelbooking_id"] != false && controller.shippingDetails["bool_parcel_reception"] == false )...[
                              if(controller.travelDetails.isNotEmpty)...[
                                if(controller.shippingDetails['shipping_departure_city_id']!=false && controller.shippingDetails['shipping_arrival_city_id'] != false)
                                  EServiceTilWidget(
                                    actions: SizedBox(),
                                    title: Text(AppLocalizations.of(context).aboutTravel.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black))),

                                    content: buildTravelCard(context, controller.travelDetails),
                                  ),
                                EServiceTilWidget(
                                  title: Text(AppLocalizations.of(context).aboutTraveler.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black))),
                                  actions: Obx(() =>
                                  controller.shippingDetails['booking_type'] == 'By Road'?
                                  controller.shippingDetails['average_rating'] != 0.0 ?
                                  TextButton(
                                      onPressed: ()=>{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).loadingData),
                                          duration: Duration(seconds: 3),
                                        )),
                                        controller.getUserRating(controller.travelDetails['partner_id'][0]),
                                      },
                                      child: Text( !controller.viewRatings.value ? AppLocalizations.of(context).viewRatings : "", style: Get.textTheme.subtitle2.merge(TextStyle(color: interfaceColor)))
                                  ) : Text(''):
                                  controller.shippingDetails['booking_type'] == 'By Air'?controller.shippingDetails['air_average_rating'] != 0.0 ?TextButton(
                                      onPressed: ()=>{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).loadingData),
                                          duration: Duration(seconds: 3),
                                        )),
                                        controller.getUserRating(controller.travelDetails['partner_id'][0]),
                                      },
                                      child: Text( !controller.viewRatings.value ? AppLocalizations.of(context).viewRatings : "", style: Get.textTheme.subtitle2.merge(TextStyle(color: interfaceColor)))
                                  ):Text(''):Text('')
                                  ),
                                  content: buildUserDetailsCard(context),
                                )
                              ]
                            ],
                            if(controller.shippingDetails["travelbooking_id"] != false && controller.shippingDetails["bool_parcel_reception"] == true )...[
                              if(controller.travelDetails.isNotEmpty)...[
                                if(controller.shippingDetails['shipping_departure_city_id']!=false && controller.shippingDetails['shipping_arrival_city_id'] != false)
                                  EServiceTilWidget(
                                    actions: SizedBox(),
                                    title: Text(AppLocalizations.of(context).aboutTravel.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black))),

                                    content: buildTravelCard(context, controller.travelDetails),
                                  ),
                                EServiceTilWidget(
                                  title: Text(AppLocalizations.of(context).aboutTraveler.tr, style: Get.textTheme.subtitle2.merge(TextStyle(color: Colors.black))),
                                  actions: Obx(() =>
                                  controller.shippingDetails['booking_type'] == 'By Road'?
                                  controller.shippingDetails['average_rating'] != 0.0 ?
                                  TextButton(
                                      onPressed: ()=>{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).loadingData),
                                          duration: Duration(seconds: 3),
                                        )),
                                        controller.getUserRating(controller.travelDetails['partner_id'][0]),
                                      },
                                      child: Text( !controller.viewRatings.value ? AppLocalizations.of(context).viewRatings : "", style: Get.textTheme.subtitle2.merge(TextStyle(color: interfaceColor)))
                                  ) : Text(''):
                                  controller.shippingDetails['booking_type'] == 'By Air'?controller.shippingDetails['air_average_rating'] != 0.0 ?TextButton(
                                      onPressed: ()=>{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).loadingData),
                                          duration: Duration(seconds: 3),
                                        )),
                                        controller.getUserRating(controller.travelDetails['partner_id'][0]),
                                      },
                                      child: Text( !controller.viewRatings.value ? AppLocalizations.of(context).viewRatings : "", style: Get.textTheme.subtitle2.merge(TextStyle(color: interfaceColor)))
                                  ):Text(''):Text('')
                                  ),
                                  content: buildUserDetailsCard(context),
                                )
                              ]
                            ]

      ]



                        ]
                    )
                )
              ]
          )
      );
    });
  }


  Widget buildTravelCard(BuildContext context, var travelDetails){
    String departureCity = travelDetails['departure_city_id'][1].split('(').first;
    String a = travelDetails['departure_city_id'][1].split('(').last;
    String departureCountry = a.split(')').first;

    String arrivalCity = travelDetails['arrival_city_id'][1].split('(').first;

    String b = travelDetails['arrival_city_id'][1].split('(').last;
    String arrivalCountry = b.split(')').first;

    return Column(
      children: [
        AccountWidget(
          icon: FontAwesomeIcons.bus,
          text: AppLocalizations.of(context).departureTown,
          value: '$departureCity ( $departureCountry)',
        ),
        AccountWidget(
          icon: FontAwesomeIcons.bus,
          text: AppLocalizations.of(context).arrivalTown,
          value: '$arrivalCity ($arrivalCountry)',
        ),

        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  children: [
                    Text(AppLocalizations.of(context).departureDate.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    //FaIcon(FontAwesomeIcons.planeDeparture),
                    SizedBox(height: 10),
                    RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.parse(travelDetails['departure_date'])), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                            ]
                        ))
                  ]
              ),
              Spacer(),
              Column(
                children: [
                  Text(AppLocalizations.of(context).arrivalDate.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  //FaIcon(FontAwesomeIcons.planeArrival),
                  SizedBox(height: 10),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.parse(travelDetails['arrival_date'])), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                          ]
                      ))
                ],
              )
            ]
        )

      ],
    );
  }


  Widget buildCodeSheet(BuildContext context, var travelCode, var shipping){

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
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                SizedBox(height: 20),
                Text(AppLocalizations.of(context).shippingValidation, style: Get.textTheme.headline4.merge(TextStyle(fontSize: 20))),
                SizedBox(height: 20),
                DelayedAnimation(
                    delay: 100,
                    child: Container(
                        padding: EdgeInsets.only(top: 00,bottom: 20, left: 60, right: 60),
                        child: QrImageView(
                          data: "$travelCode-${shipping['id']}",
                          version: QrVersions.auto,
                          size: 200,
                          gapless: false,
                        )
                    )
                ),
                SizedBox(height: 20),
                Text('------ ${AppLocalizations.of(context).orUpperCase} ------'.tr, style: TextStyle(fontSize: 20)),

                SizedBox(height: 20),
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
                            Obx(() => TextFormField(
                              initialValue: "$travelCode-${shipping['id']}",
                              //controller: codeController,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: ()=> {

                                        controller.copyPressed.value = true,
                                        Clipboard.setData(ClipboardData(text: "$travelCode-${shipping['id']}")),
                                        Fluttertoast.showToast(
                                          msg: 'Copied to clipboard',
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: inactive,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        )

                                      },
                                      icon: Icon(Icons.file_copy, color:controller.copyPressed.value ? validateColor : null)
                                  )
                              ),
                              style: Get.textTheme.bodyText2,
                              readOnly: true,
                              obscureText: false,
                              textAlign: TextAlign.start,
                            )),
                            //IconButton(onPressed: ()=>{}, icon: Icon(Icons.file_copy))
                          ],
                        )
                    )),
              ],
            )
        )
    );
  }

  Container buildCarouselBullets(BuildContext context) {
    double width = MediaQuery.of(context).size.width/1.2;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Container(
            alignment: Alignment.center,
            width: width,
            height: 100,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      children: [
                        Text(AppLocalizations.of(context).departure.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        //FaIcon(FontAwesomeIcons.planeDeparture),
                        SizedBox(height: 10),
                        RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.parse(controller.travelDetails.isNotEmpty?controller.travelDetails['departure_date']:controller.shippingDetails['shipping_departure_date'])), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                                  TextSpan(text: "\n${controller.travelDetails.isNotEmpty? controller.travelDetails['departure_date'].split(" ").last:controller.shippingDetails['shipping_departure_date'].split(" ").last}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                                ]
                            ))
                      ]
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(AppLocalizations.of(context).arrival.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                      //FaIcon(FontAwesomeIcons.planeArrival),
                      SizedBox(height: 10),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(text: DateFormat("dd MMM yyyy").format(DateTime.parse(controller.travelDetails.isNotEmpty?controller.travelDetails['arrival_date']:controller.shippingDetails['shipping_arrival_date'])), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 16, color: appColor))),
                                TextSpan(text: "\n${controller.travelDetails.isNotEmpty?controller.travelDetails['arrival_date'].split(" ").last:controller.shippingDetails['shipping_arrival_date'].split(" ").last}", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                              ]
                          ))
                    ],
                  )
                ]
            )
        )
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width/2.8;
    String departureCity = controller.shippingDetails['travelbooking_id'] != false && controller.shippingDetails['travelbooking_id'] != "m1st_hk_roadshipping.travelbooking()" ?controller.shippingDetails['travel_departure_city_name'].split('(').first:controller.shippingDetails['shipping_departure_city_id'][1].split('(').first;
    String a = controller.shippingDetails['travelbooking_id'] != false ?controller.shippingDetails['travel_departure_city_name'].split('(').last:controller.shippingDetails['shipping_departure_city_id'][1].split('(').last;
    String departureCountry = a.split(')').first;

    String arrivalCity = controller.shippingDetails['travelbooking_id'] != false && controller.shippingDetails['travelbooking_id'] != "m1st_hk_roadshipping.travelbooking()" ?controller.shippingDetails['travel_arrival_city_name'].split('(').first:controller.shippingDetails['shipping_arrival_city_id'][1].split('(').first;

    String b = controller.shippingDetails['travelbooking_id'] != false ? controller.shippingDetails['travel_arrival_city_name'].split('(').last:controller.shippingDetails['shipping_arrival_city_id'][1].split('(').last;
    String arrivalCountry = b.split(')').first;

    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: departureCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14))),
                            TextSpan(text: "\n$departureCountry", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                          ]
                      )
                  )
              ),
              FaIcon(FontAwesomeIcons.arrowRight),
              Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: arrivalCity, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 14))),
                            TextSpan(text: "\n$arrivalCountry", style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)))
                          ]
                      ))
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildUserDetailsCard(BuildContext context) {
    return Obx(() => SizedBox(
      height: !controller.viewRatings.value ? 80 : Get.height/2,
      width: Get.width,
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: FadeInImage(
                      width: 65,
                      height: 65,
                      image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.travelDetails['partner_id'][0]}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                      placeholder: AssetImage(
                          "assets/img/loading.gif"),
                      imageErrorBuilder:
                          (context, error, stackTrace) {
                        return Image.asset(
                            'assets/img/téléchargement (3).png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.fitWidth);
                      },
                    )
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(controller.travelDetails['partner_id'][1],
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 2,
                        style: Get.textTheme.headline1.merge(TextStyle(fontSize: 12, color: appColor)),
                      ),
                    ],
                  ),
                ),

                Text("⭐️ ${controller.travelDetails['booking_type']=='road'?controller.travelDetails['average_rating'].toStringAsFixed(1):controller.travelDetails['air_average_rating'].toStringAsFixed(1)}", style: TextStyle(fontSize: 12, color: appColor))
              ]
          ),
          if(controller.viewRatings.value)
            Expanded(
              child: ListView.builder(
                  itemCount: controller.ratings.length,
                  itemBuilder: (_, index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipOval(
                                  child: FadeInImage(
                                    width: 40,
                                    height: 40,
                                    image: NetworkImage('${Domain.serverPort}/image/res.partner/${controller.ratings[index]['rater_id'][0]}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                    placeholder: AssetImage(
                                        "assets/img/loading.gif"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/téléchargement (3).png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fitWidth);
                                    },
                                  )
                              ),
                              Flexible(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        width: Get.width,
                                        margin: EdgeInsets.only(top: 5.0),
                                        child: Row(
                                            children: [
                                              Expanded(child: Text(controller.ratings[index]['rater_id'][1],
                                                style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 12)),
                                              )),
                                              for(var i=0; i < int.parse(controller.ratings[index]['rating']); i++)...[
                                                Text('⭐️')
                                              ]
                                            ]
                                        )
                                    ),
                                    Text("\n" + controller.ratings[index]['comment'].toString(),
                                      style: Get.textTheme.bodyText1.merge(TextStyle(color: Colors.black, fontSize: 10)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                              DateFormat('dd, MMM yyyy').format(DateTime.parse(controller.ratings[index]['rating_date'])),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Get.textTheme.headline1.merge(TextStyle(color: appColor,fontSize: 12))
                          ),
                        ),
                      ],
                    );
                  }),
            )
        ],
      ),
    ));
  }

  Widget buildBottomWidget(BuildContext context) {

    Get.lazyPut(()=>TravelInspectController());

    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Obx(() => (controller.shippingType.value=='shippingOffer' )?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(controller.shippingDetails['partner_id'][0] == Get.find<MyAuthService>().myUser.value.id )...[
              GestureDetector(
                  onTap: ()=> {
                    showDialog(
                        context: Get.context,
                        barrierDismissible: false,
                        builder: (_){
                          return SpinKitThreeBounce(size: 30, color: Colors.white,);
                        }),
                    Get.find<TravelInspectController>().editing.value = true,
                    Get.find<TravelInspectController>().departureId.value = controller.shippingDetails['shipping_departure_city_id'][0],
                    Get.find<TravelInspectController>().arrivalId.value = controller.shippingDetails['shipping_arrival_city_id'][0],
                    Get.find<TravelInspectController>().departureDate.value = controller.shippingDetails['shipping_departure_date'],
                    Get.find<TravelInspectController>().arrivalDate.value = controller.shippingDetails['shipping_arrival_date'],
                    Get.find<TravelInspectController>().depTown.text = controller.shippingDetails['shipping_departure_city_id'][1],
                    Get.find<TravelInspectController>().arrTown.text = controller.shippingDetails['shipping_departure_city_id'][1],

                    Get.toNamed(Routes.CREATE_OFFER_EXPEDITION, arguments: {'shippingDto': controller.shippingDetails}),

                  },
                  child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: SizedBox(
                          height: 70,
                          width: 60,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(FontAwesomeIcons.edit, size: 50),
                                Text(AppLocalizations.of(context).edit.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                              ]
                          )
                      )
                  )
              ),
              SizedBox(width: 10),
              GestureDetector(
                  onTap: ()=> showDialog(
                      context: context,
                      builder: (_)=>
                          PopUpWidget(
                            title: AppLocalizations.of(context).shippingCancellation,
                            cancel: AppLocalizations.of(context).back,
                            confirm: AppLocalizations.of(context).cancel,
                            onTap: () async =>{

                              print(controller.shippingDetails['id']),
                              await controller.cancelRoadShipping(controller.shippingDetails['id']),

                            }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                          )
                  ),
                  child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: SizedBox(
                          height: 70,
                          width: 60,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.remove_circle_outline_sharp, size: 50),
                                Text(AppLocalizations.of(context).cancel.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                              ]
                          )
                      )
                  )
              )


            ]

          ],
        ).marginSymmetric(horizontal: 10):
        controller.shippingType.value=='receptionOffer'?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(controller.shippingDetails['state'] =='pending' && controller.shippingDetails['booking_type'] =='By Road' || controller.shippingDetails['booking_type'] =='')...[

        if(controller.shippingDetails['parcel_reception_receiver_partner_id'][0] == Get.find<MyAuthService>().myUser.value.id )...[
          if(!controller.shippingDetails['disagree'])...[
            GestureDetector(
                onTap: ()=> {
                  showDialog(
                      context: Get.context,
                      barrierDismissible: false,
                      builder: (_){
                        return SpinKitThreeBounce(size: 30, color: Colors.white,);
                      }),
                  Get.find<TravelInspectController>().editing.value = true,
                  Get.find<TravelInspectController>().departureId.value = controller.shippingDetails['shipping_departure_city_id'][0],
                  Get.find<TravelInspectController>().arrivalId.value = controller.shippingDetails['shipping_arrival_city_id'][0],
                  Get.find<TravelInspectController>().departureDate.value = controller.shippingDetails['shipping_departure_date'],
                  Get.find<TravelInspectController>().arrivalDate.value = controller.shippingDetails['shipping_arrival_date'],
                  Get.find<TravelInspectController>().depTown.text = controller.shippingDetails['shipping_departure_city_id'][1],
                  Get.find<TravelInspectController>().arrTown.text = controller.shippingDetails['shipping_departure_city_id'][1],

                  Get.toNamed(Routes.CREATE_RECEPTION_OFFER, arguments: {'shippingDto': controller.shippingDetails}),

                },
                child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                        height: 70,
                        width: 60,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(FontAwesomeIcons.edit, size: 50),
                              Text(AppLocalizations.of(context).edit.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                            ]
                        )
                    )
                )
            ),
            SizedBox(width: 10),
            GestureDetector(
                onTap: ()=> showDialog(
                    context: context,
                    builder: (_)=>
                        PopUpWidget(
                          title: AppLocalizations.of(context).shippingCancellation,
                          cancel: AppLocalizations.of(context).back,
                          confirm: AppLocalizations.of(context).cancel,
                          onTap: () async =>{

                            print(controller.shippingDetails['id']),
                            await controller.cancelRoadShipping(controller.shippingDetails['id']),

                          }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                        )
                ),
                child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                        height: 70,
                        width: 60,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.remove_circle_outline_sharp, size: 50),
                              Text(AppLocalizations.of(context).cancel.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                            ]
                        )
                    )
                )
            )
          ]else...[
            GestureDetector(
                onTap: ()=> showDialog(
                    context: context,
                    builder: (_)=>
                        PopUpWidget(
                          title: AppLocalizations.of(context).transfer,
                          cancel: AppLocalizations.of(context).cancel,
                          confirm: AppLocalizations.of(context).confirm,
                          onTap: () async => {
                            Navigator.of(Get.context).pop(),
                            controller.transferShipping(controller.shippingDetails['id']),
                          }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                        )
                ),
                child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                        height: 70,
                        width: 60,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.fast_forward_rounded, size: 50),
                              Text(AppLocalizations.of(context).transfer.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                            ]
                        )
                    )
                )
            )
          ]
        ]

            ],

            if(controller.shippingDetails['state'] !='pending')...[
              if(controller.shippingDetails['state'] !='rejected')...[
                if(controller.shippingDetails['booking_type'] == 'By Road')...[
                  if(controller.shippingDetails['state'] =='received' && controller.shippingDetails['is_rated'] == false)...[
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: interfaceColor
                        ),
                        onPressed: ()=> {
                          Get.toNamed(Routes.RATING, arguments: {'shippingDetails': controller.shippingDetails,'travellerId': controller.travelDetails['partner_id'][0], 'heroTag': 'services_carousel'}),
                        },
                        icon: Icon(Icons.thumb_up),
                        label: SizedBox(
                            width: Get.width/2,
                            height: 40,
                            child: Center(
                              child: Text(AppLocalizations.of(context).rateTraveller),
                            )
                        )
                    )
                  ]else...[
                    if(controller.shippingDetails['state'] !='accepted' && controller.shippingDetails['is_rated'] != false)...[
                      GestureDetector(
                          onTap: ()async=>{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context).loadingData),
                              duration: Duration(seconds: 2),
                            )),
                            await controller.getUserInvoice(controller.shippingDetails['move_id'][0]),

                          },
                          child: Card(
                              elevation: 10,
                              color: interfaceColor,
                              margin: EdgeInsets.symmetric( vertical: 15),
                              child: SizedBox(
                                  width: Get.width/2,
                                  height: 40,
                                  child: Center(
                                      child: Text(AppLocalizations.of(context).viewInvoice.tr, style: TextStyle(color: Colors.white))
                                  )
                              )
                          )
                      )]

                  ]
                ]

              ]
            ]



          ],
        ).marginSymmetric(horizontal: 10)
            : controller.shippingType.value=='shippingRequest'?
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              if(controller.shippingDetails['state'] =='pending' && controller.shippingDetails['booking_type'] =='By Road')...[

                if(!controller.shippingDetails['disagree'])...[
                  GestureDetector(
                      onTap: () async => {
                        showDialog(
                            context: Get.context,
                            barrierDismissible: false,
                            builder: (_){
                              return SpinKitThreeBounce(size: 30, color: Colors.white,);
                            }),

                        Get.find<TravelInspectController>().editing.value = true,
                        Get.find<TravelInspectController>().shipping = controller.shippingDetails,
                        await  Get.find<TravelInspectController>().editingFunction(),
                        Get.toNamed(Routes.ADD_SHIPPING_FORM, arguments: {'shippingDto': controller.shippingDetails,  'heroTag': 'services_carousel'}),


                      },
                      child: Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: SizedBox(
                              height: 70,
                              width: 60,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(FontAwesomeIcons.edit, size: 50),
                                    Text(AppLocalizations.of(context).edit.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                                  ]
                              )
                          )
                      )
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                      onTap: ()=> showDialog(
                          context: context,
                          builder: (_)=>
                              PopUpWidget(
                                title: AppLocalizations.of(context).shippingCancellation,
                                cancel: AppLocalizations.of(context).back,
                                confirm: AppLocalizations.of(context).cancel,
                                onTap: () async =>{

                                  print(controller.shippingDetails['id']),
                                  await controller.cancelRoadShipping(controller.shippingDetails['id']),

                                }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                              )
                      ),
                      child: Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: SizedBox(
                              height: 70,
                              width: 60,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.remove_circle_outline_sharp, size: 50),
                                    Text(AppLocalizations.of(context).cancel.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                                  ]
                              )
                          )
                      )
                  )
                ]else...[
                  GestureDetector(
                      onTap: ()=> showDialog(
                          context: context,
                          builder: (_)=>
                              PopUpWidget(
                                title: AppLocalizations.of(context).transfer,
                                cancel: AppLocalizations.of(context).cancel,
                                confirm: AppLocalizations.of(context).confirm,
                                onTap: () async => {
                                  Navigator.of(Get.context).pop(),
                                  controller.transferShipping(controller.shippingDetails['id']),
                                }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                              )
                      ),
                      child: Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: SizedBox(
                              height: 70,
                              width: 60,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.fast_forward_rounded, size: 50),
                                    Text(AppLocalizations.of(context).transfer.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                                  ]
                              )
                          )
                      )
                  )
                ]

              ]else...[
                if(controller.shippingDetails['state'] =='pending' && controller.shippingDetails['booking_type'] =='By Air')...[
                  if(controller.shippingDetails['move_id'].toString() == 'false')...[
                    GestureDetector(
                        onTap: () async => {
                          showDialog(
                              context: Get.context,
                              barrierDismissible: false,
                              builder: (_){
                                return SpinKitThreeBounce(size: 30, color: Colors.white,);
                              }),
                          Get.find<TravelInspectController>().editing.value = true,
                          Get.find<TravelInspectController>().shipping = controller.shippingDetails,
                          Get.find<TravelInspectController>().travel = controller.travelDetails,
                          await Get.find<TravelInspectController>().editingFunction(),
                          Get.toNamed(Routes.ADD_SHIPPING_FORM, arguments: {'shippingDto': controller.shippingDetails, 'travelDto': controller.travelDetails,'heroTag': 'services_carousel'}),


                        },
                        child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: SizedBox(
                                height: 70,
                                width: 60,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(FontAwesomeIcons.edit, size: 50),
                                      Text(AppLocalizations.of(context).edit.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                                    ]
                                )
                            )
                        )
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                        onTap: ()=> showDialog(
                            context: context,
                            builder: (_)=>
                                PopUpWidget(
                                  title: AppLocalizations.of(context).shippingCancellation,
                                  cancel: AppLocalizations.of(context).back,
                                  confirm: AppLocalizations.of(context).cancel,
                                  onTap: () async =>{

                                    print(controller.shippingDetails['id']),
                                    await controller.cancelAirShipping(controller.shippingDetails['id']),

                                  }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                                )
                        ),
                        child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: SizedBox(
                                height: 70,
                                width: 60,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.remove_circle_outline_sharp, size: 50),
                                      Text(AppLocalizations.of(context).cancel.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                                    ]
                                )
                            )
                        )
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                        onTap: ()=> showDialog(
                            context: context,
                            builder: (_)=>
                                PopUpWidget(
                                  title: AppLocalizations.of(context).transfer,
                                  cancel: AppLocalizations.of(context).cancel,
                                  confirm: AppLocalizations.of(context).confirm,
                                  onTap: () async => {
                                    Navigator.of(Get.context).pop(),
                                    controller.transferShipping(controller.shippingDetails['id']),
                                  }, icon: Icon(FontAwesomeIcons.warning, size: 50),
                                )
                        ),
                        child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: SizedBox(
                                height: 70,
                                width: 60,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.fast_forward_rounded, size: 50),
                                      Text(AppLocalizations.of(context).transfer.toUpperCase(), style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                                    ]
                                )
                            )
                        )
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                        onTap: ()async{
                          print(controller.shippingDetails['id']);
                          await controller.payAirShipping(controller.shippingDetails['id']);
                          await controller.getAirShipping(controller.shippingDetails['id']);
                        },
                        child: Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: SizedBox(
                                height: 70,
                                width: 60,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.money_rounded, size: 50),
                                      Text('Pay Now', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 10, color: inactive)))
                                    ]
                                )
                            )
                        )
                    )
                  ]


                ]
              ],
              if(controller.shippingDetails['state'] !='pending')...[
                if(controller.shippingDetails['state'] !='rejected')...[
                  if(controller.shippingDetails['booking_type'] == 'By Road')...[
                    if(controller.shippingDetails['state'] =='received' && controller.shippingDetails['is_rated'] == false)...[
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: interfaceColor
                          ),
                          onPressed: ()=> {
                            Get.toNamed(Routes.RATING, arguments: {'shippingDetails': controller.shippingDetails,'travellerId': controller.travelDetails['partner_id'][0], 'heroTag': 'services_carousel'}),
                          },
                          icon: Icon(Icons.thumb_up),
                          label: SizedBox(
                              width: Get.width/2,
                              height: 40,
                              child: Center(
                                child: Text(AppLocalizations.of(context).rateTraveller),
                              )
                          )
                      )
                    ]
                    else...[
                      if(controller.shippingDetails['state'] !='accepted' && controller.shippingDetails['is_rated'] != false)...[
                        GestureDetector(
                            onTap: ()async=>{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 2),
                              )),
                              await controller.getUserInvoice(controller.shippingDetails['move_id'][0]),

                            },
                            child: Card(
                                elevation: 10,
                                color: interfaceColor,
                                margin: EdgeInsets.symmetric( vertical: 15),
                                child: SizedBox(
                                    width: Get.width/2,
                                    height: 40,
                                    child: Center(
                                        child: Text(AppLocalizations.of(context).viewInvoice.tr, style: TextStyle(color: Colors.white))
                                    )
                                )
                            )
                        )]
                      else...[
                        if(controller.shippingDetails['state'] =='accepted'&& controller.shippingDetails['booking_type'] =='By Air')
                          GestureDetector(
                              onTap: ()async=>{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context).loadingData),
                                  duration: Duration(seconds: 2),
                                )),
                                await controller.getUserInvoice(controller.shippingDetails['move_id'][0]),

                              },
                              child: Card(
                                  elevation: 10,
                                  color: interfaceColor,
                                  margin: EdgeInsets.symmetric( vertical: 15),
                                  child: SizedBox(
                                      width: Get.width/2,
                                      height: 40,
                                      child: Center(
                                          child: Text('Pay Now'.tr, style: TextStyle(color: Colors.white))
                                      )
                                  )
                              )
                          )
                      ]
                    ]
                  ]
                  else...[
                    if(controller.shippingDetails['state'] =='received' && controller.shippingDetails['is_rated'] == false)...[
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: interfaceColor
                          ),
                          onPressed: ()=> {
                            Get.toNamed(Routes.RATING, arguments: {'shippingDetails': controller.shippingDetails,'travellerId': controller.travelDetails['partner_id'][0], 'heroTag': 'services_carousel'}),
                          },
                          icon: Icon(Icons.thumb_up),
                          label: SizedBox(
                              width: Get.width/2,
                              height: 40,
                              child: Center(
                                child: Text(AppLocalizations.of(context).rateTraveller),
                              )
                          )
                      )
                    ]else...[
                      if(controller.shippingDetails['state'] !='accepted' && controller.shippingDetails['is_rated'] != false)...[
                        GestureDetector(
                            onTap: ()async=>{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context).loadingData),
                                duration: Duration(seconds: 2),
                              )),
                              await controller.getUserInvoice(controller.shippingDetails['move_id'][0]),

                            },
                            child: Card(
                                elevation: 10,
                                color: interfaceColor,
                                margin: EdgeInsets.symmetric( vertical: 15),
                                child: SizedBox(
                                    width: Get.width/2,
                                    height: 40,
                                    child: Center(
                                        child: Text(AppLocalizations.of(context).viewInvoice.tr, style: TextStyle(color: Colors.white))
                                    )
                                )
                            )
                        )]
                      else...[
                        if(controller.shippingDetails['state'] =='accepted'&& controller.shippingDetails['booking_type'] =='By Air')
                          GestureDetector(
                              onTap: ()async=>{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context).loadingData),
                                  duration: Duration(seconds: 2),
                                )),
                                await controller.getUserInvoice(controller.shippingDetails['move_id'][0]),

                              },
                              child: Card(
                                  elevation: 10,
                                  color: interfaceColor,
                                  margin: EdgeInsets.symmetric( vertical: 15),
                                  child: SizedBox(
                                      width: Get.width/2,
                                      height: 40,
                                      child: Center(
                                          child: Text('Pay Now'.tr, style: TextStyle(color: Colors.white))
                                      )
                                  )
                              )
                          )
                      ]
                    ]

                  ]

                ]
              ]




            ]
        ):SizedBox()
        )

    );
  }

  Widget buildTravellerView(BuildContext context){
    return controller.shippingDetails["booking_type"] == 'By Road'?
    !controller.shippingDetails["disagree"] ? Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ]
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(controller.shippingDetails["state"].toLowerCase() == 'pending' && !controller.shippingDetails['msg_shipping_accepted'] && controller.shippingDetails["booking_type"] == 'By Road')
              GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_)=>
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              icon: Icon(Icons.warning, size: 50),
                              content: SizedBox(
                                  height: 100,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(AppLocalizations.of(context).firstPriceProposition, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15, color: Colors.black))),
                                        SizedBox(
                                          width: Get.width,
                                          height: 40,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.black,
                                            onChanged: (value) {
                                              controller.price.value = double.parse(value.toString());
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: background,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: ()=>{
                                      controller.price.value = 0.0,
                                      Navigator.pop(context)
                                    },
                                        child: Text(AppLocalizations.of(context).back, style: TextStyle(color: inactive))),
                                    SizedBox(width: 10),
                                    TextButton(onPressed: ()=> {
                                      if(controller.price.value != 0.0){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).loadingData),
                                          duration: Duration(seconds: 4),
                                        )),
                                        print(controller.price.value),
                                        controller.sendMessage(controller.shippingDetails)
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).enterPrice),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: specialColor.withOpacity(0.5),
                                        ))
                                      }
                                    },
                                        child: Text(AppLocalizations.of(context).confirm, style: TextStyle(color: interfaceColor)))
                                  ],
                                )
                              ],
                            )
                    );

                  },
                  child: Card(
                      color: validateColor,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                          height: 40,
                          width: 100,
                          child: Center(
                              child: Text(AppLocalizations.of(context).accept.tr, style: TextStyle(color: Colors.white))
                          )
                      )
                  )
              ),
            if(controller.shippingDetails["state"].toLowerCase() == 'pending' && controller.shippingDetails["booking_type"] == 'By Road')
              GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_)=>
                            PopUpWidget(
                              title: AppLocalizations.of(context).shippingRejection,
                              cancel: AppLocalizations.of(context).cancel,
                              confirm: AppLocalizations.of(context).reject,
                              onTap: () async =>{
                                await controller.rejectRoadShipping(controller.shippingDetails['id']),

                              }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                            )
                    );
                  },
                  child: Card(
                      color: specialColor,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                          height: 40,
                          width: 100,
                          child: Center(
                              child: Text(AppLocalizations.of(context).reject, style: TextStyle(color: Colors.white))
                          )
                      )
                  )
              ),
            if(controller.shippingDetails["state"].toLowerCase() == 'pending' && controller.shippingDetails["booking_type"] == 'By Air')
              GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_)=>
                            PopUpWidget(
                              title: AppLocalizations.of(context).shippingRejection,
                              cancel: AppLocalizations.of(context).cancel,
                              confirm: AppLocalizations.of(context).reject,
                              onTap: () async =>{
                                await controller.rejectAirShipping(controller.shippingDetails['id']),

                              }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                            )
                    );
                  },
                  child: Card(
                      color: specialColor,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                          height: 40,
                          width: 100,
                          child: Center(
                              child: Text(AppLocalizations.of(context).reject, style: TextStyle(color: Colors.white))
                          )
                      )
                  )
              )
          ]
      ),
    ) : SizedBox()
        : Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ]
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(controller.shippingDetails["state"].toLowerCase() == 'pending' && !controller.shippingDetails['msg_shipping_accepted'] && controller.shippingDetails["booking_type"] == 'By Road')
              GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_)=>
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              icon: Icon(Icons.warning, size: 50),
                              content: SizedBox(
                                  height: 100,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(AppLocalizations.of(context).firstPriceProposition, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15, color: Colors.black))),
                                        SizedBox(
                                          width: Get.width,
                                          height: 40,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.black,
                                            onChanged: (value) {
                                              controller.price.value = double.parse(value.toString());
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: background,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: ()=>{
                                      controller.price.value = 0.0,
                                      Navigator.pop(context)
                                    },
                                        child: Text(AppLocalizations.of(context).back, style: TextStyle(color: inactive))),
                                    SizedBox(width: 10),
                                    TextButton(onPressed: ()=> {
                                      if(controller.price.value != 0.0){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).loadingData),
                                          duration: Duration(seconds: 4),
                                        )),
                                        print(controller.price.value),
                                        controller.sendMessage(controller.shippingDetails)
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).enterPrice),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: specialColor.withOpacity(0.5),
                                        ))
                                      }
                                    },
                                        child: Text(AppLocalizations.of(context).confirm, style: TextStyle(color: interfaceColor)))
                                  ],
                                )
                              ],
                            )
                    );

                  },
                  child: Card(
                      color: validateColor,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                          height: 40,
                          width: 100,
                          child: Center(
                              child: Text(AppLocalizations.of(context).accept.tr, style: TextStyle(color: Colors.white))
                          )
                      )
                  )
              ),
            if(controller.shippingDetails["state"].toLowerCase() == 'pending' && controller.shippingDetails["booking_type"] == 'By Road')
              GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_)=>
                            PopUpWidget(
                              title: AppLocalizations.of(context).shippingRejection,
                              cancel: AppLocalizations.of(context).cancel,
                              confirm: AppLocalizations.of(context).reject,
                              onTap: () async =>{
                                await controller.rejectRoadShipping(controller.shippingDetails['id']),

                              }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                            )
                    );
                  },
                  child: Card(
                      color: specialColor,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                          height: 40,
                          width: 100,
                          child: Center(
                              child: Text(AppLocalizations.of(context).reject, style: TextStyle(color: Colors.white))
                          )
                      )
                  )
              ),
            if(controller.shippingDetails["state"].toLowerCase() == 'pending' && controller.shippingDetails["booking_type"] == 'By Air')
              GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_)=>
                            PopUpWidget(
                              title: AppLocalizations.of(context).shippingRejection,
                              cancel: AppLocalizations.of(context).cancel,
                              confirm: AppLocalizations.of(context).reject,
                              onTap: () async =>{
                                await controller.rejectAirShipping(controller.shippingDetails['id']),

                              }, icon: Icon(FontAwesomeIcons.warning, size: 40,color: specialColor),
                            )
                    );
                  },
                  child: Card(
                      color: specialColor,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                          height: 40,
                          width: 100,
                          child: Center(
                              child: Text(AppLocalizations.of(context).reject, style: TextStyle(color: Colors.white))
                          )
                      )
                  )
              )
          ]
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
}
