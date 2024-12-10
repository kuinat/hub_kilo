import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../home/controllers/home_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';

class UserTravelsController extends GetxController {

  final isDone = false.obs;
  var isLoading = true.obs;
  var items = [].obs;
  var state = "".obs;
  var myTravelsList = [];
  var roadTravels = [];
  var listAttachment = [];
  var roadTravelList = [];
  var airTravelList = [];
  var inNegotiation = false.obs;
  var listForProfile = [].obs;
  var listOfAllAirTravelsLuggages = [];
  var isConform = false.obs;
  final selectedState = <String>[].obs;
  var origin = [].obs;
  var status = ["ALL".tr, "PENDING".tr, "ACCEPTED".tr, "NEGOTIATING".tr, "COMPLETED".tr, "REJECTED".tr];
  //var travel_booking_id = 0.obs;

  ScrollController scrollController = ScrollController();
  var valueDropDownTravel = ''.obs;

  @override
  void onInit() {
    valueDropDownTravel.value = status[0];
    initValues();
    super.onInit();

  }

  @override
  void onReady(){

    initValues();
    super.onReady();
  }

  initValues()async{
    isLoading.value = true;
    Get.lazyPut(()=>UserTravelsController());


    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );

    Get.lazyPut(()=>AddTravelController());

    Get.lazyPut(()=>BookingsController());

    Get.lazyPut(() => HomeController());


    await getUser(Get.find<MyAuthService>().myUser.value.id);
    myTravelsList = await myRoadTravels();
    myTravelsList.addAll(await myAirTravels());



    items.value = [];
    origin.value = [];
    origin.value = myTravelsList;
    items.value = myTravelsList;

    await Get.find<BookingsController>().getAttachmentFiles();




  }

  Future refreshMyTravels() async {
    isLoading.value = true;
    items.clear();
    origin.clear();
    await getUser(Get.find<MyAuthService>().myUser.value.id);
    myTravelsList = await myRoadTravels();
    myTravelsList.addAll(await myAirTravels());
    origin.value = myTravelsList;
    items.value = myTravelsList;

  }

  void toggleTravels(bool value, String type) {
    if (value) {
      selectedState.clear();
      selectedState.add(type);
    } else {
      selectedState.removeWhere((element) => element == type);
    }
  }

  Future getUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];
      roadTravelList = data['travelbooking_ids'];
      airTravelList = data['air_travelbooking_ids'];
      listAttachment = data['partner_attachment_ids'];
    } else {
      print(response.reasonPhrase);
    }
  }

  Future myRoadTravels()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$roadTravelList'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      for(var travel in result){
        if(travel['state'] == 'negotiating'){
          Get.find<HomeController>().existingPublishedRoadTravel.value = true;
        }
      }

      return json.decode(data);
    }
    else {
      var data = await response.stream.bytesToString();

      print(data);
    }
  }
  Future myAirTravels()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.travelbooking?ids=$airTravelList'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // var result = json.decode(data);
      // for(var item in result){
      //   var luggages = await getSpecificAirTravelLuggages(item['luggage_types']);
      //   listOfAllAirTravelsLuggages.addAll(luggages);
      // }
      var result = json.decode(data);
      for(var travel in result){
        if(travel['state'] == 'negotiating'){
          Get.find<HomeController>().existingPublishedAirTravel.value = true;
        }
      }

      isLoading.value = false;
      return json.decode(data);
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
  }

  getSpecificAirTravelLuggages(List luggageIds)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.flight.luggage?ids=$luggageIds'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('specific : ${json.decode(data)}');

      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
      return [];
    }


  }

  publishTravel(int travelId)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.travelbooking/set_to_negotiating/?ids=$travelId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).travelPublished));
      showDialog(
          context: Get.context,
          builder: (context) {
            return SizedBox(height: 30,
                child: SpinKitThreeBounce(color: Colors.white, size: 20));
          },
      );
      await getUser(Get.find<MyAuthService>().myUser.value.id);
      myTravelsList = await myRoadTravels();
      myTravelsList.addAll(await myAirTravels());
      items.value = [];
      origin.value = [];
      origin.value = myTravelsList;
      items.value = myTravelsList;
      Navigator.of(Get.context).pop();
      showDialog(
          context: Get.context,
          builder: (_){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              icon: Icon(Icons.warning_amber_rounded, size: 40),
              title: Text('Add a Shipping to your travel!', style: Get.textTheme.headline2.merge(TextStyle(color: interfaceColor, fontSize: 14))),
              content: Text('Do you want to join your travel to a shipping offer or a reception offer?', style: Get.textTheme.headline4.merge(TextStyle(color: Colors.black, fontSize: 12))),
              actions: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Get.width/3,
                          height: 40,
                          child: TextButton(
                              onPressed: () => {
                                Navigator.pop(Get.context),
                                Get.lazyPut(()=>AddTravelController()),
                                Get.find<AddTravelController>().travel_booking_id.value = travelId,
                                Get.toNamed(Routes.EXPEDITIONS_OFFERS_VIEW),
                              },
                              child: Text('Shippings Offers', style: Get.textTheme.headline4
                              )
                          ),
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                          width: Get.width/3,
                          height: 40,
                          child: TextButton(
                              onPressed: () => {
                                Navigator.pop(Get.context),
                                Get.lazyPut(()=>AddTravelController()),
                                Get.find<AddTravelController>().travel_booking_id.value = travelId,
                                Get.toNamed(Routes.RECEPTIONS_OFFERS_VIEW),
                              },
                              child: Text('Receptions Offers', style: Get.textTheme.headline4
                              )
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () => Navigator.pop(Get.context),
                          child: Text(AppLocalizations.of(Get.context).cancel, style: Get.textTheme.headline4.merge(TextStyle(color: specialColor))
                          )
                      ),
                    ),

                ],)
              ],
            );
          });
      myTravelsList = await myRoadTravels();
      myTravelsList.addAll(await myAirTravels());
      items.value = myTravelsList;

    }
    else {
      var data = await response.stream.bytesToString();

      if(Get.find<AddTravelController>().isIdentityFileUnderAnalysis.value){
        showDialog(
            context: Get.context,
            builder: (_){
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                icon: Icon(Icons.warning_amber_rounded, size: 40),
                title: Text(AppLocalizations.of(Get.context).identityFilesNonConform, style: Get.textTheme.headline2.merge(TextStyle(color: interfaceColor, fontSize: 14))),
                content: Text('You have already uploaded an identity file, it is under analysis, when it will be confirmed'
                    'you can publish your travel', style: Get.textTheme.headline4.merge(TextStyle(color: Colors.black, fontSize: 12))),
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
            });
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
                content: Text(json.decode(data)['message']+"\n${AppLocalizations.of(Get.context).wantUploadNewFile}", style: Get.textTheme.headline4.merge(TextStyle(color: Colors.black, fontSize: 12))),
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
            });
      }


    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_city_id'][1]
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_city_id'][1]
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = dummySearchList;
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }


}
