import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/ui.dart';
import '../../../models/my_user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';

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
  GoogleSignIn googleAuth = GoogleSignIn();
  GoogleSignInAccount googleAccount;
  var auth;

  AuthController() {
    _userRepository = UserRepository();
    Get.put(currentUser);

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
    return await FirebaseAuth.instance.signInWithCredential(credential);



    // googleAccount = await googleAuth.signIn();
    //
    // print(googleAccount.toString());
    //
    //
    // if (googleAccount != null) {
    //   print('Helle Nathalie');
    //   final GoogleSignInAuthentication googleSignInAuthentication =
    //   await googleAccount.authentication;
    //   final AuthCredential authCredential = GoogleAuthProvider.credential(
    //       idToken: googleSignInAuthentication.idToken,
    //       accessToken: googleSignInAuthentication.accessToken);
    //
    //   await auth.signInWithCredential(authCredential);
    //
    // }
  }

  googleSignOut() async {
    googleAccount = await googleAuth.signOut();

  }


  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();

        loading.value = true;
        var id = await _userRepository.login(currentUser.value);

        if(id != null){
          Get.find<MyAuthService>().myUser.value = await _userRepository.get(id);
          if(Get.find<MyAuthService>().myUser.value.id != null){
            loading.value = false;
            Get.showSnackbar(Ui.SuccessSnackBar(message: "You logged in successfully ".tr ));
            await Get.toNamed(Routes.ROOT);
          }
          else{
            loading.value = false;
          }
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
            loading.value = false;
            if(id == null)
            {
              loading.value = false;
            }
            if(id != null){
              Get.find<MyAuthService>().myUser.value = await _userRepository.get(id);
              if(Get.find<MyAuthService>().myUser.value.id != null){
                loading.value = false;
                Get.showSnackbar(Ui.SuccessSnackBar(message: "You registered successfully ".tr ));
                await Get.toNamed(Routes.ROOT);
              }

            }

          }
        else{
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
