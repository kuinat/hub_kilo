import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/my_user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/phone_verification_bottom_sheet_widget.dart';

class ProfileController extends GetxController {
  final user = new MyUser().obs;
  var url = ''.obs;
  //final Rx<MyUser> currentUser = Get.find<MyAuthService>().myUser;
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
  final editProfile = false.obs;
  final editPassword = false.obs;
  var birthDateSet = false.obs;
  var genderList = [
    "MALE".tr,
    "FEMALE".tr
  ].obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  ProfileController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    user.value = Get.find<MyAuthService>().myUser.value;
    selectedGender.value = genderList.elementAt(0);
    user.value?.birthday = user.value.birthday;
    //user.value.phone = user.value.phone;
    birthDate.value = user.value.birthday;
    // user.value.image.toString()=='null'?
    // url.value= null:
    // url.value = Domain.serverPort+"/web/image/res.partner/"+user.value.id.toString()+"/image_1920";

    //print("url: "+url.value);
    //user.value = Get.find<AuthService>().user.value;
    //avatar.value = new Media(thumb: user.value.avatar.thumb);
    super.onInit();
  }

  Future refreshProfile({bool showMessage}) async {
    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (profileForm.currentState.validate()) {
      //try {
      profileForm.currentState.save();
      /*user.value.deviceToken = null;
        user.value.password = newPassword.value == confirmPassword.value ? newPassword.value : null;
        user.value.avatar = avatar.value;*/
      // if (Get.find<SettingsService>().setting.value.enableOtp) {
      //   await _userRepository.sendCodeToPhone();
      //   Get.bottomSheet(
      //     PhoneVerificationBottomSheetWidget(),
      //     isScrollControlled: false,
      //   );
      // }
      //else {
      print(user.value.name);
      print(user.value.email);
      print(user.value.birthplace);
      print(user.value.street);
      print(user.value.birthday);
      print(user.value.sex);
      print(user.value.isTraveller);
      print(user.value.phone);

       await _userRepository.update(user.value);
      user.value = await _userRepository.get(user.value.id);
      Get.find<MyAuthService>().myUser.value = user.value;
      buttonPressed.value = false;
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile updated successfully".tr));
      await Get.toNamed(Routes.ROOT);
      //}
      // } catch (e) {
      //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      // } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
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
      birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
      user.value.birthday = DateFormat('yy/MM/dd').format(pickedDate);
    }
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))))) {
      return false;
    }
    return true;
  }


  // imagePicker() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //
  //   if (result != null) {
  //     setState(() {
  //       image = File(result.files.single.path.toString());
  //       uploadImage(partnerId);
  //     });
  //   } else {
  //     print("No file selected");
  //   }
  // }


  // Future<void> verifyPhone() async {
  //   try {
  //     await _userRepository.verifyPhone(smsSent.value);
  //     /*user.value = await _userRepository.update(user.value);
  //     Get.find<AuthService>().user.value = user.value;*/
  //     Get.back();
  //     Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  void resetProfileForm() {
    //avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.get(user.value.id);
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
