import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../common/ui.dart';
import '../../../../main.dart';

class ValidationController extends GetxController {

  final isDone = false.obs;
  var isLoading = true.obs;
  final currentState = 0.obs;
  final validationType = 0.obs;
  var bookings = [].obs;
  var items =[];
  ScrollController scrollController = ScrollController();
  TextEditingController codeController = TextEditingController();

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
    items = await getReceiverBookings();
    bookings.value = items;
  }

  Future scan() async {
    try {
      ScanResult qrCode = await BarcodeScanner.scan();
      String qrResult = qrCode.rawContent;
      //setState(() => barcode = qrResult);
      print(qrResult);
      completeTransaction(qrResult);
      return qrResult;

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        Get.log('The user did not grant the camera permission!');
      } else {
        Get.log('Unknown error: $e');
      }
    } on FormatException{
      Get.log('null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      Get.log('Unknown error: $e');
    }
  }

  completeTransaction(var code)async{
    final box = GetStorage();
    var id = box.read("session_id");
    print(id);
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; $id'
    };
    var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/all/booking/completed'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "booking_code": code
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: json.decode(data)['result'].tr));
    }
    else {
      print(response.reasonPhrase);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
    }
  }

  getReceiverBookings()async{
    final box = GetStorage();
    var id = box.read("session_id");
    print(id);
    var headers = {
      'Cookie': 'frontend_lang=en_US; $id'
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/air/receiver/bookings'));
    request.body = '''{\r\n  "jsonrpc": "2.0"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("my userBookings: $data");
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
    dummySearchList = items;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      bookings.value = dummyListData;
      return;
    } else {
      bookings.value = items;
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
