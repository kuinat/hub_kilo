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
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/media_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

class ImportIdentityFilesController extends GetxController{

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

    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;
    print("first country is ${countries[0]}");
    var arguments = Get.arguments as Map<String, dynamic>;

    if(arguments != null){
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
    }

    super.onInit();
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
