import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/my_user_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/my_auth_service.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';

class ExpeditionOrderController extends GetxController {
  final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  //final Rx<M>
  GlobalKey<FormState> expeditionOrderFormKey;

  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  UserRepository _userRepository;

  ExpeditionOrderController() {
    _userRepository = UserRepository();
  }


  void register() async {
    Get.focusScope.unfocus();
    if (expeditionOrderFormKey.currentState.validate()) {
      expeditionOrderFormKey.currentState.save();
      loading.value = true;
      try {

        currentUser.value = await _userRepository.register(currentUser.value);
        //await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
        await Get.find<RootController>().changePage(0);
        // if (Get.find<SettingsService>().setting.value.enableOtp) {
        //   await _userRepository.sendCodeToPhone();
        //   loading.value = false;
        //   await Get.toNamed(Routes.PHONE_VERIFICATION);
        // } else {
        //   await Get.find<FireBaseMessagingService>().setDeviceToken();
        //   currentUser.value = await _userRepository.register(currentUser.value);
        //   await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
        //   await Get.find<RootController>().changePage(0);
        // }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
    await Get.find<RootController>().changePage(0);
  }

}
