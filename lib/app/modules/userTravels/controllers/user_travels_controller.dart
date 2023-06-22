import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';
import '../../../services/my_auth_service.dart';

class UserTravelsController extends GetxController {

  final isDone = false.obs;
  var isLoading = true.obs;
  var items = [].obs;
  var state = "".obs;
  var myTravelsList = [];
  var roadTravels = [];
  var list = [];
  var listForProfile = [].obs;
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
    items.clear();
    for(var a=0; a < myTravelsList.length; a++){
      if(myTravelsList[a]["create_uid"][0] == Get.find<MyAuthService>().myUser.value.id ){
        items.add(myTravelsList[a]);
      }
    }
    list = items;
    listForProfile.value =list;
    print(items);
  }

  Future refreshMyTravels() async {
    items.clear();
    myTravelsList = await myTravels();
    for(var a=0; a < myTravelsList.length; a++){
      if(myTravelsList[a]["create_uid"][0] == Get.find<MyAuthService>().myUser.value.id ){
        items.add(myTravelsList[a]);
      }
    }
    list = items;
    listForProfile.value = list;
    print(listForProfile.length.toString());
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
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m1st_hk_roadshipping.travelbooking'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      return json.decode(data);
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
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

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
