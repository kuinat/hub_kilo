import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/my_user_model.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';

class UserTravelsController extends GetxController {

  final isDone = false.obs;
  var isLoading = true.obs;
  var items = [].obs;
  var state = "".obs;
  var myTravelsList = [];
  var roadTravels = [];
  var listAttachment = [];
  var travelList = [];
  var inNegotiation = false.obs;
  var listForProfile = [].obs;
  var listInvoice = [];
  var isConform = false.obs;
  var buttonPressed = false.obs;
  final selectedState = <String>[].obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    initValues();
    super.onInit();

  }

  @override
  void onReady(){

    initValues();
    super.onReady();
  }

  initValues()async{
    Get.lazyPut(()=>UserTravelsController());
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    await getUser(Get.find<MyAuthService>().myUser.value.id);
    myTravelsList = await myTravels();
    items.clear();

    items.value = myTravelsList;

    print(items);
  }

  Future refreshMyTravels() async {
    items.clear();
    await getUser(Get.find<MyAuthService>().myUser.value.id);
    myTravelsList = await myTravels();
    items.value = myTravelsList;
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

  Future getUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];
      travelList = data['travelbooking_ids'];
      listAttachment = data['partner_attachment_ids'];
      listInvoice = data['invoice_ids'];
    } else {
      print(response.reasonPhrase);
    }
  }

  getAttachmentFiles(int travelId)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/ir.attachment?ids=$listAttachment&fields=%5B%22conformity%22%5D&with_context=%7B%7D&with_company=1'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      List list = [];
      List data = json.decode(result);
      print(data);
      list = data.where((element) => element['conformity'].toString().contains("true")).toList();
      if(list.isNotEmpty){
        publishTravel(travelId);
      }else{
        showDialog(
            context: Get.context,
            builder: (_){
              return AlertDialog(
                title: Text("Identity files not conform!"),
                content: Text('Your identity could not be verified, please make sure to register your personal identity information and try again', style: Get.textTheme.headline4),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(Get.context),
                          child: Text("Cancel", style: Get.textTheme.headline4.merge(TextStyle(color: specialColor))
                          )
                      ),
                      SizedBox(width: 10),
                      TextButton(
                          onPressed: () => {
                            Navigator.pop(Get.context),
                            Get.toNamed(Routes.IDENTITY_FILES),
                          },
                          child: Text("Upload files", style: Get.textTheme.headline4
                          )
                      ),
                    ],
                  )
                ],
              );
            });
      }
    }
    else {
      var result = await response.stream.bytesToString();
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(json.decode(result)['message']),
        backgroundColor: specialColor.withOpacity(0.4),
        duration: Duration(seconds: 2),
      ));
      print(response.reasonPhrase);
    }
  }

  getInvoice() async{

  }

  Future myTravels()async{

    print("travel ids are: $travelList");

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$travelList'));

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

  publishTravel(int travelId)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7884fbe019046ffc1379f17c73f57a9e344a6d8a'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.travelbooking?values='
        '{"state": "negotiating"}&ids=$travelId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Travel opened to the public".tr));
      await getUser(Get.find<MyAuthService>().myUser.value.id);
      myTravelsList = await myTravels();
      items.value = myTravelsList;
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_city_id'][1]
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_city_id'][1]
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = dummySearchList;
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }

}
