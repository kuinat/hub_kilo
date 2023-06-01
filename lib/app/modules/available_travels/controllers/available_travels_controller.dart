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
    items.value = list;
    for(var i in items){
      print(i['id']);
    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = list;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = list;
    }
  }

  Future getAllTravels() async {

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/api/list/all/travels'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      isLoading.value = false;
      return json.decode(data)['shippings'];
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
