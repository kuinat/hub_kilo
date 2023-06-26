import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/my_auth_service.dart';
import '../../root/controllers/root_controller.dart';
import '../../userTravels/controllers/user_travels_controller.dart';

class AccountController extends GetxController {


  final _picker = ImagePicker();
  File image;
  var loadImage = false.obs;
  UploadRepository _uploadRepository;
  UserRepository _userRepository;
  var currentUser = Get.find<MyAuthService>().myUser;


  @override
  void onInit() async{
    //currentUser = await getUser();
    await Get.find<UserTravelsController>().refreshMyTravels();
    super.onInit();

  }

  AccountController() {
    _uploadRepository = new UploadRepository();
    _userRepository = new UserRepository();




  }

  onRefresh() async{
    await getUser();
  }

  Future getUser() async {
    try {
      print('Get.find<MyAuthService>().myUser.value :'+Get.find<MyAuthService>().myUser.value.id.toString());
      currentUser.value = await _userRepository.get(currentUser.value.id);
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


  selectCameraOrGallery()async{
    showDialog(
        context: Get.context,
        builder: (_){
          return AlertDialog(
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

  // Future getUser() async {
  //
  //   final box = GetStorage();
  //   var sessionId = box.read('session_id');
  //   var headers = {
  //     //'Authorization': 'f4306f3775e61e951742869b5a627c49273d069c',
  //     'Cookie': sessionId.toString()
  //   };
  //   var request = http.Request('GET', Uri.parse(Domain.serverPort+'/api/res_partner'));
  //   request.body = '''{\n     "jsonrpc": "2.0"\n}''';
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     var result = await response.stream.bytesToString();
  //     var data = json.decode(result)['partner'];
  //     print('user1  '+data.toString());
  //
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }
}
