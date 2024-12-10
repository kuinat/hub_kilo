import 'dart:convert';

import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../services/my_auth_service.dart';
import '../../../services/settings_service.dart';
import 'package:http/http.dart' as http;

import '../../travel_inspect/controllers/travel_inspect_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';

class HomeController extends GetxController {
  var landTravelList = [].obs;
  var airTravelList = [].obs;
  var expeditionOfferList = [].obs;
  var receptionOfferList = [].obs;
  var travelItem = [];
  var expeditionsItem = [];
  var receptionsItem = [];
  var isRoadTravelLoading = true.obs;
  var isAirTravelLoading = true.obs;
  var isExpeditionOfferLoading = true.obs;
  var isReceptionOfferLoading = true.obs;
  var shippingRequestSelected = false.obs;
  var currentPage = 1.obs;
  final addresses = <Address>[].obs;
  var airTravels = [];
  var landTravels = [];
  var seaTravels = [];
  final currentSlide = 0.obs;
  //final buttonPressed = false.obs;
  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;
  var totalPages = 0.obs;
  var listOfAllAirTravelsLuggages = [];
  var existingPublishedRoadTravel = false.obs;
  var existingPublishedAirTravel = false.obs;

  HomeController() {
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );
    Get.lazyPut<TravelInspectController>(
          () => TravelInspectController(),
    );
    //_sliderRepo = new SliderRepository();
    //_categoryRepository = new CategoryRepository();
    //_eServiceRepository = new EServiceRepository();
  }

  @override
  void onInit() async {
    landTravels = [];
    travelItem = await getAllRoadTravels();
    travelItem.shuffle();
    landTravelList.value = travelItem;

    airTravels = await getAllAirTravels();
    airTravels.shuffle();
    airTravelList.value = airTravels;

    expeditionsItem = await getAllExpeditionsOffers();
    expeditionOfferList.value = expeditionsItem;

    receptionsItem = await getAllReceptionsOffers();
    receptionOfferList.value = receptionsItem;

    existingPublishedRoadTravel.value = await verifyPublishedRoadTravel();
    existingPublishedAirTravel.value = await verifyPublishedAirTravel();
    //print(listItems);
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    isRoadTravelLoading.value = true;
    isExpeditionOfferLoading.value = true;
    landTravels = [];
    travelItem = await getAllRoadTravels();
    travelItem.shuffle();
    landTravelList.value = travelItem;
    airTravels = await getAllAirTravels();
    airTravels.shuffle();

    airTravelList.value = airTravels;

    expeditionsItem = await getAllExpeditionsOffers();
    expeditionOfferList.value = expeditionsItem;

    receptionsItem = await getAllReceptionsOffers();
    receptionOfferList.value = receptionsItem;
  }

  Future getAllRoadTravels()async{
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=52d594da9dde293f734bbc823c22ed471f482459'
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/frontend/all/travels'));
    request.body = '''{\n    "jsonrpc": "2.0"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      isRoadTravelLoading.value = false;
      return json.decode(data)['travels'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  getAllExpeditionsOffers()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m1st_hk_roadshipping.shipping'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      isExpeditionOfferLoading.value = false;
      var result =  json.decode(data);
      var list= [];
      for(int i = 0; i<result.length; i++){
        if(result[i]['travelbooking_id'] == false && result[i]['bool_parcel_reception'] == false){
          if(result[i]['state']=='pending'){
            print(result[i]);
            list.add(result[i]);
          }

        }
      }
      return list;
    }
    else {
      print(response.reasonPhrase);
    }


  }

  getAllReceptionsOffers()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m1st_hk_roadshipping.shipping'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      isReceptionOfferLoading.value = false;
      var result =  json.decode(data);
      var list= [];
      for(int i = 0; i<result.length; i++){
        if(result[i]['travelbooking_id'] == false && result[i]['bool_parcel_reception'] == true){
            if(result[i]['state']=='pending'){
              print("hello: ${(result[i]['parcel_reception_shipper'])}");
              list.add(result[i]);

            }
        }
        print('wow jj: $list');

      }
      return list;
    }
    else {
      print(response.reasonPhrase);
    }


  }


  Future getAllAirTravels()async{
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=52d594da9dde293f734bbc823c22ed471f482459'
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/air/'
        'frontend/all/travels'));
    request.body = '''{\n    "jsonrpc": "2.0"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var result = json.decode(data)['travels'];

      listOfAllAirTravelsLuggages.clear();

      for(var item in result){
        var luggages = await getSpecificAirTravelLuggages(item['luggage_types']);
        print(luggages);
        listOfAllAirTravelsLuggages.addAll(luggages);

      }
      isAirTravelLoading.value = false;
      return json.decode(data)['travels'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

}

getSpecificAirTravelLuggages(List luggageIds)async{
  var headers = {
    'Accept': 'application/json',
    'Authorization': Domain.authorization
  };
  var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.flight.luggage?ids=$luggageIds'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    print('specific : ${json.decode(data)}');

    return json.decode(data);
  }
  else {
    print(response.reasonPhrase);
    return [];
  }





}

Future verifyPublishedRoadTravel()async{

  var headers = {
    'Accept': 'application/json',
    'Authorization': Domain.authorization
  };
  var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=${Get.find<MyAuthService>().myUser.value.roadTravelIds}'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    var result = json.decode(data);
    for(var travel in result){
      if(travel['state'] == 'negotiating'){
        return true;
      }
    }
   return false;
  }
  else {
    var data = await response.stream.bytesToString();
    return false;

    print(data);
  }
}
Future verifyPublishedAirTravel()async{

  var headers = {
    'Accept': 'application/json',
    'Authorization': Domain.authorization
  };
  var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.travelbooking?ids=${Get.find<MyAuthService>().myUser.value.airTravelIds}'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    var result = json.decode(data);
    for (var travel in result) {
      if (travel['state'] == 'negotiating') {
        print('true');
        return true;
      }
    }
    return false;
  }
  else {
    var data = await response.stream.bytesToString();
    return false;
    print(data);
  }
}
