import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';

import '../../../models/media_model.dart';
import '../../root/controllers/root_controller.dart';

class AddTravelController extends GetxController{

  var avatar = new Media().obs;
  final isDone = false.obs;
  var departureDate = DateTime.now().obs;
  var arrivalDate = DateTime.now().obs;
  var departureTown = ''.obs;
  var arrivalTown = ''.obs;
  var quantity = 0.obs;
  var price = 0.obs;
  var travelType = "".obs;
  var buttonPressed = false.obs;
  var checkBoxValue = false.obs;
  var list = [].obs;
  GlobalKey<FormState> newTravelKey;
  List transportType = [
    "Land",
    "Air",
    "Sea"
  ].obs;
  ScrollController scrollController = ScrollController();
  final formStep = 0.obs;
  //TextEditingController departureTown = TextEditingController();

  backToHome()async{
    await Get.find<RootController>().changePage(0);
  }

  @override
  void onInit() async {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        //await listenForMessages();
      }
    });
    super.onInit();
  }

  chooseDepartureDate() async {
    DateTime pickedDate = await showRoundedDatePicker(
      context: Get.context,
      imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
      initialDate: DateTime.now(),
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
      departureDate.value = pickedDate;
    }
  }

  chooseArrivalDate() async {
    DateTime pickedDate = await showRoundedDatePicker(
      context: Get.context,
      imageHeader: AssetImage("assets/img/pexels-julius-silver-753331.jpg"),
      initialDate: DateTime.now(),
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
      arrivalDate.value = pickedDate;
    }
  }

  searchPlace()async{
    Prediction prediction = await PlacesAutocomplete.show(
        context: Get.context,
        apiKey: "AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU",
        mode: Mode.fullscreen, // Mode.overlay
        language: "en",
        components: [Component(Component.country, "pk")]);
    displayPrediction(prediction);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: 'AIzaSyDdyth2EiAjU9m9eE_obC5fnTY1yeVNTJU',
       // apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      print(p.description);
      print(detail);
      /*scaffold.showSnackBar(
        SnackBar(content: Text("${p.description}")),
      );*/
    }
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
