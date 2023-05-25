import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

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
    travelItem = await getAllTravels();
    landTravels = travelItem['road_shippings'];
    airTravels = travelItem['air_shippings'];
    list.addAll(landTravels);
    list.addAll(airTravels);
    items.value = shuffle(list);
    for(var i in items){
      print(i['id']);
    }
  }

  List shuffle(List array) {
    var random = Random(); //import 'dart:math';

    // Go through all elementsof list
    for (var i = array.length - 1; i > 0; i--) {

      // Pick a random number according to the lenght of list
      var n = random.nextInt(i + 1);
      var temp = array[i];
      array[i] = array[n];
      array[n] = temp;
    }
    return array;
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

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/api/all/travels'));

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
