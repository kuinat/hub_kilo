import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;
import '../../../models/my_user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/my_auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

class ImportIdentityFilesController extends GetxController{

  final _picker = ImagePicker();

  //File identificationFilePhoto;
  File identificationFile;
  var isConform = false.obs;
  var listAttachment = [];
  var attachmentFiles = [].obs;

  final loadIdentityFile = false.obs;
  final identityPieceSelected = ''.obs;
  var currentState = 0.obs;
  var loadImage = false.obs;
  var currentUser = Get.find<MyAuthService>().myUser;
  var buttonPressed = false.obs;
  var number = "".obs;
  var residentialAddressId = 0.obs;
  ScrollController scrollController = ScrollController();
  final formStep = 0.obs;
  var loadAttachments = true.obs;
  TextEditingController depTown = TextEditingController();
  TextEditingController arrTown = TextEditingController();

  var selectedPiece = AppLocalizations.of(Get.context).selectIdentityPiece.obs;
  final user = new MyUser().obs;

  var pieceList = [
    AppLocalizations.of(Get.context).selectIdentityPiece.tr,
    AppLocalizations.of(Get.context).cni.tr,
    AppLocalizations.of(Get.context).passport.tr,
  ];

  var dateOfDelivery = DateTime.now().add(Duration(days: 2)).toString().obs;
  var dateOfExpiration = DateTime.now().add(Duration(days: 3)).toString().obs;
  UserRepository _userRepository;

  ImportIdentityFilesController() {
    _userRepository = UserRepository();
    Get.put(currentUser);

  }

  @override
  void onInit() async {

    isConform.value = false;
    user.value = Get.find<MyAuthService>().myUser.value;

    await onRefresh();
    final box = GetStorage();

    super.onInit();
  }

  onRefresh() async{
    loadAttachments.value = true;
    await getUserInfo(Get.find<MyAuthService>().myUser.value.id);
  }

  getUserInfo(int id) async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse(Domain.serverPort+'/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result)[0];
      listAttachment = data['partner_attachment_ids'];
      await getAttachmentFiles();
      print(listAttachment);
    } else {
      print(response.reasonPhrase);
    }
  }

  getAttachmentFiles()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/ir.attachment?ids=$listAttachment&fields=%5B%22attach_custom_type%22%2C%22name%22%2C%22duration_rest%22%2C%22validity%22%2C%22conformity%22%5D&with_context=%7B%7D&with_company=1'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      List data = json.decode(result);
      attachmentFiles.value = data;
      loadAttachments.value = false;
      for(var i = 0; i < attachmentFiles.length; i++){
        if(attachmentFiles[i]['conformity'] == true){
          isConform.value = true;
          print('Attachment files ${attachmentFiles[i]}');
        }else{
          isConform.value = false;
        }
      }
      print(data);
    }
    else {
      var result = await response.stream.bytesToString();
      print(result);
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
      theme: ThemeData.light().copyWith(
          primaryColor: buttonColor
      ),
      height: Get.height/2,
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
    if (pickedDate != null) {
      //birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
      dateOfDelivery.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  expiryDate() async {
    DateTime pickedDate = await showRoundedDatePicker(

      context: Get.context,
      theme: ThemeData.light().copyWith(
          primaryColor: buttonColor
      ),
      height: Get.height/2,
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

    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text("Uploading image..."),
      duration: Duration(seconds: 3),
    ));

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Domain.serverPort}/upload/ir.attachment/$id/datas'));
    request.files.add(await http.MultipartFile.fromPath('ufile', identityFile.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200){

      var data = await response.stream.bytesToString();
      print("attachment image: "+data.toString());
      Future.delayed(Duration(seconds: 15),()async{
        if(buttonPressed.value){
          Get.showSnackbar(Ui.InfoSnackBar(message: "The image you are trying to upload may be too large..."));
        }
      });
      Get.find<MyAuthService>().myUser.value = await _userRepository.get(Get.find<MyAuthService>().myUser.value.id);
      await onRefresh();
      buttonPressed.value = false;
      Get.toNamed(Routes.IDENTITY_FILES);
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.SuccessSnackBar(message: json.decode(data)['message'].tr));
      buttonPressed.value = false;
    }
  }

  identityFilePicker(String source) async {
    if(source=='camera'){
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        var imageFile = File(pickedImage.path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = new Math.Random().nextInt(10000);
          Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
          var compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));
          print('Lenght'+compressedImage.lengthSync().toString());
          identificationFile = compressedImage;

        }
        else{
          identificationFile = File(pickedImage.path);

        }

        Navigator.of(Get.context).pop();
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;//Navigator.of(Get.context).pop();
      }
    }
    else{
      final XFile pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        var imageFile = File(pickedImage.path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = new Math.Random().nextInt(10000);
          Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
          var compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));
          print('Lenght'+compressedImage.lengthSync().toString());
          identificationFile = compressedImage;

        }
        else{
          identificationFile = File(pickedImage.path);
        }
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
      'Authorization': Domain.authorization
    };

    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/ir.attachment?values={'
        '"attach_custom_type": "$identityPieceSelected",'
        '"name": "${number.value}",'
        '"partner_id": "${currentUser.value.id}",'
        '"date_start": "$dateOfDelivery",'
        '"date_end": "$dateOfExpiration"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('data'+data);
      var result = json.decode(data);
      await sendImages(result[0], identificationFile );
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Identity File successfully saved ".tr));
    }
    else {
      buttonPressed.value = false;
      var data = await response.stream.bytesToString();
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text(json.decode(data)['message']),
          backgroundColor: specialColor.withOpacity(0.4),
          duration: Duration(seconds: 2)));
    }
  }

  deleteAttachment(int id) async{
    var headers = {
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=e87c0952437cd4d3c538435f459ed8858274382f'
    };
    var request = http.Request('DELETE', Uri.parse('${Domain.serverPort}/unlink/ir.attachment?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Get.find<MyAuthService>().myUser.value = await _userRepository.get(Get.find<MyAuthService>().myUser.value.id);
      await onRefresh();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Your identity card was successfully deleted..."));
    }
    else {
      var data = await response.stream.bytesToString();
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
        content: Text(json.decode(data)['message']),
        backgroundColor: specialColor.withOpacity(0.4),
        duration: Duration(seconds: 2)));
    }

  }


  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
