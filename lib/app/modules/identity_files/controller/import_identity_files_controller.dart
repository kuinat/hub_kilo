import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/media_model.dart';
import 'package:http/http.dart' as http;

import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/my_auth_service.dart';

class ImportIdentityFilesController extends GetxController{

  final _picker = ImagePicker();

  //File identificationFilePhoto;
  File identificationFile;


  final loadIdentityFile = false.obs;
  final identityPieceSelected = ''.obs;
  UserRepository _userRepository;
  var currentState = 0.obs;
  var loadImage = false.obs;
  var currentUser = Get.find<MyAuthService>().myUser;

  var birthCityId = 0.obs;
  var residentialAddressId = 0.obs;


  var predict1 = false.obs;
  var predict2 = false.obs;
  var errorCity1 = false.obs;
  //File passport;
  var countries = [].obs;
  var list = [];

  ScrollController scrollController = ScrollController();
  final formStep = 0.obs;
  TextEditingController depTown = TextEditingController();
  TextEditingController arrTown = TextEditingController();

  var selectedPiece = "Select identity piece".obs;


  var pieceList = [
    'Select identity piece'.tr,
    'CNI'.tr,
    'Passport'.tr,
  ];

  var dateOfDelivery = DateTime.now().add(Duration(days: 2)).toString().obs;
  var dateOfExpiration = DateTime.now().add(Duration(days: 3)).toString().obs;

  @override
  void onInit() async {
    final box = GetStorage();
    list = box.read("allCountries");
    countries.value = list;
    print("first country is ${countries[0]}");

    super.onInit();
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


  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))))) {
      return true;
    }
    return false;
  }



  deliveryDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

      context: Get.context,

      imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
      initialDate: DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(2013),
      height: MediaQuery.of(Get.context).size.height*0.5,
      lastDate: DateTime(2040),
      styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleYearButton: TextStyle(
            fontSize: 52,
            color: Colors.white,
          )
      ),
      borderRadius: 16,
      //selectableDayPredicate: disableDate
    );
    if (pickedDate != null) {
      //birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
      dateOfDelivery.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }




  expiryDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

      context: Get.context,

      imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
      initialDate: DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(2013),
      lastDate: DateTime(2040),
      styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleYearButton: TextStyle(
            fontSize: 52,
            color: Colors.white,
          )
      ),
      borderRadius: 16,
      //selectableDayPredicate: disableDate
    );
    if (pickedDate != null ) {
      //birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
      dateOfExpiration.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  selectCameraOrGalleryIdentityFile()async{
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
                        await identityFilePicker('camera');
                        //Navigator.pop(Get.context);
                        loadIdentityFile.value = !loadIdentityFile.value;

                      },
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await identityFilePicker('gallery');
                        //Navigator.pop(Get.context);
                        loadIdentityFile.value = !loadIdentityFile.value;
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

    if (response.statusCode == 200){
      var data = await response.stream.bytesToString();
      print("Hello"+data.toString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Identity File succesfully updated ".tr));
      //Navigator.pop(Get.context);

    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
    //}
  }

  identityFilePicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        identificationFile = File(pickedImage.path);
        Navigator.of(Get.context).pop();
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;//Navigator.of(Get.context).pop();
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        identificationFile = File(pickedImage.path);
        Navigator.of(Get.context).pop();
        //await sendImages(id, identificationFile );
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;
        //Navigator.of(Get.context).pop();
      }

    }

  }


  createAttachment() async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=c2f0577a02cbfee7322f6f0e233e301745a03c03'
    };

    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/ir.attachment?values={'
        '"attach_custom_type": "$identityPieceSelected",'
        '"name": "Name",'
        '"partner_id": "${currentUser.value.id}",'
        '"date_start": "$dateOfDelivery",'
        '"date_end": "$dateOfExpiration"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('data'+data);
      var result = json.decode(data);
      return result[0];
    }
    else {
      print(response.reasonPhrase);
    }


  }


  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
