import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  var departureId = 0.obs;
  var arrivalId = 0.obs;


  var predict1 = false.obs;
  var predict2 = false.obs;
  //File passport;
  var countries = [].obs;
  var list = [];

  ScrollController scrollController = ScrollController();
  final formStep = 0.obs;
  TextEditingController depTown = TextEditingController();
  TextEditingController arrTown = TextEditingController();



  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  ProfileController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;

    print('List is sssssss:   '+countries.value.toString());
    profileForm = new GlobalKey<FormState>();



    user.value = Get.find<MyAuthService>().myUser.value;
    selectedGender.value = genderList.elementAt(0);
    user.value?.birthday = user.value.birthday;
    //user.value.phone = user.value.phone;
    birthDate.value = user.value.birthday;
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
      user.value.birthday = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))))) {
      return false;
    }
    return true;
  }

  void resetProfileForm() {
    //avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.get(user.value.userId);
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
