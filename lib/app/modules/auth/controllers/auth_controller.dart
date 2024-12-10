import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/my_user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthController extends GetxController {
  final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  //final Rx<M>
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  var onClick = false.obs;
  var birthDateSet = false.obs;
  final smsSent = ''.obs;
  var birthDate = DateTime.now().obs;
  var confirmPassword = ''.obs;
  var password = ''.obs;
  var email = ''.obs;
  var userId = 0.obs;
  var isChecked = false.obs;
  var verifyClicked = false.obs;
  var loginClickable = false.obs;
  var code = ''.obs;
  UserRepository _userRepository;
  GoogleSignIn googleAuth = GoogleSignIn();
  GoogleSignInAccount googleAccount;
  var users = [].obs;
  var auth;
  var taxDto = {}.obs;
  var authUserId = 0.obs;



  AuthController() {
    _userRepository = UserRepository();
    Get.put(currentUser);

  }

  @override
  void onInit() async {
    var box = await GetStorage();
    if(box.read('userEmail')!=null){
      email.value = box.read('userEmail');
    }
    if(box.read('password')!=null){
      password.value = box.read('password');
    }
    if(box.read('checkBox') != null){
      isChecked.value = box.read('checkBox');
    }

    var towns = box.read("allCountries");
    var countriesDatabase = box.read("allCountriesOnly");
    var states = box.read("states");

    if(towns == null){
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(Get.context).loadingCities),
        duration: Duration(seconds: 3),
      ));

      List countries = await getCountries();

      box.write("allCountries", countries);

    }
    if(countriesDatabase == null) {
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text('Loading countries...'),
        duration: Duration(seconds: 3),
      ));
      List countriesOnly = await getCountryOnly();
      box.write("allCountriesOnly", countriesOnly);
    }

    if(states == null){
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text('Loading states...'),
        duration: Duration(seconds: 3),
      ));

      List states = await getStates();

      box.write("states", states);

    }



    var data = await getTax();
    taxDto.value = data;
    super.onInit();
  }

  Future getTax()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/account.tax'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      //print(data);
      return json.decode(data)[json.decode(data).length - 1];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  onTokenReceived(String token) {
    print("FINAL TOKEN===> $token");
  }

  Future getCountries()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/res.city'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      //print(data);
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(Get.context).citiesLoadedSuccessfully),
        backgroundColor: validateColor,
        duration: Duration(seconds: 2),
      ));
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }
  Future getStates()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/res.country.state'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      //print(data);
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(Get.context).citiesLoadedSuccessfully),
        backgroundColor: validateColor,
        duration: Duration(seconds: 2),
      ));
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }
  Future getCountryOnly()async{
    print('Helllllllllllllllllllllo');
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/res.country'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(Get.context).citiesLoadedSuccessfully),
        backgroundColor: validateColor,
        duration: Duration(seconds: 2),
      ));
      return json.decode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      for (final providerProfile in user.providerData) {
        // ID of the provider (google.com, apple.com, etc.)
        final provider = providerProfile.providerId;

        // UID specific to the provider
        final uid = providerProfile.uid;

        // Name, email address, and profile photo URL
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        //final profilePhoto = providerProfile.photoURL;
        final phone = providerProfile.phoneNumber;
        final photo = providerProfile.photoURL;
        print(photo);


        await getAllUsers();
        var found =false;
        var index = 0;
        for(int i = 0; i<users.length; i++){
          if(emailAddress==users[i]['login']){
            found = true;
            index = i;
          }
        }
        if (found){
          Get.find<MyAuthService>().myUser.value = await _userRepository.get(users[index]['partner_id'][0]['id']);
          //Get.find<MyAuthService>().myUser.value.image = photo;
          Domain.googleUser = true;
          Domain.googleImage = photo;

          var foundDeviceToken= false;
          if(Get.find<MyAuthService>().myUser.value.deviceTokenIds.isNotEmpty)
          {
            var tokensList = await getUserDeviceTokens(Get.find<MyAuthService>().myUser.value.deviceTokenIds);
            for(int i = 0; i<tokensList.length;i++){
              if(Domain.deviceToken==tokensList[i]['token']){
                foundDeviceToken = true;
              }
            }
          }

          loading.value = false;
          if(!foundDeviceToken){
            await saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
          }
          Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).loginSuccessfull ));
          await Get.toNamed(Routes.ROOT);

        }
        else{
          var id =  await createGoogleUser(name, emailAddress, phone);
          Get.find<MyAuthService>().myUser.value = await _userRepository.get(id);
          //Get.find<MyAuthService>().myUser.value.image = photo;
          Domain.googleUser = true;
          Domain.googleImage = photo;

          await saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
          Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).signinSuccessfull ));
          await Get.toNamed(Routes.ROOT);

        }
      }
    }
  }

  authorizeUser(int userId)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.users?ids=$userId&values={'
        '"sh_user_from_signup": true,'
        '}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).loginSuccessfull ));
      await Get.toNamed(Routes.ROOT);

    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
    }
  }

  createGoogleUser(String name, String email, String phone ) async {

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
        '"image_1920": false,'
        '"sel_groups_1_9_10": 10}'

    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)  {
      var result = await response.stream.bytesToString();
      print(result);
      var data = json.decode(result);
      var portalId = await updateGoogleUserToPortalUser(data[0]);
      var partnerId = await getCreatedGoogleUser(portalId);
      return partnerId;
      //await uploadProfileImage(profileImage, partnerId);
      //await updateBeneficiaryPartnerEmail(partnerId, email);
      //createShipping(partnerId);
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['message']));
      //existingPartner = ['testname','https://stock.adobe.com/search?k=admin'];
      //existingPartnerVisible.value = true;
    }
  }

  updateGoogleUserToPortalUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
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

  getCreatedGoogleUser(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
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

  googleSignOut() async {
    googleAccount = await googleAuth.signOut();

  }

  getAllUsers()async{
    var headers = {
      'api-key': Domain.apiKey
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort2}/res.users/search'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      List list = json.decode(data)['data'];
      users.value = list;
      print("ok");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getUserByEmail(var email)async{
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=64e58748817b9f2ba70792e877a42e18f9699312'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://preprod.hubkilo.com/mobile/get_user_by_email'));
    request.fields.addAll({
      'email': '$email'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(json.decode(data)['user_id'] != null){
        userId.value = json.decode(data)['user_id'];
        await sendResetLink(userId.value);
      }else{
        onClick.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)['error'] ));
      }
    }
    else {
      onClick.value = false;
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).userNotFound ));
    }
  }

  void sendResetLink(int userId) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/res.users/action_reset_password?ids=$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: "${AppLocalizations.of(Get.context).firstTextResetPassword} ${email.value}${AppLocalizations.of(Get.context).secondTextResetPassword}".tr ));
      onClick.value = false;
    }
    else {
      onClick.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context).userNotFound ));
      print(response.reasonPhrase);
    }
  }

  getUserVerification(int id)async{
    print(id);
    var headers = {
      'api-key': Domain.apiKey
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort2}/res.users/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)['data'][0];

      if(data['sh_user_from_signup']){

        var foundDeviceToken= false;
        loading.value = false;

        if(Get.find<MyAuthService>().myUser.value.deviceTokenIds.isNotEmpty)
        {
          var tokensList = await getUserDeviceTokens(Get.find<MyAuthService>().myUser.value.deviceTokenIds);
          for(int i = 0; i<tokensList.length;i++){
            if(Domain.deviceToken==tokensList[i]['token']){
              foundDeviceToken = true;
            }
          }

        }

        if(!foundDeviceToken){
          await saveDeviceToken(Domain.deviceToken, Get.find<MyAuthService>().myUser.value.id);
        }

        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context).loginSuccessfull ));

        verifyClicked.value = false;

        await Get.toNamed(Routes.ROOT);

      }else{
        code.value = data['verification_code'].toString();
        loading.value = false;
        Get.toNamed(Routes.VERIFICATION);
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  void login() async {
    Get.focusScope.unfocus();

    if (loginFormKey.currentState.validate()) {

      //loginFormKey.currentState.save();

      loading.value = true;
      var myUser = MyUser(email: email.value, password: password.value);
      var id = await _userRepository.login(myUser);

      if(id != 0){
        Get.find<MyAuthService>().myUser.value = await _userRepository.get(id);
        ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(Get.context).loadingData),
          duration: Duration(seconds: 2),
        ));
        await getUserVerification(Get.find<MyAuthService>().myUser.value.userId);

      }else{
        loading.value = false;
      }
    }
    //await Get.find<RootController>().changePage(0);
  }

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();

      loading.value = true;
      var registered = await _userRepository.register(currentUser.value);
      if(registered)
      {
        var id = await _userRepository.login(currentUser.value);
        //currentUser.value = await _userRepository.get(id);
        //loading.value = false;

        if(id != null){
          await updatePartnerGender(id, currentUser.value.sex);
          loading.value = false;
          Get.find<MyAuthService>().myUser.value = await _userRepository.get(id);

          await getUserVerification(Get.find<MyAuthService>().myUser.value.userId);

        }else{
          loading.value = false;
        }

      }
      else{
        loading.value = false;
      }
    }
  }



  updatePartnerGender(int id, String gender) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.partner?ids=$id&values={"gender": "$gender"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print(id.toString());
      print(gender);
      print('The partner has been updated');
    }
    else {
      print(response.reasonPhrase);
    }

  }

  saveDeviceToken(String token, var id)async{
    print(token);
    print(id.toString());

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/fcm.device.token?values={'
        '"token": "$token",'
        '"partner_id": $id}'));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('Device token already exist, Again ');
    }
    else {
      print(response.reasonPhrase);
    }
  }


  getUserDeviceTokens(List tokensList)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/fcm.device.token?ids=$tokensList'));

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


  resendOTPCode()async{

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse('https://preprod.hubkilo.com/update_verification_code/${Get.find<MyAuthService>().myUser.value.userId}'));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(Get.context);
      var data = await response.stream.bytesToString();
      var message = json.decode(data)['result']['message'];
      Get.showSnackbar(Ui.SuccessSnackBar(message: message ));
    }
    else {
      Navigator.pop(Get.context);
      print(response.reasonPhrase);
    }


  }

}