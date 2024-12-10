import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;
import '../../../providers/odoo_provider.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';


class AllReceptionsOffersController extends GetxController {

  //final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  final myExpeditionsPage = 0.obs;
  final offerReception = false.obs;
  final buttonPressed = false.obs;
  final shippingSelected = false.obs;
  var receptionOffersSelected = [].obs;
  var allReceptionOffers = [].obs;
  var shippingDetails = [].obs;
  var list = [].obs;
  final imageUrl = "".obs;
  var totalPages = 0.obs;
  var currentPage = 1.obs;
  ScrollController scrollController = ScrollController();

  var receptionsOffersLoading = false.obs;

  AllExpeditionsOfferController() {
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut<TravelInspectController>(
          () => TravelInspectController(),
    );
    Get.lazyPut<AddTravelController>(
          () => AddTravelController(),
    );
    Get.lazyPut<UserTravelsController>(
          () => UserTravelsController(),
    );
    Get.put(AllReceptionsOffersController());

  }

  @override
  void onInit() async{
    super.onInit();

    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    await initValues();
  }

  // @override
  // void onReady()async{
  //   heroTag.value = Get.arguments.toString();
  //   await initValues();
  //   super.onReady();
  // }


  initValues()async{

    imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";


    // var arguments = Get.arguments as Map<String, dynamic>;
    // if(arguments != null) {
    //   shippingDetails.value = arguments['travelCard'];
    // }

    receptionsOffersLoading.value = true;
    var listOffers = await getAllReceptionsOffersPerPage(1);

    allReceptionOffers.value = listOffers;

    list.addAll(allReceptionOffers);


  }

  getAllReceptionsOffersPerPage(int i)async{
    print("number is : $i");
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com//paginate/shipping/reception'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "page": i
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      receptionsOffersLoading.value = false;
      int pages = json.decode(data)['result']['total_pages'];
      totalPages.value = pages;
      print(totalPages.value);
      receptionsOffersLoading.value = false;

      var result = json.decode(data)['result']['shipping_data'];

      var list= [];
      for(int i = 0; i<result.length; i++){
        if(result[i]['travelbooking_id'] == false && result[i]['bool_parcel_reception'] == true){
          if(result[i]['state']=='pending'){
            print(result[i]);
            list.add(result[i]);
          }

        }
      }
      return list;
    }
    else {
      print(response.reasonPhrase);
    }


  }

  void refreshPage(int value)async {

    list.addAll(allReceptionOffers);

    List data = [];
    receptionsOffersLoading.value = true;
    data = await getAllReceptionsOffersPerPage(value);
    allReceptionOffers.value = data;

    //travelList.value = data;
    list.addAll(data);
  }



  joinShippingTravel(var shipping)async{

    print('Travel Booking Id: ${Get.find<AddTravelController>().travel_booking_id}');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('PUT',  Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id":${Get.find<AddTravelController>().travel_booking_id}}&ids=${shipping['id']}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping  successfully joined to travel ".tr));
      //Navigator.pop(Get.context);
      buttonPressed.value = false;
      Future.delayed(Duration(seconds: 3),()async{
        Get.find<UserTravelsController>().refreshMyTravels();
        //Navigator.pop(Get.context);
      });
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }

  void filterSearchResults(String query) {

    List dummySearchList = [];
    print(query);

    dummySearchList = allReceptionOffers;
    if(query.isNotEmpty) {
      print(allReceptionOffers[0]);
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) =>
      element['shipping_departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) || element['shipping_arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList();

      allReceptionOffers.value = dummyListData;
      print(allReceptionOffers);
      return;
    } else {

      allReceptionOffers.value = list;
    }
  }




}


