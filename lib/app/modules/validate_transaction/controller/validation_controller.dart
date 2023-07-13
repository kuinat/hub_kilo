import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/pop_up_widget.dart';

class ValidationController extends GetxController {

  final isDone = false.obs;
  var isLoading = true.obs;
  final currentState = 0.obs;
  final validationType = 0.obs;
  var shipping = [].obs;
  var items =[];
  var luggageInfo = {}.obs;
  var travelInfo = {}.obs;
  ScrollController scrollController = ScrollController();
  TextEditingController codeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    initValues();
  }

  @override
  void onReady(){

    initValues();
    super.onReady();
  }

  initValues()async{
    List data = await getAllShipping();
    //items = await getReceiverBookings();
    List receiverShipping = [];
    for(var a=0; a<data.length; a++){
      if(data[a]['receiver_partner_id'] != false){
        if( Get.find<MyAuthService>().myUser.value.id == data[a]['receiver_partner_id'][0]){
          receiverShipping.add(data[a]);
          var luggage = await getLuggageInfo(data[a]['luggage_ids'][0]);
          var travel = await geTravelInfo(data[a]['travelbooking_id'][0]);
          luggageInfo.value = luggage;
          travelInfo.value = travel;
        }
      }
    }

    shipping.value = receiverShipping;
    print(shipping);
  }

  refreshPage()async{
    initValues();
  }

  Future scan() async {
    try {
      ScanResult qrCode = await BarcodeScanner.scan();
      String qrResult = qrCode.rawContent;
      //setState(() => barcode = qrResult);
      print(qrResult);
      verifyCode(qrResult.split('>').first, qrResult.split('>').last);

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

  verifyCode(var code, var id)async{

    var shippingInfo = {};

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      shippingInfo = json.decode(data)[0];
      if(code == json.decode(data)[0]['travel_code']){
        showDialog(
            context: Get.context,
            builder: (_)=>  PopUpWidget(
              title: "Confirm the delivery of Shipping with reference: ${shippingInfo['name']}, travel from ${shippingInfo['travel_arrival_city_name']} to ${shippingInfo['travel_departure_city_name']}, to M/Mrs ${shippingInfo['receiver_partner_id'][1]}",
              cancel: 'Cancel',
              confirm: 'Confirm',
              onTap: ()=> setToReceive(id),
              icon: Icon(Icons.help_outline, size: 40,color: validateColor),
            ));
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Code not matching! Please verify and try again later".tr));
      }
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
      print(data);
    }
  }

  setToReceive(var id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d04af03f698078c752b685cba7f34e4cbb3f208b'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"state": "received",}&ids=$id'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Transaction completed with success"));
      Navigator.pop(Get.context);
    }
    else {
      var data = await response.stream.bytesToString();
      print(response.reasonPhrase);
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }

  Future getAllShipping() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m1st_hk_roadshipping.shipping'));

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

  getReceiverBookings()async{
    final box = GetStorage();
    var id = box.read("session_id");
    print(id);
    var headers = {
      'Cookie': 'frontend_lang=en_US; $id'
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/air/receiver/bookings'));
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
      shipping.value = dummyListData;
      return;
    } else {
      shipping.value = items;
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }

  Future getLuggageInfo(int id) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.luggage?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data)[0];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future geTravelInfo(var id) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data)[0];
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
