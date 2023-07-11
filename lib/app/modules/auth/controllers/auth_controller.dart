import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
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
            //loading.value = false;
            if(id == null)
            {
              loading.value = false;
            }
            if(id != null){
              await updatePartnerGender(id, currentUser.value.sex);
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

  updatePartnerGender(int id, String gender) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=dc69145b99f377c902d29e0b11e6ea9bb1a6a1ba'
    };

    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/write/res.partner?ids=$id}&values={'
        '"gender": "$gender"}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();




    if (response.statusCode == 200) {
      print('Helllllllllllllllllllllllllllllllllllllo');
      print(await response.stream.bytesToString());


    }
    else {
      print(response.reasonPhrase);
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
  // chooseBirthDate() async {
  //   DateTime pickedDate = await showRoundedDatePicker(
  //
  //       context: Get.context,
  //
  //       imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
  //       initialDate: DateTime.now().subtract(Duration(days: 1)),
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime.now(),
  //       styleDatePicker: MaterialRoundedDatePickerStyle(
  //           textStyleYearButton: TextStyle(
  //             fontSize: 52,
  //             color: Colors.white,
  //           )
  //       ),
  //       borderRadius: 16,
  //       selectableDayPredicate: disableDate
  //   );
  //   if (pickedDate != null && pickedDate != birthDate.value) {
  //     birthDate.value = pickedDate;
  //   }
  // }

  // bool disableDate(DateTime day) {
  //   if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))))) {
  //     return false;
  //   }
  //   return true;
  // }



}
