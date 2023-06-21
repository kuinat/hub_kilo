import 'dart:convert';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;
  var landTravelList = [].obs;
  var airTravelList = [].obs;
  var travelItem = [];
  var isLoading = true.obs;

  final addresses = <Address>[].obs;
  var airTravels = [];
  var landTravels = [];
  var seaTravels = [];
  final currentSlide = 0.obs;
  //final buttonPressed = false.obs;
  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    travelItem = await getAllTravels();
    for(var a in travelItem){
      if(a["booking_type"] == "road"){
        landTravels.add(a);
      }
    }
    landTravelList.value = landTravels;
    airTravelList.value = airTravels;
    //print(listItems);
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    isLoading.value = true;
    travelItem = await getAllTravels();

    for(var a in travelItem){
      if(a["booking_type"] == "road"){
        landTravels.add(a);
      }
    }
    landTravelList.value = landTravels;
    airTravelList.value = airTravels;
    //print(listItems);
    /*print("land travel: $airTravelList");
    print("air travel: $airTravelList");*/
  }

  Future getAllTravels()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m1st_hk_roadshipping.travelbooking'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      isLoading.value = false;
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
