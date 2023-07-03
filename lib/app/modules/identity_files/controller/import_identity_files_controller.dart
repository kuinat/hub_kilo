import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/media_model.dart';
import 'package:http/http.dart' as http;

import '../../../repositories/upload_repository.dart';

class ImportIdentityFilesController extends GetxController{

  var avatar = new Media().obs;
  File passport;
  var countries = [].obs;
  var list = [];
  var loadPassport = false.obs;
  var loadTicket = false.obs;
  File ticket;
  final travelCard = {}.obs;
  final identityPieceSelected = ''.obs;
  GlobalKey<FormState> newTravelKey;
  var birthDate = ''.obs;

  final _picker = ImagePicker();
  File image;
  UploadRepository _uploadRepository;

  var dateOfDelivery = DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 3650))).toString().obs;
  var dateOfExpiration = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString().obs;

  @override
  void onInit() async {

    super.onInit();
  }

  passportPicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        passport = File(pickedImage.path);
        loadPassport.value = !loadPassport.value;
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        passport = File(pickedImage.path);
        loadPassport.value = !loadPassport.value;
      }

    }

  }

  ticketPicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        ticket = File(pickedImage.path);
        loadTicket.value = !loadTicket.value;
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        ticket = File(pickedImage.path);
        loadTicket.value = !loadTicket.value;
      }

    }

  }

  deliveryDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

      context: Get.context,

      imageHeader: AssetImage("assets/img/istockphoto-1421193265-612x612.jpg"),
      initialDate: DateTime.now().subtract(Duration(days: 1825)),
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
      selectableDayPredicate: disableDate
      //selectableDayPredicate: disableDate
    );
    if (pickedDate != null && pickedDate != birthDate.value) {
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
                        Navigator.pop(Get.context);

                      },
                      leading: Icon(FontAwesomeIcons.camera),
                      title: Text('Take a picture', style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await identityFilePicker('gallery');
                        Navigator.pop(Get.context);
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
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/ir.attachment/$id/datas'));
    request.files.add(await http.MultipartFile.fromPath('ufile', identityFile.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print("Hello"+data.toString());
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Identity File successfully updated ".tr));
      Navigator.pop(Get.context);

    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.SuccessSnackBar(message: json.decode(data)['message']));
      print(data);
    }
    //}
  }

  identityFilePicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
      }
    }
  }

  createAttachment() async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.serverPort,
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/ir.attachment?values={'
    '"attach_custom_type": "$identityPieceSelected",'
    '"name": "RAS",'
    '"date_start": ${dateOfDelivery.value},'
    '"date_end": ${dateOfExpiration.value}}'
    ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      await sendImages(result[0], image );
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
      Get.showSnackbar(Ui.ErrorSnackBar(message: json.decode(data)["message"]));
    }
  }

  bool disableDate(DateTime day) {
    if ((day.isAfter(DateTime.now().add(Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
