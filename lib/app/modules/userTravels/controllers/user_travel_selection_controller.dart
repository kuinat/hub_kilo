import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../../../providers/odoo_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../add_ravel_form/controller/add_travel_controller.dart';
import '../../root/controllers/root_controller.dart';
import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTravelSelectionController extends GetxController {

  //final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  final myExpeditionsPage = 0.obs;
  final offerExpedition = false.obs;
  final buttonPressed = false.obs;
  final shippingSelected = false.obs;
  var expeditionOffersSelected = [].obs;
  var publishedUserTravels = [].obs;
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
  var isConform = false.obs;
  final selectedState = <String>[].obs;
  var travel_booking_id;
  var origin = [].obs;
  var status = ["ALL".tr, "PENDING".tr, "ACCEPTED".tr, "NEGOTIATING".tr, "COMPLETED".tr, "REJECTED".tr];

  var expeditionsOffersLoading = false.obs;

  UserTravelSelectionController() {
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    Get.lazyPut<TravelInspectController>(
          () => TravelInspectController(),
    );
    Get.lazyPut<AddTravelController>(
          () => AddTravelController(),
    );


  }

  @override
  void onInit() async{
    super.onInit();

    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    await initValues();
  }

  // @override
  // void onReady()async{
  //   heroTag.value = Get.arguments.toString();
  //   await initValues();
  //   super.onReady();
  // }


  initValues()async{

    await getUser(Get.find<MyAuthService>().myUser.value.id);

    var list = await myTravels();
     var otherList = [];
    for(int i = 0; i<list.length; i++){
      if(list[i]['state'] == 'negotiating'){
        otherList.add(list[i]);
      }

    }
    publishedUserTravels.value = otherList;
    travel_booking_id = list;



    print('Travels: ${list[0]}');

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
    } else {
      print(response.reasonPhrase);
    }
  }

  Future myTravels()async{
    print('Travel List: ${travelList}');



    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$travelList'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(json.decode(data));
      return json.decode(data);
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
  }






  joinShippingTravel(var shipping)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('PUT',  Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id":${Get.find<AddTravelController>().travel_booking_id}}&ids=${shipping['id']}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //await getShippingCreated(json.decode(data));
      Future.delayed(Duration(seconds: 3),()async{
        Navigator.pop(Get.context);
        await Get.find<RootController>().changePage(1);
      });
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping  successfully joined to travel ".tr));
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }




}
