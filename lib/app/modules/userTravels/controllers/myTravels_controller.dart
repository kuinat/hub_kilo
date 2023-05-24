import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class MyTravelsController extends GetxController {

  final isDone = false.obs;
  var isLoading = false.obs;
  var items = [].obs;
  var state = "".obs;
  var myTravelsList = [];
  final selectedState = <String>[].obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    initValues();
  }

  @override
  void onReady(){

    initValues();
    super.onReady();
  }

  initValues()async{
    myTravelsList = await myTravels();
    items.value = myTravelsList;
    print(items);
  }

  Future refreshMyTravels() async {
    myTravelsList = await myTravels();
    items.value = myTravelsList;
    print(items);
  }

  void toggleTravels(bool value, String type) {
    if (value) {
      selectedState.clear();
      selectedState.add(type);
    } else {
      selectedState.removeWhere((element) => element == type);
    }
  }

  Future myTravels()async{
    final box = GetStorage();
    var id = box.read("session_id");
    print(id);
    var headers = {
      'Cookie': 'frontend_lang=en_US; $id'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/air/api/current/user/travels'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("my travels: $data");
      if(data != 'Empty'){
        isLoading.value = false;
        return json.decode(data)['response'];
      }else{
        isLoading.value = false;
        return [];
      }
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = myTravelsList;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = myTravelsList;
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
