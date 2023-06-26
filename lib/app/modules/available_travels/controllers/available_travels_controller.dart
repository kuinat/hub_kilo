import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

import '../../userBookings/controllers/bookings_controller.dart';

class AvailableTravelsController extends GetxController {
  //var user = new User().obs;
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
  /*Rx<List<Map<String, dynamic>>> items =
  Rx<List<Map<String, dynamic>>>([]);*/
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
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments.toString();
    initValues();
    super.onReady();
  }

  initValues()async{
    list = await getAllTravels();
    landTravels = [];
    for(var a=0; a < list.length; a++){
      if(list[a]['state'] == "negotiating"){
        landTravels.add(list[a]);
      }
    }
    final seen = Set();
    items.value = landTravels.where((str) => seen.add(str)).toList();
        //landTravels.toSet().toList();
    print(items);
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
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m1st_hk_roadshipping.travelbooking'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      isLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
