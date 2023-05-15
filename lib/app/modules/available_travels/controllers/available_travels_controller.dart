import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/media_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/phone_verification_bottom_sheet_widget.dart';
import 'package:http/http.dart' as http;

class AvailableTravelsController extends GetxController {
  //var user = new User().obs;
  final heroTag = "".obs;
  var avatar = new Media().obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  final buttonPressed = false.obs;
  var allTravels = [];
  var items = [].obs;
  final isServer = false.obs;
  /*Rx<List<Map<String, dynamic>>> items =
  Rx<List<Map<String, dynamic>>>([]);*/
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  /*ProfileController() {
    _userRepository = new UserRepository();
  }*/

  @override
  void onInit() {
    initValues();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments.toString();
    super.onReady();
  }

  initValues()async{
    allTravels = await getAllTravels();
    items.value = allTravels;
    print(items);
  }

  Future refreshProfile({bool showMessage}) async {
    //await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  /*void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList = allTravels;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['name']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      items.value = dummyListData;
      return;
    } else {
      items.value = allTravels;
    }
  }*/

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (profileForm.currentState.validate()) {
      try {
        profileForm.currentState.save();
        /*user.value.deviceToken = null;
        user.value.password = newPassword.value == confirmPassword.value ? newPassword.value : null;
        user.value.avatar = avatar.value;*/
        if (Get.find<SettingsService>().setting.value.enableOtp) {
          await _userRepository.sendCodeToPhone();
          Get.bottomSheet(
            PhoneVerificationBottomSheetWidget(),
            isScrollControlled: false,
          );
        } else {
          /*user.value = await _userRepository.update(user.value);
          Get.find<AuthService>().user.value = user.value;*/
          Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      /*user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;*/
      Get.back();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void resetProfileForm() {
    //avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }

  Future getAllTravels() async {
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=8731877be51f7b3bdf564f2ebb623764d2f9fbcd'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/all/air/travels'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isServer.value = !isServer.value;
      final data = await response.stream.bytesToString();
      return json.decode(data)['response'];
    }
    else {
      print(response.reasonPhrase);
    }

    try {
      //user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      //await _userRepository.deleteCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
