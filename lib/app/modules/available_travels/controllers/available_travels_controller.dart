import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../main.dart';
import '../../../repositories/user_repository.dart';
import 'package:http/http.dart' as http;

import '../../bookings/controllers/bookings_controller.dart';

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
  var isLoading = true.obs;
  var currentIndex = 0.obs;
  List transportState = [
    "All",
    "Due",
    "Pending",
    "Accepted"
  ].obs;
  /*Rx<List<Map<String, dynamic>>> items =
  Rx<List<Map<String, dynamic>>>([]);*/
  GlobalKey<FormState> profileForm;

  /*ProfileController() {
    _userRepository = new UserRepository();
  }*/
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
    allTravels = await getAllTravels();
    items.value = allTravels;
    for(var i in allTravels){
      print(i['id']);
    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = allTravels;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = allTravels;
    }
  }

  Future getAllTravels() async {
    final box = GetStorage();
    var id = box.read('session_id');
    var headers = {
      'Cookie': 'frontend_lang=en_US; $id'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/air/all/travels'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      isLoading.value = false;
      return json.decode(data)['response'];
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
