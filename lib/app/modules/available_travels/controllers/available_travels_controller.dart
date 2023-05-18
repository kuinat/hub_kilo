import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../main.dart';
import '../../../models/media_model.dart';
import '../../../repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class AvailableTravelsController extends GetxController {
  //var user = new User().obs;
  final heroTag = "".obs;
  var avatar = new Media().obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  final buttonPressed = false.obs;
  var allTravels = [];
  var items = [].obs;
  final isServer = false.obs;
  /*Rx<List<Map<String, dynamic>>> items =
  Rx<List<Map<String, dynamic>>>([]);*/
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  /*ProfileController() {
    _userRepository = new UserRepository();
  }*/

  @override
  void onInit() {
    initValues();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments.toString();
    super.onReady();
  }

  initValues()async{
    allTravels = await getAllTravels();
    items.value = allTravels;
    print(items);
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = allTravels;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['name']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
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
      'Cookie': 'frontend_lang=en_US; session_id=8731877be51f7b3bdf564f2ebb623764d2f9fbcd'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/air/all/travels'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isServer.value = !isServer.value;
      final data = await response.stream.bytesToString();
      return json.decode(data)['response'];
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
