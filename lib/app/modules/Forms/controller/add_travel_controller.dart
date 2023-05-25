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
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

class AddTravelController extends GetxController{

  var avatar = new Media().obs;
  final isDone = false.obs;
  var departureDate = DateTime.now().add(Duration(days: 2)).toString().obs;
  var arrivalDate = DateTime.now().add(Duration(days: 3)).toString().obs;
  var departureTown = ''.obs;
  var arrivalTown = ''.obs;
  var country1 = ''.obs;
  var country2 = ''.obs;
  var restriction = ''.obs;
  var quantity = 0.obs;
  var price = 0.0.obs;
  var canBargain = false.obs;
  var townEdit = false.obs;
  var town2Edit = false.obs;
  var travelType = "".obs;
  File passport;
  var loadPassport = false.obs;
  var loadTicket = false.obs;
  File ticket;
  final travelCard = {}.obs;
  final selectedTravel = <String>[].obs;
  var buttonPressed = false.obs;
  var ticketUpload = false.obs;
  GlobalKey<FormState> newTravelKey;
  List transportType = [
    "Land",
    "Air",
    "Sea"
  ].obs;
  ScrollController scrollController = ScrollController();
  final formStep = 0.obs;
  //TextEditingController departureTown = TextEditingController();

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if(arguments != null) {
      travelCard.value = arguments['travelCard'];
      if (travelCard != null) {
        travelType.value = travelCard['travel_type'];
        canBargain.value = travelCard['negotiation'];
        departureDate.value = travelCard['departure_date'];
        arrivalDate.value = travelCard['arrival_date'];
        departureTown.value = travelCard['departure_town'];
        arrivalTown.value = travelCard['arrival_town'];
        quantity.value = travelCard['kilo_qty'];
        price.value = travelCard['price_per_kilo'];
        restriction.value = travelCard['type_of_luggage_accepted'];
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

  void toggleTravels(bool value, String type) {
    if (value) {
      selectedTravel.clear();
      selectedTravel.add(type);
    } else {
      selectedTravel.removeWhere((element) => element == type);
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

  searchPlace()async{
    Prediction prediction = await PlacesAutocomplete.show(
        context: Get.context,
        apiKey: "AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU",
        mode: Mode.fullscreen, // Mode.overlay
        language: "en",
        components: [Component(Component.country, "pk")]);
    print(prediction.description);
    //displayPrediction(prediction);
  }

  /*Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: 'AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU',
       // apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      print(p.description);
      print(detail);
      ScaffoldMessenger.of(Get.context).showSnackBar(
        SnackBar(
          content: Text(p.description),
        ),
      );
      /*Scaffold.showSnackBar(
        SnackBar(content: Text("${p.description}")),
      );*/
    }
  }*/

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().add(Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  postTravel()async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var id = box.read('session_id').split("=").last;
    print(id);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$id',
      'Cookie': 'frontend_lang=en_US; $session_id'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/air/api/travel/create'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "departure_town": departureTown.value,
        "arrival_town": arrivalTown.value,
        "departure_date": departureDate.value.toString(),
        "arrival_date": arrivalDate.value.toString(),
        "kilo_qty": quantity.value,
        "price_per_kilo": price.value,
        "type_of_luggage_accepted": restriction.value,
        "negotiation": canBargain.value
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("travel response: $data");
      if(json.decode(data)['result']['status'] == 'success'){
        print('travel id: '+json.decode(data)['result']['travel']['id'].toString());
        await uploadImages(json.decode(data)['result']['travel']['id']);
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Your travel has been created successfully ".tr));
        buttonPressed.value = !buttonPressed.value;
        //uploadImages(id);
        Navigator.pop(Get.context);
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

  updateTravel(int id)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; $session_id'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/air/travel/update/$id'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "departure_town": departureTown.value,
        "arrival_town": arrivalTown.value,
        "departure_date": departureDate.value.toString(),
        "arrival_date": arrivalDate.value.toString(),
        "kilo_qty": quantity.value,
        "price_per_kilo": price.value,
        "type_of_luggage_accepted": restriction.value,
        "negotiation": canBargain.value
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("travel response: $data");
      if(json.decode(data)['result'] != null && json.decode(data)['result']['status'] == 200){
        buttonPressed.value = !buttonPressed.value;
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Your travel has been updated successfully ".tr));
        Navigator.pop(Get.context);
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

  uploadImages(int travelId)async{
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
    }
    else {
      print(response.reasonPhrase);
    }

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
