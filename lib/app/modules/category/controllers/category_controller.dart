import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../main.dart';
import '../../../services/my_auth_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';

class CategoryController extends GetxController {
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  var roadTravelList = [].obs;
  var airTravelList = [].obs;
  var expeditionsOffersList = [].obs;
  var receptionOffersList = [].obs;
  var list = [].obs;
  final imageUrl = "".obs;
  var travelType = "".obs;
  var widgetType = "".obs;
  var totalPages = 0.obs;
  var currentPage = 1.obs;
  var loading = true.obs;
  var listOfAllAirTravelsLuggages = [];
  var filterPressed = false.obs;
  var _channel;
  ScrollController scrollController = ScrollController();

  CategoryController() {
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
    //_sliderRepo = new SliderRepository();
    //_categoryRepository = new CategoryRepository();
    //_eServiceRepository = new EServiceRepository();
  }


  @override
  Future<void> onInit() async {

    var arguments = Get.arguments as Map<String, dynamic>;
    travelType.value = arguments['travelType'];
    widgetType.value = arguments['widgetType'];
    print(roadTravelList);
    if(arguments['travelType'] == "air"){
      imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
    }else if(arguments['travelType'] == "Sea"){
      imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
    }else{
      imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
    }

    widgetType.value == 'roadTravels'?
    roadTravelList.value = await getAllRoadTravels(1):
    widgetType.value == 'expeditionsOffers'?
    expeditionsOffersList.value = await getAllRoadShippingOffers(1):
    widgetType.value == 'airTravels'?
    airTravelList.value = await getAllAirTravels(1):
    widgetType.value == 'receptionOffers'?
    receptionOffersList.value = await getAllRoadReceptionOffers(1):
    null;

    widgetType.value == 'roadTravels'?
    list.addAll(roadTravelList):
    widgetType.value == 'expeditionsOffers'?
    list.addAll(expeditionsOffersList):
    widgetType.value == 'airTravels'?
    list.addAll(airTravelList):
    widgetType.value == 'receptionOffers'?
    list.addAll(receptionOffersList):
    null;

    await Get.find<BookingsController>().getAttachmentFiles();
     Get.find<HomeController>().existingPublishedRoadTravel.value = await verifyPublishedRoadTravel();
     Get.find<HomeController>().existingPublishedAirTravel.value = await verifyPublishedAirTravel();
    super.onInit();

    _channel = WebSocketChannel.connect(
      Uri.parse('wss://preprod.hubkilo.com:9090/all_rooms'),
    );


    _channel.stream.listen(
            (message) async {
          print('heyy');
          //print(message.toString());
          //refreshPage(currentPage.value);
          List data = [];
          data = await getAllRoadTravels(currentPage.value);
          roadTravelList.value = data;
          list.addAll(data);

        });
  }

  void filterSearchResults(String query) {
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );

    List dummySearchList = [];
    widgetType.value == 'roadTravels'?
    dummySearchList = Get.find<HomeController>().landTravelList:
    widgetType.value == 'expeditionsOffers'?
    dummySearchList = Get.find<HomeController>().expeditionOfferList
    :widgetType.value == 'airTravels'?
    dummySearchList = Get.find<HomeController>().airTravelList
    : widgetType.value == 'receptionOffers'?
    dummySearchList = Get.find<HomeController>().receptionOfferList
    :dummySearchList = [];
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = widgetType.value == 'roadTravels'?
          dummySearchList.where((element) =>
      element['departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
      :widgetType.value == 'expeditionsOffers'?
      dummySearchList.where((element) =>
      element['shipping_departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) || element['shipping_arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
          :widgetType.value == 'receptionOffers'?
      dummySearchList.where((element) =>
      element['shipping_departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) || element['shipping_arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
      :widgetType.value == 'airTravels'?
      dummySearchList.where((element) =>
      element['departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
      :[];

      widgetType.value == 'roadTravels'?
      roadTravelList.value = dummyListData:
      widgetType.value == 'expeditionsOffers'?
      expeditionsOffersList.value = dummyListData:
      widgetType.value == 'receptionOffers'?
      receptionOffersList.value = dummyListData:
      widgetType.value == 'airTravels'?
      airTravelList.value = dummyListData
      :[];
      return;
    } else {
      widgetType.value == 'roadTravels'?
      roadTravelList.value = list:
      widgetType.value == 'expeditionsOffers'?
      expeditionsOffersList.value = list
          : widgetType.value == 'receptionOffers'?
      receptionOffersList.value = list
          :
      widgetType.value == 'airTravels'?
      airTravelList.value = list:
      [];
    }
  }

  void filterSearchDepartureTown(String query) {
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );

    List dummySearchList = [];
    widgetType.value == 'roadTravels'?
    dummySearchList = Get.find<HomeController>().landTravelList:
    widgetType.value == 'expeditionsOffers'?
    dummySearchList = Get.find<HomeController>().expeditionOfferList
        : widgetType.value == 'receptionOffers'?
    dummySearchList = Get.find<HomeController>().receptionOfferList
        :
    widgetType.value == 'airTravels'?
    dummySearchList = Get.find<HomeController>().airTravelList
        :dummySearchList = [];
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = widgetType.value == 'roadTravels'?
      dummySearchList.where((element) =>
      element['departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase())  ).toList()
          :widgetType.value == 'expeditionsOffers'?
      dummySearchList.where((element) =>
      element['shipping_departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase())  ).toList()
          :widgetType.value == 'receptionOffers'?
      dummySearchList.where((element) =>
          element['shipping_departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase())  ).toList()
          :widgetType.value == 'airTravels'?
      dummySearchList.where((element) =>
      element['departure_city_id'][1].toString().toLowerCase().contains(query.toLowerCase())  ).toList()
          :[];

      widgetType.value == 'roadTravels'?
      roadTravelList.value = dummyListData:
      widgetType.value == 'expeditionsOffers'?
      expeditionsOffersList.value = dummyListData:
      widgetType.value == 'receptionOffers'?
      receptionOffersList.value = dummyListData:
      widgetType.value == 'airTravels'?
      airTravelList.value = dummyListData
          :[];
      return;
    } else {
      widgetType.value == 'roadTravels'?
      roadTravelList.value = list:
      widgetType.value == 'expeditionsOffers'?
      expeditionsOffersList.value = list:
      widgetType.value == 'receptionOffers'?
      receptionOffersList.value = list
          : widgetType.value == 'airTravels'?
      airTravelList.value = list:
      [];
    }
  }

  void filterSearchArrivalTown(String query) {
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );

    List dummySearchList = [];
    widgetType.value == 'roadTravels'?
    dummySearchList = Get.find<HomeController>().landTravelList:
    widgetType.value == 'expeditionsOffers'?
    dummySearchList = Get.find<HomeController>().expeditionOfferList
        : widgetType.value == 'receptionOffers'?
    dummySearchList = Get.find<HomeController>().receptionOfferList
        : widgetType.value == 'airTravels'?
    dummySearchList = Get.find<HomeController>().airTravelList
        :dummySearchList = [];
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = widgetType.value == 'roadTravels'?
      dummySearchList.where((element) =>
       element['arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
          :widgetType.value == 'expeditionsOffers'?
      dummySearchList.where((element) =>
       element['shipping_arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
          :widgetType.value == 'receptionOffers'?
      dummySearchList.where((element) =>
          element['shipping_arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
          :widgetType.value == 'airTravels'?
      dummySearchList.where((element) =>
       element['arrival_city_id'][1].toString().toLowerCase().contains(query.toLowerCase()) ).toList()
          :[];

      widgetType.value == 'roadTravels'?
      roadTravelList.value = dummyListData:
      widgetType.value == 'expeditionsOffers'?
      expeditionsOffersList.value = dummyListData:
      widgetType.value == 'receptionOffers'?
      receptionOffersList.value = dummyListData:
      widgetType.value == 'airTravels'?
      airTravelList.value = dummyListData
          :[];
      return;
    } else {
      widgetType.value == 'roadTravels'?
      roadTravelList.value = list:
      widgetType.value == 'expeditionsOffers'?
      expeditionsOffersList.value = list
          :widgetType.value == 'receptionOffers'?
      receptionOffersList.value = list
      :widgetType.value == 'airTravels'?
      airTravelList.value = list:
      [];
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future getAllRoadTravels(int i)async{
    print("number is : $i");
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/mobile/all/hub_road/travels'));
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
      isLoading.value = false;
      int pages = json.decode(data)['result']['total_pages'];
      totalPages.value = pages;
      print(totalPages.value);
      loading.value = false;
      return json.decode(data)['result']['travels'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getAllAirTravels(int i)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/mobile/all/hub_air/travels'));
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
      var result = json.decode(data)['result']['travels'];

      listOfAllAirTravelsLuggages.clear();

      for(var item in result){
        var luggages = await getSpecificAirTravelLuggages(item['luggage_types']);
        print(luggages);
        listOfAllAirTravelsLuggages.addAll(luggages);

      }
      isLoading.value = false;
      int pages = json.decode(data)['result']['total_pages'];
      totalPages.value = pages;

      loading.value = false;
      return json.decode(data)['result']['travels'];
    }
    else {
      print(response.reasonPhrase);
    }


  }
  getSpecificAirTravelLuggages(List luggageIds)async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain
        .serverPort}/read/m2st_hk_airshipping.flight.luggage?ids=$luggageIds'));

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

  getAllRoadShippingOffers(int i)async{
    print("number is : $i");
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/paginate/shipping/offers'));
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
      isLoading.value = false;
      print('yeeeeeeeeeeeeeeeeeeeeeeeee');
      int pages = json.decode(data)['result']['total_pages'];
      totalPages.value = pages;
      print(totalPages.value);
      loading.value = false;
      return json.decode(data)['result']['shipping_data'];

    }
    else {
      print(response.reasonPhrase);
    }


  }

  getAllRoadReceptionOffers(int i)async{
    print("number is : $i");
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/paginate/shipping/reception'));
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
      isLoading.value = false;
      int pages = json.decode(data)['result']['total_pages'];
      totalPages.value = pages;
      print('fact ${totalPages.value}');
      loading.value = false;
      return json.decode(data)['result']['shipping_data'];

    }
    else {
      print(response.reasonPhrase);
    }


  }






  void refreshPage(int value)async {
    widgetType.value == 'roadTravels'?
    list.addAll(roadTravelList):
    widgetType.value == 'expeditionsOffers'?
    list.addAll(expeditionsOffersList):
    widgetType.value == 'receptionOffers'?
    list.addAll(receptionOffersList):null;

    List data = [];
    loading.value = true;
    widgetType.value == 'roadTravels'?
    data = await getAllRoadTravels(value):
    widgetType.value == 'expeditionsOffers'?
    data = await getAllRoadShippingOffers(value):
    widgetType.value == 'receptionOffers'?
    data = await getAllRoadReceptionOffers(value):null;

    widgetType.value == 'roadTravels'?
    roadTravelList.value = data:
    widgetType.value == 'expeditionsOffers'?
    expeditionsOffersList.value = data:
    widgetType.value == 'receptionOffers'?
    receptionOffersList.value = data
        :null;

    //travelList.value = data;
    list.addAll(data);
  }


  Future verifyPublishedRoadTravel()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=${Get.find<MyAuthService>().myUser.value.roadTravelIds}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      for(var travel in result){
        if(travel['state'] == 'negotiating'){
          return true;
        }
      }
      return false;
    }
    else {
      var data = await response.stream.bytesToString();
      return false;

      print(data);
    }
  }
  Future verifyPublishedAirTravel()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.travelbooking?ids=${Get.find<MyAuthService>().myUser.value.airTravelIds}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      for (var travel in result) {
        if (travel['state'] == 'negotiating') {
          print('true');
          return true;
        }
      }
      return false;
    }
    else {
      var data = await response.stream.bytesToString();
      return false;
      print(data);
    }
  }
}
