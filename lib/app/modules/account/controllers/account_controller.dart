import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/my_user_model.dart';
import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/my_auth_service.dart';
import '../../root/controllers/root_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';

class AccountController extends GetxController {

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
  final identityPieceSelected = ''.obs;
  var selectedGender = "".obs;
  final editProfile = false.obs;
  final editPassword = false.obs;
  var birthDateSet = false.obs;
  //File identificationFilePhoto;
  final loadIdentityFile = false.obs;
  var genderList = [
    "MALE".tr,
    "FEMALE".tr
  ].obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  var dateOfDelivery = DateTime.now().add(Duration(days: 2)).toString().obs;
  var dateOfExpiration = DateTime.now().add(Duration(days: 3)).toString().obs;

  ProfileController() {
    _userRepository = new UserRepository();
  }
  final _picker = ImagePicker();
  File image;
  var loadImage = false.obs;
  UploadRepository _uploadRepository;
  var currentState = 0.obs;
  var currentUser = Get.find<MyAuthService>().myUser;


  @override
  void onInit() async{
    user.value = Get.find<MyAuthService>().myUser.value;
    selectedGender.value = genderList.elementAt(0);
    user.value?.birthday = user.value.birthday;
    //user.value.phone = user.value.phone;
    birthDate.value = user.value.birthday;
    await Get.find<UserTravelsController>().refreshMyTravels();
    super.onInit();

  }

  AccountController() {
    _uploadRepository = new UploadRepository();
    _userRepository = new UserRepository();

  }

  onRefresh() async{
    user.value = Get.find<MyAuthService>().myUser.value;
    selectedGender.value = genderList.elementAt(0);
    user.value?.birthday = user.value.birthday;
    //user.value.phone = user.value.phone;
    birthDate.value = user.value.birthday;
    await getUser();
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
      user.value.birthday = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
  chooseBirthDateDeliveryAndExpiration() async {
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
      return true;
    }
    return false;
  }

  Future getUser() async {
    try {
      print('Get.find<MyAuthService>().myUser.value :'+Get.find<MyAuthService>().myUser.value.id.toString());
      currentUser.value = await _userRepository.get(currentUser.value.userId);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  profileImagePicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        await _uploadRepository.image(image, currentUser.value);
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        loadImage.value = !loadImage.value;
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        await _uploadRepository.image(image, currentUser.value);
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        loadImage.value = !loadImage.value;
      }

    }

  }

  deliveryDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

        context: Get.context,

        imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
        initialDate: DateTime.now().subtract(Duration(days: 1)),
        firstDate: DateTime(1900),
        //lastDate: DateTime(2010),
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
      //birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
      dateOfDelivery.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }




expiryDate() async {
  DateTime pickedDate = await showRoundedDatePicker(

      context: Get.context,

      imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
      initialDate: DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(1900),
      //lastDate: DateTime(2010),
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
    //birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
    dateOfExpiration.value = DateFormat('yyyy-MM-dd').format(pickedDate);
  }
}

  selectCameraOrGalleryIdentityFile(int id)async{
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
                        await identityFilePicker('camera', id);
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;

                      },
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await identityFilePicker('gallery', id);
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;
                      },
                      leading: Icon(FontAwesomeIcons.image),
                      title: Text('Upload an image', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    )
                  ],
                )
            ),
          );
        });
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
                      title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('gallery');
                        Navigator.pop(Get.context);
                        loadImage.value = !loadImage.value;
                      },
                      leading: Icon(FontAwesomeIcons.image),
                      title: Text('Upload an image', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    )
                  ],
                )
            ),
          );
        });
  }
  sendImages(int id, File identityFile)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/ir.attachment/$id/datas'));
    request.files.add(await http.MultipartFile.fromPath('ufile', identityFile.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("Hello"+data.toString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Identity File succesfully updated ".tr));
      Navigator.pop(Get.context);

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
    //}
  }

  identityFilePicker(String source, int id) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        await sendImages(id, image );
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        loadImage.value = !loadImage.value;
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        await _uploadRepository.image(image, currentUser.value);
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        loadImage.value = !loadImage.value;
      }

    }

  }


  createAttachment() async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.serverPort,
      'Cookie': 'session_id=c2f0577a02cbfee7322f6f0e233e301745a03c03'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/ir.attachment?values={'
        '"attach_custom_type": "$identityPieceSelected",'
        '"name": "Name",'
        '"date_start": "$deliveryDate()",'
        '"date_end": "$expiryDate()"}'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      return result[0];
  }
  else {
  print(response.reasonPhrase);
  }


}

  void resetProfileForm() {
    //avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }



  Future<void> deleteUser() async {
    try {
      //await _userRepository.deleteCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}

