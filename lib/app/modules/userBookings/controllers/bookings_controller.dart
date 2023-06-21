import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import 'package:http/http.dart' as http;

import '../../../providers/odoo_provider.dart';
import '../../../repositories/upload_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/packet_image_field_widget.dart';

class BookingsController extends GetxController {

  final currentSlide = 0.obs;
  final quantity = 1.0.obs;
  final luggageWidth = 1.0.obs;
  final luggageHeight= 1.0.obs;
  final description = ''.obs;
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
  var transferBooking = false.obs;
  var bookingIdForTransfer =''.obs;

  var selectedIndex = 0.obs;
  var receiverId = 0.obs;
  var selected = false.obs;

  var visible = true.obs;
  var editNumber = false.obs;



  final uploading = false.obs;
  final currentState = 0.obs;
  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  File imageFile;
  final heroTag = "".obs;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
  final isDone = false.obs;
  var myAirBookings = [];
  var myRoadBookings = [];
  var bookingsOnMyTravel = [];
  var imageFiles = [].obs;
  var items = [].obs;
  var itemsBookingsOnMyTravel = [].obs;
  ScrollController scrollController = ScrollController();
  var list = [];

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
    initValues();
  }

  @override
  void onReady(){
    heroTag.value = Get.arguments.toString();
    initValues();
    super.onReady();
  }

  initValues()async{
    isLoading.value = true;
    myAirBookings = await getMyAirBookings();
    myRoadBookings = await getMyRoadBookings();

    print('road bookings'+myRoadBookings.toString());
    print('air bookings'+myAirBookings.toString());

    items.value = await mixBookingCategories(myAirBookings, myRoadBookings);
    list = await mixBookingCategories(myAirBookings, myRoadBookings);
    isLoading.value = false;
    await getAllUsers();

  }

  refreshBookings()async{
    initValues();
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = list;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['travel']['departure_town']
          .toString().toLowerCase().contains(query.toLowerCase()) || element['travel']['arrival_town']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = list;
    }
  }

  Future getMyAirBookings() async {
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
      //isLoading.value = false;
      print(data);
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getMyRoadBookings()async{
    final box = GetStorage();
    var id = box.read('session_id');
    var headers = {
      'Cookie': 'frontend_lang=en_US; '+id.toString()
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/road/current/user/my_booking/made'));
    request.body = '''{\r\n  "jsonrpc": "2.0"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //isLoading.value = false;
      print(data);
      return json.decode(data);

    }
    else {
      print(response.reasonPhrase);
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

  editAirBooking(int book_id)async{
    if(imageFiles.length == 0 || imageFiles.length ==3 ){
      final box = GetStorage();
      var session_id = box.read('session_id');
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'frontend_lang=en_US; '+session_id.toString()
      };
      var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/air/travel/booking/update/'+book_id.toString()));

      if(selectUser.value) {
        print(true);
        print(receiverId.value.toString());
        request.body = json.encode({
          "jsonrpc": "2.0",
          "params": {
            "receiver_partner_id": receiverId.value,
            "type_of_luggage": description.value,
            "kilo_booked": quantity.value.toInt()
          }
        });
      }
      else{
        request.body = json.encode({
          "jsonrpc": "2.0",
          "params": {
            "receiver_name": name.value,
            "receiver_email": email.value,
            "receiver_phone": phone.value,
            "receiver_address": address.value,
            "type_of_luggage": description.value,
            "kilo_booked": quantity.value.toInt()
          }
        });
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        if(json.decode(data)['result'] != null){
          await setAirPacketImage(book_id);
          Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking  succesfully updated ".tr));
          Navigator.pop(Get.context);
          imageFiles.clear();
        }else{
          Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
        }
      }
      else {
        print(response.reasonPhrase);
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }


    }
    else{
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please upload 3 photos or don't update the pictures!".tr));
    }



  }


  editRoadBooking(int book_id)async{
    if(imageFiles.length == 0 || imageFiles.length ==3 ){
      final box = GetStorage();
      var session_id = box.read('session_id');

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': session_id.toString()
      };
      var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/road/travel/booking/update/'+book_id.toString()));
      if(selectUser.value) {
        print('road');
        request.body = json.encode({
          "jsonrpc": "2.0",
          "params": {
            "receiver_partner_id": receiverId.value,
            "luggage_width": luggageWidth.value,
            "luggage_height": luggageHeight.value,
            "luggage_weight": quantity.value,
            "type_of_luggage": description.value
          }
        });
      }
      else{
        print('road again');

        request.body = json.encode({
          "jsonrpc": "2.0",
          "params": {
            "receiver_name": name.value,
            "receiver_email": email.value,
            "receiver_phone": phone.value,
            "receiver_address": address.value,
            "type_of_luggage": description.value,
            "luggage_width": luggageWidth.value,
            "luggage_height": luggageHeight.value,
            "luggage_weight": quantity.value
          }
        });
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        if(json.decode(data)['result'] != null){
          await setRoadPacketImage(book_id);
          Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking  succesfully updated ".tr));
          Navigator.pop(Get.context);
          imageFiles.clear();
        }else{
          Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
        }
      }
      else {
        print(response.reasonPhrase);
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else{
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please upload 3 photos or don't update the pictures!".tr));
    }



  }


  Future <File> pickImage(ImageSource source) async {
    //image.value = null;
    ImagePicker imagePicker = ImagePicker();
    //uploading.value = true;
    //await deleteUploaded();
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

  Future setAirPacketImage (bookingId)async{
    Get.lazyPut<PacketImageFieldController>(
          () => PacketImageFieldController(),
    );

    if (imageFiles.length==3) {
      //try {
        //await deleteUploaded();
        await _uploadRepository.airImagePacket(imageFiles, bookingId);
      // } catch (e) {
      //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      // }
    }
  }

  Future setRoadPacketImage (bookingId)async{
    Get.lazyPut<PacketImageFieldController>(
          () => PacketImageFieldController(),
    );
    File imageFile = Get.find<PacketImageFieldController>().image.value;
    if (imageFiles.length==3) {

      //await deleteUploaded();
      await _uploadRepository.roadImagePacket(imageFiles.value, bookingId);

    }
  }

  transferMyAirBookingNow(int booking_id)async{
    transferBooking.value = true;
    bookingIdForTransfer.value = booking_id.toString();
    await Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);

  }

  transferMyRoadBookingNow(int booking_id)async{
    transferBooking.value = true;
    bookingIdForTransfer.value = booking_id.toString();
    await Get.offAndToNamed(Routes.AVAILABLE_TRAVELS);

  }

  deleteMyAirBooking(int book_id)async{
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
        Get.showSnackbar(Ui.SuccessSnackBar(message: json.decode(data)['message']));
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

  deleteMyRoadBooking(int id)async{
    print('delete Road Booking');
    final box = GetStorage();
    var session_id = box.read("session_id");

    var headers = {
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.Request('DELETE', Uri.parse(Domain.serverPort
        +'/road/booking/'+id.toString()+'/delete'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(json.decode(data)['status'] == 200){
        Get.showSnackbar(Ui.SuccessSnackBar(message: "${json.decode(data)['message']}".tr));
        Navigator.pop(Get.context);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  getAllUsers()async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Content-Type': 'text/plain',
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/hubkilo/all/partners'));
    request.body = '''{\r\n     "jsonrpc": "2.0"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      users.value= json.decode(data);
      resetusers.value= json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
