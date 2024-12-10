import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/my_user_model.dart';
import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/my_auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

class AccountController extends GetxController {

  final user = new MyUser().obs;
  var url = ''.obs;
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
  final buttonPressed = false.obs;
  var birthDate = ''.obs;
  final birthPlace = "".obs;
  final phone = "".obs;
  var selectedGender = "".obs;
  final editPlaceOfBirth = false.obs;
  final editResidentialAddress= false.obs;
  var birthDateSet = false.obs;
  var isConform = false.obs;

  var loadAttachments = true.obs;
  final identityPieceSelected = ''.obs;
  final userRatings = 0.0.obs;
  var ratings = [].obs;
  var airRatings = [].obs;
  var roadRatings = [].obs;
  var loading = true.obs;

  File identificationFile;

  var edit = false.obs;
  //File identificationFilePhoto;

  var genderList = [
    AppLocalizations.of(Get.context).male.tr,
    AppLocalizations.of(Get.context).female.tr
  ].obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  var dateOfDelivery = DateTime.now().add(Duration(days: 2)).toString().obs;
  var dateOfExpiration = DateTime.now().add(Duration(days: 3)).toString().obs;

  final _picker = ImagePicker();
  File image;
  UploadRepository _uploadRepository;
  var currentState = 0.obs;
  var loadImage = false.obs;
  var currentUser = Get.find<MyAuthService>().myUser;

  var birthCityId = 0.obs;
  var residentialAddressId = 0.obs;
  var listAttachment = [];
  var attachmentFiles = [].obs;
  var view = false.obs;
  var editing = false.obs;

  var predict1 = false.obs;
  var predict2 = false.obs;
  var errorCity1 = false.obs;
  //File passport;
  var countries = [].obs;
  var list = [];
  var enableNotification = true.obs;

  ScrollController scrollController = ScrollController();
  final formStep = 0.obs;
  TextEditingController depTown = TextEditingController();
  TextEditingController arrTown = TextEditingController();

  var selectedPiece = "Select identity piece".obs;

  var deviceTokens = [].obs;
  var tokens = [].obs;

  @override
  void onInit() async{
    isConform.value = false;
    user.value = Get.find<MyAuthService>().myUser.value;
    await getUserInfo(Get.find<MyAuthService>().myUser.value.id);
    await getAttachmentFiles();
    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;
    print("first country is ${countries[0]}");
    selectedGender.value = genderList.elementAt(0);
    user.value?.birthday = user.value.birthday;
    //user.value.phone = user.value.phone;
    birthDate.value = user.value.birthday;

    super.onInit();

  }

  AccountController() {
    _uploadRepository = new UploadRepository();
    _userRepository = new UserRepository();

  }

  onRefresh() async{
    loadAttachments.value = true;
    await getAttachmentFiles();
    user.value = Get.find<MyAuthService>().myUser.value;
    await getUserInfo(Get.find<MyAuthService>().myUser.value.id);
    await getUser();
  }

  void updateProfile() async {
    final box = GetStorage();
     buttonPressed.value = true;
     if (residentialAddressId.value == 0 &&birthCityId.value == 0) {
      print('resedential : '+residentialAddressId.value.toString());
      user.value.street = box.read("residential_city")!=null?box.read("residential_city"):residentialAddressId.value.toString();
      user.value.birthplace = box.read("birth_city")!=null?box.read("birth_city"):birthCityId.value.toString();
      box.write("birth_city", birthCityId.value.toString());
      box.write("residential_city", residentialAddressId.value.toString());
    }
    else if(residentialAddressId.value != 0 &&birthCityId.value != 0){
      print('resedential0 : '+residentialAddressId.value.toString());
      user.value.street = residentialAddressId.value.toString();
      user.value.birthplace = birthCityId.value.toString();
      box.write("birth_city", birthCityId.value.toString());
      box.write("residential_city", residentialAddressId.value.toString());
    }
    else{
      if (residentialAddressId.value == 0 && birthCityId.value != 0 ) {
        print('resedential1 : '+residentialAddressId.value.toString());
        user.value.street = box.read("residential_city");
        user.value.birthplace = birthCityId.value.toString();
        box.write("birth_city", birthCityId.value.toString());
      }

      if ( birthCityId.value == 0 && residentialAddressId.value != 0) {
        print('resedential2 : '+residentialAddressId.value.toString());
        user.value.birthplace = box.read("birth_city");
        user.value.street = residentialAddressId.value.toString();
        box.write("residential_city", residentialAddressId.value.toString());
      }

    }


      await _userRepository.update(user.value);
      user.value = await _userRepository.get(user.value.id);
      Get.find<MyAuthService>().myUser.value = user.value;
      buttonPressed.value = false;
      edit.value = false;
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).profileUpdated.tr));
      editing.value = false;
      Navigator.pop(Get.context);
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

  verifyOldPassword(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/web/session/authenticate'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "db": "preprod.hubkilo.com",
        "login": email,
        "password": password
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['result'];
      //print(data);
      if(data != null){
        return true;
      }
      else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).passwordError));
        return false;
        //throw new Exception(response.reasonPhrase);
      }
    }
    else {Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).unknown));
      return false;
    }

  }

  updateUserPassword(String newPassword) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=d2c885aa27073b1ccdcf777cdab4d1d3ef5bef08'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.users?ids=${user.value.userId}&values='
        '{"password": "$newPassword"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).passwordUpdatedSuccessfully));
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
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
      birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
      user.value.birthday = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }


  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  Future getUser() async {
    try {
      currentUser.value = await _userRepository.get(Get.find<MyAuthService>().myUser.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
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
          image = compressedImage;

        }
        else{
          image = File(pickedImage.path);

        }
        await _uploadRepository.image(image, currentUser.value);
        onRefresh();
        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).profilePictureSavedSuccessfully.tr));
        loadImage.value = !loadImage.value;
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
          image = compressedImage;

        }
        else{
          image = File(pickedImage.path);

        }

        await _uploadRepository.image(image, currentUser.value);
        onRefresh();
        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).profilePictureSavedSuccessfully.tr));
        loadImage.value = !loadImage.value;
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
                      onTap: ()async{
                        await profileImagePicker('camera');
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;

                      },
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text(AppLocalizations.of(Get.context).takePicture, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('gallery');
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;
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

  void resetProfileForm() {
    //avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }

  getUserInfo(int id) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];
      listAttachment = data['partner_attachment_ids'];
      userRatings.value = (data['average_rating']+data['air_average_rating'])/2;
      print('User Ratings: ${userRatings.value}');
      deviceTokens.value = data['fcm_token_ids'];
      
      if(userRatings.value != 0.0){
        var roadRating = await getUserRoadRating(data['rating_ids']);
        var airRating = await getUserAirRating(data['air_rating_ids']);
        ratings.clear();
        ratings.addAll(roadRatings);
        ratings.addAll(airRatings);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getUserRoadRating(var ids)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner.rating?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      loading.value = false;
      roadRatings.value = json.decode(data);
    }
    else {
      roadRatings.value = [];
      print(response.reasonPhrase);

    }
  }

  getUserAirRating(var ids)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner.air.rating?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      loading.value = false;
      airRatings.value = json.decode(data);
    }
    else {
      airRatings.value = [];
      print(response.reasonPhrase);
    }
  }

  getAttachmentFiles()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/ir.attachment?ids=$listAttachment&fields=%5B%22attach_custom_type%22%2C%22conformity%22%5D&with_context=%7B%7D&with_company=1'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      List data = json.decode(result);
      loadAttachments.value = false;
      attachmentFiles.value = data;
      for(var i = 0; i < attachmentFiles.length; i++){
        if(attachmentFiles[i]['conformity']){
          isConform.value = true;
        }
      }
      print(data);

    }
    else {
      var result = await response.stream.bytesToString();
      print(result);
    }
  }

  getDeviceTokens()async{

    var tokenIds = deviceTokens;
    print(tokenIds);

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/fcm.device.token?ids=$tokenIds'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result);
      List ids = [];
      for(var i in data){
        if(i['token'] == Domain.deviceToken){
          ids.add(i['id']);
        }
      }
      removeDeviceToken(ids);
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  removeDeviceToken(var ids)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('DELETE', Uri.parse('${Domain.serverPort}/unlink/fcm.device.token?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      enableNotification.value = false;
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  enableNotify()async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/fcm.device.token?values={'
        '"token": "${Domain.deviceToken}",'
        '"partner_id": ${Get.find<MyAuthService>().myUser.value.id}}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      enableNotification.value = true;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  deletePartnerAccount(int id)async{
    var headers = {
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/res.partner/unlink/?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      await onRefresh();
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Your Hubcolis account was deleted successfully' ));
    }
    else {
      print(response.reasonPhrase);
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }

  }

  deleteUserAccount(int id, int userId)async{
    var headers = {
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/res.users/unlink/?ids=$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      deletePartnerAccount(id);
      //await onRefresh();
      //Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).emergencyContactDeletionText));
    }
    else {
      print(response.reasonPhrase);
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }

  }

}

