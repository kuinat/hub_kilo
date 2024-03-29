import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/my_user_model.dart';
import '../../../models/option_model.dart';
import 'package:http/http.dart' as http;

import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/my_auth_service.dart';
import '../../root/controllers/root_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';

class TravelInspectController extends GetxController {
  final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  final currentSlide = 0.obs;
  final quantity = 1.00.obs;
  final travelCard = {}.obs;
  final imageUrl = "".obs;
  final bookingStep = 0.obs;
  final elevation = 0.obs;
  final name = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final address = "".obs;
  final selectUser = false.obs;
  var receiverId = 0.obs;
  var paymentMethodId = 0.obs;
  final buttonPressed = false.obs;
  final luggageLoading = true.obs;
  var url = ''.obs;
  var selectedIndex = 0.obs;
  var currentIndex = 0.obs;
  var status = ''.obs;
  var accept = false.obs;
  var reject = false.obs;
  var selected = false.obs;
  var userExist = false.obs;
  var typing = false.obs;
  var selectedLuggage = false.obs;
  var list = [];
  var users =[].obs;
  var travelBookings = [].obs;
  var listBeneficiaries =[];
  var transferBooking = false.obs;
  var transferBookingId = ''.obs;
  var transferRoadBookingId = ''.obs;
  var imageFiles = [].obs;
  var luggageModels = [].obs;
  var luggageId = [].obs;
  var listUsers = [].obs;
  var viewUsers = [].obs;
  var luggageSelected = [].obs;
  var listPaymentMethod = [].obs;
  final errorField = false.obs;
  var shippingLuggage =[].obs;
  final _picker = ImagePicker();
  File profileImage;
  final loadProfileImage = false.obs;
  var existingPartner;
  var selectedUser = false.obs;
  var selectedUserIndex = 0.obs;

  var visible = true.obs;
  UserRepository _userRepository;

  UploadRepository _uploadRepository;


  TravelInspectController() {
    _uploadRepository = new UploadRepository();
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    _userRepository = UserRepository();
    Get.put(currentUser);

  }

  @override
  void onInit() async {
    transferBooking = Get.find<BookingsController>().transferBooking;
    print("transfer "+transferBooking.toString());
    transferBookingId =Get.find<BookingsController>().bookingIdForTransfer;
    transferRoadBookingId =Get.find<BookingsController>().bookingIdForTransfer;
    var arguments = Get.arguments as Map<String, dynamic>;
    travelCard.value = arguments['travelCard'];
    print('travelCard Value '+travelCard.toString());
    List allUsers = await getAllUsers();
    listUsers.value = allUsers;
    //listAir = await getAirBookingsOnTravel(travelCard['id']);
    //listRoad = await getRoadBookingsOnTravel(travelCard['id']);

    /*travelCard['booking_type'] == "air"?
    list = listAir
        :travelCard['travel_type'] == "road"?*/

     if(Get.find<MyAuthService>().myUser.value.id != travelCard['partner_id'][0]){
       print(currentUser.value.id);
       listBeneficiaries = await getAllBeneficiaries(currentUser.value.id);
       List models = await getAllLuggageModel();
       luggageModels.value = models;
      users.value = listBeneficiaries;
     }

    if(travelCard['booking_type'].toLowerCase() == "air"){
      imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
      //"assets/img/istockphoto-1421193265-612x612.jpg";
    }else if(travelCard['booking_type'].toLowerCase() == "sea"){
      imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
      //"assets/img/pexels-julius-silver-753331.jpg";
    }else{
      imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
      //"assets/img/istockphoto-859916128-612x612.jpg";
    }
    super.onInit();
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = listBeneficiaries;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      users.value = dummyListData;
      return;
    } else {
      users.value = listBeneficiaries;
    }
  }

  searchUser(String query){
    if(query.isNotEmpty) {
      typing.value = true;
      List dummyListData = [];
      dummyListData = listUsers.where((element) => element['login']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      if(dummyListData.isNotEmpty){
        userExist.value = true;
        viewUsers.value = dummyListData;
        print(userExist);
      }else{
        userExist.value = false;
        email.value = query;
        print(userExist);
      }
      return;
    }else{
      typing.value = false;
    }
  }

  getPaymentMethod()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/account.payment.method.line'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      for(var a in json.decode(data)){
        if(a['payment_acquirer_state'].toString() == "enabled"){
          listPaymentMethod.add(a);
        }
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future getThisTravelShipping(var shipping)async{

    var headers = {
      'api-key': Domain.apiKey,
      // 'Accept': 'application/json',
      // 'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort2}/m1st_hk_roadshipping.shipping/search'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      print('data is'+data.toString());
      var shippingList =[];
      if(json.decode(data)['success']){
        for(var a=0; a<json.decode(data)['data'].length; a++){
          if(shipping.contains(json.decode(data)['data'][a]['id']) && !shippingList.contains(json.decode(data)['data'][a])){
            shippingList.add(json.decode(data)['data'][a]);
          }
        }
        return shippingList;
      }else{
        print("An issue");
        return [];
      }
    }
    else {
      print(response.reasonPhrase);
      return [];
    }
  }

  @override
  void onReady() async {
    //await refreshEService();
    super.onReady();
  }

  Future refreshEService() async {
    onInit();
  }

  cancelTravel(int travel_id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.travelbooking?values='
        '{"state": "rejected"}&ids=$travel_id'));

    http.StreamedResponse response = await request.send();

    request.headers.addAll(headers);

    if (response.statusCode == 200) {

      final data = await response.stream.bytesToString();
      print(data);

      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping Canceled"));
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);

    }
    else {
      final data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));

      throw new Exception(response.reasonPhrase);
    }
  }

  acceptShipping(int id)async{
    final box = GetStorage();
    var session_id = box.read('session_id');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values='
        '{"state": "accepted"}&ids=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      list = await getThisTravelShipping(travelCard['shipping_ids']);
      travelBookings.value = list;
      Get.showSnackbar(Ui.SuccessSnackBar(message: "shipping accepted Successfully".tr));
      Navigator.pop(Get.context);
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }

  }

  validateTravel(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.travelbooking?values='
        '{"state": "accepted"}&ids=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      list = await getThisTravelShipping(travelCard['shipping_ids']);
      travelBookings.value = list;
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping accepted Successfully".tr));
      Navigator.pop(Get.context);
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
    }
  }

  rejectShipping(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7884fbe019046ffc1379f17c73f57a9e344a6d8a'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values='
        '{"state": "rejected"}&ids=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      list = await getThisTravelShipping(travelCard['shipping_ids']);
      travelBookings.value = list;
      print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "shipping rejected ".tr));
      Navigator.pop(Get.context);
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }

  shipNow()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=a3ffbeb70a9e310852261c236548fc5735e96419'
    };
    if(!selectUser.value) {
      var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.shipping?values={'
          '"travelbooking_id": ${travelCard['id']},'
          '"receiver_partner_id": ${receiverId.value},'
          '"shipping_price": 0.0,'
          '"luggage_ids": $luggageId,'
          '"payment_method_line_id": $paymentMethodId,'
          '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
          '}'
      ));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {

        var data = await response.stream.bytesToString();
        print(data);

        buttonPressed.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping created successfully ".tr));
        await Get.find<RootController>().changePage(1);

      }
      else {
        var data = await response.stream.bytesToString();
        print(data);
        buttonPressed.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      }
    }
    else{

      await createBeneficiary(name.value, email.value, phone.value);

    }
  }

   createBeneficiary(String name, String email, String phone ) async {

    print(name);
    print(email);
    print(phone);

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };
    var request = http.Request('POST',Uri.parse('${Domain.serverPort}/create/res.users?values={ '
        '"name": "$name",'
        '"login": "$email",'
        '"email": "$email",'
        '"phone": "$phone",'
        '"sel_groups_1_9_10": 10}'

    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)  {
      var result = await response.stream.bytesToString();
      print(result);
      var data = json.decode(result);
      var portalId = await updateBeneficiaryToPortalUser(data[0]);
      var partnerId = await getCreatedBeneficiary(portalId);
      await uploadProfileImage(profileImage, partnerId);
      //await updateBeneficiaryPartnerEmail(partnerId, email);
      createShipping(partnerId);
    }
    else {
      var data = await response.stream.bytesToString();
      buttonPressed.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      //existingPartner = ['testname','https://stock.adobe.com/search?k=admin'];
      //existingPartnerVisible.value = true;


    }
  }

  createShipping(var partnerId)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };

    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id": ${travelCard['id']},'
        '"receiver_partner_id": $partnerId,'
        '"shipping_price": 0.0,'
        '"luggage_ids": $luggageId,'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Shipping created successfully ".tr));
      await Get.find<RootController>().changePage(1);

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
    }
  }

  uploadProfileImage(File file, int id) async {
    if (Get.find<MyAuthService>().myUser.value.email==null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
      'Cookie': 'session_id=a5b5f221b0eca50ae954ad4923fead1063097951'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/res.partner/$id/image_1920'));
    request.files.add(await http.MultipartFile.fromPath('ufile', file.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      print("Yrreee: "+await response.stream.bytesToString());
      //var user = await getUser();
      //var uuid =user.image ;

      //return uuid;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  updateBeneficiaryToPortalUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d04af03f698078c752b685cba7f34e4cbb3f208b'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.users?ids=$id&values={'
        '"sel_groups_1_9_10": 9}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      print('Updated to portal user');
      print(data);
      return json.decode(data)[0];
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  getCreatedBeneficiary(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.users?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result);
      var id = data[0]['partner_id'][0];
      print('The id of the created beneficiary is: '+id.toString());
      return id;

    } else {
      var result = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(result)['message']));
    }
  }

  transferTravelShipping()async{

    final box = GetStorage();
    var session_id = box.read('session_id');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=a3ffbeb70a9e310852261c236548fc5735e96419'
    };

    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id": ${travelCard['id']},'
        '}&ids=${transferBookingId}'
    ));


    //'"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Transfer success ".tr));
      Get.find<BookingsController>().transferBooking.value = false;
      Navigator.pop(Get.context);

    }
    else {
      print(response.reasonPhrase);
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      Get.find<BookingsController>().transferBooking.value = false;
    }
  }

  TextStyle getTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.caption.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.caption;
  }

  Color getColor(Option option) {
    if (option.checked.value) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }

  void incrementQuantity() {
    quantity.value < 1000 ? quantity.value++ : null;
  }

  void decrementQuantity() {
    quantity.value > 1 ? quantity.value-- : null;
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

  sendImages(int a, var imageFil)async{
    for(var b=0; b<luggageId.length;b++){
      var headers = {
        'Accept': 'application/json',
        'Authorization': Domain.authorization,
        'Content-Type': 'multipart/form-data',
        'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
      };
      var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/m1st_hk_roadshipping.luggage/${luggageId[b]}/luggage_image$a'));
      request.files.add(await http.MultipartFile.fromPath('ufile', imageFil.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        print(data);
      }
      else {
        var data = await response.stream.bytesToString();
        print(data);
      }
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

  Future getAllUsers()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/search_read/res.users'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("Users Loaded");
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getAllBeneficiaries(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
        var result = json.decode(data);
        var list= result[0]['receiver_partner_ids'];
        var listUser = await getUsersInAddressBook(list);
        print('Partner list'+listUser.toString());
        return listUser==null?[]:listUser;

    }
    else {
      print(response.reasonPhrase);
    }
  }


  getUsersInAddressBook(List list)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=fb684dfb6b5282f2f26a5696dae345076e431019'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=$list'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      return result;
    }
    else {
    print(response.reasonPhrase);
    }

  }


  selectCameraOrGalleryProfileImage()async{
    showDialog(
        context: Get.context,
        builder: (_){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
                height: 170,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('camera');
                        //Navigator.pop(Get.context);
                        loadProfileImage.value = !loadProfileImage.value;

                      },
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('gallery');
                        //Navigator.pop(Get.context);
                        loadProfileImage.value = !loadProfileImage.value;
                      },
                      leading: Icon(FontAwesomeIcons.image),
                      title: Text('Upload an image', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    )
                  ],
                )
            ),
          );
        });
  }

  profileImagePicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        Navigator.of(Get.context).pop();
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;//Navigator.of(Get.context).pop();
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        Navigator.of(Get.context).pop();
        //await sendImages(id, identificationFile );
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;
        //Navigator.of(Get.context).pop();
      }
    }
  }


}
