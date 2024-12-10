import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:math';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

import '../../userBookings/controllers/bookings_controller.dart';

class AvailableTravelsController extends GetxController {

  final heroTag = "".obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  final buttonPressed = false.obs;
  var allTravels = [];
  var items = [].obs;
  var list = [];
  var isLoading = true.obs;
  var currentIndex = 0.obs;
  var landTravelList = [].obs;
  var airTravelList = [].obs;
  var travelItem = {};
  var airTravels = [];
  var landTravels = [];
  var _channel;
  var listOfAllAirTravelsLuggages = [];
  /*Rx<List<Map<String, dynamic>>> items =
  Rx<List<Map<String, dynamic>>>([]);*/
  ScrollController scrollController = ScrollController();
  GlobalKey<FormState> profileForm;

  AvailableTravelsController() {
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
  }

  @override
  void onInit() {
    super.onInit();
    initValues();
    // _channel = WebSocketChannel.connect(
    //   Uri.parse('wss://preprod.hubkilo.com:9090/all_rooms'),
    // );
    //
    //
    // _channel.stream.listen(
    //         (message) {
    //       print('heyy');
    //       //print(message.toString());
    //       items.value.add(json.decode(message.toString())["data"]);
    //
    //     });
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments.toString();
    initValues();
    super.onReady();
  }

  initValues()async{
    list = await getAllTravels();
    items.value = list;
        //landTravels.toSet().toList();
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = list;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_city_id'][1]
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_city_id'][1]
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = list;
    }
  }

  Future getAllTravels() async {
    List mixedTravels = await getAllRoadTravels();
    List list = await getAllAirTravels();
    mixedTravels.addAll(list);
    return mixedTravels;

  }

  Future getAllRoadTravels()async{
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=52d594da9dde293f734bbc823c22ed471f482459'
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/frontend/all/travels'));
    request.body = '''{\n    "jsonrpc": "2.0"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      return json.decode(data)['travels'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getAllAirTravels()async{
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=52d594da9dde293f734bbc823c22ed471f482459'
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/air/'
        'frontend/all/travels'));
    request.body = '''{\n    "jsonrpc": "2.0"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var result = json.decode(data)['travels'];
      for(var item in result){
        var luggages = await getSpecificAirTravelLuggages(item['luggage_types']);
        print(luggages);
        listOfAllAirTravelsLuggages.addAll(luggages);

      }
      isLoading.value = false;
      print('air traveil list isssssssssssssss: ${json.decode(data)['travels']}');
      return json.decode(data)['travels'];
    }
    else {
      print(response.reasonPhrase);
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

}
