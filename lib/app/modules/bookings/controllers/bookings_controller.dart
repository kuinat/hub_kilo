import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import 'package:http/http.dart' as http;

class BookingsController extends GetxController {

  final uploading = false.obs;
  final currentState = 0.obs;
  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  File imageFile;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
  final isDone = false.obs;
  var myBookings = [];
  var bookingsOnMyTravel = [];
  var items = [].obs;
  var itemsBookingsOnMyTravel = [].obs;
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
    myBookings = await getMyBookings();
    items.value = myBookings;
    print(items);
    bookingsOnMyTravel = await getBookingsOnMyTravel();
    itemsBookingsOnMyTravel.value = bookingsOnMyTravel;
    print(itemsBookingsOnMyTravel);
  }

  refreshBookings()async{
    initValues();
  }

  Future getMyBookings() async {
    final box = GetStorage();
    var id = box.read('session_id');
    var headers = {
      'Cookie': 'frontend_lang=en_US; $id'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/air/current/user/my_booking/made'));
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

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = bookingsOnMyTravel;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = bookingsOnMyTravel;
    }
  }

  getBookingsOnMyTravel()async{
    final box = GetStorage();
    var id = box.read('session_id');
    var headers = {
      'Cookie': 'frontend_lang=en_US; $id'
    };

    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/air/current/user/travel/booked'));
    request.body = '''{\r\n  "jsonrpc": "2.0"\r\n}''';
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

  deleteMyBooking(int book_id)async{
    final box = GetStorage();
    var id = box.read('session_id');
    var headers = {
      'Cookie': 'frontend_lang=en_US; $id'
    };
    var request = http.Request('DELETE', Uri.parse('${Domain.serverPort}/air/booking/$book_id/delete'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      if(json.decode(data)['success']) {
        Get.showSnackbar(Ui.SuccessSnackBar(message: json.decode(data)['message'].tr));
        Navigator.pop(Get.context);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
        initValues();
        throw new Exception(response.reasonPhrase);
      }
    }
    else {
      throw new Exception(response.reasonPhrase);
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
