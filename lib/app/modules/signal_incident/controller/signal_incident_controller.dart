import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../../../models/chat_model.dart';
import '../../../models/my_user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/my_auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

class SignalIncidentController extends GetxController{

  final _picker = ImagePicker();

  //File identificationFilePhoto;
  File ticketFile;
  var ticketFiles = [].obs;
  var isConform = false.obs;
  var loading = false.obs;
  var listAttachment = [];
  var attachmentFiles = [].obs;
  var ticketTypeList = [].obs;
  var allUserTickets = [].obs;
  var ticketsList = [];
  final loadIdentityFile = false.obs;
  final loadIncidents = true.obs;
  final identityPieceSelected = ''.obs;
  var currentState = 0.obs;
  var loadImage = false.obs;
  var currentUser = Get.find<MyAuthService>().myUser;
  var buttonPressed = false.obs;
  var subject = "".obs;
  var description = "".obs;
  var ticketTypeId = 1000000.obs;
  var predict1 = false.obs;
  var showButton = false.obs;
  var errorTicket = false.obs;
  ScrollController scrollController = ScrollController();

  TextEditingController ticketType = TextEditingController();

  final validate = false.obs;
  File imageFile;
  final isLoading = true.obs;
  final isDone = false.obs;
  final enableSend = false.obs;
  final enableImageSend = false.obs;
  final validateMessage = {}.obs;
  var list = [];
  var getIndex = 1000.obs;
  var messages = [].obs;
  var messagesSent = [].obs;
  final card = {}.obs;
  final travel = {}.obs;
  final departureTown = "".obs;
  final departureCountry = "".obs;
  final arrivalTown = "".obs;
  final arrivalCountry = "".obs;
  final receiver_id = 0.obs;
  final receiver_Name = "".obs;
  var messageId = 0.obs;
  var commission = 0.0.obs;
  TextEditingController chatTextController = TextEditingController();
  TextEditingController chatTextImageController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var chatText = 0.0.obs;
  Timer timer;
  var ticketId = 0.obs;
  var _channel;


  //var list = [];

  var priority = 0.obs;

  var selectedPiece = 'Pick an incident type'.obs;
  final user = new MyUser().obs;

  var pieceList = [
    'Pick an incident type'.tr,
    AppLocalizations.of(Get.context).cni.tr,
    AppLocalizations.of(Get.context).passport.tr,
  ];

  var dateOfDelivery = DateTime.now().add(Duration(days: 2)).toString().obs;
  var dateOfExpiration = DateTime.now().add(Duration(days: 3)).toString().obs;
  UserRepository _userRepository;

  SignalIncidentController() {
    _userRepository = UserRepository();
    Get.put(currentUser);

  }

  @override
  void onInit() async {
    timer = Timer.periodic(Duration(seconds: 3),
            (Timer timer) => refreshMessages());

    user.value = Get.find<MyAuthService>().myUser.value;

    await onRefresh();

    super.onInit();
  }

  onRefresh() async{
    list = await getAllTicketTypes();
    ticketTypeList.value = list;

    ticketsList = await getAllUserTicket();
    allUserTickets.value = ticketsList;

  }

  @override
  void dispose() {
    //timer.cancel();
    super.dispose();
  }

  void refreshMessages() async {
    var result =[];
    //await getShipping(card['id']);

    result = await getMessages(ticketId.value);
    print(result.length);
    print(messages.length);

    if(result.length > messages.length){
      for(var i = 0; i<result.length; i++){
        int l = result.length - messages.length;
        if(i < l+1){
          messages.add(result[i]);
          messagesSent.clear();
          print("reloaded");
        }
      }
    }else{
      print("no new message");
    }
    /*lastDocument = new Rx<DocumentSnapshot>(null);
    await listenForMessages();*/
  }

  Future getMessages(int ticketId)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/api/get_messages/$ticketId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      List result = json.decode(data);
      result.removeAt(result.length-2);
      return result;
    }
    else {
      var data = await response.stream.bytesToString();
      print(data);
    }
  }

  sendMessage(int ticketId, partnerId, String message)async{
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; session_id=e47ff4e1c2cebc11751f4fd23c286255edc3c64b'
    };
    var request = http.Request('POST', Uri.parse('https://preprod.hubkilo.com/api/create_message'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "ticket_id": ticketId,
        "author_id": partnerId,
        "body": message
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data)['result']['data'];
      return result;

    }
    else {
      var data = await response.stream.bytesToString();
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text(json.decode(data)['message']),
          backgroundColor: specialColor.withOpacity(0.4),
          duration: Duration(seconds: 2)));
    }

  }

  checkValue(String value){
    if(value.isNotEmpty){
      enableSend.value = true;
    }else{
      enableSend.value = false;
    }
  }




  createTicket() async{
    print(subject.value);
    print(currentUser.value.userId);
    print(priority);
    print(description);
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };

    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/create/axis.helpdesk.ticket?values={'
        '"helpdesk_ticket_type_id": $ticketTypeId,'
        '"name": "${subject.value}",'
        '"partner_id": ${currentUser.value.id},'
        '"helpdesk_stage_id": 1,'
        '"helpdesk_team_id": 1,'
        '"res_user_id": false,'
        '"priority": "$priority",'
        '"description": "$description"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print('data'+data);
      var result = json.decode(data);
      for(var ticketFile in ticketFiles){
        uploadTicketAttachment(result[0], ticketFile);
      }
      await onRefresh();
      Navigator.of(Get.context).pop();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Incident successfully reported".tr));
      buttonPressed.value = false;
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

  uploadTicketAttachment(int id, File ticketFile)async{
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text("Uploading image..."),
      duration: Duration(seconds: 3),
    ));

    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=e47ff4e1c2cebc11751f4fd23c286255edc3c64b'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://preprod.hubkilo.com/helpdesk/upload_attachment/$id'));
    request.files.add(await http.MultipartFile.fromPath('attachment', ticketFile.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.SuccessSnackBar(message: json.decode(data)['message'].tr));
    }

  }

  uploadTicketMessageImage(int id, File ticketFile, int messageId)async{
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text("Uploading image..."),
      duration: Duration(seconds: 3),
    ));

    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=e47ff4e1c2cebc11751f4fd23c286255edc3c64b'
    };
    //var request = http.MultipartRequest('POST', Uri.parse('https://preprod.hubkilo.com/message/helpdesk/upload_attachment/57/8954?attachment'));
    var request = http.MultipartRequest('POST', Uri.parse('https://preprod.hubkilo.com/message/helpdesk/upload_attachment/$id/$messageId'));
    request.files.add(await http.MultipartFile.fromPath('attachment', ticketFile.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      var data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.SuccessSnackBar(message: json.decode(data)['message'].tr));
    }

  }



  pickImage(ImageSource source) async {

    ImagePicker imagePicker = ImagePicker();

    if(source.toString() == ImageSource.camera.toString())
    {
      var compressedImage;
      XFile pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
      File imageFile = File(pickedFile.path);
      if(imageFile.lengthSync()>pow(1024, 2)){
        final tempDir = await getTemporaryDirectory();
        final path = tempDir.path;
        int rand = new Math.Random().nextInt(10000);
        Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
        compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));


      }
      else{

        compressedImage = File(pickedFile.path);

      }
        ticketFiles.add(compressedImage);

    }
    else{
      var compressedImage;
      var i =0;
      var pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
        File imageFile = File(pickedFile.path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = new Math.Random().nextInt(10000);
          Im.Image image1 = Im.decodeImage(imageFile.readAsBytesSync());
          compressedImage = new File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1, quality: 25));


        }
        else{

          compressedImage = File(pickedFile.path);

        }

      ticketFiles.add(compressedImage);

    }
  }


  void filterSearchTicketTypes(String query) {
    List dummySearchList = [];
    dummySearchList = list;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['display_name']
          .toString().toLowerCase().contains(query.toLowerCase()) ).toList();
      ticketTypeList.value = dummyListData;
      return;
    } else {
      ticketTypeList.value = list;
    }
  }

  getAllTicketTypes ()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/search_read/axis.helpdesk.ticket.type'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result);
      print(data);

      return data;
    }
    else {
      return [];
      print(response.reasonPhrase);
    }

  }

  getAllUserTicket()async{
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=4846b377ee42ee6206d3803dc08c61de2774518a'
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/partner/helpdesk/get_ticket/${currentUser.value.id}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result);
      loadIncidents.value = false;
      print('My tickets: $data');
      return data['tickets'];
    }
    else {
      print(response.reasonPhrase);
      return [];
    }

  }

  getAssignedEmployee(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'frontend_lang=en_US; session_id=e47ff4e1c2cebc11751f4fd23c286255edc3c64b'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.users?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data)[0];
      return result;
    }
    else {
    print(response.reasonPhrase);
    }

  }

  getTicketAttachmentIds(int id) async{
    var headers = {
      'Cookie': 'frontend_lang=en_US; session_id=c873276d5c50fb6ae61033f04ea7925668c9dec2'
    };
    var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/helpdesk/get_ticket/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data)['ticket']['attachment_ids'];
      return result;
    }
    else {
    print(response.reasonPhrase);
    return [];
    }

  }

  closeTicket(int ticket_id)async{
    loading.value = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverPort}/call/axis.helpdesk.ticket/close_action/?ids=$ticket_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {

      final data = await response.stream.bytesToString();
      print(data);

      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Ticket Successfully Closed'));
      await onRefresh();
      loading.value = false;
      Navigator.pop(Get.context);

    }
    else {
      final data = await response.stream.bytesToString();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "${json.decode(data)['message']}".tr));

      throw new Exception(response.reasonPhrase);
    }
  }




  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
