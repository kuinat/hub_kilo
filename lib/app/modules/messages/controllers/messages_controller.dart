import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../services/auth_service.dart';
import 'package:http/http.dart' as http;

class MessagesController extends GetxController {

  var message = Message([]).obs;
  ChatRepository _chatRepository;
  NotificationRepository _notificationRepository;
  AuthService _authService;
  var messagesList = <Message>[].obs;
  var chats = <Chat>[].obs;
  File imageFile;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
  final isDone = false.obs;
  final enableSend = false.obs;
  var list = [];
  var messages = [].obs;
  final card = {}.obs;
  final travel = {}.obs;
  final departureTown = "".obs;
  final departureCountry = "".obs;
  final arrivalTown = "".obs;
  final arrivalCountry = "".obs;
  ScrollController scrollController = ScrollController();
  TextEditingController chatTextController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var chatText = 0.0.obs;
  Timer timer;
  /*MessagesController() {
    _chatRepository = new ChatRepository();
    _notificationRepository = new NotificationRepository();
    _authService = Get.find<AuthService>();
  }*/

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    card.value = arguments['shippingCard'];
    var data = await getTravelInfo(card['travelbooking_id'][0]);
    travel.value = data;
    if(travel != null){
      String departureCity = travel['departure_city_id'][1].split('(').first;
      String a = travel['departure_city_id'][1].split('(').last;
      String country1 = a.split(')').first;
      departureTown.value = departureCity;
      departureCountry.value = country1;
      String arrivalCity = travel['arrival_city_id'][1].split('(').first;
      String b = travel['arrival_city_id'][1].split('(').last;
      String country2 = b.split(')').first;
      arrivalTown.value = departureCity;
      arrivalCountry.value = country2;
    }
    print("book details: $card");
    list = await getMessages(card['travelmessage_ids']);
    messages.value = list;
    print("messages are: $messages");
    super.onInit();
  }

  @override
  void onClose() {
    //chatTextController.dispose();
    //timer.cancel();
  }

  // stopTimer(){
  //           timer.cancel();
  // }

  checkValue(String value){
    if(value.isNotEmpty){
      enableSend.value = true;
    }else{
      enableSend.value = false;
    }
  }

  Future createMessage(Message _message) async {
    _message.users.insert(0, _authService.user.value);
    _message.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    _message.readByUsers = [_authService.user.value.id];

    message.value = _message;

    _chatRepository.createMessage(_message).then((value) {
      listenForChats();
    });
  }

  Future deleteMessage(Message _message) async {
    messagesList.remove(_message);
    await _chatRepository.deleteMessage(_message);
  }

  Future refreshMessages() async {
    messagesList.clear();
    lastDocument = new Rx<DocumentSnapshot>(null);
    await listenForMessages();
  }

  sendMessage(int receiverId)async{
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) async{
      list = await getMessages(card['travelmessage_ids']);
      messages.value = list;
      print("Reloaded");
    } );
    print(chatTextController.text);
    final box = GetStorage();
    var session_id = box.read("session_id");

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; $session_id'
    };

      var request = http.Request('POST', Uri.parse(
          card['travel']['travel_type'] == 'air'
          ? '${Domain.serverPort}/air/send_message' :
      card['travel']['travel_type'] == 'road' ?
      '${Domain.serverPort}/road/send_message' : ''
      ));

    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "travel_booking_id": card['id'],
        "receiver_id": receiverId,
        "message": chatTextController.text
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      onInit();
      print(data);

    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future getTravelInfo(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=7c27b4e93f894c9b8b48cad4e00bb4892b5afd83'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelbooking?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return json.decode(data)[0];
    }
    else {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      print(data);
    }
  }

  Future getMessages(List ids)async{

    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
      'Cookie': 'session_id=0e707e91908c430d7b388885f9963f7a27060e74'
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/m1st_hk_roadshipping.travelmessage?ids=$ids'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      isLoading.value = false;
      return json.decode(data);
    }
    else {
    print(response.reasonPhrase);
    }
  }

  acceptAndPriceRoadBooking(var message)async{
    print(card['id']);
    final box = GetStorage();
    var session_id = box.read("session_id");

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; $session_id'
    };
    var request = http.Request('PUT', Uri.parse('${Domain.serverPort}/road/travel/booking_price/${card['id']}'));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "booking_price": message
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      if(json.decode(data)['result'] != null){
        print(data);
        acceptRoadBooking(card['id']);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  acceptRoadBooking(int id)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/road/accept/booking/'+id.toString()));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(json.decode(data)['result'] != null){
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking confirmed ".tr));
        Navigator.pop(Get.context);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
    }

  }

  acceptAndPriceAirBooking(var message)async{
    print(card['id']);
    final box = GetStorage();
    var session_id = box.read("session_id");


    var headers = {
      'Content-Type': 'application/json',
      'Cookie': session_id.toString()
    };
    var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/air/travel/booking/new_price/'+card['id'].toString()));
    request.body = json.encode({
      "jsonrpc": "2.0",
      "params": {
        "new_price": message
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();

      if(json.decode(data)['result'] != null){
        print(data);
        acceptAirBooking(card['id']);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      print(response.reasonPhrase);
    }


  }

  acceptAirBooking(int id)async{
    final box = GetStorage();
    var session_id = box.read('session_id');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'frontend_lang=en_US; '+session_id.toString()
    };
    var request = http.Request('PUT', Uri.parse(Domain.serverPort+'/air/accept/booking/$id'));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      if(json.decode(data)['result'] != null){
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking comfirmed ".tr));
        Navigator.pop(Get.context);
      }else{
        Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
      }
    }
    else {
      print(response.reasonPhrase);
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occured!".tr));
    }
  }
  Future listenForMessages() async {
    isLoading.value = true;
    isDone.value = false;
    Stream<QuerySnapshot> _userMessages;
    if (lastDocument.value == null) {
      _userMessages = _chatRepository.getUserMessages(_authService.user.value.id);
    } else {
      _userMessages = _chatRepository.getUserMessagesStartAt(_authService.user.value.id, lastDocument.value);
    }
    _userMessages.listen((QuerySnapshot query) {
      if (query.docs.isNotEmpty) {
        query.docs.forEach((element) {
          messagesList.add(Message.fromDocumentSnapshot(element));
        });
        lastDocument.value = query.docs.last;
      } else {
        isDone.value = true;
      }
      isLoading.value = false;
    });
  }

  listenForChats() async {
    message.value = await _chatRepository.getMessage(message.value);
    message.value.readByUsers.add(_authService.user.value.id);
    _chatRepository.getChats(message.value).listen((event) {
      chats.assignAll(event);
    });
  }

  addMessage(Message _message, String text) {
    Chat _chat = new Chat(text, DateTime.now().millisecondsSinceEpoch, _authService.user.value.id, _authService.user.value);
    if (_message.id == null) {
      _message.id = UniqueKey().toString();
      createMessage(_message);
    }
    _message.lastMessage = text;
    _message.lastMessageTime = _chat.time;
    _message.readByUsers = [_authService.user.value.id];
    //uploading.value = false;
    _chatRepository.addMessage(_message, _chat).then((value) {}).then((value) {
      List<User> _users = [];
      _users.addAll(_message.users);
      _users.removeWhere((element) => element.id == _authService.user.value.id);
      _notificationRepository.sendNotification(_users, _authService.user.value, "App\\Notifications\\NewMessage", text, _message.id);
    });
  }

  Future getImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile pickedFile;

    pickedFile = await imagePicker.pickImage(source: source);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      try {
        //uploading.value = true;
        return await _chatRepository.uploadFile(imageFile);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select an image file".tr));
    }
  }
}
