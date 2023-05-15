import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTravelsController extends GetxController {

  final isDone = false.obs;
  var allTravels = [].obs;
  Rx<List<Map<String, dynamic>>> items =
  Rx<List<Map<String, dynamic>>>([]);
  final allPlayers = [
    {"name": "Rohit Sharma", "country": "India", "type": "air"},
    {"name": "Virat Kohli ", "country": "India", "type": "sea"},
    {"name": "Glenn Maxwell", "country": "Australia", "type": "land"}
  ].obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    items.value = allPlayers;
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        //await listenForMessages();
      }
    });
    super.onInit();
  }

  Future refreshMyTravels() async {
    items.value = allPlayers;
    /*messages.clear();
    lastDocument = new Rx<DocumentSnapshot>(null);
    await listenForMessages();*/
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = allPlayers;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['name']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = allPlayers;
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
