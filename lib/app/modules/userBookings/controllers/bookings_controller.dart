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

  final currentSlide = 0.obs;
  final quantity = 1.obs;
  final description = ''.obs;
  final travelCard = {}.obs;
  final imageUrl = "".obs;
  final bookingStep = 0.obs;
  final elevation = 0.obs;
  final name = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final address = "".obs;
  final selectUser = false.obs;
  final buttonPressed = false.obs;
  var url = ''.obs;
  var users =[].obs;
  var resetusers =[].obs;

  var visible = true.obs;
  var editNumber = false.obs;



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
    /*bookingsOnMyTravel = await getBookingsOnMyTravel();
    itemsBookingsOnMyTravel.value = bookingsOnMyTravel;
    print(itemsBookingsOnMyTravel);*/
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

  /*getBookingsOnMyTravel()async{
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

  }*/

  editBooking(int book_id)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/air/travel/booking/update/'+book_id.toString()));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "receiver_name": name.value,
        "receiver_email": email.value,
        "receiver_phone": phone.value,
        "receiver_address": address.value,
        "type_of_luggage": description.value,
        "kilo_booked": quantity.value
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }


  }


  acceptBookingOnMyTravel(int booking_id)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/air/accept/booking/'+booking_id.toString()));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(json.decode(data)['result'] != null){
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking accepted ".tr));
        Navigator.pop(Get.context);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      print(response.reasonPhrase);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));

    }

  }


  rejectBookingOnMyTravel(int booking_id)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/air/reject/booking/'+booking_id.toString()));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(json.decode(data)['result'] != null){
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking rejected ".tr));
        Navigator.pop(Get.context);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      print(response.reasonPhrase);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));

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
