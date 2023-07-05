import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

import '../../../providers/odoo_provider.dart';
import '../../../repositories/upload_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';

class BookingsController extends GetxController {

  final currentSlide = 0.obs;
  final quantity = 1.0.obs;
  final luggageWidth = 1.0.obs;
  final luggageHeight= 1.0.obs;
  final description = ''.obs;
  final imageUrl = "".obs;
  final errorField = false.obs;
  final bookingStep = 0.obs;
  final elevation = 0.obs;
  final name = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final address = "".obs;
  final selectUser = false.obs;
  final buttonPressed = false.obs;
  final editPhotos = true.obs;
  var showTravelInfo = false.obs;
  var transferBooking = false.obs;
  var bookingIdForTransfer =''.obs;
  var luggageModels = [].obs;
  var luggageSelected = [].obs;
  var users =[].obs;
  var shippingLuggage =[].obs;
  var shippingLoading = false.obs;
  final luggageLoading = true.obs;
  final shippingPrice = 0.0.obs;
  var selectedIndex = 0.obs;
  var luggageIndex = 0.obs;
  var selected = false.obs;
  var receiverId = 0.obs;
  final heroTag = "".obs;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
  final isDone = false.obs;
  var imageFiles = [].obs;
  var items = [].obs;
  var luggageId = [].obs;
  var itemsBookingsOnMyTravel = [].obs;
  ScrollController scrollController = ScrollController();
  var list = [];
  var shippingList = [];
  var viewPressed = false.obs;

  UploadRepository _uploadRepository;

  BookingsController() {
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
    _uploadRepository = new UploadRepository();
  }

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
    heroTag.value = Get.arguments.toString();
    initValues();
    super.onReady();
  }

  initValues()async{
    getUser(Get.find<MyAuthService>().myUser.value.id);

    List models = await getAllLuggageModel();
    List listUsers = await getAllUsers();
    luggageModels.value = models;
    users.value = listUsers;
    isLoading.value = false;
    //await getAllUsers();

  }

  refreshBookings()async{
    initValues();
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = list;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = list;
    }
  }

  getUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];

      shippingList = data['shipping_ids'];
      list = await getMyShipping();
      items.value = list;

    } else {
      print(response.reasonPhrase);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured"));
    }
  }

  createShippingLuggage(var item)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.luggage?values={'
        '"average_height": ${item["average_height"]},'
        '"average_weight": ${item["average_weight"]},'
        '"average_width": ${item["average_width"]},'
        '"luggage_model_id": ${item["id"]}'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      luggageId.value = [];
      var data = await response.stream.bytesToString();
      luggageId.add(json.decode(data)[0]);
      print("added id: $luggageId");
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  deleteShippingLuggage(var luggageId)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('DELETE', Uri.parse('${Domain.serverPort}/unlink/m1st_hk_roadshipping.luggage?ids=$luggageId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      bookingStep.value = 0;
      print(data);
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  Future getAllLuggageModel()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m0sthk.luggage_model'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      luggageLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getAllUsers()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=a3ffbeb70a9e310852261c236548fc5735e96419'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/res.partner'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getMyShipping() async {

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$shippingList'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      //isLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getTravelInfo(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data)[0];
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
  }

  mixBookingCategories(var myAirBookings, var myRoadBookings)async{
    var bookings = [];
    for(var airBooking in myAirBookings){
      bookings.add(airBooking);
    }
    for(var roadBooking in myRoadBookings )
      {
        bookings.add(roadBooking);
      }

    bookings.sort((a, b) => a['travel']['departure_date'].compareTo(b['travel']['departure_date']));


    return bookings;
  }

  editShipping(var shipping)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id": ${shipping['travelbooking_id']},'
        '"receiver_partner_id": ${shipping['receiver_partner_id']},'
        '"shipping_price": ${shippingPrice.value}'
        '"luggage_ids": $luggageId,'
        '}&ids=${shipping['id']}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(json.decode(data)['result'] != null){

        Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking  succesfully updated ".tr));
        Navigator.pop(Get.context);
        imageFiles.clear();
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }


  transferShipping(int booking_id)async{
    transferBooking.value = true;
    bookingIdForTransfer.value = booking_id.toString();
    print (bookingIdForTransfer.value.toString());
    // Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);
    await Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);

  }

  cancelShipping(int shipping_id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d04af03f698078c752b685cba7f34e4cbb3f208b'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"state": "rejected",}&ids=$shipping_id'
    ));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {

      final data = await response.stream.bytesToString();
      print(data);
      await getUser(Get.find<MyAuthService>().myUser.value.id);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping Canceled"));
      Navigator.pop(Get.context);
      list = await getMyShipping();
      items.value = list;

    }
    else {
      final data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      throw new Exception(response.reasonPhrase);
    }
  }

  Future <File> pickImage(ImageSource source) async {

    ImagePicker imagePicker = ImagePicker();

    if(source.toString() == ImageSource.camera.toString())
    {
      XFile pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
      File imageFile = File(pickedFile.path);
      if(imageFiles.length<3)
      {
        imageFiles.add(imageFile) ;
      }
      else
      {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "You can only upload 3 photos!".tr));
        throw new Exception('You can only upload 3 photos');
      }
    }
    else{
      var i =0;
      var galleryFiles = await imagePicker.pickMultiImage();
      while(i<galleryFiles.length){
        File imageFile = File(galleryFiles[i].path);
        if(imageFiles.length<3)
        {
          imageFiles.add(imageFile) ;
        }
        else
        {
          Get.showSnackbar(Ui.ErrorSnackBar(message: "You can only upload 3 photos!".tr));
          throw new Exception('You can only upload 3 photos');
        }
        i++;
      }
    }
  }


  sendImages(int a, var imageFil, int id)async{

    //for(var b=0; b<luggageId.length;b++){
      var headers = {
        'Accept': 'application/json',
        'Authorization': Domain.authorization,
        'Content-Type': 'multipart/form-data',
      };
      var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/m1st_hk_roadshipping.luggage/$id/luggage_image$a'));
      request.files.add(await http.MultipartFile.fromPath('ufile', imageFil.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        print("Hello"+data.toString());
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Luggages  succesfully updated ".tr));
        Navigator.pop(Get.context);
        imageFiles.clear();
      }
      else {
        var data = await response.stream.bytesToString();
        print(data);
      }
    //}
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
      shippingLoading.value = false;
      shippingLuggage.value = json.decode(data);
    }
    else {
    print(response.reasonPhrase);
    }
  }
}
