import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
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

class AuthController extends GetxController {
  final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
  final email = ''.obs;
  //final Rx<M>
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  var birthDateSet = false.obs;
  final smsSent = ''.obs;
  var birthDate = DateTime.now().obs;
  var confirmPassword = ''.obs;
  var password = ''.obs;
  UserRepository _userRepository;

  AuthController() {
    _userRepository = UserRepository();
    Get.put(currentUser);
  }

  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();

      try {
        loading.value = true;
        currentUser.value = await _userRepository.login(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(message: "You logged in successfully ".tr ));
        await Get.toNamed(Routes.ROOT);

      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "User credentials not matching or existing"));
      } finally {
        loading.value = false;
      }

    }
    //await Get.find<RootController>().changePage(0);
  }

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();

      try {
        loading.value = true;

        currentUser.value = await _userRepository.register(currentUser.value);

        loading.value = false;

        Get.showSnackbar(Ui.SuccessSnackBar(message: "Your account has been created successfully ".tr));
        await Get.toNamed(Routes.ROOT);


      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }



    }
  }



  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        //await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(message: "The Password reset link has been sent to your email: ".tr + currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
  chooseBirthDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

        context: Get.context,

        imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
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
        selectableDayPredicate: disableDate
    );
    if (pickedDate != null && pickedDate != birthDate.value) {
      birthDate.value = pickedDate;
    }
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))))) {
      return false;
    }
    return true;
  }



}
