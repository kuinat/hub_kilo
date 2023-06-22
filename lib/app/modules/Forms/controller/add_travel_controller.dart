import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/media_model.dart';
import '../../../routes/app_routes.dart';
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

class AddTravelController extends GetxController{

  var avatar = new Media().obs;
  final isDone = false.obs;
  var departureDate = DateTime.now().add(Duration(days: 2)).toString().obs;
  var arrivalDate = DateTime.now().add(Duration(days: 3)).toString().obs;
  var departureId = 0.obs;
  var arrivalId = 0.obs;
  var restriction = ''.obs;
  var quantity = 0.0.obs;
  var price = 0.0.obs;
  var canBargain = false.obs;
  var predict1 = false.obs;
  var predict2 = false.obs;
  var townEdit = false.obs;
  var town2Edit = false.obs;
  var travelType = "".obs;
  File passport;
  var countries = [].obs;
  var list = [];
  var loadPassport = false.obs;
  var loadTicket = false.obs;
  File ticket;
  final travelCard = {}.obs;
  var travelTypeSelected = false.obs;
  var buttonPressed = false.obs;
  var ticketUpload = false.obs;
  GlobalKey<FormState> newTravelKey;
  ScrollController scrollController = ScrollController();
  final formStep = 0.obs;
  TextEditingController depTown = TextEditingController();
  TextEditingController arrTown = TextEditingController();

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    travelCard.value = arguments['travelCard'];
    print("travel is $travelCard");
    if (travelCard != null) {
      travelType.value = travelCard['booking_type'];
      departureId.value = travelCard['departure_city_id'][0];
      arrivalId.value = travelCard['arrival_city_id'][0];
      departureDate.value = travelCard['departure_date'];
      arrivalDate.value = travelCard['arrival_date'];
      depTown.text = travelCard['departure_city_id'][1];
      arrTown.text = travelCard['arrival_city_id'][1];
      quantity.value = travelCard['total_weight'];
      price.value = travelCard['booking_price'];
      //restriction.value = travelCard['total_weight'];
    }
    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;
    super.onInit();
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = list;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      countries.value = dummyListData;
      for(var i in countries){
        print(i['display_name']);
      }
      return;
    } else {
      countries.value = list;
    }
  }

  final _picker = ImagePicker();

  passportPicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        passport = File(pickedImage.path);
        loadPassport.value = !loadPassport.value;
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        passport = File(pickedImage.path);
        loadPassport.value = !loadPassport.value;
      }

    }

  }

  ticketPicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        ticket = File(pickedImage.path);
        loadTicket.value = !loadTicket.value;
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        ticket = File(pickedImage.path);
        loadTicket.value = !loadTicket.value;
      }

    }

  }

  backToHome()async{
    await Get.find<RootController>().changePage(0);
  }

  chooseDepartureDate() async {
    DateTime pickedDate = await showRoundedDatePicker(
      context: Get.context,
      imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
      initialDate: DateTime.now().add(Duration(days: 2)),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 10),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        textStyleYearButton: TextStyle(
          fontSize: 52,
          color: Colors.white,
        )
      ),
      borderRadius: 16,
      selectableDayPredicate: disableDate
    );
    if (pickedDate != null && pickedDate != departureDate.value) {
      departureDate.value = pickedDate.toString();
    }
  }

  chooseArrivalDate() async {
    DateTime pickedDate = await showRoundedDatePicker(
      context: Get.context,
      imageHeader: AssetImage("assets/img/pexels-julius-silver-753331.jpg"),
      initialDate: DateTime.now().add(Duration(days: 2)),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 10),
        styleDatePicker: MaterialRoundedDatePickerStyle(
            textStyleYearButton: TextStyle(
              fontSize: 52,
              color: Colors.white,
            )
        ),
      borderRadius: 16,
      selectableDayPredicate: disableDate
    );
    if (pickedDate != null && pickedDate != arrivalDate.value) {
      arrivalDate.value = pickedDate.toString();
    }
  }

  /*searchPlace()async{
    Prediction prediction = await PlacesAutocomplete.show(
        context: Get.context,
        apiKey: "AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU",
        mode: Mode.fullscreen, // Mode.overlay
        language: "en",
        components: [Component(Component.country, "pk")]);
    print(prediction.description);
    //displayPrediction(prediction);
  }*/

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().add(Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  createRoadTravel()async{

    final box = GetStorage();
    var session_id = box.read('session_id');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Basic ZnJpZWRyaWNoOkF6ZXJ0eTEyMzQ1JQ==',
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.travelbooking?values='
        '{"name": "New Travel",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}"'
        '}'
    ));

  request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("travel response: $data");
      if(json.decode(data) != []){
        //await uploadCNI(json.decode(data)['result']['travel']['id']);

        buttonPressed.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Your travel has been created successfully ".tr));
        Get.offNamed(Routes.MY_TRAVELS);

      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
        buttonPressed.value = !buttonPressed.value;
        throw new Exception(response.reasonPhrase);
      }
    }
    else {
      throw new Exception(response.reasonPhrase);
    }
  }

  updateRoadTravel()async{
    final box = GetStorage();
    var session_id = box.read('session_id');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Basic ZnJpZWRyaWNoOkF6ZXJ0eTEyMzQ1JQ==',
      'Cookie': 'session_id=7884fbe019046ffc1379f17c73f57a9e344a6d8a'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.travelbooking?values={'
        '"name": "Travel update",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}"'
        '}&ids=${travelCard['id']}'
    ));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print("travel response: $data");
      buttonPressed.value = false;
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Your travel has been updated successfully ".tr));
      Navigator.pop(Get.context);

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      throw new Exception(response.reasonPhrase);
    }
  }

  /*uploadCNI(int travelId)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.MultipartRequest('POST', Uri.parse(Domain.serverPort+'/road/travel/document/upload'));
    request.fields.addAll({
      'travel_id': travelId.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('cni_doc', passport.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Your travel has been created successfully ".tr));
      buttonPressed.value = !buttonPressed.value;
      //uploadImages(id);
      Navigator.pop(Get.context);
    }
    else {
      print(response.reasonPhrase);
    }
  }*/

  /*uploadImages(int travelId)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.MultipartRequest('POST', Uri.parse(Domain.serverPort+'/air/travel/document/upload'));
    request.fields.addAll({
      'travel_id': travelId.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('cni_doc', passport.path));
    request.files.add(await http.MultipartFile.fromPath('ticket_doc', ticket.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Your travel has been created successfully ".tr));
      buttonPressed.value = !buttonPressed.value;
      //uploadImages(id);
    }
    else {
      print(response.reasonPhrase);
    }

  }*/


  selectCameraOrGallery()async{
    showDialog(
        context: Get.context,
        builder: (_){
          return AlertDialog(
            content: Container(
                height: 170,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      onTap: ()async{
                        ticketUpload.value? await ticketPicker('camera'):await passportPicker('camera');
                        // pickImage(ImageSource.camera, field, uploadCompleted);
                        // Navigator.pop(Get.context);
                        Navigator.pop(Get.context);

                      },
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        ticketUpload.value? await ticketPicker('gallery'): await passportPicker('gallery');
                        Navigator.pop(Get.context);
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

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
