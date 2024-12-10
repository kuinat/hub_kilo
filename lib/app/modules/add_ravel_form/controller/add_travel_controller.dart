import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
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
import '../../../models/media_model.dart';
import '../../../models/my_user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

import '../../userTravels/controllers/user_travels_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;


class AddTravelController extends GetxController{

  var travel_booking_id = 0.obs;
  var avatar = new Media().obs;
  final isDone = false.obs;
  var departureDate = DateTime.now().add(Duration(days: 2)).toString().toString().split(".").first.obs;
  var arrivalDate = DateTime.now().add(Duration(days: 3)).toString().toString().split(".").first.toString().obs;
  var departureId = 0.obs;
  var arrivalId = 0.obs;
  var restriction = ''.obs;
  var kilosQuantity = 0.0.obs;
  var kilosPrice = 0.0.obs;
  var envelopQuantity = 0.0.obs;
  var envelopPrice = 0.0.obs;
  var computerQuantity = 0.0.obs;
  var computerPrice = 0.0.obs;
  var canBargain = false.obs;
  var professionalTransporter = false.obs;
  var predict1 = false.obs;
  var predict2 = false.obs;
  var townEdit = false.obs;
  var town2Edit = false.obs;
  var travelType = "road".obs;
  var vatNumber = "".obs;
  var showButton = false.obs;
  var errorCity1 = false.obs;
  File covidTest;
  var countries = [].obs;
  var listCountriesOnly = [].obs;
  var listStates = [].obs;
  var countriesOnly = [].obs;
  var states = [].obs;
  var airLuggageModelList = [].obs;
  var airLuggageModelLoaded = false.obs;
  var list = [];
  var listBanks = [];
  var listUserAccounts = [];
  var loadCovidTest = false.obs;
  var loadTicket = false.obs;
  File ticket;
  final travelCard = {}.obs;
  var travelTypeSelected = false.obs;
  var buttonPressed = false.obs;
  var ticketUpload = false.obs;
  GlobalKey<FormState> newTravelKey;
  ScrollController scrollController = ScrollController();
  final formStepRoad = 0.obs;
  final formStepAir = 0.obs;
  TextEditingController depTown = TextEditingController();
  TextEditingController arrTown = TextEditingController();
  final user = new MyUser().obs;
  var url = ''.obs;
  TextEditingController birthPlaceTown = TextEditingController();
  TextEditingController residentialTown = TextEditingController();
  //final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  final updatePassword = false.obs;
  final deleteUser = false.obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final userName = "".obs;
  final email = "".obs;
  final gender = "".obs;
  var editNumber = false.obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  //final buttonPressed = false.obs;
  var birthDate = ''.obs;
  final birthPlace = "".obs;
  final allBanks = [].obs;
  final allAccountNumbers = [].obs;
  final residence = "".obs;
  final phone = "".obs;
  var selectedGender = "".obs;
  final editPlaceOfBirth = false.obs;
  final editResidentialAddress= false.obs;
  var birthDateSet = false.obs;
  var isIdentityFileConform = false.obs;
  var isIdentityFileUnderAnalysis = false.obs;

  var loadAttachments = true.obs;
  final identityPieceSelected = ''.obs;
  final userRatings = 0.0.obs;
  var language = ''.obs;
  var stepperValue = 0.obs;
  var enveloppeChecked = false.obs;
  var kilosChecked = false.obs;
  var computerChecked = false.obs;
  var luggageChecked = false.obs;
  var luggagesInfo = [];
  var quantityInfo = 0.0;
  var priceInfo = 0.0;
  var uploadTicket = false.obs;
  var uploadCovidTest = false.obs;

  File identificationFile;

  var activeStep = 5.obs; // Initial step set to 5.

  var upperBound = 6.obs;

  var edit = false.obs;
  //File identificationFilePhoto;

  var genderList = [
    AppLocalizations.of(Get.context).gender.tr,
    AppLocalizations.of(Get.context).male.tr,
    AppLocalizations.of(Get.context).female.tr
  ].obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  var dateOfDelivery = DateTime.now().add(Duration(days: 2)).toString().obs;
  var dateOfExpiration = DateTime.now().add(Duration(days: 3)).toString().obs;


  final _picker = ImagePicker();
  File image;
  //UploadRepository _uploadRepository;
  var currentState = 0.obs;
  var loadImage = false.obs;
  var currentUser = Get.find<MyAuthService>().myUser;

  var birthCityId = 0.obs;
  var residentialAddressId = 0.obs;
  var listAttachment = [];
  var attachmentFiles = [].obs;
  var view = false.obs;
  var editing = false.obs;

  var predict1Profile = false.obs;
  var predict2Profile = false.obs;
  var errorCity1Profile = false.obs;

  var predictBank = false.obs;
  var bankFound = false.obs;
  var bankAccountNumberFound = true.obs;
  var showBankAccountSearchField = true.obs;
  var bankAccountAdded = false.obs;
  var bankSelected = false.obs;
  var bankAccountNumberSelected = false.obs;
  var selectedBankAccountIndex = 1000.obs;
  final enableBankFields = false.obs;
  //var predict2Profile = false.obs;
  var errorBank = false.obs;
  var addBankAccountPressed = false.obs;
  var bankId = 0.obs;
  final bankBic = "".obs;
  final bankName = "".obs;
  final bankAccountNumber = "".obs;


  var predictBankAccountNumber = false.obs;
  //var predict2Profile = false.obs;
  var errorBankAccountNumber = false.obs;

  TextEditingController  ibanCode = TextEditingController();

  TextEditingController  bankIdentifierCode = TextEditingController();


  var travelerPickUpCityId = 0.obs;
  var travelerPickUpCountryId = 0.obs;
  var travelerPickUpStateId = 0.obs;

  var predictPickUpCity = false.obs;
  var errorPickUpCity = false.obs;
  final pickUpCity = "".obs;
  TextEditingController  travelerPickUpCity = TextEditingController();


  var predictPickUpState = false.obs;
  var errorPickUpState = false.obs;
  final pickUpState = "".obs;
  TextEditingController  travelerPickUpState = TextEditingController();

  var predictPickUpCountry = false.obs;
  var errorPickUpCountry = false.obs;
  final pickUpCountry = "".obs;
  TextEditingController  travelerPickUpCountry = TextEditingController();

  final pickUpStreet = "".obs;
  //final pickUpCity = "".obs;

  var selectedPackages = [].obs;
  //File passport;
  //var countries = [].obs;
  // var list = [];

  @override
  void onInit() async {

    _userRepository = UserRepository();
    user.value.vat.toString() == 'false'?vatNumber.value = "": vatNumber.value = user.value.vat;
    var languageBox = await GetStorage();
    language.value = languageBox.read('language');
    user.value = Get.find<MyAuthService>().myUser.value;
    birthDate.value = user.value.birthday;
    birthPlace.value = user.value.birthplace;
    residence.value =user.value.street;
    print(user.value.birthday);
    print(user.value.birthplace);
    print(user.value.street);
    print(user.value.sex);


    final box = GetStorage();
    list = box.read("allCountries");
    listCountriesOnly.value = box.read("allCountriesOnly");
    countries.value = list;
    countriesOnly.value = listCountriesOnly;
    listStates.value = box.read("states");
    states.value = listStates;
    print(allAccountNumbers.length);

    listBanks = await getAllBanks();
    listUserAccounts = await getAllUserAccounts();

    allBanks.value = listBanks;
    allAccountNumbers.value = listUserAccounts;



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

        if(travelCard['booking_type'] == 'air'){
          pickUpStreet.value = travelCard['street'];
          travelerPickUpCityId.value =travelCard['city'][0];
          travelerPickUpCity.text = travelCard['city'][1];
          travelerPickUpCountryId.value = travelCard['country_id'][0];
          travelerPickUpCountry.text = travelCard['country_id'][1];
          travelerPickUpStateId.value = travelCard['state_id'][0];
          travelerPickUpState.text = travelCard['state_id'][1];

          var specificAirTravelLuggage = await getSpecificAirTravelLuggages(travelCard['luggage_types']);

          airLuggageModelList.value = await getAllAirLuggageModels();
          print('air luggage list is: $airLuggageModelList');



          for(var item in specificAirTravelLuggage){
            if(item['luggage_type_id'][1]=='KILO'){
              kilosChecked.value = !kilosChecked.value;
              if(kilosChecked.value){
                selectedPackages.add(item);
                kilosQuantity.value = item['quantity'];
                kilosPrice.value = item['price'];
                print('Selected Packages are: ${item}');
              }


            }
            if(item['luggage_type_id'][1]=='ENVELOP'){
              enveloppeChecked.value = !enveloppeChecked.value;
              if(enveloppeChecked.value){
                selectedPackages.add(item);
                envelopPrice.value = item['price'];
                print('Selected Packages are: ${item}');
              }

            }
            if(item['luggage_type_id'][1]=='COMPUTER'){
              computerChecked.value = !computerChecked.value;
              if(computerChecked.value){
                selectedPackages.add(item);
                computerPrice.value = item['price'];
                print('Selected Packages are: ${item}');
              }
            }
          }
        }
      }
    }
    else{
      airLuggageModelList.value = await getAllAirLuggageModels();
      print('air luggage list is: $airLuggageModelList');
    }


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

  void filterSearchBankAccount(String query) {
    List dummySearchList = [];
    dummySearchList = listUserAccounts;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      allAccountNumbers.value = dummyListData;

      if(allAccountNumbers.isEmpty){
        bankAccountNumberFound.value = false;
      }
      else{
        bankAccountNumberFound.value = true;
      }

      return;
    } else {
      allAccountNumbers.value = listUserAccounts;
      // bankBic.value = bankIdentifierCode.text;
      // bankId.value = 0;



    }
  }

  void filterSearchResultsCountriesOnly(String query) {
    List dummySearchList = [];
    dummySearchList = listCountriesOnly;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      countriesOnly.value = dummyListData;
      for(var i in countriesOnly){
        print(i['display_name']);
      }
      return;
    } else {
      countriesOnly.value = listCountriesOnly;
    }
  }

  void filterSearchResultsStates(String query) {
    List dummySearchList = [];
    dummySearchList = listStates;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      states.value = dummyListData;
      for(var i in states){
        print(i['display_name']);
      }
      return;
    } else {
      states.value = listStates;
    }
  }

  //final _picker = ImagePicker();

  covidTestPicker(String source) async {
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
          covidTest = compressedImage;
          loadCovidTest.value = !loadCovidTest.value;

        }
        else{
          covidTest = File(pickedImage.path);
          loadCovidTest.value = !loadCovidTest.value;

        }


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
          covidTest = compressedImage;
          loadCovidTest.value = !loadCovidTest.value;

        }
        else{
          covidTest = File(pickedImage.path);
          loadCovidTest.value = !loadCovidTest.value;

        }
      }

    }

  }

  ticketPicker(String source) async {
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
          ticket = compressedImage;
          loadTicket.value = !loadTicket.value;

        }
        else{
          ticket = File(pickedImage.path);
          loadTicket.value = !loadTicket.value;

        }
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
          ticket = compressedImage;
          loadTicket.value = !loadTicket.value;

        }
        else{
          ticket = File(pickedImage.path);
          loadTicket.value = !loadTicket.value;

        }
      }

    }

  }

  selectCameraOrGallery()async{
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
                      onTap: uploadTicket.value?()async{
                        await ticketPicker('camera');
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;

                      }:uploadCovidTest.value?
                          ()async{
                        await covidTestPicker('camera');
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;

                      }:
                          (){},
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text(AppLocalizations.of(Get.context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: uploadTicket.value?()async{
                        await ticketPicker('gallery');
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;
                      }: uploadCovidTest.value?()async{
                        await covidTestPicker('gallery');
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;
                      }:(){},
                      leading: Icon(FontAwesomeIcons.image),
                      title: Text(AppLocalizations.of(Get.context).uploadImage, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    )
                  ],
                )
            ),
          );
        });
  }

  backToHome()async{
    await Get.find<RootController>().changePage(0);
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

  createRoadTravel()async{
    professionalTransporter.value?await updateVatNumber():(){};
    final box = GetStorage();
    var session_id = box.read('session_id');

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m1st_hk_roadshipping.travelbooking?values='
        '{"name": "New_Travel/${DateFormat("yyyy/MM/dd").format(DateTime.now())}",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}",'
        '"bank_account": "${bankAccountNumber.value}",'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("travel response: ${json.decode(data)}");
      Future.delayed(Duration(seconds: 3),()async{
        Navigator.pop(Get.context);
        Navigator.pop(Get.context);
        Get.delete<AddTravelController>();
        travel_booking_id.value = json.decode(data)[0];
        Get.find<UserTravelsController>().refreshMyTravels();
      });
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
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred! Please make sure you don't have a travel in published state or verify your information and try again".tr));
      buttonPressed.value = false;
      print("Error response: ${json.decode(data)['message']}");
    }
  }

  updateRoadTravel()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7884fbe019046ffc1379f17c73f57a9e344a6d8a'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m1st_hk_roadshipping.travelbooking?values={'
        '"name": "Update_Travel/${DateFormat("yyyy/MM/dd").format(DateTime.now())}",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}"'
        '"bank_account": "${bankAccountNumber.value}",'
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
      Get.delete<AddTravelController>();

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      throw new Exception(response.reasonPhrase);
    }
  }

  chooseBirthDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

      context: Get.context,
      theme: ThemeData.light().copyWith(
          primaryColor: buttonColor
      ),
      height: Get.height/2,
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
        //birthDateSet.value = true;
      }
      else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'You must be at least 16 years old to use HubColis'));
      }

    }
  }

  void updateProfile() async {
    _userRepository = new UserRepository();
    user.value.street = residentialAddressId.value.toString();
    user.value.birthplace = birthCityId.value.toString();
    await updatePartner(user.value);
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
      print('Profile updated');
      user.value = await _userRepository.get(user.value.id);
      Get.find<MyAuthService>().myUser.value = user.value;
    }
    else {
      buttonPressed.value = false;
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
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

  @override
  void onClose() {
    //chatTextController.dispose();
  }
  @override
  void dispose() {
    //
    super.dispose();


    //chatTextController.dispose();
  }


  createBankAccount()async{
    addBankAccountPressed.value = true;
    if(enableBankFields.value){
      await createBank();
    }

    print({bankId.value});
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d3e7e105eca6906b76634c0c92e2358de33dc7c6'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/res.partner.bank?values={'
        '"partner_id":${user.value.id},'
        '"bank_id": ${bankId.value},'
        '"acc_number":"$bankAccountNumber"}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      user.value = await _userRepository.get(user.value.id);
      Get.find<MyAuthService>().myUser.value = user.value;
      listUserAccounts = await getAllUserAccounts();
      allAccountNumbers.value = listUserAccounts;
      addBankAccountPressed.value = false;
    }
    else {
      print(response.reasonPhrase);
    }



  }

  getAllBanks()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/res.bank'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('All Banks: ${json.decode(data)}');
      if(json.decode(data) != null){
        return json.decode(data);
      }
      else{
        return [];

      }

    }
    else {
      print(response.reasonPhrase);
      return [];
    }


  }

  getAllUserAccounts()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d3e7e105eca6906b76634c0c92e2358de33dc7c6'
    };

    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner.bank?ids=${user.value.bankIds}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('User Accounts: ${json.decode(data)}');
      if(json.decode(data) != null){
        return json.decode(data);
      }
      else{
        return [];

      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  createBank() async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d3e7e105eca6906b76634c0c92e2358de33dc7c6'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/res.bank?values={'
        '"name": "$bankName",'
        '"bic": "$bankBic"}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      bankId.value = result[0];
      listBanks = await getAllBanks();
      allBanks.value = listBanks;
      //await createBankAccount(result[0]);
    }
    else {
      print(response.reasonPhrase);
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
      if(json.decode(data) != null){
        return json.decode(data);
      }
      else{
        return [];

      }

    }
    else {
      print(response.reasonPhrase);
      return [];
    }


  }

  getAllAirLuggageModels()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/m2st_hk_airshipping.luggage.type'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      var result =  json.decode(data);
      airLuggageModelLoaded.value = true;
      return result;
    }
    else {
      return [];
      print(response.reasonPhrase);
    }


  }

  createAirLuggage(int id)async{
    for(int i = 0; i< selectedPackages.length; i++){
      if(selectedPackages[i]['display_name']=='KILO'){
        var headers = {

          'Authorization': Domain.authorization
        };

        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.flight.luggage?values={'
            '"luggage_type_id":${selectedPackages[i]['id']},'
            '"flight_announcement_id":$id,'
            '"price": ${luggagesInfo[i][2]},'
            '"quantity": ${luggagesInfo[i][1]}}'));


        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          print(' data 3 is is :$result');

        }
        else {
          print(response.reasonPhrase);
        }
      }else if(selectedPackages[i]['display_name']=='ENVELOP'){
        var headers = {

          'Authorization': Domain.authorization
        };

        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.flight.luggage?values={'
            '"luggage_type_id":${selectedPackages[i]['id']},'
            '"flight_announcement_id":$id,'
            '"price": ${luggagesInfo[i][2]},'
            '"quantity": ${luggagesInfo[i][1]}}'));


        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          print(' data 3 is is :$result');
        }
        else {
          print(response.reasonPhrase);
        }
      }else if(selectedPackages[i]['display_name']=='COMPUTER'){
        var headers = {

          'Authorization': Domain.authorization
        };

        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.flight.luggage?values={'
            '"luggage_type_id":${selectedPackages[i]['id']},'
            '"flight_announcement_id":$id,'
            '"price": ${luggagesInfo[i][2]},'
            '"quantity": ${luggagesInfo[i][1]}}'));


        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          print(' data 3 is is :$result');
        }
        else {
          print(response.reasonPhrase);
        }
      } else{
        var headers = {

          'Authorization': Domain.authorization
        };

        var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.flight.luggage?values={'
            '"luggage_type_id":${selectedPackages[i]['id']},'
            '"flight_announcement_id":$id,'
            '"price": ${luggagesInfo[i][2]},'
            '"quantity": ${luggagesInfo[i][1]}}'));


        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = await response.stream.bytesToString();
          var result =  json.decode(data);
          print(' data 3 is is :$result');
        }
        else {
          print(response.reasonPhrase);
        }


      }

    }



  }

  uploadPlaneDocument(int id)async{
    await uploadTicketDocument(id);
    await uploadCovidTestDocument(id);

  }

  createAttachment(int id) async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.traveler.verification?values={'
        '"flight_announcement_id":$id,'
        '"date": "2023-07-30"}'));



    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('data'+data);
      var result = json.decode(data);
      //Get.showSnackbar(Ui.SuccessSnackBar(message: "Identity File successfully updated ".tr));
      await uploadPlaneDocument(result[0] );
    }
    else {
      buttonPressed.value = false;
      var data = await response.stream.bytesToString();
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text(json.decode(data)['message']),
          backgroundColor: specialColor.withOpacity(0.4),
          duration: Duration(seconds: 2)));
    }
  }

  uploadTicketDocument(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/m2st_hk_airshipping.traveler.verification/$id/flight_ticket'));
    request.files.add(await http.MultipartFile.fromPath('ufile', ticket.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(' data 1 is $data');
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }

  }

  uploadCovidTestDocument(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/m2st_hk_airshipping.traveler.verification/$id/covid_test_proof'));
    request.files.add(await http.MultipartFile.fromPath('ufile', covidTest.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(' data 2 is $data');
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }

  }


  createAirTravel()async{
    professionalTransporter.value?await updateVatNumber():(){};
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = travelerPickUpStateId.value != 0?http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.travelbooking?values='
        '{"name": "New_Travel/${DateFormat("yyyy/MM/dd").format(DateTime.now())}",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}",'
        '"street": "${pickUpStreet.value}",'
        '"city": "${travelerPickUpCityId.value}",'
        '"state_id": "${travelerPickUpStateId.value}",'
        '"country_id": "${travelerPickUpCountryId.value}",'
        '"bank_account": "${bankAccountNumber.value}",'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}'
    )):http.Request('POST', Uri.parse('${Domain.serverPort}/create/m2st_hk_airshipping.travelbooking?values='
        '{"name": "New_Travel/${DateFormat("yyyy/MM/dd").format(DateTime.now())}",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}",'
        '"street": "${pickUpStreet.value}",'
        '"city": "${travelerPickUpCityId.value}",'
        '"country_id": "${travelerPickUpCountryId.value}",'
        '"bank_account": "${bankAccountNumber.value}",'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}'
        '}'
    ));

    // '"luggage_types": "${departureDate.value}",'
    //     '"flight_docs": "${departureDate.value}",'

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("travel response: ${json.decode(data)}");
      await createAttachment(json.decode(data)[0]);
      await createAirLuggage(json.decode(data)[0]);
      Future.delayed(Duration(seconds: 3),()async{
        Navigator.pop(Get.context);
        Navigator.pop(Get.context);
        Get.delete<AddTravelController>();
        travel_booking_id.value = json.decode(data)[0];
        Get.find<UserTravelsController>().refreshMyTravels();
      });
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
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred! Please make sure you don't have a travel in published state or verify your information and try again".tr));
      buttonPressed.value = false;
      print("Error response: ${json.decode(data)['message']}");
    }
  }
  updateAirTravel()async{

    var headers = {
      'Authorization': Domain.authorization
    };
    var request = travelerPickUpStateId.value != 0?
    http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.travelbooking?values={'
        '"name": "Update_Travel/${DateFormat("yyyy/MM/dd").format(DateTime.now())}",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}"'
        '"street": "${pickUpStreet.value}",'
        '"city": "${travelerPickUpCityId.value}",'
        '"state_id": "${travelerPickUpStateId.value}",'
        '"country_id": "${travelerPickUpCountryId.value}",'
        '"bank_account": "${bankAccountNumber.value}",'
        '}&ids=${travelCard['id']}'
    ))
        : http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.travelbooking?values={'
        '"name": "Update_Travel/${DateFormat("yyyy/MM/dd").format(DateTime.now())}",'
        '"booking_type": "${travelType.value}",'
        '"departure_city_id": "${departureId.value}",'
        '"arrival_city_id": "${arrivalId.value}",'
        '"arrival_date": "${arrivalDate.value}",'
        '"departure_date": "${departureDate.value}"'
        '"street": "${pickUpStreet.value}",'
        '"city": "${travelerPickUpCityId.value}",'
        '"country_id": "${travelerPickUpCountryId.value}",'
        '"bank_account": "${bankAccountNumber.value}",'
        '}&ids=${travelCard['id']}'
    ));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      print("travel response: $data");
      await updateAttachment(json.decode(data)[0], travelCard['flight_docs'][0]);
      await updateAirLuggage(json.decode(data)[0], travelCard['luggage_types'][0]);
      buttonPressed.value = false;
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Your travel has been updated successfully ".tr));
      Navigator.pop(Get.context);
      Get.delete<AddTravelController>();

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      buttonPressed.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));
      throw new Exception(response.reasonPhrase);
    }
  }

  updateAttachment(int id, attachmentId) async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.traveler.verification?values={'
        '"flight_announcement_id":$id,'
        '"date": "2023-07-30",'
        '}&ids=$attachmentId'
    ));



    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('data'+data);
      var result = json.decode(data);
      // Get.showSnackbar(Ui.SuccessSnackBar(message: "Identity File successfully updated ".tr));
      await uploadPlaneDocument(result[0] );
    }
    else {
      buttonPressed.value = false;
      var data = await response.stream.bytesToString();
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text(json.decode(data)['message']),
          backgroundColor: specialColor.withOpacity(0.4),
          duration: Duration(seconds: 2)));
    }
  }

  updateAirLuggage(int id, int airLuggageId)async{
    for(var item in selectedPackages){
      var headers = {

        'Authorization': Domain.authorization
      };

      var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/m2st_hk_airshipping.flight.luggage?values={'
          '"luggage_type_id":${item['id']},'
          '"flight_announcement_id":$id,'
          '"price": $kilosPrice,'
          '"quantity": $kilosQuantity,'
          '}&ids=$airLuggageId'
      ));


      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        var result =  json.decode(data);
        print(' data 3 is is :$result');
        return result;
      }
      else {
        print(response.reasonPhrase);
      }
    }



  }

}
