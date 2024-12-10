import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/pop_up_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ValidationController extends GetxController {

  final isDone = false.obs;
  var isLoading = true.obs;
  final currentState = 0.obs;
  final validationType = 0.obs;
  var shipping = [].obs;
  var copyPressed = false.obs;
  var loading = false.obs;
  var items = [].obs;
  var shippingLuggage =[].obs;
  var luggageInfo = {}.obs;
  var currentUser = Get.find<MyAuthService>().myUser;
  var status = ["ALL", "PENDING", "ACCEPTED", "CANCEL", "PAID", "CONFIRM" , "RECEIVED"];
  ScrollController scrollController = ScrollController();
  TextEditingController codeController = TextEditingController();
  var origin = [].obs;

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
    isLoading.value = true;
    List data = [];
    List result = await getBeneficiaryRoadShipping(Get.find<MyAuthService>().myUser.value.id);
    var secondList = await getBeneficiaryAirShipping(Get.find<MyAuthService>().myUser.value.id);
    result.addAll(secondList);
    for(var a=0; a<result.length; a++){
      if(result[a]['is_paid']){
        data.add(result[a]);
      }
    }
    items.value = data;
    shipping.value = data;
    isLoading.value = false;
    print(shipping);
  }

  refreshPage()async{
    print("refreshing parcels");
    initValues();
  }

  Future scan() async {
    try {
      ScanResult qrCode = await BarcodeScanner.scan();
      String qrResult = qrCode.rawContent;
      //setState(() => barcode = qrResult);
      print(qrResult);
      qrResult.toLowerCase().contains('road')?
      verifyRoadShippingCode(qrResult.split('-').first, qrResult.split('-').last)
      :verifyAirShippingCode(qrResult.split('-').first, qrResult.split('-').last);

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

  verifyRoadShippingCode(var code, var id)async{

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
      loading.value = false;
      if(code == json.decode(data)[0]['travel_code']){
        showDialog(
            context: Get.context,
            builder: (_)=>  PopUpWidget(
              title: "${AppLocalizations.of(Get.context).confirmDeliveryReference} ${shippingInfo['name']}, ${AppLocalizations.of(Get.context).travelFrom} ${shippingInfo['travel_departure_city_name']} to ${shippingInfo['travel_arrival_city_name']}, to M/Mrs ${shippingInfo['receiver_partner_id'] != false ? shippingInfo['receiver_partner_id'][1] : shippingInfo['receiver_name_set']}",
              cancel: AppLocalizations.of(Get.context).cancel,
              confirm: AppLocalizations.of(Get.context).confirm,
              onTap: ()=> setRoadShippingToReceive(id),
              icon: Icon(Icons.help_outline, size: 70,color: inactive),
            ));
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).parcelCodeError.tr));
      }
    }
    else {
      var data = await response.stream.bytesToString();
      loading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
      print(data);
    }
  }

  verifyAirShippingCode(var code, var id)async{

    var shippingInfo = {};

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.shipping?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      shippingInfo = json.decode(data)[0];
      loading.value = false;
      if(code == json.decode(data)[0]['travel_code']){
        showDialog(
            context: Get.context,
            builder: (_)=>  PopUpWidget(
              title: "${AppLocalizations.of(Get.context).confirmDeliveryReference} ${shippingInfo['name']}, ${AppLocalizations.of(Get.context).travelFrom} ${shippingInfo['travel_departure_city_name']} to ${shippingInfo['travel_arrival_city_name']}, to M/Mrs ${shippingInfo['receiver_partner_id'] != false ? shippingInfo['receiver_partner_id'][1] : shippingInfo['receiver_name_set']}",
              cancel: AppLocalizations.of(Get.context).cancel,
              confirm: AppLocalizations.of(Get.context).confirm,
              onTap: ()=> setAirShippingToReceive(id),
              icon: Icon(Icons.help_outline, size: 70,color: inactive),
            ));
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).parcelCodeError.tr));
      }
    }
    else {
      var data = await response.stream.bytesToString();
      loading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
      print(data);
    }
  }

  setRoadShippingToReceive(var id)async{

    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text("Loading data..."),
      duration: Duration(seconds: 3),
    ));

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.shipping/set_to_received?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      Future.delayed(Duration(seconds: 2),()async{
        await Get.toNamed(Routes.ROOT);
      });
      showDialog(
          context: Get.context, builder: (_){
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Lottie.asset("assets/img/successfully-done.json"),
        );
      });
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      print(response.reasonPhrase);
    }
  }

  setAirShippingToReceive(var id)async{

    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text("Loading data..."),
      duration: Duration(seconds: 3),
    ));

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.shipping/set_to_received?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      Future.delayed(Duration(seconds: 2),()async{
        await Get.toNamed(Routes.ROOT);
      });
      showDialog(
          context: Get.context, builder: (_){
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Lottie.asset("assets/img/successfully-done.json"),
        );
      });
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      print(response.reasonPhrase);
    }
  }

  Future getBeneficiaryRoadShipping(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/mobile/road/receiver/shipping/get_details'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "partner_id": id
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var list = [];
      isLoading.value = false;
      print('My parcels where I am beneficiary is: ${json.decode(data)}');
      if(json.decode(data)['result'] != 'No Parcel Found!'){
        if(json.decode(data)['result']['response'] != null){
          list = json.decode(data)['result']['response'];
        }else{
          list = [];
        }
      }

      return list;
    }
    else {
      print(response.reasonPhrase);
    }
  }


  Future getBeneficiaryAirShipping(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/mobile/air/receiver/shipping/get_details'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "partner_id": id
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(id);
      final data = await response.stream.bytesToString();
      var list = [];
      isLoading.value = false;
      print(json.decode(data));
      if(json.decode(data)['result'] != 'No Parcel Found!'){
        if(json.decode(data)['result']['response'] != null){
          list = json.decode(data)['result']['response'];
        }else{
          list = [];
        }
      }

      return list;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }

  Future getLuggageInfo(var ids) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.luggage?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      shippingLuggage.value = json.decode(data);

    }
    else {
      print(response.reasonPhrase);
    }
  }
}
