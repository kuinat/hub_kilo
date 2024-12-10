import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/computer_model.dart';
import '../../../models/envelop_model.dart';
import '../../../models/kilos_model.dart';
import '../../../models/my_user_model.dart';
import '../../../models/option_model.dart';
import 'package:http/http.dart' as http;

import '../../../models/other_model.dart';
import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../../root/controllers/root_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

class TravelInspectController extends GetxController {
  final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  final currentSlide = 0.obs;
  final quantity = 1.00.obs;
  final travelCard = {}.obs;
  final imageUrl = "".obs;
  final elevation = 0.obs;
  final name = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final address = "".obs;
  final createUser = false.obs;
  final createUserReceptionOffer = true.obs;
  final typing = false.obs;
  var receiverId = 0.obs;
  var parcel_reception_shipper_partner_id  = 0.obs;
  var receiverDto = {}.obs;
  var shipperDto = {}.obs;
  var createdReceiverDto = {}.obs;
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
  var selectedLuggage = false.obs;
  var airLuggageCreated = false.obs;
  var list = [];
  var users =[].obs;
  var ratings =[].obs;
  var shippingCreatedId;
  var roadTravelBookings = [].obs;
  var airTravelBookings = [].obs;
  var listBeneficiaries =[];
  var transferBooking = false.obs;
  var transferBookingId = 0.obs;
  var transferRoadBookingId = 0.obs;
  var imageFiles = [].obs;
  var internalImageFiles = [].obs;
  var externalImageFiles = [].obs;
  var luggageModels = [].obs;
  var luggageId = [].obs;
  var listUsers = [].obs;
  var viewUsers = [].obs;
  var roadLuggageType = "".obs;
  var airLuggageType = "".obs;
  var roadLuggageTypeFrench = "".obs;
  var airLuggageTypeFrench = "".obs;
  var luggageSelected = [].obs;
  //var listPaymentMethod = [].obs;
  final _picker = ImagePicker();
  File profileImage;
  final loadProfileImage = false.obs;
  var existingPartner;
  var selectedUser = false.obs;
  var luggageDto = {}.obs;
  var viewClicked = false.obs;
  var viewRatings = false.obs;
  var loadingShipping = true.obs;
  var loadingBeneficiaries = true.obs;
  var indexClicked = 0.obs;
  var selectedUserIndex = 0.obs;
  var predict1 = false.obs;
  var errorCity1 = false.obs;
  TextEditingController city = TextEditingController();
  var street = "".obs;
  var cityId = 0.obs;

  var countries = [].obs;
  var roadTravelShipping = [].obs;
  var airTravelShipping = [].obs;
  var mixedTravelShipping = [].obs;
  var isClicked = false.obs;
  var roadLuggageTypes = [AppLocalizations.of(Get.context).envelopeType, AppLocalizations.of(Get.context).briefcaseType, AppLocalizations.of(Get.context).suitcaseType].obs;
  var airLuggageTypes = ['envelope', 'Personal Computer', 'Other'].obs;
  final user = new MyUser().obs;
  var showButton = false.obs;
  TextEditingController birthPlaceTown = TextEditingController();
  TextEditingController residentialTown = TextEditingController();
  //final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  var birthDate = ''.obs;
  final birthPlace = "".obs;
  final residence = "".obs;
  var birthDateSet = false.obs;
  //final _picker = ImagePicker();
  var birthCityId = 0.obs;
  var residentialAddressId = 0.obs;
  var predict1Profile = false.obs;
  var predict2Profile = false.obs;
  var errorCity1Profile = false.obs;

  //Arrival departures variables when creating an offer of expedition
  var departureId = 0.obs;
  var arrivalId = 0.obs;
  var restriction = ''.obs;
  var predict1Town = false.obs;
  var predict2 = false.obs;
  var townEdit = false.obs;
  var town2Edit = false.obs;
  var travelType = "road".obs;
  var errorCity1Town = false.obs;
  TextEditingController depTown = TextEditingController();
  TextEditingController arrTown = TextEditingController();

  TextEditingController descriptionText = TextEditingController();
  TextEditingController weightText = TextEditingController();
  TextEditingController heightText = TextEditingController();
  TextEditingController widthText = TextEditingController();

  var departureDate = DateTime.now().add(Duration(days: 2)).toString().toString().split(".").first.obs;
  var arrivalDate = DateTime.now().add(Duration(days: 3)).toString().toString().split(".").first.toString().obs;

  var shipping = {}.obs;
  var travel = {}.obs;
  final formStep = 0.obs;
  var shippingLuggage = [].obs;
  var genderList = [
    AppLocalizations.of(Get.context).male,
    AppLocalizations.of(Get.context).female
  ].obs;
  var selectedGender = "".obs;
  var editLuggage = false.obs;
  var editing = false.obs;
  UserRepository _userRepository;
  UploadRepository _uploadRepository;

  //Variables concerning luggage Details
  var luggageWeight = ''.obs;
  var luggageHeight = ''.obs;
  var luggageWidth = ''.obs;
  var luggageDescription = ''.obs;
  final Locale locale = Localizations.localeOf(Get.context);


  var specificAirTravelLuggage = [].obs;
  var specificAirShippingLuggage = [];
  var airShippingLuggageToEdit = [];
  var showAvailableLuggage = false.obs;
  var enveloppeChecked = false.obs;
  var envelopeSelectedIndex = 100.obs;
  var kilosChecked = false.obs;
  var luggageChecked = false.obs;
  var computerChecked = false.obs;
  var disableButton = false.obs;
  var selectedPackages = [].obs;
  KilosModel kilosModel;
  var kilosLuggageId = 0.obs;
  var kilosQuantity = 0.0.obs;
  var kilosPrice = 0.0.obs;
  var kilosWidth = 0.0.obs;
  var kilosHeight = 0.0.obs;
  var kilosWeight = 0.0.obs;
  var kilosLength = 0.0.obs;
  var kilosDescription = ''.obs;
  EnvelopModel envelopModel;
  var envelopLuggageId = 0.obs;
  var envelopQuantity = 0.0.obs;
  var envelopPrice = 0.0.obs;
  var envelopWidth = 0.0.obs;
  var envelopHeight = 0.0.obs;
  var envelopWeight = 0.0.obs;
  var envelopLength = 0.0.obs;
  var envelopFormat = ''.obs;
  var envelopDescription = ''.obs;
  var luggageModelId = 0.obs;
  ComputerModel computerModel;
  var computerLuggageId = 0.obs;
  var modelLuggageId = 0.obs;
  var computerQuantity = 0.0.obs;
  var computerPrice = 0.0.obs;
  OtherModel otherModel;
  var modelLuggageQuantity = 0.0.obs;
  var modelName = ''.obs;
  var modelLuggagePrice = 0.0.obs;
  var modelLuggageWidth = 0.0.obs;
  var modelLuggageHeight = 0.0.obs;
  var modelLuggageWeight = 0.0.obs;
  var modelLuggageLength = 0.0.obs;
  var modelLuggageDescription = ''.obs;
  var computerWidth = 0.0.obs;
  var computerHeight = 0.0.obs;
  var computerWeight = 0.0.obs;
  var computerLength = 0.0.obs;
  var computerDescription = ''.obs;

  var isEnvelopLuggageModelLoaded = false.obs;
  var envelopLuggageModel = [].obs;

  var professionalTransporter = false.obs;
  var vatNumber = "".obs;

  var predictBank = false.obs;
  var bankFound = false.obs;
  var bankAccountNumberFound = true.obs;
  var showBankAccountSearchField = true.obs;
  var bankAccountAdded = false.obs;
  var bankSelected = false.obs;
  var editShipper = false.obs;
  var bankAccountNumberSelected = false.obs;
  var selectedBankAccountIndex = 1000.obs;
  //var predict2Profile = false.obs;
  var errorBank = false.obs;
  var bankId = 0.obs;
  final bankBic = "".obs;
  final bankName = "".obs;
  final bankAccountNumber = "".obs;

  var listBanks = [];
  var listUserAccounts = [];

  final allBanks = [].obs;
  final allAccountNumbers = [].obs;


  var predictBankAccountNumber = false.obs;
  //var predict2Profile = false.obs;
  var errorBankAccountNumber = false.obs;

  TextEditingController  ibanCode = TextEditingController();

  TextEditingController  bankIdentifierCode = TextEditingController();

  TravelInspectController() {
    _uploadRepository = new UploadRepository();
    Get.lazyPut<BookingsController>(
          () => BookingsController(),
    );

    Get.lazyPut<HomeController>(
          () => HomeController(),
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

    user.value.vat.toString() == 'false'?vatNumber.value = "": vatNumber.value = user.value.vat;

    var arguments = Get.arguments as Map<String, dynamic>;
    if(arguments!=null) {
      if (arguments['travelCard'] != null) {
        travelCard.value = arguments['travelCard'];
        print(travelCard);
        print(travelCard['state_id']);

        user.value = Get.find<MyAuthService>().myUser.value;
        print(user.value.birthday.toString());

        birthDate.value = user.value.birthday.toString();
        birthPlace.value = user.value.birthplace;
        residence.value = user.value.street;


        if (travelCard['booking_type'].toLowerCase() == "air" ) {
          imageUrl.value =
          "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
          specificAirTravelLuggage.value = await getSpecificAirTravelLuggages(travelCard['luggage_types']);
          envelopLuggageModel.value = await getEnvelopLuggageModel();

        } else if (travelCard['booking_type'].toLowerCase() == "sea") {
          imageUrl.value =
          "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
          //"assets/img/pexels-julius-silver-753331.jpg";
        } else {
          imageUrl.value =
          "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
          //"assets/img/istockphoto-859916128-612x612.jpg";
        }
      }
      else{
        user.value = Get.find<MyAuthService>().myUser.value;

      }

      if(arguments['shippingDto']!=null){
        shipping.value = arguments['shippingDto'];
      }


    } else{
      user.value = Get.find<MyAuthService>().myUser.value;
      birthDate.value = user.value.birthday.toString();
      birthPlace.value = user.value.birthplace;
      residence.value = user.value.street;
    }




    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;
    //print("first country is ${countries[0]}");
    if(travelCard.isNotEmpty){
      if(Get.find<MyAuthService>().myUser.value.id == travelCard['partner_id'][0]){
        loadingShipping.value = true;
        airTravelShipping.clear();
        roadTravelShipping.clear();

        travelCard['booking_type'].toLowerCase() == "air"?
        airTravelShipping.value = await getThisAirTravelShipping(travelCard['shipping_ids'])
        :roadTravelShipping.value = await getThisRoadTravelShipping(travelCard['shipping_ids']);

        mixedTravelShipping.clear();
        mixedTravelShipping.addAll( roadTravelShipping.value);
        mixedTravelShipping.addAll( airTravelShipping.value);

      }
    }

    listBeneficiaries = await getAllBeneficiaries(currentUser.value.id);

    super.onInit();
  }


  refreshPage()async{
    airTravelShipping.clear();
    roadTravelShipping.clear();

    travelCard['booking_type'].toLowerCase() == "air"?
    airTravelShipping.value = await getThisAirTravelShipping(travelCard['shipping_ids'])
        :roadTravelShipping.value = await getThisRoadTravelShipping(travelCard['shipping_ids']);

    mixedTravelShipping.clear();
    mixedTravelShipping.addAll( roadTravelShipping.value);
    mixedTravelShipping.addAll( airTravelShipping.value);
    listBeneficiaries = await getAllBeneficiaries(currentUser.value.id);
  }

  newShippingFunction()async{
    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;
    print(currentUser.value.id);
    List models = await getAllLuggageModel();
    luggageModels.value = models;
    listBeneficiaries = await getAllBeneficiaries(currentUser.value.id);
    users.value = listBeneficiaries;
    List allUsers = await getAllUsers();
    listUsers.value = allUsers;
  }

  editingFunction()async{
    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;
    if(shipping['booking_type'] == 'By Road' || shipping['booking_type'] == ''){
      getAllLuggageModel();
    }
    else{

      var travelLuggageTypeIds = travel['luggage_types'];
      specificAirTravelLuggage.value = await getSpecificAirTravelLuggages(travelLuggageTypeIds);

      specificAirShippingLuggage = await getSpecificAirShippingLuggages(shipping['luggage_ids']);

      envelopLuggageModel.value = await getEnvelopLuggageModel();

    }
    listBeneficiaries = await getAllBeneficiaries(currentUser.value.id);
    users.value = listBeneficiaries;
    List allUsers = await getAllUsers();
    listUsers.value = allUsers;

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

  void filterSearchBank(String query) {
    List dummySearchList = [];
    dummySearchList = listBanks;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      allBanks.value = dummyListData;

      if(allBanks.isEmpty){
        bankFound.value = false;
      }
      else{
        bankFound.value = true;
      }

      return;
    } else {
      allBanks.value = listBanks;
      bankBic.value = bankIdentifierCode.text;
      bankId.value = 0;
    }
  }


  void filterSearchCity(String query) {
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

  searchUser(String query){
    print('lenght: ${listUsers.length}');
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


  Future getThisRoadTravelShipping(var shipping)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$shipping'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      loadingShipping.value = false;
      print('data is'+data.toString());
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
      return [];
    }
  }

  Future getThisAirTravelShipping(var shipping)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.shipping?ids=$shipping'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      loadingShipping.value = false;
      print('data is'+data.toString());
      return json.decode(data);
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
    if(travelCard['booking_type'].toLowerCase() == "air"){
      await getAirTravel(travelCard['id']);
    }else{
      await getRoadTravel(travelCard['id']);
    }
  }

  Future getAirTravel(var id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      specificAirTravelLuggage.value = await getSpecificAirTravelLuggages(travelCard['luggage_types']);
      envelopLuggageModel.value = await getEnvelopLuggageModel();
      if(travelCard.isNotEmpty){
        if(Get.find<MyAuthService>().myUser.value.id == travelCard['partner_id'][0]){
          loadingShipping.value = true;
          roadTravelShipping.value = await getThisRoadTravelShipping(travelCard['shipping_ids']);
          airTravelShipping.value = await getThisAirTravelShipping(travelCard['shipping_ids']);
          mixedTravelShipping.clear();
          mixedTravelShipping.addAll( roadTravelShipping.value);
          mixedTravelShipping.addAll( airTravelShipping.value);

        }
      }
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  Future getRoadTravel(var id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(travelCard.isNotEmpty){
        if(Get.find<MyAuthService>().myUser.value.id == travelCard['partner_id'][0]){
          loadingShipping.value = true;
          roadTravelShipping.value = await getThisRoadTravelShipping(travelCard['shipping_ids']);
          airTravelShipping.value = await getThisAirTravelShipping(travelCard['shipping_ids']);
          mixedTravelShipping.clear();
          mixedTravelShipping.addAll( roadTravelShipping.value);
          mixedTravelShipping.addAll( airTravelShipping.value);

        }
      }

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  getRoadTravelInfo(var id, var shipping)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      if(json.decode(data)[0]['booking_type'].toLowerCase() == "air"){
        Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
      }else if(json.decode(data)[0]['booking_type'].toLowerCase() == "sea"){
        Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
      }else{
        Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
      };

      Get.find<BookingsController>().shippingDetails.value = shipping;
      Get.find<BookingsController>().travelDetails.value = json.decode(data)[0];
      Get.find<BookingsController>().owner.value = false;

      Get.toNamed(Routes.SHIPPING_DETAILS);

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }
  getAirTravelInfo(var id, var shipping)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      if(json.decode(data)[0]['booking_type'].toLowerCase() == "air"){
        Get.find<BookingsController>().imageUrl.value = "https://images.unsplash.com/photo-1570710891163-6d3b5c47248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyZ28lMjBwbGFuZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60";
      }else if(json.decode(data)[0]['booking_type'].toLowerCase() == "sea"){
        Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/591986620/fr/photo/porte-conteneurs-de-fret-générique-en-mer.jpg?b=1&s=170667a&w=0&k=20&c=gZmtr0Gv5JuonEeGmXDfss_yg0eQKNedwEzJHI-OCE8=";
      }else{
        Get.find<BookingsController>().imageUrl.value = "https://media.istockphoto.com/id/859916128/photo/truck-driving-on-the-asphalt-road-in-rural-landscape-at-sunset-with-dark-clouds.jpg?s=612x612&w=0&k=20&c=tGF2NgJP_Y_vVtp4RWvFbRUexfDeq5Qrkjc4YQlUdKc=";
      };

      Get.find<BookingsController>().shippingDetails.value = shipping;
      Get.find<BookingsController>().travelDetails.value = json.decode(data)[0];
      Get.find<BookingsController>().owner.value = false;

      Get.toNamed(Routes.SHIPPING_DETAILS);

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  cancelRoadTravel(int travel_id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.travelbooking/set_to_rejected/?ids=$travel_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {

      final data = await response.stream.bytesToString();
      print(data);

      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).travelCanceled));
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);

    }
    else {
      final data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));

      throw new Exception(response.reasonPhrase);
    }
  }
  cancelAirTravel(int travel_id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.travelbooking/set_to_rejected_frontend/?ids=$travel_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {

      final data = await response.stream.bytesToString();
      print(data);

      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).travelCanceled));
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);

    }
    else {
      final data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));

      throw new Exception(response.reasonPhrase);
    }
  }

  closeRoadTravelNegotiation(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.travelbooking/set_to_accepted/?ids=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var list = await getThisRoadTravelShipping(travelCard['shipping_ids']);
      roadTravelBookings.value = list;
       showDialog(
          context: Get.context,
          builder: (context){
           return  SizedBox(height: 30,
                child: SpinKitThreeBounce(color: Colors.white, size: 20));
          },
      );
      await Get.find<UserTravelsController>().refreshMyTravels();
      await refreshPage();
      await Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).negotiationClosed.tr));
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);
      Get.find<HomeController>().existingPublishedRoadTravel.value  = false;
    }
    else {
      var data = await response.stream.bytesToString();
      Navigator.pop(Get.context);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}"));
    }
  }

  closeAirTravelNegotiation(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.travelbooking/set_to_accepted/?ids=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var list = await getThisAirTravelShipping(travelCard['shipping_ids']);
      airTravelBookings.value = list;
      showDialog(
        context: Get.context,
        builder: (context){
          return  SizedBox(height: 30,
              child: SpinKitThreeBounce(color: Colors.white, size: 20));
        },
      );

      await Get.find<UserTravelsController>().refreshMyTravels();
      refreshPage();
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).negotiationClosed.tr));
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);
      Get.find<HomeController>().existingPublishedAirTravel.value  = false;
    }
    else {
      var data = await response.stream.bytesToString();
      Navigator.pop(Get.context);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}"));
    }
  }

  markReceivedForRoad(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.shipping/set_to_confirm/?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print("travel response: $data");
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).confirmLuggageReception));
      refreshPage();
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);

    }
    else {
      var data = await response.stream.bytesToString();
      print("error: $data");
      Navigator.pop(Get.context);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}"));
      throw new Exception(response.reasonPhrase);
    }
  }

  markReceivedForAir(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.shipping/set_to_confirm/?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print("travel response: $data");
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).confirmLuggageReception));
      refreshPage();
      Navigator.pop(Get.context);
      Navigator.pop(Get.context);

    }
    else {
      var data = await response.stream.bytesToString();
      print("error: $data");
      Navigator.pop(Get.context);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}"));
      throw new Exception(response.reasonPhrase);
    }
  }

  updateVatNumber() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.partner?ids=${user.value.id}&values={'
        '"is_company":true,'
        '"vat":"${vatNumber.value}"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('vat number updated');
      user.value = await _userRepository.get(user.value.id);
      Get.find<MyAuthService>().myUser.value = user.value;


    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  shipRoadNow()async{
    professionalTransporter.value?await updateVatNumber():(){};
    print("create user?  "+ createUser.value.toString());
    print(travelCard['id'].toString() + name.value + email.value + phone.value + cityId.value.toString() + street.value);
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', !createUser.value ? Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id": ${travelCard['id']},'
        '"receiver_partner_id": ${receiverId.value},'
        '"receiver_source": "database",'
        '"luggage_ids": $luggageId,'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}'
    ) : Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.shipping?values={'
        '"travelbooking_id": ${travelCard['id']},'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"receiver_source": "manual",'
        '"luggage_ids": $luggageId,'
        '"receiver_name_set": "${name.value}",'
        '"receiver_email_set": "${email.value}",'
        '"receiver_phone_set": "${phone.value}",'
        '"register_receiver": "True",'
        '"receiver_city_id": ${cityId.value},'
        '"receiver_street_set": "${street.value}"'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print(data);
      if(!createUser.value){
        Future.delayed(Duration(seconds: 3),()async{
          Navigator.pop(Get.context);
          Navigator.pop(Get.context);
          Get.find<BookingsController>().refreshBookings();
        });
        isClicked.value = false;
        buttonPressed.value = false;
        showDialog(
            context: Get.context, builder: (_){
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Lottie.asset("assets/img/successfully-done.json"),
          );
        });
      }else{
        await getRoadShippingCreated(json.decode(data));
        Navigator.pop(Get.context);
        Navigator.pop(Get.context);
      }
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      isClicked.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
    }
  }

  createExpeditionOffer()async{
    print("Departure id?  "+ departureId.value.toString());
    print("Arrival id?  "+ arrivalId.value.toString());
    // print(travelCard['id'].toString() + name.value + email.value + phone.value + cityId.value.toString() + street.value);
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', !createUser.value ? Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.shipping?values={'
        '"shipping_departure_city_id": "${departureId.value}",'
        '"shipping_arrival_city_id": "${arrivalId.value}",'
        '"shipping_departure_date": "${departureDate.value}",'
        '"shipping_arrival_date": "${arrivalDate.value}",'
        '"receiver_partner_id": ${receiverId.value},'
        '"luggage_ids": $luggageId,'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}'
    ) : Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.shipping?values={'
        '"shipping_departure_city_id": "${departureId.value}",'
        '"shipping_arrival_city_id": "${arrivalId.value}",'
        '"shipping_departure_date": "${departureDate.value}",'
        '"shipping_arrival_date": "${arrivalDate.value}",'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"receiver_source": "manual",'
        '"luggage_ids": $luggageId,'
        '"receiver_name_set": "${name.value}",'
        '"receiver_email_set": "${email.value}",'
        '"receiver_phone_set": "${phone.value}",'
        '"register_receiver": "True",'
        '"receiver_city_id": ${cityId.value},'
        '"receiver_street_set": "${street.value}"'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print(data);
      if(!createUser.value){
        Future.delayed(Duration(seconds: 3),()async{
          Navigator.pop(Get.context);
          Navigator.pop(Get.context);
          Navigator.pop(Get.context);
          Get.find<BookingsController>().refreshBookings();
        });
        isClicked.value = false;
        buttonPressed.value = false;
        showDialog(
            context: Get.context, builder: (_){
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Lottie.asset("assets/img/successfully-done.json"),
          );
        });
      }else{
        await getRoadShippingCreated(json.decode(data));
        Navigator.pop(Get.context);
        Navigator.pop(Get.context);
      }
      Get.find<BookingsController>().offerExpedition.value = false;
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      isClicked.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
    }
  }

  createReceptionOffer()async{
    print('byeeeeeeeeeeeeeeeeeee');
    createUserReceptionOffer.value? await createShipper() : (){};

    print(parcel_reception_shipper_partner_id.value);
    // print(travelCard['id'].toString() + name.value + email.value + phone.value + cityId.value.toString() + street.value);
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST',  Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.shipping?values={'
        '"shipping_departure_city_id": "${departureId.value}",'
        '"shipping_arrival_city_id": "${arrivalId.value}",'
        '"shipping_departure_date": "${departureDate.value}",'
        '"bool_parcel_reception": true,'
        '"shipping_arrival_date": "${arrivalDate.value}",'
        '"parcel_reception_receiver_partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"luggage_ids": $luggageId,'
        '"parcel_reception_shipper": ${parcel_reception_shipper_partner_id.value}'
        '}'
    ));
    // '"partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
    //     '"receiver_partner_id": ${Get.find<MyAuthService>().myUser.value.id},'

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print(data);
      if(!createUser.value){
        Future.delayed(Duration(seconds: 3),()async{
          Navigator.pop(Get.context);
          Navigator.pop(Get.context);
          Navigator.pop(Get.context);
          Get.find<BookingsController>().refreshBookings();
        });
        isClicked.value = false;
        buttonPressed.value = false;
        showDialog(
            context: Get.context, builder: (_){
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Lottie.asset("assets/img/successfully-done.json"),
          );
        });
      }else{
        await getRoadShippingCreated(json.decode(data));
        Navigator.pop(Get.context);
        Navigator.pop(Get.context);
      }
      Get.find<BookingsController>().offerReception.value = false;
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      isClicked.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
    }
  }

  createShipper() async {

    Random random = Random();
    var _randomNumber = random.nextInt(9999);
    print(_randomNumber);

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST',Uri.parse('${Domain.serverPort}/create/res.users?values={ '
        '"name": "${name.value}",'
        '"login": "${email.value}",'
        '"image_1920": false,'
        '"email": "${email.value}",'
        '"phone": "${phone.value}",'
        '"verification_code": "$_randomNumber",'
        '"sel_groups_1_9_10": 10}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)  {
      var result = await response.stream.bytesToString();
      var data = json.decode(result);
      //await updatePartnerEmail(data[0], myUser.email);
      //await updatePartnerGender(data[0], myUser.sex);
      await getCreatedShipper(data[0]);



      return true;
    }
    else {
      print(response.reasonPhrase);
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      return false;
    }

  }

  getCreatedShipper(int id) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=c873276d5c50fb6ae61033f04ea7925668c9dec2'
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/api/v1/read/res.users?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      parcel_reception_shipper_partner_id.value = result[0]["partner_id"][0];
      print('parcel id is ${parcel_reception_shipper_partner_id.value}');
    }
    else {
      print(response.reasonPhrase);
    }


  }

  updateToPortalUser(int id) async {
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
      print(await response.stream.bytesToString());

    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  getRoadShippingCreated(var ids)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.shipping?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var result = json.decode(data)[0];
      var receiverPartnerId = result['bool_parcel_reception'] == false?result['receiver_partner_id'][0]:result['parcel_reception_receiver_partner_id'][0];
      //selectCameraOrGalleryProfileImage();
      if(profileImage != null && profileImage.path.isNotEmpty){
        uploadProfileImage(profileImage, receiverPartnerId);
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }
  getAirShippingCreated(var ids)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.shipping?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var result = json.decode(data)[0];
      shippingCreatedId = result['id'];
      print('Shipping created id is : $shippingCreatedId');
      var receiverPartnerId = result['receiver_partner_id'][0];
      //selectCameraOrGalleryProfileImage();
      if(profileImage != null && profileImage.path.isNotEmpty){
        uploadProfileImage(profileImage, receiverPartnerId);
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  uploadProfileImage(File file, int id) async {
    /*if (Get.find<MyAuthService>().myUser.value.email==null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }*/

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
      Future.delayed(Duration(seconds: 2),()async{
        Navigator.pop(Get.context);
        await Get.find<RootController>().changePage(1);
      });
      isClicked.value = false;
      buttonPressed.value = false;
      showDialog(
          context: Get.context, builder: (_){
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Lottie.asset("assets/img/successfully-done.json"),
        );
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  transferRoadTravelShipping()async{

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

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).transferSuccess.tr));
      await unMarkTravelerDisagree(transferBookingId.value);
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

  transferAirTravelShipping()async{

    final box = GetStorage();
    var session_id = box.read('session_id');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=a3ffbeb70a9e310852261c236548fc5735e96419'
    };

    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.shipping?values={'
        '"travelbooking_id": ${travelCard['id']},'
        '}&ids=${transferBookingId}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //print(data);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).transferSuccess.tr));
      //await unMarkTravelerDisagree(transferBookingId.value);
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

  unMarkTravelerDisagree(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=c2c7163b01bb30294bca4fb4a7119c00df2bd953'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m1st_hk_roadshipping.shipping/unmark_traveler_disagree/?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
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
      var compressedImage;
      XFile pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
      File imageFile = File(pickedFile.path);
      if(imageFile.lengthSync()>pow(1024, 2)){
        final tempDir = await getTemporaryDirectory();
        final path = tempDir.path;
        int rand = new Math.Random().nextInt(10000);
        Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
        compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));


      }
      else{

        compressedImage = File(pickedFile.path);

      }
      if(imageFiles.length<12)
      {
        if(imageFiles.length<6){
          internalImageFiles.add(compressedImage);
        }
        else{
          externalImageFiles.add(compressedImage);
        }
        imageFiles.add(compressedImage) ;
      }
      else
      {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).photoUploadLimitations.tr));
        throw new Exception(AppLocalizations.of(Get.context).photoUploadLimitations);
      }
    }
    else{
      var compressedImage;
      var i =0;
      var galleryFiles = await imagePicker.pickMultiImage();

      while(i<galleryFiles.length){
        File imageFile = File(galleryFiles[i].path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = new Math.Random().nextInt(10000);
          Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
          compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));


        }
        else{

          compressedImage = File(galleryFiles[i].path);

        }
        if(imageFiles.length<12)
        {
          if(imageFiles.length<6){
            internalImageFiles.add(compressedImage);
          }
          else{
            externalImageFiles.add(compressedImage);
          }
          imageFiles.add(compressedImage) ;
        }
        else
        {
          Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).photoUploadLimitations.tr));
          throw new Exception(AppLocalizations.of(Get.context).photoUploadLimitations);
        }
        i++;
      }
    }
  }

  createShippingLuggage()async{
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(Get.context).loadingData),
      duration: Duration(seconds: 2),
    ));
    print(" here ${weightText.text}");
    print(" hire ${luggageWeight.value}");

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.luggage?values={'
        '"average_height": ${double.parse(luggageHeight.value)},'
        '"average_weight": ${double.parse(luggageWeight.value)},'
        '"average_width": ${double.parse(luggageWidth.value)},'
        '"name": "${luggageDescription.value}",'
        '"luggage_model_id": ${luggageDto['id']}'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      luggageId.add(json.decode(data)[0]);
      formStep.value++;
      print("added id: $luggageId");
    }
    else {
      var data = await response.stream.bytesToString();
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.withOpacity(0.4),
        content: Text(AppLocalizations.of(Get.context).luggageCreationFailed),
        duration: Duration(seconds: 2),
      ));
      print(data);
    }
  }

  editRoadShipping(var shipping)async{

    if(!editLuggage.value){
      luggageId.value = shipping['luggage_ids'];
    }

    print('value: ${createUser.value}');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };


    var request = http.Request('PUT', !createUser.value ? Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"receiver_partner_id": ${receiverId.value},'
        '"receiver_source": "database",'
        '"luggage_ids": $luggageId,'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}&ids=${shipping['id']}'
    ) : Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"receiver_source": "manual",'
        '"luggage_ids": $luggageId,'
        '"receiver_name_set": "${name.value}",'
        '"receiver_email_set": "${email.value}",'
        '"receiver_phone_set": "${phone.value}",'
        '"register_receiver": "True",'
        '"receiver_city_id": ${cityId.value},'
        '"receiver_street_set": "${street.value}"'
        '}&ids=${shipping['id']}'
    ));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      await getRoadShippingCreated(json.decode(data));
      Future.delayed(Duration(seconds: 3),()async{
        Navigator.pop(Get.context);
        await Get.find<RootController>().changePage(1);
      });
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).shippingUpdated.tr));
      imageFiles.clear();
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }

  editExpeditionOffer(var shipping)async{

    if(!editLuggage.value){
      luggageId.value = shipping['luggage_ids'];
    }

    print('value: ${departureId.value}');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('PUT', !createUser.value ? Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"shipping_departure_city_id": "${departureId.value}",'
        '"shipping_arrival_city_id": "${arrivalId.value}",'
        '"shipping_departure_date": "${departureDate.value}",'
        '"shipping_arrival_date": "${arrivalDate.value}",'
        '"receiver_partner_id": ${receiverId.value},'
        '"luggage_ids": $luggageId,'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}&ids=${shipping['id']}'
    ) : Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"shipping_departure_city_id": "${departureId.value}",'
        '"shipping_arrival_city_id": "${arrivalId.value}",'
        '"shipping_departure_date": "${departureDate.value}",'
        '"shipping_arrival_date": "${arrivalDate.value}",'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"receiver_source": "manual",'
        '"luggage_ids": $luggageId,'
        '"receiver_name_set": "${name.value}",'
        '"receiver_email_set": "${email.value}",'
        '"receiver_phone_set": "${phone.value}",'
        '"register_receiver": "True",'
        '"receiver_city_id": ${cityId.value},'
        '"receiver_street_set": "${street.value}"'
        '}&ids=${shipping['id']}'
    ));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      await getRoadShippingCreated(json.decode(data));
      Future.delayed(Duration(seconds: 3),()async{
        Navigator.pop(Get.context);
        Navigator.pop(Get.context);
        await Get.find<RootController>().changePage(1);
      });
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).shippingUpdated.tr));
      imageFiles.clear();
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }

  editReceptionOffer(var shipping)async{

    if(!editLuggage.value){
      luggageId.value = shipping['luggage_ids'];
    }
    if(!editShipper.value){
      parcel_reception_shipper_partner_id.value = shipping['receiver_partner_id'][0];
    }
    else{
      createUserReceptionOffer.value? createShipper() : (){};
    }

    print('value: ${departureId.value}');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.shipping?values={'
        '"shipping_departure_city_id": "${departureId.value}",'
        '"shipping_arrival_city_id": "${arrivalId.value}",'
        '"shipping_departure_date": "${departureDate.value}",'
        '"shipping_arrival_date": "${arrivalDate.value}",'
        '"luggage_ids": $luggageId,'
        '"parcel_reception_receiver_partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"parcel_reception_shipper": ${parcel_reception_shipper_partner_id.value}'
        '}&ids=${shipping['id']}'
    ));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      await getRoadShippingCreated(json.decode(data));
      Future.delayed(Duration(seconds: 3),()async{
        Navigator.pop(Get.context);
        Navigator.pop(Get.context);
        await Get.find<RootController>().changePage(1);
      });
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).shippingUpdated.tr));
      imageFiles.clear();
      editing.value = false;
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
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
      formStep.value--;
      print(data);
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  sendRoadImages(int a, var imageFil)async{
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

    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text("Loading data..."),
      duration: Duration(seconds: 3),
    ));

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
      if(editing.value){
        luggageModels.value = json.decode(data);
        print(shipping);
        getLuggage(shipping['luggage_ids']);
      }
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getLuggage(var ids) async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.luggage?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      //shippingLoading.value = false;
      shippingLuggage.value = json.decode(data);
      print('luggage: $shippingLuggage');

      List models = [];
      for(var i in luggageModels){
        for(var a in shippingLuggage){
          if(i['id'] == a["luggage_model_id"][0]){
            models.add(i);
          }
        }
      }
      luggageSelected.value = models;
      print('luggage selected: $luggageSelected');
      luggageDto.value = luggageSelected[0];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  chooseBirthDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

      context: Get.context,

      imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
      height: MediaQuery.of(Get.context).size.height*0.5,
      initialDate: DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleYearButton: TextStyle(
            fontSize: 52,
            color: Colors.white,
          )
      ),
      borderRadius: 16,
      //selectableDayPredicate: disableDate
    );
    if (pickedDate != null && pickedDate != birthDate.value) {
      if(DateTime.now().year-pickedDate.year >= 16){
        birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
        user.value.birthday = DateFormat('yyyy-MM-dd').format(pickedDate);
        // birthDateSet.value = true;
      }
      else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'You must be at least 16 years old to use HubColis'));
      }
    }
  }


  void updateProfile() async {
    user.value.street = residentialAddressId.value.toString();
    user.value.birthplace = birthCityId.value.toString();
    await updatePartner(user.value);
    user.value = await _userRepository.get(user.value.id);
    Get.find<MyAuthService>().myUser.value = user.value;
    Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).profileUpdated.tr));

  }

  updatePartner(MyUser myUser) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.partner?ids=${myUser.id}&values={'
        '"birth_city_id": "${myUser.birthplace}",'
        '"residence_city_id": "${myUser.street}",'
        '"gender": "${myUser.sex}",'
        '"birthdate":"${myUser.birthday}"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print(myUser.birthplace);
      print(myUser.street);

    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  Future getAllUsers()async{

    var headers = {
      'api-key': Domain.apiKey
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort2}/res.users/search'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data)['data'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getUser(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      getUserRating(json.decode(data)[0]['given_rating_ids']);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getUserRating(var ids)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner.rating?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      viewRatings.value = true;
      ratings.value = json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getAllBeneficiaries(int id)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data)[0];
      var list= travelCard['booking_type'] == 'road'?result['receiver_partner_ids']:result['air_receiver_partner_ids'];
      var listUser = await getUsersInAddressBook(list);
      loadingBeneficiaries.value = false;
      return listUser;

    }
    else {
      print(response.reasonPhrase);
      return [];
    }
  }

  getUsersInAddressBook(List list)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=$list'));

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

  selectCameraOrGalleryProfileImage(){
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
                      title: Text(AppLocalizations.of(Get.context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('gallery');
                        //Navigator.pop(Get.context);
                        loadProfileImage.value = !loadProfileImage.value;
                      },
                      leading: Icon(FontAwesomeIcons.image),
                      title: Text(AppLocalizations.of(Get.context).uploadImage, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
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
        var imageFile = File(pickedImage.path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = new Math.Random().nextInt(10000);
          Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
          var compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));
          print('Lenght'+compressedImage.lengthSync().toString());
          profileImage = compressedImage;

        }
        else{
          profileImage = File(pickedImage.path);

        }
        Navigator.of(Get.context).pop();
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;//Navigator.of(Get.context).pop();
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        var imageFile = File(pickedImage.path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = new Math.Random().nextInt(10000);
          Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
          var compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));
          print('Lenght'+compressedImage.lengthSync().toString());
          profileImage = compressedImage;

        }
        else{
          profileImage = File(pickedImage.path);

        }
        Navigator.of(Get.context).pop();
      }
    }
  }

  chooseDepartureDate() async {
    DateTime pickedDate = await showRoundedDatePicker(
        context: Get.context,
        theme: ThemeData.light().copyWith(
            primaryColor: buttonColor
        ),
        height: Get.height/2,
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
        selectableDayPredicate: disableDepartureDate
    );
    String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
    if (formattedDate.isNotEmpty) {
      departureDate.value = pickedDate.toString();
      TimeOfDay selectedTime = await showTimePicker(
        context: Get.context,
        initialTime: TimeOfDay.now(),
      );
      departureDate.value = "$formattedDate ${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}:00";

    }
    print(departureDate.value);
  }

  chooseArrivalDate() async {
    DateTime pickedDate = await showRoundedDatePicker(
        context: Get.context,
        theme: ThemeData.light().copyWith(
            primaryColor: buttonColor
        ),
        height: Get.height/2,
        initialDate: DateTime.parse(departureDate.value),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 10),
        styleDatePicker: MaterialRoundedDatePickerStyle(
            textStyleYearButton: TextStyle(
              fontSize: 52,
              color: Colors.white,
            )
        ),
        borderRadius: 16,
        selectableDayPredicate: disableArrivalDate
    );
    String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
    if (formattedDate.isNotEmpty) {
      arrivalDate.value = pickedDate.toString();
      TimeOfDay selectedTime = await showTimePicker(
        context: Get.context,
        initialTime: TimeOfDay.now(),
      );
      arrivalDate.value = "$formattedDate ${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}:00";
      print(arrivalDate.value);
    }
  }

  bool disableDepartureDate(DateTime day) {
    if ((day.isAfter(DateTime.now().add(Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  bool disableArrivalDate(DateTime day) {
    if ((day.isAfter(DateTime.parse(departureDate.value).subtract(Duration(days: 1))))) {
      return true;
    }
    return false;
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
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
      return [];
    }


  }


  createAirLuggage()async{
    for(var item in selectedPackages){
      if(item.luggageType=='KILO'){


        var headers = {
          'Accept': 'application/json',
          'Authorization': Domain.authorization
        };
        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.luggage?values={"luggage_model_id": ${item.luggageId},"average_weight":${item.kilosWeight},"average_height":${item.kilosHeight},"average_width":${item.kilosWidth},"average_length":${item.kilosLength},"name": "${item.kilosDescription}"}'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          luggageId.add(result[0]);
          print(' data 3 is is :$result');
          for(var a=1; a<13; a++){
            await sendAirImages(a, item.imageFiles[a-1], result[0]);

          }

          airLuggageCreated.value = true;

        }
        else {
          print(response.reasonPhrase);
        }


      } else if(item.luggageType=='ENVELOP'){
        var headers = {
          'Accept': 'application/json',
          'Authorization': Domain.authorization
        };
        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.luggage?values={"luggage_model_id": ${item.luggageId},"envelop_formate":"${item.envelopFormat}","name": "${item.envelopDescription}"}'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          luggageId.add(result[0]);
          print(' data 3 is is :$result');
          for(var a=1; a<13; a++){
            await sendAirImages(a, item.imageFiles[a-1], result[0]);
          }
          airLuggageCreated.value = true;

        }
        else {
          print(response.reasonPhrase);
        }

      }
      else if(item.luggageType=='COMPUTER'){

        var headers = {
          'Accept': 'application/json',
          'Authorization': Domain.authorization
        };
        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.luggage?values={"luggage_model_id": ${item.luggageId},"average_weight":${item.computerWeight},"average_height":${item.computerHeight},"average_width":${item.computerWidth},"average_length":${item.computerLength},"name": "${item.computerDescription}"}'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          luggageId.add(result[0]);
          print(' data 3 is is :$result');
          for(var a=1; a<13; a++){
            await sendAirImages(a, item.imageFiles[a-1], result[0]);
          }
          airLuggageCreated.value = true;

        }
        else {
          print(response.reasonPhrase);
        }

      }
      else {
        var headers = {
          'Accept': 'application/json',
          'Authorization': Domain.authorization
        };
        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.luggage?values={"luggage_model_id": ${item.luggageId},"average_weight":${item.otherWeight},"average_height":${item.otherHeight},"average_width":${item.otherWidth},"average_length":${item.otherLength},"name": "${item.otherDescription}"}'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          luggageId.add(result[0]);
          print(' data 3 is is :$result');
          for(var a=1; a<13; a++){
            await sendAirImages(a, item.imageFiles[a-1], result[0]);
          }
          airLuggageCreated.value = true;

        }
        else {
          print(response.reasonPhrase);
        }



      }

    }

  }

  updateAirLuggage()async{
    for(var item in airShippingLuggageToEdit){
      if(item.luggageType=='KILO'){


        var headers = {
          'Accept': 'application/json',
          'Authorization': Domain.authorization
        };

        var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.luggage?ids=${item.luggageId}&values={"average_weight":${item.kilosWeight},"average_height":${item.kilosHeight},"average_width":${item.kilosWidth},"average_length":${item.kilosLength},"name": "${item.kilosDescription}"}'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          luggageId.add(result[0]);
          print(' data 3 is is :$result');
          for(var a=1; a<13; a++){
            await sendAirImages(a, item.imageFiles[a-1], result[0]);

          }

          print('air luggage updated');

          airLuggageCreated.value = true;

        }
        else {
          print(response.reasonPhrase);
        }


      }

      if(item.luggageType=='ENVELOP'){
        var headers = {
          'Accept': 'application/json',
          'Authorization': Domain.authorization
        };
        var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.luggage?ids=${item.luggageId}&values={"envelop_formate":"${item.envelopFormat}","name": "${item.envelopDescription}"}'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          luggageId.add(result[0]);
          print(' data 3 is is :$result');
          for(var a=1; a<13; a++){
            await sendAirImages(a, item.imageFiles[a-1], result[0]);
          }
          airLuggageCreated.value = true;
          print('air luggage updated');

        }
        else {
          print(response.reasonPhrase);
        }

      }


      if(item.luggageType=='COMPUTER'){

        var headers = {
          'Accept': 'application/json',
          'Authorization': Domain.authorization
        };
        var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.luggage?ids=${item.luggageId}&values={"average_weight":${item.computerWeight},"average_height":${item.computerHeight},"average_width":${item.computerWidth},"average_length":${item.computerLength},"name": "${item.computerDescription}"}'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          luggageId.add(result[0]);
          print(' data 3 is is :$result');
          for(var a=1; a<13; a++){
            await sendAirImages(a, item.imageFiles[a-1], result[0]);
          }
          airLuggageCreated.value = true;
          print('air luggage updated');

        }
        else {
          print(response.reasonPhrase);
        }


      }

    }

  }



  sendAirImages(int a, var imageFil, airLuggageId)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/m2st_hk_airshipping.luggage/$airLuggageId/luggage_image$a'));
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

  getSpecificAirShippingLuggages(List luggageIds)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m2st_hk_airshipping.luggage?ids=$luggageIds'));

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

  getEnvelopLuggageModel()async{
    var headers = {
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d3e7e105eca6906b76634c0c92e2358de33dc7c6'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m2st_hk_airshipping.luggage'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();

      var result = json.decode(data);
      List list =[];
      for(var item in result){
        if(item['envelop_formate'].toString() != 'false'){
          list.add(item);
        }
      }
      isEnvelopLuggageModelLoaded.value = true;
      return list;
    }
    else {
      print(response.reasonPhrase);
    }


  }

  shipAirNow()async{
    professionalTransporter.value?await updateVatNumber():(){};
    print("create user?  "+ createUser.value.toString());
    print(travelCard['id'].toString() + name.value + email.value + phone.value + cityId.value.toString() + street.value);
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', !createUser.value ? Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.shipping?values={'
        '"travelbooking_id": ${travelCard['id']},'
        '"receiver_partner_id": ${receiverId.value},'
        '"receiver_source": "database",'
        '"luggage_ids": $luggageId,'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}'
    ) : Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.shipping?values={'
        '"travelbooking_id": ${travelCard['id']},'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"receiver_source": "manual",'
        '"luggage_ids": $luggageId,'
        '"receiver_name_set": "${name.value}",'
        '"receiver_email_set": "${email.value}",'
        '"receiver_phone_set": "${phone.value}",'
        '"register_receiver": "True",'
        '"receiver_city_id": ${cityId.value},'
        '"receiver_street_set": "${street.value}"'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print(data);
      if(!createUser.value){
        await getAirShippingCreated(json.decode(data));
        if(shippingCreatedId != null){
          await payAirShipping(shippingCreatedId);
          await Get.find<BookingsController>().getAirShipping(shippingCreatedId);
        }
        isClicked.value = false;
        buttonPressed.value = false;
        Future.delayed(Duration(seconds: 5),()async{
          Get.find<BookingsController>().refreshBookings();
        });
        // showDialog(
        //     context: Get.context, builder: (_){
        //   return ClipRRect(
        //     borderRadius: BorderRadius.all(Radius.circular(10)),
        //     child: Lottie.asset("assets/img/successfully-done.json"),
        //   );
        // });
      }else{
        await getAirShippingCreated(json.decode(data));
        if(shippingCreatedId != null){
          await payAirShipping(shippingCreatedId);
          Get.find<BookingsController>().getAirShipping(shippingCreatedId);
        }
        // Navigator.pop(Get.context);
        // Navigator.pop(Get.context);
      }
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      isClicked.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
    }
  }

  editAirShipping(var shipping)async{

    print('value: ${createUser.value}');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('PUT', !createUser.value ? Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.shipping?values={'
        '"receiver_partner_id": ${receiverId.value},'
        '"receiver_source": "database",'
        '"luggage_ids": $luggageId,'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}&ids=${shipping['id']}'
    ) : Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.shipping?values={'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id},'
        '"receiver_source": "manual",'
        '"luggage_ids": $luggageId,'
        '"receiver_name_set": "${name.value}",'
        '"receiver_email_set": "${email.value}",'
        '"receiver_phone_set": "${phone.value}",'
        '"register_receiver": "True",'
        '"receiver_city_id": ${cityId.value},'
        '"receiver_street_set": "${street.value}"'
        '}&ids=${shipping['id']}'
    ));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      await getAirShippingCreated(json.decode(data));
      Future.delayed(Duration(seconds: 3),()async{
        Navigator.pop(Get.context);
        await Get.find<RootController>().changePage(1);
      });
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).shippingUpdated.tr));
      imageFiles.clear();
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message'].tr));
    }
  }


  payAirShipping(int shipping_id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/m2st_hk_airshipping.shipping/pay_shipping/?ids=$shipping_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }






}



